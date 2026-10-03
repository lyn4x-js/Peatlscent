-- Mahiru Texture Pack - iPad / Delta V2 LiveWatch
-- Fixes inconsistent Arena loading by watching texture properties continuously.
-- When RIVALS assigns the original texture ID later, this script replaces it immediately.

local env = (getgenv and getgenv()) or _G
local KEY = "__MAHIRU_IPAD_DELTA_V2_LIVEWATCH"

-- Clean up previous run
if env[KEY] and env[KEY].connections then
    for _, c in ipairs(env[KEY].connections) do
        pcall(function() c:Disconnect() end)
    end
end

local state = {
    connections = {},
    applying = setmetatable({}, {__mode = "k"})
}
env[KEY] = state

local function keep(c)
    if c then
        table.insert(state.connections, c)
    end
end

local write = writefile
local custom = getcustomasset or getsynasset

if typeof(game.HttpGet) ~= "function" or not write or not custom then
    warn("[Mahiru V2] Missing Delta APIs")
    return
end

local function extractId(v)
    if type(v) ~= "string" then return nil end
    return v:match("rbxassetid://(%d+)")
        or v:match("[?&]id=(%d+)")
        or v:match("(%d+)")
end

local function validBody(body, ext)
    if type(body) ~= "string" or #body < 4 then return false end

    if ext == ".png" then
        return #body >= 8 and body:sub(1,8) == "\137PNG\r\n\26\n"
    elseif ext == ".mp3" then
        return body:sub(1,3) == "ID3" or body:byte(1) == 255
    elseif ext == ".ttf" then
        local h = body:sub(1,4)
        return h == "\0\1\0\0" or h == "OTTO"
    end

    return true
end

local function register(file, url, ext)
    local lastErr

    for attempt = 1, 4 do
        local ok, result = pcall(function()
            local body = game:HttpGet(url)

            if not validBody(body, ext) then
                error("invalid "..ext.." data")
            end

            write(file, body)

            local id = custom(file)
            if type(id) ~= "string" or id == "" then
                error("getcustomasset returned no id")
            end

            return id
        end)

        if ok then
            return result
        end

        lastErr = result
        task.wait(0.35 * attempt)
    end

    warn("[Mahiru V2] Failed "..file..": "..tostring(lastErr))
    return nil
end

-- =========================
-- MAIN MAHIRU MAP TEXTURE
-- =========================

local MAIN_TEXTURE_ID = "7658055825"

local mahiruTexture = register(
    "mahiru_v2_texture.png",
    "https://raw.githubusercontent.com/crypt0knifer-111/Texture-mahiru/361b1c8539dfcbf1dacea6c057ae914770620de2/mahiru%20Texture.png",
    ".png"
)

if not mahiruTexture then
    warn("[Mahiru V2] Main texture failed")
    return
end

-- =========================
-- SFX
-- =========================

local GeneralMap = {}

local killSound = register(
    "mahiru_v2_kill.mp3",
    "https://raw.githubusercontent.com/crypt0knifer-111/Texture-mahiru/79f7b5e755740e45fa06d37d0e6a223418505d40/a-la-a-la.mp3",
    ".mp3"
)

if killSound then
    GeneralMap["16530229616"] = killSound
    GeneralMap["16530229541"] = killSound
    GeneralMap["16530229695"] = killSound
end

local movementSound = register(
    "mahiru_v2_move.mp3",
    "https://raw.githubusercontent.com/crypt0knifer-111/Mp3-s/4abce95151973a5ba6464d502712e28c980cd5f4/sounder.MP3",
    ".mp3"
)

if movementSound then
    GeneralMap["16737738420"] = movementSound
    GeneralMap["16770456156"] = movementSound
    GeneralMap["16492958314"] = movementSound
end

-- =========================
-- FONT
-- =========================

local fontAsset = register(
    "mahiru_v2_sakuna.ttf",
    "https://raw.githubusercontent.com/crypt0knifer-111/Texture-mahiru/36502b56f8af7ff2e0e33aa559a143248903e68b/SAKUNA.ttf",
    ".ttf"
)

local FontIds = {
    ["12187323909"] = true,
    ["12187320363"] = true,
    ["12187354260"] = true,
    ["12187342816"] = true,
    ["12187280273"] = true,
    ["12187303601"] = true,
    ["12187262242"] = true,
    ["12187288714"] = true,
    ["12187341500"] = true,
    ["12187271237"] = true,
    ["12187341020"] = true,
}

-- =========================
-- LIVE PROPERTY PATCHING
-- =========================

local watched = setmetatable({}, {__mode = "k"})

local function safeSet(obj, prop, value)
    if state.applying[obj] then return end

    state.applying[obj] = true

    pcall(function()
        obj[prop] = value
    end)

    state.applying[obj] = nil
end

local function patchTextureProperty(obj, prop)
    if state.applying[obj] then return end

    local ok, old = pcall(function()
        return obj[prop]
    end)

    if not ok or type(old) ~= "string" then
        return
    end

    local sourceId = extractId(old)

    if sourceId == MAIN_TEXTURE_ID and old ~= mahiruTexture then
        safeSet(obj, prop, mahiruTexture)
        return
    end

    local rep = sourceId and GeneralMap[sourceId]
    if rep and rep ~= old then
        safeSet(obj, prop, rep)
    end
end

local function patchSound(obj)
    if state.applying[obj] then return end

    local ok, old = pcall(function()
        return obj.SoundId
    end)

    if not ok then return end

    local rep = GeneralMap[extractId(old)]
    if rep and rep ~= old then
        safeSet(obj, "SoundId", rep)
    end
end

local function patchFont(obj)
    if not fontAsset or state.applying[obj] then return end

    pcall(function()
        local f = obj.FontFace
        local sourceId = extractId(f.Family)

        if sourceId and FontIds[sourceId] then
            state.applying[obj] = true
            obj.FontFace = Font.new(fontAsset, f.Weight, f.Style)
            state.applying[obj] = nil
        end
    end)

    state.applying[obj] = nil
end

local function attach(obj)
    if watched[obj] or env[KEY] ~= state then
        return
    end

    watched[obj] = true

    if obj:IsA("Texture") then
        patchTextureProperty(obj, "Texture")
        keep(obj:GetPropertyChangedSignal("Texture"):Connect(function()
            patchTextureProperty(obj, "Texture")
        end))

    elseif obj:IsA("Decal") then
        patchTextureProperty(obj, "Texture")
        keep(obj:GetPropertyChangedSignal("Texture"):Connect(function()
            patchTextureProperty(obj, "Texture")
        end))

    elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
        patchTextureProperty(obj, "Image")
        keep(obj:GetPropertyChangedSignal("Image"):Connect(function()
            patchTextureProperty(obj, "Image")
        end))

    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
        patchTextureProperty(obj, "Texture")
        keep(obj:GetPropertyChangedSignal("Texture"):Connect(function()
            patchTextureProperty(obj, "Texture")
        end))

    elseif obj:IsA("Sound") then
        patchSound(obj)
        keep(obj:GetPropertyChangedSignal("SoundId"):Connect(function()
            patchSound(obj)
        end))

    elseif obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        patchFont(obj)
        keep(obj:GetPropertyChangedSignal("FontFace"):Connect(function()
            patchFont(obj)
        end))
    end
end

-- Attach to everything that already exists.
local existing = game:GetDescendants()
for i, obj in ipairs(existing) do
    attach(obj)

    if i % 300 == 0 then
        task.wait()
    end
end

-- Attach immediately to anything RIVALS creates later.
keep(game.DescendantAdded:Connect(function(obj)
    task.defer(function()
        attach(obj)

        -- Some Arena objects are created first and assigned their texture a moment later.
        task.wait(0.05)

        if obj.Parent then
            if obj:IsA("Texture") or obj:IsA("Decal") then
                patchTextureProperty(obj, "Texture")
            elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                patchTextureProperty(obj, "Image")
            elseif obj:IsA("Sound") then
                patchSound(obj)
            end
        end
    end)
end))

-- =========================
-- MAHIRU SKY LIVE WATCH
-- =========================

local Lighting = game:GetService("Lighting")
local SKY_NAME = "Mahiru_Pink_Sky_V2"

local skyDefs = {
    SkyboxBk = {
        "mahiru_v2_sky_bk.png",
        "https://raw.githubusercontent.com/crypt0knifer-111/Mahiru-in-Pink-Sky-s/2b4fa55d27b12f489a5fc79c6a43e7fd1f837a13/back.png"
    },
    SkyboxDn = {
        "mahiru_v2_sky_dn.png",
        "https://raw.githubusercontent.com/crypt0knifer-111/Mahiru-in-Pink-Sky-s/2b4fa55d27b12f489a5fc79c6a43e7fd1f837a13/down.png"
    },
    SkyboxFt = {
        "mahiru_v2_sky_ft.png",
        "https://raw.githubusercontent.com/crypt0knifer-111/Mahiru-in-Pink-Sky-s/2b4fa55d27b12f489a5fc79c6a43e7fd1f837a13/Front.png"
    },
    SkyboxLf = {
        "mahiru_v2_sky_lf.png",
        "https://raw.githubusercontent.com/crypt0knifer-111/Mahiru-in-Pink-Sky-s/2b4fa55d27b12f489a5fc79c6a43e7fd1f837a13/Left.png"
    },
    SkyboxRt = {
        "mahiru_v2_sky_rt.png",
        "https://raw.githubusercontent.com/crypt0knifer-111/Mahiru-in-Pink-Sky-s/2b4fa55d27b12f489a5fc79c6a43e7fd1f837a13/right.png"
    },
    SkyboxUp = {
        "mahiru_v2_sky_up.png",
        "https://raw.githubusercontent.com/crypt0knifer-111/Mahiru-in-Pink-Sky-s/2b4fa55d27b12f489a5fc79c6a43e7fd1f837a13/Up.png"
    },
}

local skyAssets = {}
for prop, def in pairs(skyDefs) do
    skyAssets[prop] = register(def[1], def[2], ".png")
end

local applyingSky = false

local function applySky()
    if applyingSky or env[KEY] ~= state then
        return
    end

    applyingSky = true

    local sky = Lighting:FindFirstChild(SKY_NAME)

    if not sky or not sky:IsA("Sky") then
        if sky then
            pcall(function() sky:Destroy() end)
        end

        sky = Instance.new("Sky")
        sky.Name = SKY_NAME
        sky.Parent = Lighting
    end

    for prop, asset in pairs(skyAssets) do
        if asset then
            pcall(function()
                if sky[prop] ~= asset then
                    sky[prop] = asset
                end
            end)
        end
    end

    pcall(function()
        sky.StarCount = 0
        sky.CelestialBodiesShown = false
    end)

    applyingSky = false
end

applySky()

keep(Lighting.ChildAdded:Connect(function(child)
    if child:IsA("Sky") and child.Name ~= SKY_NAME then
        task.defer(function()
            task.wait()
            applySky()
        end)
    end
end))

keep(Lighting.ChildRemoved:Connect(function(child)
    if child.Name == SKY_NAME then
        task.defer(function()
            task.wait(0.05)
            applySky()
        end)
    end
end))

local sky = Lighting:FindFirstChild(SKY_NAME)
if sky then
    for _, prop in ipairs({
        "SkyboxBk","SkyboxDn","SkyboxFt",
        "SkyboxLf","SkyboxRt","SkyboxUp"
    }) do
        keep(sky:GetPropertyChangedSignal(prop):Connect(function()
            if not applyingSky then
                task.defer(applySky)
            end
        end))
    end
end

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Mahiru iPad V2",
        Text = "Live Arena texture watcher enabled",
        Duration = 6
    })
end)

print("[Mahiru iPad V2] LiveWatch loaded")
