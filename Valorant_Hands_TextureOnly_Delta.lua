-- Valorant Hands TEXTURE ONLY - Delta/iOS
-- Keeps the original RIVALS hand/arm meshes intact.
-- From valorant.json: texture asset 144076357 -> FP_Wushu_S0_DF.png

local PREFIX="[VALORANT HANDS TEXTURE] "
local env=(getgenv and getgenv()) or _G
local write=rawget(env,"writefile") or writefile
local customAsset=rawget(env,"getcustomasset") or getcustomasset or getsynasset

if not write or not customAsset then
    warn(PREFIX.."file/custom-asset API unavailable")
    return
end

local STATE_KEY="__VALORANT_HANDS_TEXTURE_ONLY_V1"
if env[STATE_KEY] and env[STATE_KEY].connections then
    for _,c in ipairs(env[STATE_KEY].connections) do
        pcall(function() c:Disconnect() end)
    end
end
local state={connections={}}
env[STATE_KEY]=state
local function keep(c) if c then table.insert(state.connections,c) end end

local SOURCE_ID="144076357"
local URL="https://raw.githubusercontent.com/engnyg/123f1/refs/heads/main/valorant/arm/FP_Wushu_S0_DF.png"
local FILE="valorant_hands_texture_only_v1.png"

local ok,texture=pcall(function()
    local body=game:HttpGet(URL)
    if type(body)~="string" or #body<8 or body:sub(1,8)~="\137PNG\r\n\26\n" then
        error("download was not a valid PNG")
    end
    write(FILE,body)
    local id=customAsset(FILE)
    if type(id)~="string" or id=="" then error("custom asset failed") end
    return id
end)

if not ok then
    warn(PREFIX..tostring(texture))
    return
end

local function extract(v)
    if type(v)~="string" then return nil end
    return v:match("rbxassetid://(%d+)") or v:match("[?&]id=(%d+)") or v:match("(%d+)")
end

local imageProps={
    MeshPart={"TextureID"},
    SpecialMesh={"TextureId"},
    Decal={"Texture"},
    Texture={"Texture"},
    ImageLabel={"Image"},
    ImageButton={"Image"},
}

local function apply(obj)
    for class,props in pairs(imageProps) do
        if obj:IsA(class) then
            for _,prop in ipairs(props) do
                local good,old=pcall(function() return obj[prop] end)
                if good and extract(old)==SOURCE_ID and old~=texture then
                    pcall(function() obj[prop]=texture end)
                end
            end
            return true
        end
    end
    return false
end

for _,obj in ipairs(game:GetDescendants()) do apply(obj) end

keep(game.DescendantAdded:Connect(function(obj)
    task.defer(function()
        if not obj or not obj.Parent or not apply(obj) then return end
        for _,delayTime in ipairs({0.2,0.6,1.4,3.0}) do
            task.wait(delayTime)
            if env[STATE_KEY]~=state or not obj or not obj.Parent then return end
            apply(obj)
        end
    end)
end))

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title="Valorant Hands",
        Text="Texture-only hands loaded",
        Duration=5
    })
end)
print(PREFIX.."loaded")
