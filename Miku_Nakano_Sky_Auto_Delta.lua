-- Miku Nakano Sky - Delta/iOS
-- Persistent 6-sided skybox from the supplied pack.
-- Reapplies automatically if RIVALS replaces/removes the Sky.

local Lighting = game:GetService("Lighting")
local env = (getgenv and getgenv()) or _G
local write = rawget(env, "writefile") or writefile
local custom = rawget(env, "getcustomasset") or getcustomasset or getsynasset

local KEY = "__MIKU_NAKANO_SKY_AUTO"

if env[KEY] and env[KEY].connections then
    for _,c in ipairs(env[KEY].connections) do
        pcall(function() c:Disconnect() end)
    end
end

local state = {connections = {}, applying = false}
env[KEY] = state

if not write or not custom then
    warn("[MIKU SKY] writefile/getcustomasset unavailable")
    return
end

local defs = {
    SkyboxLf = {"miku_sky_lf", "https://github.com/uokkna/sky-stuff/raw/refs/heads/main/sky512_lf.tex"},
    SkyboxDn = {"miku_sky_dn", "https://github.com/uokkna/sky-stuff/raw/refs/heads/main/sky512_dn.tex"},
    SkyboxRt = {"miku_sky_rt", "https://github.com/uokkna/sky-stuff/raw/refs/heads/main/sky512_rt.tex"},
    SkyboxBk = {"miku_sky_bk", "https://github.com/uokkna/sky-stuff/raw/refs/heads/main/sky512_bk.tex"},
    SkyboxFt = {"miku_sky_ft", "https://github.com/uokkna/sky-stuff/raw/refs/heads/main/sky512_ft.tex"},
    SkyboxUp = {"miku_sky_up", "https://github.com/uokkna/sky-stuff/raw/refs/heads/main/sky512_up.tex"},
}

local function extensionFor(body)
    if body:sub(1,8) == "\137PNG\r\n\26\n" then return ".png" end
    if body:byte(1) == 0xFF and body:byte(2) == 0xD8 and body:byte(3) == 0xFF then return ".jpg" end
    if body:sub(1,4) == "DDS " then return ".dds" end
    return ".tex"
end

local assets = {}

for prop,d in pairs(defs) do
    local ok,res = pcall(function()
        local body = game:HttpGet(d[2])
        if type(body) ~= "string" or #body < 16 then
            error("download was empty")
        end

        local filename = d[1] .. extensionFor(body)
        write(filename, body)

        local asset = custom(filename)
        if type(asset) ~= "string" or asset == "" then
            error("getcustomasset failed")
        end
        return asset
    end)

    if ok then
        assets[prop] = res
    else
        warn("[MIKU SKY] "..prop.." failed: "..tostring(res))
    end
end

if not next(assets) then
    warn("[MIKU SKY] No sky faces could be loaded")
    return
end

local function applySky()
    if state.applying or env[KEY] ~= state then return end
    state.applying = true

    -- Remove competing Sky instances so RIVALS' default sky does not cover ours.
    for _,obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("Sky") and obj.Name ~= "Miku_Nakano_Custom_Sky" then
            pcall(function() obj:Destroy() end)
        end
    end

    local sky = Lighting:FindFirstChild("Miku_Nakano_Custom_Sky")
    if not sky or not sky:IsA("Sky") then
        if sky then pcall(function() sky:Destroy() end) end
        sky = Instance.new("Sky")
        sky.Name = "Miku_Nakano_Custom_Sky"
        sky.Parent = Lighting
    end

    for prop,asset in pairs(assets) do
        pcall(function()
            sky[prop] = asset
        end)
    end

    state.applying = false
end

applySky()

table.insert(state.connections, Lighting.ChildAdded:Connect(function(obj)
    if obj:IsA("Sky") and obj.Name ~= "Miku_Nakano_Custom_Sky" then
        task.defer(applySky)
    end
end))

table.insert(state.connections, Lighting.ChildRemoved:Connect(function(obj)
    if obj.Name == "Miku_Nakano_Custom_Sky" then
        task.defer(function()
            task.wait(0.1)
            applySky()
        end)
    end
end))

local sky = Lighting:FindFirstChild("Miku_Nakano_Custom_Sky")
if sky then
    for _,prop in ipairs({"SkyboxLf","SkyboxDn","SkyboxRt","SkyboxBk","SkyboxFt","SkyboxUp"}) do
        table.insert(state.connections, sky:GetPropertyChangedSignal(prop):Connect(function()
            if not state.applying then
                task.defer(applySky)
            end
        end))
    end
end

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Miku Nakano Sky",
        Text = "Persistent custom sky loaded",
        Duration = 5
    })
end)
