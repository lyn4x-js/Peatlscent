-- Pearlscent iPad TextureObject Fix V6
-- Based on the iPad diagnostic:
-- Arena/ShootingRange uses lots of Roblox "Texture" instances whose Texture property is 7658055825.
-- This build targets those Texture objects directly and leaves MeshPart/SpecialMesh alone.

local env=(getgenv and getgenv()) or _G
local KEY="__PEARLSCENT_IPAD_TEXTUREOBJ_V6"

if env[KEY] and env[KEY].connections then
    for _,c in ipairs(env[KEY].connections) do
        pcall(function() c:Disconnect() end)
    end
end

local state={connections={}}
env[KEY]=state
local function keep(c)
    if c then table.insert(state.connections,c) end
end

local write=writefile
local custom=getcustomasset or getsynasset

if typeof(game.HttpGet)~="function" or not write or not custom then
    warn("[Pearlscent iPad V6] Missing Delta APIs")
    return
end

local SOURCE_TEXTURE_ID="7658055825"

local function extractId(v)
    if type(v)~="string" then return nil end
    return v:match("rbxassetid://(%d+)")
        or v:match("[?&]id=(%d+)")
        or v:match("(%d+)")
end

local function register(file,url)
    local lastErr
    for attempt=1,4 do
        local ok,res=pcall(function()
            local body=game:HttpGet(url)
            if type(body)~="string" or #body<32 then
                error("bad download")
            end
            write(file,body)
            local id=custom(file)
            if type(id)~="string" or id=="" then
                error("getcustomasset failed")
            end
            return id
        end)
        if ok then return res end
        lastErr=res
        task.wait(0.35*attempt)
    end
    warn("[Pearlscent iPad V6] Asset failed: "..tostring(lastErr))
    return nil
end

local pearlescentTexture=register(
    "pearlscent_v6_world.png",
    "https://raw.githubusercontent.com/H4rb0r-rbx/Fleasion-pearlscent-textures/main/fcc06bbf-0829-4e29-80ac-661bcbb57a22-removebg-preview.png"
)

if not pearlescentTexture then
    warn("[Pearlscent iPad V6] Main texture could not load")
    return
end

-- Keep the other Pearlscent replacements too.
local GeneralMap={
    ["16537337310"]="rbxassetid://70643163489676",
    ["16537449730"]="rbxassetid://70643163489676",
}

local extras={
    {"pearlscent_v6_double_jump.ogg","https://raw.githubusercontent.com/H4rb0r-rbx/Fleasion-pearlscent-textures/main/bell%20ding%20sfx.ogg",{16770456156,16492958314}},
    {"pearlscent_v6_item_background.png","https://raw.githubusercontent.com/H4rb0r-rbx/Fleasion-pearlscent-textures/main/IMG_4989.PNG",{13220167337,13188242420,13220167472,13188153054,13188242287}},
    {"pearlscent_v6_slide.wav","https://raw.githubusercontent.com/H4rb0r-rbx/Fleasion-pearlscent-textures/main/sparkle.wav",{16737738420}},
    {"pearlscent_v6_click.mp3","https://raw.githubusercontent.com/H4rb0r-rbx/Fleasion-pearlscent-textures/main/universfield-water-drop-131023.mp3",{177266782}},
    {"pearlscent_v6_kill.mp3","https://raw.githubusercontent.com/H4rb0r-rbx/Fleasion-pearlscent-textures/main/benkirb-shine-1-268902.mp3",{16530229616,16530229541,16530229695}},
}

for _,a in ipairs(extras) do
    local rep=register(a[1],a[2])
    if rep then
        for _,id in ipairs(a[3]) do
            GeneralMap[tostring(id)]=rep
        end
    end
end

local fontAsset=register(
    "pearlscent_v6_font.ttf",
    "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/Garet-Book.ttf"
)

local FontIds={
    ["12187323909"]=true,["12187320363"]=true,["12187354260"]=true,
    ["12187342816"]=true,["12187280273"]=true,["12187303601"]=true,
    ["12187262242"]=true,["12187288714"]=true,["12187341500"]=true,
    ["12187271237"]=true,["12187341020"]=true,
}

local function patchTextureObject(obj)
    if not obj:IsA("Texture") then return false end

    local ok,old=pcall(function() return obj.Texture end)
    if not ok then return false end

    if extractId(old)==SOURCE_TEXTURE_ID then
        pcall(function()
            obj.Texture=pearlescentTexture
        end)
        return true
    end

    local rep=GeneralMap[extractId(old)]
    if rep and rep~=old then
        pcall(function() obj.Texture=rep end)
        return true
    end

    return false
end

local function patchOther(obj)
    if obj:IsA("Sound") then
        pcall(function()
            local old=obj.SoundId
            local rep=GeneralMap[extractId(old)]
            if rep and rep~=old then obj.SoundId=rep end
        end)

    elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
        pcall(function()
            local old=obj.Image
            local id=extractId(old)
            if id==SOURCE_TEXTURE_ID then
                obj.Image=pearlescentTexture
            else
                local rep=GeneralMap[id]
                if rep and rep~=old then obj.Image=rep end
            end
        end)

    elseif obj:IsA("Decal") then
        pcall(function()
            local old=obj.Texture
            local id=extractId(old)
            if id==SOURCE_TEXTURE_ID then
                obj.Texture=pearlescentTexture
            else
                local rep=GeneralMap[id]
                if rep and rep~=old then obj.Texture=rep end
            end
        end)

    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
        pcall(function()
            local old=obj.Texture
            local rep=GeneralMap[extractId(old)]
            if rep and rep~=old then obj.Texture=rep end
        end)
    end

    if fontAsset and (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then
        pcall(function()
            local f=obj.FontFace
            local id=extractId(f.Family)
            if id and FontIds[id] then
                obj.FontFace=Font.new(fontAsset,f.Weight,f.Style)
            end
        end)
    end
end

local busy=false
local function scan()
    if busy or env[KEY]~=state then return end
    busy=true

    local matched=0
    for i,obj in ipairs(game:GetDescendants()) do
        if obj:IsA("Texture") then
            if patchTextureObject(obj) then matched+=1 end
        else
            patchOther(obj)
        end

        if i%250==0 then
            task.wait()
        end
    end

    busy=false
    print("[Pearlscent iPad V6] scan complete, texture matches patched: "..matched)
end

-- Initial pass.
task.spawn(scan)

-- Patch streamed Arena/ShootingRange objects as they appear.
keep(game.DescendantAdded:Connect(function(obj)
    task.defer(function()
        if env[KEY]~=state then return end

        if obj:IsA("Texture") then
            patchTextureObject(obj)
            task.wait(0.15)
            if obj.Parent then patchTextureObject(obj) end
            task.wait(0.5)
            if obj.Parent then patchTextureObject(obj) end
            task.wait(1.5)
            if obj.Parent then patchTextureObject(obj) end
        else
            patchOther(obj)
        end
    end)
end))

-- RIVALS can populate/rewrite texture objects shortly after the area appears.
for _,t in ipairs({1,2.5,5,9,15,25}) do
    task.delay(t,scan)
end

local lp=game:GetService("Players").LocalPlayer
if lp then
    keep(lp.CharacterAdded:Connect(function()
        task.delay(0.5,scan)
        task.delay(2,scan)
        task.delay(5,scan)
    end))
end

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title="Pearlscent iPad V6",
        Text="Texture-object Arena fix loaded",
        Duration=6
    })
end)

print("[Pearlscent iPad V6] loaded")
