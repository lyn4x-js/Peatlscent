-- Pearlscent + PSM Sky AUTO
-- Original working Pearlscent + event-based persistent PSM sky.
-- No experimental hand scripts.

-- ===== ORIGINAL PEARLSCENT =====
do
-- Pearlscent asset replacer for Delta-style executors
-- Paste this whole file into the executor.
-- Source mappings: Pearlscent.json

local okGet = typeof(game.HttpGet) == "function"
local write = rawget(getgenv and getgenv() or _G, "writefile") or writefile
local exists = rawget(getgenv and getgenv() or _G, "isfile") or isfile
local customAsset = rawget(getgenv and getgenv() or _G, "getcustomasset") or getcustomasset or getsynasset

if not okGet then
    warn("[Pearlscent] game:HttpGet is unavailable")
    return
end

-- Direct Roblox-ID replacements work even if local custom assets are unavailable.
local IdMap = {
    ["16537337310"] = "rbxassetid://70643163489676",
    ["16537449730"] = "rbxassetid://70643163489676",
}

local Assets = {
    {
        name = "texture",
        file = "pearlscent_texture.png",
        url = "https://raw.githubusercontent.com/H4rb0r-rbx/Fleasion-pearlscent-textures/main/fcc06bbf-0829-4e29-80ac-661bcbb57a22-removebg-preview.png",
        ids = {7658055825},
    },
    {
        name = "double_jump",
        file = "pearlscent_double_jump.ogg",
        url = "https://raw.githubusercontent.com/H4rb0r-rbx/Fleasion-pearlscent-textures/main/bell%20ding%20sfx.ogg",
        ids = {16770456156, 16492958314},
    },
    {
        name = "item_background",
        file = "pearlscent_item_background.png",
        url = "https://raw.githubusercontent.com/H4rb0r-rbx/Fleasion-pearlscent-textures/main/IMG_4989.PNG",
        ids = {13220167337, 13188242420, 13220167472, 13188153054, 13188242287},
    },
    {
        name = "slide",
        file = "pearlscent_slide.wav",
        url = "https://raw.githubusercontent.com/H4rb0r-rbx/Fleasion-pearlscent-textures/main/sparkle.wav",
        ids = {16737738420},
    },
    {
        name = "click",
        file = "pearlscent_click.mp3",
        url = "https://raw.githubusercontent.com/H4rb0r-rbx/Fleasion-pearlscent-textures/main/universfield-water-drop-131023.mp3",
        ids = {177266782},
    },
    {
        name = "kill",
        file = "pearlscent_kill.mp3",
        url = "https://raw.githubusercontent.com/H4rb0r-rbx/Fleasion-pearlscent-textures/main/benkirb-shine-1-268902.mp3",
        ids = {16530229616, 16530229541, 16530229695},
    },
    {
        name = "font",
        file = "pearlscent_font.ttf",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/Garet-Book.ttf",
        ids = {
            12187323909, 12187320363, 12187354260, 12187342816,
            12187280273, 12187303601, 12187262242, 12187288714,
            12187341500, 12187271237, 12187341020,
        },
    },
}

local function downloadAndRegister(asset)
    if not write or not customAsset then
        warn("[Pearlscent] Local asset APIs missing; skipping " .. asset.name)
        return nil
    end

    local success, result = pcall(function()
        local shouldDownload = true
        if exists then
            local ok, already = pcall(exists, asset.file)
            shouldDownload = not (ok and already)
        end

        if shouldDownload then
            local body = game:HttpGet(asset.url)
            if type(body) ~= "string" or #body < 32 then
                error("download returned invalid/empty data")
            end
            write(asset.file, body)
        end

        local content = customAsset(asset.file)
        if type(content) ~= "string" or content == "" then
            error("getcustomasset returned no content id")
        end
        return content
    end)

    if not success then
        warn("[Pearlscent] Failed " .. asset.name .. ": " .. tostring(result))
        return nil
    end

    return result
end

for _, asset in ipairs(Assets) do
    local content = downloadAndRegister(asset)
    if content then
        for _, id in ipairs(asset.ids) do
            IdMap[tostring(id)] = content
        end
    end
end

local function extractId(value)
    if type(value) ~= "string" then return nil end
    return value:match("rbxassetid://(%d+)")
        or value:match("[?&]id=(%d+)")
        or value:match("(%d+)")
end

local function replacementFor(value)
    local id = extractId(value)
    return id and IdMap[id] or nil
end

local watched = setmetatable({}, {__mode = "k"})

local function replaceProperty(obj, property)
    local ok, old = pcall(function()
        return obj[property]
    end)
    if not ok or type(old) ~= "string" then return end

    local replacement = replacementFor(old)
    if replacement and replacement ~= old then
        pcall(function()
            obj[property] = replacement
        end)
    end
end

local function replaceFont(obj)
    pcall(function()
        local old = obj.FontFace
        local replacement = replacementFor(old.Family)
        if replacement then
            obj.FontFace = Font.new(replacement, old.Weight, old.Style)
        end
    end)
end

local function propertiesFor(obj)
    if obj:IsA("Sound") then
        return {"SoundId"}
    elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
        return {"Image"}
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        return {"Texture"}
    elseif obj:IsA("MeshPart") then
        return {"TextureID"}
    elseif obj:IsA("SpecialMesh") then
        return {"TextureId"}
    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
        return {"Texture"}
    elseif obj:IsA("Sky") then
        return {"SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp"}
    elseif obj:IsA("Shirt") then
        return {"ShirtTemplate"}
    elseif obj:IsA("Pants") then
        return {"PantsTemplate"}
    elseif obj:IsA("ShirtGraphic") then
        return {"Graphic"}
    elseif obj:IsA("Animation") then
        return {"AnimationId"}
    elseif obj:IsA("VideoFrame") then
        return {"Video"}
    end
    return nil
end

local function attach(obj)
    if watched[obj] then return end
    watched[obj] = true

    local props = propertiesFor(obj)
    if props then
        for _, property in ipairs(props) do
            replaceProperty(obj, property)
            pcall(function()
                obj:GetPropertyChangedSignal(property):Connect(function()
                    replaceProperty(obj, property)
                end)
            end)
        end
    end

    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        replaceFont(obj)
        pcall(function()
            obj:GetPropertyChangedSignal("FontFace"):Connect(function()
                replaceFont(obj)
            end)
        end)
    end
end

-- Existing instances
for _, obj in ipairs(game:GetDescendants()) do
    task.defer(attach, obj)
end

-- New instances created later
game.DescendantAdded:Connect(function(obj)
    task.defer(attach, obj)
end)

-- A short delayed second pass catches assets populated immediately after UI creation.
task.delay(3, function()
    for _, obj in ipairs(game:GetDescendants()) do
        task.defer(attach, obj)
    end
end)

print("[Pearlscent] loaded. Replacement entries: " .. tostring((function()
    local n = 0
    for _ in pairs(IdMap) do n += 1 end
    return n
end)()))

-- NOTE: The SkyBoxes rule from Pearlscent.json is intentionally not applied.
-- It contains source IDs but no replacement with_id/cdn_url, so there is no target asset to use.

end


-- ===== PSM SKY: PERSISTENT / AUTO-REAPPLY =====
do
    local Lighting = game:GetService("Lighting")
    local env = (getgenv and getgenv()) or _G
    local write = rawget(env,"writefile") or writefile
    local custom = rawget(env,"getcustomasset") or getcustomasset or getsynasset

    local KEY = "__PSM_SKY_PERSISTENT"
    if env[KEY] and env[KEY].connections then
        for _,c in ipairs(env[KEY].connections) do
            pcall(function() c:Disconnect() end)
        end
    end
    local state = {connections={}}
    env[KEY] = state

    if not write or not custom then
        warn("[PSM SKY] writefile/getcustomasset unavailable")
        return
    end

    local defs = {
        SkyboxFt={"psm_sky_ft.png","https://raw.githubusercontent.com/sukablyst400-eng/fleasion_z7/main/sky512_ft.png"},
        SkyboxLf={"psm_sky_lf.png","https://raw.githubusercontent.com/sukablyst400-eng/fleasion_z7/main/sky512_lf.png"},
        SkyboxRt={"psm_sky_rt.png","https://raw.githubusercontent.com/sukablyst400-eng/fleasion_z7/main/sky512_rt.png"},
        SkyboxDn={"psm_sky_dn.png","https://raw.githubusercontent.com/sukablyst400-eng/fleasion_z7/main/sky512_dn.png"},
        SkyboxBk={"psm_sky_bk.png","https://raw.githubusercontent.com/sukablyst400-eng/fleasion_z7/main/sky512_bk%20(2).png"},
        SkyboxUp={"psm_sky_up.png","https://raw.githubusercontent.com/sukablyst400-eng/fleasion_z7/main/sky512_up.png"},
    }

    local assets={}
    for prop,d in pairs(defs) do
        local ok,res=pcall(function()
            local body=game:HttpGet(d[2])
            if type(body)~="string" or #body<8 or body:sub(2,4)~="PNG" then
                error("invalid PNG")
            end
            write(d[1],body)
            return custom(d[1])
        end)
        if ok and type(res)=="string" then assets[prop]=res end
    end

    local applying=false
    local function applySky()
        if applying or env[KEY]~=state then return end
        applying=true

        for _,o in ipairs(Lighting:GetChildren()) do
            if o:IsA("Sky") and o.Name~="PSM_Custom_Sky" then
                pcall(function() o.Parent=nil end)
            end
        end

        local sky=Lighting:FindFirstChild("PSM_Custom_Sky")
        if not sky or not sky:IsA("Sky") then
            if sky then pcall(function() sky:Destroy() end) end
            sky=Instance.new("Sky")
            sky.Name="PSM_Custom_Sky"
            sky.Parent=Lighting
        end

        for prop,id in pairs(assets) do
            pcall(function() sky[prop]=id end)
        end
        applying=false
    end

    applySky()

    table.insert(state.connections, Lighting.ChildAdded:Connect(function(child)
        if child:IsA("Sky") and child.Name~="PSM_Custom_Sky" then
            task.defer(applySky)
        end
    end))

    table.insert(state.connections, Lighting.ChildRemoved:Connect(function(child)
        if child.Name=="PSM_Custom_Sky" then
            task.defer(function()
                task.wait(0.1)
                applySky()
            end)
        end
    end))

    -- Also catches games that rewrite the existing Sky's face properties.
    local function watchSky()
        local sky=Lighting:FindFirstChild("PSM_Custom_Sky")
        if not sky then return end
        for _,prop in ipairs({"SkyboxFt","SkyboxLf","SkyboxRt","SkyboxDn","SkyboxBk","SkyboxUp"}) do
            table.insert(state.connections, sky:GetPropertyChangedSignal(prop):Connect(function()
                if not applying then task.defer(applySky) end
            end))
        end
    end
    watchSky()

    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title="Pearlscent + PSM Sky",
            Text="Persistent sky enabled",
            Duration=5
        })
    end)
end
