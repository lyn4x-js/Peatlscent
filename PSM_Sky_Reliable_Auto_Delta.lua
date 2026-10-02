-- PSM Sky Reliable Auto - standalone
-- Event-based persistent sky; no Pearlscent or hand scripts.

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
