-- Pearlscent iPad Standalone V4
-- Full standalone build. No wrapper/gsub patching.
-- Keeps Pearlscent sounds/UI/font and applies the main Pearlscent texture only
-- to ordinary Decal/Texture/UI image objects, avoiding MeshPart/SpecialMesh/Sky.

local env=(getgenv and getgenv()) or _G
local KEY="__PEARLSCENT_IPAD_STANDALONE_V4"

if env[KEY] and env[KEY].connections then
    for _,c in ipairs(env[KEY].connections) do pcall(function() c:Disconnect() end) end
end

local state={connections={}}
env[KEY]=state
local function keep(c) if c then table.insert(state.connections,c) end end

local write=writefile
local custom=getcustomasset or getsynasset

if typeof(game.HttpGet)~="function" or not write or not custom then
    warn("[Pearlscent iPad V4] Missing Delta APIs")
    return
end

local GeneralMap={
    ["16537337310"]="rbxassetid://70643163489676",
    ["16537449730"]="rbxassetid://70643163489676",
}
local TextureMap={}
local FontMap={}

local assets={
    {
        name="main_texture",
        file="pearlscent_v4_texture.png",
        url="https://raw.githubusercontent.com/H4rb0r-rbx/Fleasion-pearlscent-textures/main/fcc06bbf-0829-4e29-80ac-661bcbb57a22-removebg-preview.png",
        ids={7658055825},
        target="texture"
    },
    {
        name="double_jump",
        file="pearlscent_v4_double_jump.ogg",
        url="https://raw.githubusercontent.com/H4rb0r-rbx/Fleasion-pearlscent-textures/main/bell%20ding%20sfx.ogg",
        ids={16770456156,16492958314},
        target="general"
    },
    {
        name="item_background",
        file="pearlscent_v4_item_background.png",
        url="https://raw.githubusercontent.com/H4rb0r-rbx/Fleasion-pearlscent-textures/main/IMG_4989.PNG",
        ids={13220167337,13188242420,13220167472,13188153054,13188242287},
        target="general"
    },
    {
        name="slide",
        file="pearlscent_v4_slide.wav",
        url="https://raw.githubusercontent.com/H4rb0r-rbx/Fleasion-pearlscent-textures/main/sparkle.wav",
        ids={16737738420},
        target="general"
    },
    {
        name="click",
        file="pearlscent_v4_click.mp3",
        url="https://raw.githubusercontent.com/H4rb0r-rbx/Fleasion-pearlscent-textures/main/universfield-water-drop-131023.mp3",
        ids={177266782},
        target="general"
    },
    {
        name="kill",
        file="pearlscent_v4_kill.mp3",
        url="https://raw.githubusercontent.com/H4rb0r-rbx/Fleasion-pearlscent-textures/main/benkirb-shine-1-268902.mp3",
        ids={16530229616,16530229541,16530229695},
        target="general"
    },
    {
        name="font",
        file="pearlscent_v4_font.ttf",
        url="https://raw.githubusercontent.com/prism658/Resources-fleasion/main/Garet-Book.ttf",
        ids={12187323909,12187320363,12187354260,12187342816,12187280273,12187303601,12187262242,12187288714,12187341500,12187271237,12187341020},
        target="font"
    },
}

local function register(a)
    for attempt=1,4 do
        local ok,res=pcall(function()
            local body=game:HttpGet(a.url)
            if type(body)~="string" or #body<32 then error("bad download") end
            write(a.file,body)
            local id=custom(a.file)
            if type(id)~="string" or id=="" then error("bad customasset") end
            return id
        end)
        if ok then return res end
        task.wait(0.3*attempt)
    end
    warn("[Pearlscent iPad V4] Failed "..a.name)
end

for _,a in ipairs(assets) do
    local rep=register(a)
    if rep then
        local target=(a.target=="texture" and TextureMap) or (a.target=="font" and FontMap) or GeneralMap
        for _,id in ipairs(a.ids) do target[tostring(id)]=rep end
    end
end

local function extractId(v)
    if type(v)~="string" then return nil end
    return v:match("rbxassetid://(%d+)") or v:match("[?&]id=(%d+)") or v:match("(%d+)")
end

local function setProp(obj,prop,map)
    pcall(function()
        local old=obj[prop]
        local id=extractId(old)
        local rep=id and map[id]
        if rep and rep~=old then obj[prop]=rep end
    end)
end

local function patch(obj)
    if env[KEY]~=state or not obj then return end

    -- Main Pearlscent map texture: only safer 2D surface/UI classes.
    if obj:IsA("Decal") or obj:IsA("Texture") then
        setProp(obj,"Texture",TextureMap)
        setProp(obj,"Texture",GeneralMap)
        return
    elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
        setProp(obj,"Image",TextureMap)
        setProp(obj,"Image",GeneralMap)
        return
    end

    -- Intentionally DO NOT put the local world texture on these iPad-problem classes.
    if obj:IsA("MeshPart") then
        setProp(obj,"TextureID",GeneralMap)
    elseif obj:IsA("SpecialMesh") then
        setProp(obj,"TextureId",GeneralMap)
    elseif obj:IsA("Sound") then
        setProp(obj,"SoundId",GeneralMap)
    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
        setProp(obj,"Texture",GeneralMap)
    elseif obj:IsA("Shirt") then
        setProp(obj,"ShirtTemplate",GeneralMap)
    elseif obj:IsA("Pants") then
        setProp(obj,"PantsTemplate",GeneralMap)
    elseif obj:IsA("ShirtGraphic") then
        setProp(obj,"Graphic",GeneralMap)
    end

    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        pcall(function()
            local f=obj.FontFace
            local id=extractId(f.Family)
            local rep=id and FontMap[id]
            if rep then obj.FontFace=Font.new(rep,f.Weight,f.Style) end
        end)
    end
end

local busy=false
local function scan()
    if busy or env[KEY]~=state then return end
    busy=true
    for i,obj in ipairs(game:GetDescendants()) do
        patch(obj)
        if i%250==0 then task.wait() end
    end
    busy=false
end

task.spawn(scan)

keep(game.DescendantAdded:Connect(function(obj)
    task.defer(function()
        patch(obj)
        task.wait(0.35)
        if obj.Parent then patch(obj) end
        task.wait(1.15)
        if obj.Parent then patch(obj) end
    end)
end))

for _,t in ipairs({1.5,4,8,15}) do task.delay(t,scan) end

local lp=game:GetService("Players").LocalPlayer
if lp then
    keep(lp.CharacterAdded:Connect(function()
        task.delay(0.8,scan)
        task.delay(3,scan)
    end))
end

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title="Pearlscent iPad V4",
        Text="Standalone texture-safe build loaded",
        Duration=5
    })
end)

print("[Pearlscent iPad V4] loaded")
