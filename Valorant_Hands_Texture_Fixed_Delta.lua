-- Valorant Hands - texture-only fix for RIVALS / Delta iOS
-- Keeps RIVALS hand geometry intact. Does NOT replace MeshId.

local env = (getgenv and getgenv()) or _G
local write = rawget(env,"writefile") or writefile
local custom = rawget(env,"getcustomasset") or getcustomasset or getsynasset

if not write or not custom then
    warn("[VAL HANDS] writefile/getcustomasset unavailable")
    return
end

local KEY = "__VAL_HAND_TEXTURE_FIXED"
if env[KEY] and env[KEY].connections then
    for _,c in ipairs(env[KEY].connections) do
        pcall(function() c:Disconnect() end)
    end
end
local state = {connections={}}
env[KEY] = state

local SOURCE_TEXTURE = "14523777036"
local URL = "https://raw.githubusercontent.com/engnyg/123f1/refs/heads/main/valorant/arm/FP_Wushu_S0_DF.png"
local FILE = "valorant_hands_wushu.png"

local ok, replacement = pcall(function()
    local body = game:HttpGet(URL)
    if type(body) ~= "string" or #body < 8 or body:sub(2,4) ~= "PNG" then
        error("PNG download failed")
    end
    write(FILE, body)
    return custom(FILE)
end)

if not ok or type(replacement) ~= "string" then
    warn("[VAL HANDS] Could not load texture: "..tostring(replacement))
    return
end

local function id(v)
    if type(v) ~= "string" then return nil end
    return v:match("rbxassetid://(%d+)") or v:match("[?&]id=(%d+)") or v:match("(%d+)")
end

local watched = setmetatable({}, {__mode="k"})

local function apply(o)
    local prop
    if o:IsA("MeshPart") then prop = "TextureID"
    elseif o:IsA("SpecialMesh") then prop = "TextureId"
    elseif o:IsA("Decal") or o:IsA("Texture") then prop = "Texture"
    else return end

    local good, current = pcall(function() return o[prop] end)
    if not good or id(current) ~= SOURCE_TEXTURE then return end

    pcall(function() o[prop] = replacement end)

    if not watched[o] then
        watched[o] = true
        local c = o:GetPropertyChangedSignal(prop):Connect(function()
            if env[KEY] ~= state or not o.Parent then return end
            local ok2, now = pcall(function() return o[prop] end)
            if ok2 and id(now) == SOURCE_TEXTURE then
                task.defer(function()
                    if o.Parent then pcall(function() o[prop] = replacement end) end
                end)
            end
        end)
        table.insert(state.connections, c)
    end
end

-- Apply to current instances once.
for _,o in ipairs(game:GetDescendants()) do apply(o) end

-- Catch hands/viewmodels recreated later, without polling the whole game.
table.insert(state.connections, game.DescendantAdded:Connect(function(o)
    task.defer(function()
        apply(o)
        task.wait(0.25); if o.Parent then apply(o) end
        task.wait(0.75); if o.Parent then apply(o) end
    end)
end))

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title="Valorant Hands",
        Text="Texture-only hand replacement loaded",
        Duration=5
    })
end)
