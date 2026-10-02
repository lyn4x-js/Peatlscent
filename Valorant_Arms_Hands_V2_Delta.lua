-- Valorant Arms/Hands V2 for Delta/iOS
-- Uses the exact arm targets from the uploaded Valorant pack.
-- Important: local OBJ MeshId replacement may not be supported by every Delta/iOS build.

local env=(getgenv and getgenv()) or _G
local write=rawget(env,"writefile") or writefile
local customAsset=rawget(env,"getcustomasset") or getcustomasset or getsynasset
if not write or not customAsset then
    warn("[VAL ARMS] writefile/getcustomasset unavailable")
    return
end

local STATE_KEY="__VALORANT_ARMS_V2"
if env[STATE_KEY] and env[STATE_KEY].connections then
    for _,c in ipairs(env[STATE_KEY].connections) do pcall(function() c:Disconnect() end) end
end
local state={connections={}}
env[STATE_KEY]=state
local function keep(c) if c then table.insert(state.connections,c) end end

local defs={
    {
        target="12307734932",
        file="valorant_left_arm_v2.obj",
        url="https://raw.githubusercontent.com/engnyg/123f1/refs/heads/main/valorant/arm/valorant-leftV2.obj"
    },
    {
        target="12307583853",
        file="valorant_right_arm_v2.obj",
        url="https://raw.githubusercontent.com/engnyg/123f1/refs/heads/main/valorant/arm/valorant-rightV2.obj"
    }
}

local map={}
for _,d in ipairs(defs) do
    local ok,result=pcall(function()
        local body=game:HttpGet(d.url)
        if type(body)~="string" or #body<16 then error("empty OBJ") end
        -- Basic sanity check that this is text OBJ data.
        local head=body:sub(1,1024):lower()
        if not (head:find("\nv ",1,true) or head:find("\no ",1,true) or
                head:sub(1,2)=="v " or head:sub(1,2)=="o " or head:sub(1,1)=="#") then
            error("download does not look like OBJ")
        end
        write(d.file,body)
        local id=customAsset(d.file)
        if type(id)~="string" or id=="" then error("getcustomasset failed") end
        return id
    end)
    if ok then
        map[d.target]=result
    else
        warn("[VAL ARMS] "..d.target.." skipped: "..tostring(result))
    end
end

local function assetId(v)
    if type(v)~="string" then return nil end
    return v:match("rbxassetid://(%d+)") or v:match("[?&]id=(%d+)") or v:match("(%d+)")
end

local function apply(obj)
    if obj:IsA("MeshPart") then
        local ok,old=pcall(function() return obj.MeshId end)
        if ok then
            local replacement=map[assetId(old)]
            if replacement and replacement~=old then
                pcall(function() obj.MeshId=replacement end)
            end
        end
        return true
    elseif obj:IsA("SpecialMesh") then
        local ok,old=pcall(function() return obj.MeshId end)
        if ok then
            local replacement=map[assetId(old)]
            if replacement and replacement~=old then
                pcall(function() obj.MeshId=replacement end)
            end
        end
        return true
    end
    return false
end

-- No recurring whole-game scan.
for _,obj in ipairs(game:GetDescendants()) do apply(obj) end

keep(game.DescendantAdded:Connect(function(obj)
    task.defer(function()
        if not obj or not obj.Parent or not apply(obj) then return end
        for _,t in ipairs({0.2,0.6,1.4,3.0}) do
            task.wait(t)
            if env[STATE_KEY]~=state or not obj or not obj.Parent then return end
            apply(obj)
        end
    end)
end))

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title="Valorant Arms V2",
        Text="Loaded exact Valorant arm targets",
        Duration=5
    })
end)
