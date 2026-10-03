-- Pearlscent iPad SurfaceAppearance Fix V5
-- Proper iPad-specific approach:
-- MeshPart local TextureID can render blank/white in Delta iPad.
-- This build applies the Pearlscent map image through SurfaceAppearance.ColorMap instead.

local env=(getgenv and getgenv()) or _G
local KEY="__PEARLSCENT_IPAD_SURFACE_V5"

if env[KEY] and env[KEY].connections then
    for _,c in ipairs(env[KEY].connections) do pcall(function() c:Disconnect() end) end
end

local state={connections={}}
env[KEY]=state
local function keep(c) if c then table.insert(state.connections,c) end end

local write=writefile
local custom=getcustomasset or getsynasset
if typeof(game.HttpGet)~="function" or not write or not custom then
    warn("[Pearlscent iPad V5] Missing Delta APIs")
    return
end

local function getId(v)
    if type(v)~="string" then return nil end
    return v:match("rbxassetid://(%d+)") or v:match("[?&]id=(%d+)") or v:match("(%d+)")
end

local function fetchAsset(file,url)
    for attempt=1,4 do
        local ok,res=pcall(function()
            local body=game:HttpGet(url)
            if type(body)~="string" or #body<32 then error("bad download") end
            write(file,body)
            local id=custom(file)
            if type(id)~="string" or id=="" then error("bad customasset") end
            return id
        end)
        if ok then return res end
        task.wait(.35*attempt)
    end
end

local MAIN_ID="7658055825"
local mainTexture=fetchAsset(
    "pearlscent_v5_world.png",
    "https://raw.githubusercontent.com/H4rb0r-rbx/Fleasion-pearlscent-textures/main/fcc06bbf-0829-4e29-80ac-661bcbb57a22-removebg-preview.png"
)

if not mainTexture then
    warn("[Pearlscent iPad V5] Main texture failed to register")
    return
end

local GeneralMap={
    ["16537337310"]="rbxassetid://70643163489676",
    ["16537449730"]="rbxassetid://70643163489676",
}

local extras={
    {"double_jump","pearlscent_v5_double_jump.ogg","https://raw.githubusercontent.com/H4rb0r-rbx/Fleasion-pearlscent-textures/main/bell%20ding%20sfx.ogg",{16770456156,16492958314}},
    {"item_background","pearlscent_v5_item_background.png","https://raw.githubusercontent.com/H4rb0r-rbx/Fleasion-pearlscent-textures/main/IMG_4989.PNG",{13220167337,13188242420,13220167472,13188153054,13188242287}},
    {"slide","pearlscent_v5_slide.wav","https://raw.githubusercontent.com/H4rb0r-rbx/Fleasion-pearlscent-textures/main/sparkle.wav",{16737738420}},
    {"click","pearlscent_v5_click.mp3","https://raw.githubusercontent.com/H4rb0r-rbx/Fleasion-pearlscent-textures/main/universfield-water-drop-131023.mp3",{177266782}},
    {"kill","pearlscent_v5_kill.mp3","https://raw.githubusercontent.com/H4rb0r-rbx/Fleasion-pearlscent-textures/main/benkirb-shine-1-268902.mp3",{16530229616,16530229541,16530229695}},
}
for _,a in ipairs(extras) do
    local rep=fetchAsset(a[2],a[3])
    if rep then for _,id in ipairs(a[4]) do GeneralMap[tostring(id)]=rep end end
end

local fontAsset=fetchAsset(
    "pearlscent_v5_font.ttf",
    "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/Garet-Book.ttf"
)
local FontIds={
    ["12187323909"]=true,["12187320363"]=true,["12187354260"]=true,
    ["12187342816"]=true,["12187280273"]=true,["12187303601"]=true,
    ["12187262242"]=true,["12187288714"]=true,["12187341500"]=true,
    ["12187271237"]=true,["12187341020"]=true,
}

local function setGeneral(obj,prop)
    pcall(function()
        local old=obj[prop]
        local id=getId(old)
        local rep=id and GeneralMap[id]
        if rep and rep~=old then obj[prop]=rep end
    end)
end

local function applyPearlscentMesh(mesh)
    local ok,tid=pcall(function() return mesh.TextureID end)
    if not ok or getId(tid)~=MAIN_ID then return end

    -- Do NOT assign the local file to MeshPart.TextureID on iPad.
    -- Use SurfaceAppearance.ColorMap, which is a different rendering path.
    local sa=mesh:FindFirstChild("__Pearlscent_iPad_Surface")
    if not sa then
        sa=Instance.new("SurfaceAppearance")
        sa.Name="__Pearlscent_iPad_Surface"
        sa.AlphaMode=Enum.AlphaMode.Overlay
        sa.Parent=mesh
    end
    pcall(function() sa.ColorMap=mainTexture end)
end

local function patch(obj)
    if env[KEY]~=state or not obj then return end

    if obj:IsA("MeshPart") then
        applyPearlscentMesh(obj)
        setGeneral(obj,"TextureID")
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        pcall(function()
            if getId(obj.Texture)==MAIN_ID then obj.Texture=mainTexture else setGeneral(obj,"Texture") end
        end)
    elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
        pcall(function()
            if getId(obj.Image)==MAIN_ID then obj.Image=mainTexture else setGeneral(obj,"Image") end
        end)
    elseif obj:IsA("Sound") then
        setGeneral(obj,"SoundId")
    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
        setGeneral(obj,"Texture")
    elseif obj:IsA("SpecialMesh") then
        -- Keep original mesh texture to avoid iPad white/invisible geometry.
        setGeneral(obj,"TextureId")
    elseif obj:IsA("Shirt") then
        setGeneral(obj,"ShirtTemplate")
    elseif obj:IsA("Pants") then
        setGeneral(obj,"PantsTemplate")
    elseif obj:IsA("ShirtGraphic") then
        setGeneral(obj,"Graphic")
    end

    if fontAsset and (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then
        pcall(function()
            local f=obj.FontFace
            local id=getId(f.Family)
            if id and FontIds[id] then obj.FontFace=Font.new(fontAsset,f.Weight,f.Style) end
        end)
    end
end

local busy=false
local function scan()
    if busy or env[KEY]~=state then return end
    busy=true
    for i,obj in ipairs(game:GetDescendants()) do
        patch(obj)
        if i%200==0 then task.wait() end
    end
    busy=false
end

task.spawn(scan)

keep(game.DescendantAdded:Connect(function(obj)
    task.defer(function()
        patch(obj)
        task.wait(.25)
        if obj.Parent then patch(obj) end
        task.wait(.75)
        if obj.Parent then patch(obj) end
        task.wait(2)
        if obj.Parent then patch(obj) end
    end)
end))

for _,t in ipairs({1,3,7,12,20}) do task.delay(t,scan) end

local lp=game:GetService("Players").LocalPlayer
if lp then
    keep(lp.CharacterAdded:Connect(function()
        task.delay(.5,scan)
        task.delay(2,scan)
    end))
end

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title="Pearlscent iPad V5",
        Text="SurfaceAppearance map-texture fix loaded",
        Duration=6
    })
end)

print("[Pearlscent iPad V5] SurfaceAppearance fix loaded")
