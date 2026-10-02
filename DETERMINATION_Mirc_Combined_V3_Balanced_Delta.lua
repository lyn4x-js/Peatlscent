-- DETERMINATION + Mirc's 5k Pack combined Delta/iOS payload - V3 Balanced mobile version
-- Conflict policy: DETERMINATION wins when both packs replace the same source asset ID.
-- Mirc's pack fills replacements that DETERMINATION does not define.

local env = (getgenv and getgenv()) or _G
local PREFIX = '[Combined Pack] '
local STATE_KEY = '__DELTA_PACK_DETERMINATION_MIRC_COMBINED'
local write = rawget(env,'writefile') or writefile
local exists = rawget(env,'isfile') or isfile
local customAsset = rawget(env,'getcustomasset') or getcustomasset or getsynasset

if typeof(game.HttpGet) ~= 'function' then warn(PREFIX..'game:HttpGet unavailable'); return end

if env[STATE_KEY] and env[STATE_KEY].connections then
  for _,c in ipairs(env[STATE_KEY].connections) do pcall(function() c:Disconnect() end) end
end
local state={connections={}}; env[STATE_KEY]=state
local function keep(c) if c then table.insert(state.connections,c) end end

local IdMap={
  ["2108482005"]="rbxassetid://7658055825",
  ["2108482231"]="rbxassetid://7658055825",
  ["2108482395"]="rbxassetid://7658055825",
  ["2108482542"]="rbxassetid://7658055825",
  ["2108482676"]="rbxassetid://7658055825",
  ["2108545280"]="rbxassetid://7658055825",
  ["7658055825"]="rbxassetid://6372755229",
  ["10196549902"]="rbxassetid://7658055825",
  ["10196550128"]="rbxassetid://7658055825",
  ["10196550367"]="rbxassetid://7658055825",
  ["10196550667"]="rbxassetid://7658055825",
  ["10196550937"]="rbxassetid://7658055825",
  ["10196567794"]="rbxassetid://7658055825",
  ["12261809766"]="rbxassetid://7658055825",
  ["12261813110"]="rbxassetid://7658055825",
  ["12261813678"]="rbxassetid://7658055825",
  ["14147881297"]="rbxassetid://7658055825",
  ["14147881792"]="rbxassetid://7658055825",
  ["14147882149"]="rbxassetid://7658055825",
  ["14147882405"]="rbxassetid://7658055825",
  ["14147882761"]="rbxassetid://7658055825",
  ["14147883091"]="rbxassetid://7658055825",
  ["15109829804"]="rbxassetid://109303978243933",
  ["70643163489676"]="rbxassetid://17405655409",
  ["72960281658487"]="rbxassetid://7658055825",
  ["84214501374682"]="rbxassetid://7658055825",
  ["89972436184102"]="rbxassetid://7658055825",
  ["92138082970751"]="rbxassetid://7658055825",
  ["99135525400251"]="rbxassetid://7712639823",
  ["103020541883227"]="rbxassetid://7658055825",
  ["135908632589654"]="rbxassetid://7658055825",
}

local Assets={
  {
    name="change map init sound to deltarune", file="combined_001_change_map_init_sound_to_deltarune.wav", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_b.wav",
    ids={"103035811146294"},
  },
  {
    name="change win to undertale", file="combined_002_change_win_to_undertale.wav", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/mus_sfx_abreak.wav",
    ids={"16810041280"},
  },
  {
    name="change lose to deltarune", file="combined_003_change_lose_to_deltarune.ogg", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_closet_impact.ogg",
    ids={"16810321565"},
  },
  {
    name="deltarune font", file="combined_004_deltarune_font.ttf", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/PixelOperator-Bold.ttf",
    ids={"12187323909","12187320363","12187354260","12187342816","12187280273","12187303601","12187262242","12187288714","12187341500","12187271237","12187341020"},
  },
  {
    name="all heads with ding", file="combined_005_all_heads_with_ding.wav", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_break1.wav",
    ids={"16537337310","16537449730"},
  },
  {
    name="countdown to finale", file="combined_006_countdown_to_finale.ogg", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Finale.ogg",
    ids={"17826470563"},
  },
  {
    name="change win to dumbvictory", file="combined_007_change_win_to_dumbvictory.wav", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_dumbvictory.wav",
    ids={"18221725850","18239670056","18221726246"},
  },
  {
    name="undertale the logo", file="combined_008_undertale_the_logo.png", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/undlogo.png",
    ids={"17803962335"},
  },
  {
    name="change lvl icon", file="combined_009_change_lvl_icon.png", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/lvl.png",
    ids={"81461991645938","13188153054","13188242420","13220167472","13220167337"},
  },
  {
    name="matchpoint", file="combined_010_matchpoint.wav", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_heavydamage.wav",
    ids={"17026600996"},
  },
  {
    name="kill to undertale", file="combined_011_kill_to_undertale.wav", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/mus_sfx_gigapunch.wav",
    ids={"16530229616","16530229541","16530229695"},
  },
  {
    name="flowey", file="combined_012_flowey.png", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/58a20c59c8dd3432c6fa8221.png",
    ids={"133917828562858","121503061771505"},
  },
  {
    name="onyx skybox support", file="combined_013_onyx_skybox_support.ttf", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/SyneMono-Regular.ttf",
    ids={"127338559130032","16294586406","75156669118637","93477262732302"},
  },
  {
    name="arch to x+", file="combined_014_arch_to_x.png", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Archnemisis_heart_1.png",
    ids={"133793956251748"},
  },
  {
    name="nem to x standard", file="combined_015_nem_to_x_standard.png", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Nemisis_heart_1.png",
    ids={"116941545385923"},
  },
  {
    name="bronze 1 to heart", file="combined_016_bronze_1_to_heart.png", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/bronze_1_heart_fixed_2_times.png",
    ids={"106623367501544"},
  },
  {
    name="b2 to heart", file="combined_017_b2_to_heart.png", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/bronze_2_heart.png",
    ids={"131795064007344"},
  },
  {
    name="bronze 3", file="combined_018_bronze_3.png", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/f.png",
    ids={"73543520622815"},
  },
  {
    name="silver 1 to d-", file="combined_019_silver_1_to_d-.png", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Silver_1_heart.png",
    ids={"80716950169934"},
  },
  {
    name="silver 2 to d", file="combined_020_silver_2_to_d.png", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/silver_2_heart.png",
    ids={"136100661820261"},
  },
  {
    name="silver 3 to d+", file="combined_021_silver_3_to_d.png", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/silver_3_heart.png",
    ids={"107898816876115"},
  },
  {
    name="gold 1 to c-", file="combined_022_gold_1_to_c-.png", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Gold_1_heart.png",
    ids={"134520747948636"},
  },
  {
    name="gold 2 to c", file="combined_023_gold_2_to_c.png", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Gold_2_heart.png",
    ids={"114166096331502"},
  },
  {
    name="gold 3 to c+", file="combined_024_gold_3_to_c.png", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Gold_3_heart.png",
    ids={"90039594400813"},
  },
  {
    name="plat 1 to b-", file="combined_025_plat_1_to_b-.png", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Plat_1_heart.png",
    ids={"133903971285645"},
  },
  {
    name="plat 2 to b", file="combined_026_plat_2_to_b.png", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Plat_2_heart.png",
    ids={"82834564754747"},
  },
  {
    name="plat 3 to b+", file="combined_027_plat_3_to_b.png", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Plat_3_heart.png",
    ids={"73345783863790"},
  },
  {
    name="diam 1 to a-", file="combined_028_diam_1_to_a-.png", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Diam_1_heart.png",
    ids={"113997689031026"},
  },
  {
    name="diam2 to A rank", file="combined_029_diam2_to_a_rank.png", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Diam_2_heart.png",
    ids={"88059506918419"},
  },
  {
    name="diam 3 to a+", file="combined_030_diam_3_to_a.png", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Diam_3_heart.png",
    ids={"112183171942172"},
  },
  {
    name="o1 to s", file="combined_031_o1_to_s.png", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Onyx_1_heart.png",
    ids={"104871954739030"},
  },
  {
    name="o2 to ss", file="combined_032_o2_to_ss.png", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Onyx_2_heart.png",
    ids={"109012386782238"},
  },
  {
    name="o3 to u", file="combined_033_o3_to_u.png", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Onyx_3_heart.png",
    ids={"127982903682334"},
  },
  {
    name="streak icon replacement", file="combined_034_streak_icon_replacement.png", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/streak.png",
    ids={"17175092502","17094014569"},
  },
  {
    name="self snitching", file="combined_035_self_snitching.png", url="https://raw.githubusercontent.com/prism658/Resources-fleasion/main/icbtw.png",
    ids={"99115398611290"},
  },
  {
    name="upd data", file="combined_036_upd_data.json", url="https://raw.githubusercontent.com/prism658/Resources-fleasion/main/upddata.json",
    ids={"101218118381254"},
  },
  {
    name="replace sparkle pop with weaponpull", file="combined_037_replace_sparkle_pop_with_weaponpull.wav", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_weaponpull.wav",
    ids={"8483887957"},
  },
  {
    name="replace intro with appearance.wav", file="combined_038_replace_intro_with_appearance_wav.wav", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/AUDIO_APPEARANCE.wav",
    ids={"6384899588"},
  },
  {
    name="replace slide sfx with uk slide", file="combined_039_replace_slide_sfx_with_uk_slide.mp3", url="https://raw.githubusercontent.com/prism658/Resources-fleasion/main/Sliding.mp3",
    ids={"16737738420"},
  },
  {
    name="replace demote rank with awwww", file="combined_040_replace_demote_rank_with_awwww.mp3", url="https://raw.githubusercontent.com/prism658/Resources-fleasion/main/studio-audience-awwww-sound-fx.mp3",
    ids={"91547731028928"},
  },
  {
    name="replace promote with final fantasy fanfare", file="combined_041_replace_promote_with_final_fantasy_fanfare.mp3", url="https://raw.githubusercontent.com/prism658/Resources-fleasion/main/final-fantasy-vii-victory-fanfare-1.mp3",
    ids={"138975587469438"},
  },
  {
    name="replace the nosniy logo g with heartright", file="combined_042_replace_the_nosniy_logo_g_with_heartright.png", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/heartright.png",
    ids={"13854780213"},
  },
  {
    name="change music", file="combined_043_change_music.mp3", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Hotel.mp3",
    ids={"17697682466","17733314783"},
  },
  {
    name="replace click ui with select deltarune", file="combined_044_replace_click_ui_with_select_deltarune.wav", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_select.wav",
    ids={"177266782"},
  },
  {
    name="matchmaking to undertale", file="combined_045_matchmaking_to_undertale.wav", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_dimbox.wav",
    ids={"18525513345"},
  },
  {
    name="change elim icon to undertale", file="combined_046_change_elim_icon_to_undertale.png", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/heartbroken.png",
    ids={"16802957270"},
  },
  {
    name="hitmarker change", file="combined_047_hitmarker_change.wav", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_credit_s.wav",
    ids={"13110130082"},
  },
  {
    name="sudden death", file="combined_048_sudden_death.ogg", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/sdfinal.ogg",
    ids={"17467242617"},
  },
  {
    name="elim to break2", file="combined_049_elim_to_break2.ogg", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/break2.ogg",
    ids={"17016581922"},
  },
  {
    name="replace d jump with deltarune sndswallow", file="combined_050_replace_d_jump_with_deltarune_sndswallow.wav", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/mus_sfx_a_lithit.wav",
    ids={"16770456156"},
  },
  {
    name="replace dash with deltadash", file="combined_051_replace_dash_with_deltadash.wav", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_scytheburst.wav",
    ids={"16492958314"},
  },
  {
    name="heal sfx", file="combined_052_heal_sfx.ogg", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/heal.ogg",
    ids={"17138490999"},
  },
  {
    name="replace the N with heartleft", file="combined_053_replace_the_n_with_heartleft.png", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/heartleft.png",
    ids={"13854780042"},
  },
  {
    name="quick melee fail to snd", file="combined_054_quick_melee_fail_to_snd.wav", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_breakc.wav",
    ids={"17153811469"},
  },
  {
    name="unraked to heart", file="combined_055_unraked_to_heart.png", url="https://raw.githubusercontent.com/prism658/undertale-txtpack/main/unranked_heart.png",
    ids={"111599878354131"},
  },
}

local function downloadAndRegister(a)
  if not write or not customAsset then warn(PREFIX..'writefile/getcustomasset unavailable; skipped '..a.name); return nil end
  local ok,res=pcall(function()
    local need=true
    if exists then local e,p=pcall(exists,a.file); need=not(e and p) end
    if need then local body=game:HttpGet(a.url); if type(body)~='string' or #body==0 then error('empty download') end; write(a.file,body) end
    local id=customAsset(a.file); if type(id)~='string' or id=='' then error('no custom asset id') end; return id
  end)
  if not ok then warn(PREFIX..'failed '..a.name..': '..tostring(res)); return nil end
  return res
end

for _,a in ipairs(Assets) do
  local content=downloadAndRegister(a)
  if content then for _,id in ipairs(a.ids) do IdMap[tostring(id)]=content end end
end

local function extractId(v)
  if type(v)~='string' then return nil end
  return v:match('rbxassetid://(%d+)') or v:match('[?&]id=(%d+)') or v:match('(%d+)')
end
local function replacementFor(v) local id=extractId(v); return id and IdMap[id] or nil end

local propsByClass={
 Sound={'SoundId'}, ImageLabel={'Image'}, ImageButton={'Image'}, Decal={'Texture'}, Texture={'Texture'},
 MeshPart={'TextureID'}, SpecialMesh={'TextureId','MeshId'}, ParticleEmitter={'Texture'}, Trail={'Texture'}, Beam={'Texture'},
 Sky={'SkyboxBk','SkyboxDn','SkyboxFt','SkyboxLf','SkyboxRt','SkyboxUp'}, Shirt={'ShirtTemplate'}, Pants={'PantsTemplate'},
 ShirtGraphic={'Graphic'}, Animation={'AnimationId'}, VideoFrame={'Video'}
}

local function replaceProperty(obj,prop)
  local ok,old=pcall(function() return obj[prop] end); if not ok or type(old)~='string' then return end
  local new=replacementFor(old); if new and new~=old then pcall(function() obj[prop]=new end) end
end
local function replaceFont(obj)
  pcall(function() local f=obj.FontFace; local new=replacementFor(f.Family); if new then obj.FontFace=Font.new(new,f.Weight,f.Style) end end)
end

-- V3 Balanced mobile mode:
-- Scan existing objects once. For new texture-capable objects, retry briefly
-- while RIVALS finishes assigning their asset IDs, then stop all retry work.
local function applyObject(obj)
  local matched=false
  for class,props in pairs(propsByClass) do
    if obj:IsA(class) then
      matched=true
      for _,prop in ipairs(props) do replaceProperty(obj,prop) end
      break
    end
  end
  if obj:IsA('TextLabel') or obj:IsA('TextButton') or obj:IsA('TextBox') then
    matched=true
    replaceFont(obj)
  end
  return matched
end

for _,obj in ipairs(game:GetDescendants()) do
  applyObject(obj)
end

keep(game.DescendantAdded:Connect(function(obj)
  task.defer(function()
    if not obj or not obj.Parent then return end
    if not applyObject(obj) then return end

    -- Short-lived retries only: catches late texture assignment without
    -- permanent per-property listeners or a repeating whole-game scan.
    for _,delayTime in ipairs({0.15,0.4,0.9,1.8,3.0}) do
      task.wait(delayTime)
      if not obj or not obj.Parent or env[STATE_KEY]~=state then return end
      applyObject(obj)
    end
  end)
end))

local count=0; for _ in pairs(IdMap) do count+=1 end
pcall(function() game:GetService('StarterGui'):SetCore('SendNotification',{Title='DETERMINATION + Mirc V3',Text='Loaded '..count..' replacement IDs',Duration=6}) end)
print(PREFIX..'loaded '..count..' replacement IDs')
