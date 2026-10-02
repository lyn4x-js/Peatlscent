-- psm's sky - Delta/iOS
-- Separate skybox script. Does not modify weapons, hands, or other texture packs.

local Lighting = game:GetService("Lighting")
local env = (getgenv and getgenv()) or _G
local write = rawget(env, "writefile") or writefile
local custom = rawget(env, "getcustomasset") or getcustomasset or getsynasset

if not write or not custom then
    warn("[PSM SKY] writefile/getcustomasset unavailable")
    return
end

local faces = {
    SkyboxFt = {"psm_sky_ft.png", "https://raw.githubusercontent.com/sukablyst400-eng/fleasion_z7/main/sky512_ft.png"},
    SkyboxLf = {"psm_sky_lf.png", "https://raw.githubusercontent.com/sukablyst400-eng/fleasion_z7/main/sky512_lf.png"},
    SkyboxRt = {"psm_sky_rt.png", "https://raw.githubusercontent.com/sukablyst400-eng/fleasion_z7/main/sky512_rt.png"},
    SkyboxDn = {"psm_sky_dn.png", "https://raw.githubusercontent.com/sukablyst400-eng/fleasion_z7/main/sky512_dn.png"},
    SkyboxBk = {"psm_sky_bk.png", "https://raw.githubusercontent.com/sukablyst400-eng/fleasion_z7/main/sky512_bk%20(2).png"},
    SkyboxUp = {"psm_sky_up.png", "https://raw.githubusercontent.com/sukablyst400-eng/fleasion_z7/main/sky512_up.png"},
}

local assets = {}
for prop, data in pairs(faces) do
    local ok, result = pcall(function()
        local body = game:HttpGet(data[2])
        if type(body) ~= "string" or #body < 8 or body:sub(2,4) ~= "PNG" then
            error("invalid PNG")
        end
        write(data[1], body)
        return custom(data[1])
    end)
    if ok and type(result) == "string" then
        assets[prop] = result
    else
        warn("[PSM SKY] Failed "..prop..": "..tostring(result))
    end
end

if not next(assets) then
    warn("[PSM SKY] No sky images loaded")
    return
end

-- Keep one dedicated sky so rerunning the script is clean.
local old = Lighting:FindFirstChild("PSM_Custom_Sky")
if old then old:Destroy() end

local sky = Instance.new("Sky")
sky.Name = "PSM_Custom_Sky"

for prop, asset in pairs(assets) do
    pcall(function()
        sky[prop] = asset
    end)
end

sky.Parent = Lighting

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "psm's sky",
        Text = "Custom sky loaded",
        Duration = 5
    })
end)
