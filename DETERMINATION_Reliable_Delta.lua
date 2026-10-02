-- DETERMINATION ONLY - Safe/No-Lag rebuild from the user's original DETERMINATION.json
-- Typed replacements prevent image properties from receiving audio/font custom assets.
-- Uses a fresh cache namespace and no repeating whole-game scan.

local PREFIX = "[DETERMINATION SAFE] "
local env = (getgenv and getgenv()) or _G
local write = rawget(env,"writefile") or writefile
local exists = rawget(env,"isfile") or isfile
local customAsset = rawget(env,"getcustomasset") or getcustomasset or getsynasset
if typeof(game.HttpGet) ~= "function" then warn(PREFIX.."HttpGet unavailable"); return end

local STATE_KEY="__DELTA_PACK_DETERMINATION_RELIABLE_V2"
if env[STATE_KEY] and env[STATE_KEY].connections then for _,c in ipairs(env[STATE_KEY].connections) do pcall(function() c:Disconnect() end) end end
local state={connections={}}; env[STATE_KEY]=state
local function keep(c) if c then table.insert(state.connections,c) end end

local DirectMap={
  ["7658055825"]="rbxassetid://6372755229",
  ["2108482005"]="rbxassetid://7658055825",
  ["14147881792"]="rbxassetid://7658055825",
  ["135908632589654"]="rbxassetid://7658055825",
  ["84214501374682"]="rbxassetid://7658055825",
  ["10196550937"]="rbxassetid://7658055825",
  ["12261809766"]="rbxassetid://7658055825",
  ["2108545280"]="rbxassetid://7658055825",
  ["10196550667"]="rbxassetid://7658055825",
  ["14147882149"]="rbxassetid://7658055825",
  ["103020541883227"]="rbxassetid://7658055825",
  ["89972436184102"]="rbxassetid://7658055825",
  ["12261813110"]="rbxassetid://7658055825",
  ["14147883091"]="rbxassetid://7658055825",
  ["2108482395"]="rbxassetid://7658055825",
  ["10196550128"]="rbxassetid://7658055825",
  ["14147882405"]="rbxassetid://7658055825",
  ["2108482542"]="rbxassetid://7658055825",
  ["10196549902"]="rbxassetid://7658055825",
  ["14147881297"]="rbxassetid://7658055825",
  ["72960281658487"]="rbxassetid://7658055825",
  ["92138082970751"]="rbxassetid://7658055825",
  ["2108482676"]="rbxassetid://7658055825",
  ["10196567794"]="rbxassetid://7658055825",
  ["12261813678"]="rbxassetid://7658055825",
  ["14147882761"]="rbxassetid://7658055825",
  ["10196550367"]="rbxassetid://7658055825",
  ["2108482231"]="rbxassetid://7658055825",
}
local ImageMap={}
local AudioMap={}
local FontMap={}

local function validBody(body,ext)
  if type(body)~="string" or #body<4 then return false end
  if ext==".png" then return body:sub(1,8)=="\137PNG\r\n\26\n" end
  if ext==".wav" then return body:sub(1,4)=="RIFF" end
  if ext==".ogg" then return body:sub(1,4)=="OggS" end
  if ext==".ttf" then local h=body:sub(1,4); return h=="\0\1\0\0" or h=="OTTO" end
  if ext==".mp3" then return body:sub(1,3)=="ID3" or body:byte(1)==255 end
  return true
end

local function registerAsset(a)
  if not write or not customAsset then return nil end
  local lastErr
  for attempt=1,3 do
    local ok,res=pcall(function()
      local body=game:HttpGet(a.url)
      if not validBody(body,a.ext) then error("invalid "..a.ext.." download") end
      write(a.file,body) -- always overwrite stale/broken cache
      local id=customAsset(a.file)
      if type(id)~="string" or id=="" then error("getcustomasset returned no id") end
      return id
    end)
    if ok then return res end
    lastErr=res
    task.wait(0.35*attempt)
  end
  warn(PREFIX.."skipped "..a.name.." after retries: "..tostring(lastErr))
  return nil
end

local Assets={
  {name="deltarune font",file="determination_safe_v1_001.ttf",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/deltarune.ttf",kind="font",ext=".ttf",ids={12187323909,12187320363,12187354260,12187342816,12187280273,12187303601,12187262242,12187288714,12187341500,12187271237,12187341020}},
  {name="replace intro with appearance.wav",file="determination_safe_v1_002.wav",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/AUDIO_APPEARANCE.wav",kind="audio",ext=".wav",ids={6384899588}},
  {name="replace sparkle pop with weaponpull",file="determination_safe_v1_003.wav",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_weaponpull.wav",kind="audio",ext=".wav",ids={8483887957}},
  {name="all heads with ding",file="determination_safe_v1_004.wav",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_break1.wav",kind="audio",ext=".wav",ids={16537337310,16537449730}},
  {name="elim to break2",file="determination_safe_v1_006.ogg",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/break2.ogg",kind="audio",ext=".ogg",ids={17016581922}},
  {name="change lose to deltarune",file="determination_safe_v1_007.ogg",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_closet_impact.ogg",kind="audio",ext=".ogg",ids={16810321565}},
  {name="replace d jump with deltarune sndswallow",file="determination_safe_v1_008.wav",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/mus_sfx_a_lithit.wav",kind="audio",ext=".wav",ids={16770456156}},
  {name="replace click ui with select deltarune",file="determination_safe_v1_009.wav",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_select.wav",kind="audio",ext=".wav",ids={177266782}},
  {name="replace dash with deltadash",file="determination_safe_v1_010.wav",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_scytheburst.wav",kind="audio",ext=".wav",ids={16492958314}},
  {name="change elim icon to undertale",file="determination_safe_v1_011.png",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/heartbroken.png",kind="image",ext=".png",ids={16802957270}},
  {name="change map init sound to deltarune",file="determination_safe_v1_012.wav",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_b.wav",kind="audio",ext=".wav",ids={103035811146294}},
  {name="change lvl icon",file="determination_safe_v1_013.png",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/lvl.png",kind="image",ext=".png",ids={81461991645938}},
  {name="change win to undertale",file="determination_safe_v1_014.wav",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/mus_sfx_abreak.wav",kind="audio",ext=".wav",ids={16810041280}},
  {name="kill to undertale",file="determination_safe_v1_015.wav",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/mus_sfx_gigapunch.wav",kind="audio",ext=".wav",ids={16530229695,16530229541,16530229616}},
  {name="heal sfx",file="determination_safe_v1_016.ogg",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/heal.ogg",kind="audio",ext=".ogg",ids={17138490999}},
  {name="replace the N with heartleft",file="determination_safe_v1_017.png",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/heartleft.png",kind="image",ext=".png",ids={13854780042}},
  {name="replace the nosniy logo g with heartright",file="determination_safe_v1_018.png",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/heartright.png",kind="image",ext=".png",ids={13854780213}},
  {name="undertale the logo",file="determination_safe_v1_019.png",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/undlogo.png",kind="image",ext=".png",ids={17803962335}},
  {name="matchmaking to undertale",file="determination_safe_v1_020.wav",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_dimbox.wav",kind="audio",ext=".wav",ids={18525513345}},
  {name="hitmarker change",file="determination_safe_v1_021.wav",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_credit_s.wav",kind="audio",ext=".wav",ids={13110130082}},
  {name="quick melee fail to snd",file="determination_safe_v1_022.wav",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_breakc.wav",kind="audio",ext=".wav",ids={17153811469}},
  {name="change hud",file="determination_safe_v1_023.png",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/lvl.png",kind="image",ext=".png",ids={13188153054,13188242420,13220167472,13220167337}},
  {name="countdown to finale",file="determination_safe_v1_024.ogg",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Finale.ogg",kind="audio",ext=".ogg",ids={17826470563}},
  {name="matchpoint",file="determination_safe_v1_025.wav",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_heavydamage.wav",kind="audio",ext=".wav",ids={17026600996}},
  {name="sudden death",file="determination_safe_v1_026.ogg",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/sdfinal.ogg",kind="audio",ext=".ogg",ids={17467242617}},
  {name="change win to dumbvictory",file="determination_safe_v1_027.wav",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_dumbvictory.wav",kind="audio",ext=".wav",ids={18221725850,18239670056,18221725850,18221726246}},
  {name="onyx skybox support",file="determination_safe_v1_030.ttf",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/SyneMono-Regular.ttf",kind="font",ext=".ttf",ids={127338559130032,16294586406,75156669118637,93477262732302}},
  {name="change music",file="determination_safe_v1_031.mp3",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Hotel.mp3",kind="audio",ext=".mp3",ids={17697682466,17733314783}},
  {name="flowey",file="determination_safe_v1_032.png",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/58a20c59c8dd3432c6fa8221.png",kind="image",ext=".png",ids={133917828562858,121503061771505}},
  {name="arch to x+",file="determination_safe_v1_033.png",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Archnemisis_heart_1.png",kind="image",ext=".png",ids={133793956251748}},
  {name="nem to x standard",file="determination_safe_v1_034.png",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Nemisis_heart_1.png",kind="image",ext=".png",ids={116941545385923}},
  {name="bronze 3",file="determination_safe_v1_035.png",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/f.png",kind="image",ext=".png",ids={106623367501544,131795064007344,73543520622815}},
  {name="silver 1 to d-",file="determination_safe_v1_036.png",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Silver_1_heart.png",kind="image",ext=".png",ids={80716950169934}},
  {name="silver 2 to d",file="determination_safe_v1_037.png",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/silver_2_heart.png",kind="image",ext=".png",ids={136100661820261}},
  {name="silver 3 to d+",file="determination_safe_v1_038.png",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/silver_3_heart.png",kind="image",ext=".png",ids={107898816876115}},
  {name="gold 1 to c-",file="determination_safe_v1_039.png",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Gold_1_heart.png",kind="image",ext=".png",ids={134520747948636}},
  {name="gold 2 to c",file="determination_safe_v1_040.png",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Gold_2_heart.png",kind="image",ext=".png",ids={114166096331502}},
  {name="gold 3 to c+",file="determination_safe_v1_041.png",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Gold_3_heart.png",kind="image",ext=".png",ids={90039594400813}},
  {name="plat 1 to b-",file="determination_safe_v1_042.png",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Plat_1_heart.png",kind="image",ext=".png",ids={133903971285645}},
  {name="plat 2 to b",file="determination_safe_v1_043.png",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Plat_2_heart.png",kind="image",ext=".png",ids={82834564754747}},
  {name="plat 3 to b+",file="determination_safe_v1_044.png",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Plat_3_heart.png",kind="image",ext=".png",ids={73345783863790}},
  {name="diam 1 to a-",file="determination_safe_v1_045.png",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Diam_1_heart.png",kind="image",ext=".png",ids={113997689031026}},
  {name="diam2 to A rank",file="determination_safe_v1_046.png",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Diam_2_heart.png",kind="image",ext=".png",ids={88059506918419}},
  {name="diam 3 to a+",file="determination_safe_v1_047.png",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Diam_3_heart.png",kind="image",ext=".png",ids={112183171942172}},
  {name="o1 to s",file="determination_safe_v1_048.png",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Onyx_1_heart.png",kind="image",ext=".png",ids={104871954739030}},
  {name="o2 to ss",file="determination_safe_v1_049.png",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Onyx_2_heart.png",kind="image",ext=".png",ids={109012386782238}},
  {name="o3 to u",file="determination_safe_v1_050.png",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Onyx_3_heart.png",kind="image",ext=".png",ids={127982903682334}},
  {name="bronze 1 to heart",file="determination_safe_v1_051.png",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/bronze_1_heart_fixed_2_times.png",kind="image",ext=".png",ids={106623367501544}},
  {name="b2 to heart",file="determination_safe_v1_052.png",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/bronze_2_heart.png",kind="image",ext=".png",ids={131795064007344}},
  {name="streak icon replacement",file="determination_safe_v1_053.png",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/streak.png",kind="image",ext=".png",ids={17175092502,17094014569}},
  {name="unraked to heart",file="determination_safe_v1_054.png",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/unranked_heart.png",kind="image",ext=".png",ids={111599878354131}},
  {name="deltarune font",file="determination_safe_v1_055.ttf",url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/PixelOperator-Bold.ttf",kind="font",ext=".ttf",ids={12187323909,12187320363,12187354260,12187342816,12187280273,12187303601,12187262242,12187288714,12187341500,12187271237,12187341020}},
}

for _,a in ipairs(Assets) do
  local content=registerAsset(a)
  if content then
    local target=(a.kind=="image" and ImageMap) or (a.kind=="audio" and AudioMap) or (a.kind=="font" and FontMap)
    if target then for _,id in ipairs(a.ids) do target[tostring(id)]=content end end
  end
end

local function extractId(v)
  if type(v)~="string" then return nil end
  return v:match("rbxassetid://(%d+)") or v:match("[?&]id=(%d+)") or v:match("(%d+)")
end
local function lookup(v,map,allowDirect)
  local id=extractId(v); if not id then return nil end
  return map[id] or (allowDirect and DirectMap[id] or nil)
end

local imageProps={
  ImageLabel={"Image"}, ImageButton={"Image"}, Decal={"Texture"}, Texture={"Texture"},
  MeshPart={"TextureID"}, SpecialMesh={"TextureId"}, ParticleEmitter={"Texture"},
  Trail={"Texture"}, Beam={"Texture"}, Sky={"SkyboxBk","SkyboxDn","SkyboxFt","SkyboxLf","SkyboxRt","SkyboxUp"},
  Shirt={"ShirtTemplate"}, Pants={"PantsTemplate"}, ShirtGraphic={"Graphic"},
}

local function applyObject(obj)
  local relevant=false
  if obj:IsA("Sound") then
    relevant=true
    local ok,old=pcall(function() return obj.SoundId end)
    if ok then local new=lookup(old,AudioMap,false); if new and new~=old then pcall(function() obj.SoundId=new end) end end
  else
    for class,props in pairs(imageProps) do
      if obj:IsA(class) then
        relevant=true
        for _,prop in ipairs(props) do
          local ok,old=pcall(function() return obj[prop] end)
          if ok then local new=lookup(old,ImageMap,true); if new and new~=old then pcall(function() obj[prop]=new end) end end
        end
        break
      end
    end
  end
  if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
    relevant=true
    pcall(function()
      local f=obj.FontFace; local new=lookup(f.Family,FontMap,false)
      if new then obj.FontFace=Font.new(new,f.Weight,f.Style) end
    end)
  end
  return relevant
end

for _,obj in ipairs(game:GetDescendants()) do applyObject(obj) end
keep(game.DescendantAdded:Connect(function(obj)
  task.defer(function()
    if not obj or not obj.Parent or not applyObject(obj) then return end
    for _,delayTime in ipairs({0.2,0.6,1.4,3.0}) do
      task.wait(delayTime)
      if env[STATE_KEY]~=state or not obj or not obj.Parent then return end
      applyObject(obj)
    end
  end)
end))

local count=0; for _ in pairs(DirectMap) do count+=1 end; for _ in pairs(ImageMap) do count+=1 end; for _ in pairs(AudioMap) do count+=1 end; for _ in pairs(FontMap) do count+=1 end
pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="DETERMINATION Reliable",Text="Loaded "..count.." validated replacements",Duration=6}) end)
print(PREFIX.."loaded "..count.." validated replacements")