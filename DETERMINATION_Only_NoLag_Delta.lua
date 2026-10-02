-- DETERMINATION - Delta/iOS asset replacement payload
-- Generated from the uploaded Fleasion JSON. Paste this whole file into Delta,
-- or host it on GitHub and execute it with loadstring(game:HttpGet(RAW_URL))().

local PREFIX = "[DETERMINATION] "
local env = (getgenv and getgenv()) or _G
local write = rawget(env, "writefile") or writefile
local exists = rawget(env, "isfile") or isfile
local customAsset = rawget(env, "getcustomasset") or getcustomasset or getsynasset

if typeof(game.HttpGet) ~= "function" then
    warn(PREFIX .. "game:HttpGet is unavailable")
    return
end

-- Clean up listeners from an earlier run of this same payload.
local STATE_KEY = "__DELTA_PACK_DETERMINATION"
if env[STATE_KEY] and env[STATE_KEY].connections then
    for _, c in ipairs(env[STATE_KEY].connections) do pcall(function() c:Disconnect() end) end
end
local state = {connections = {}}
env[STATE_KEY] = state
local function keep(c) if c then table.insert(state.connections, c) end end

local IdMap = {
    ["7658055825"] = "rbxassetid://6372755229",
    ["2108482005"] = "rbxassetid://7658055825",
    ["14147881792"] = "rbxassetid://7658055825",
    ["135908632589654"] = "rbxassetid://7658055825",
    ["84214501374682"] = "rbxassetid://7658055825",
    ["10196550937"] = "rbxassetid://7658055825",
    ["12261809766"] = "rbxassetid://7658055825",
    ["2108545280"] = "rbxassetid://7658055825",
    ["10196550667"] = "rbxassetid://7658055825",
    ["14147882149"] = "rbxassetid://7658055825",
    ["103020541883227"] = "rbxassetid://7658055825",
    ["89972436184102"] = "rbxassetid://7658055825",
    ["12261813110"] = "rbxassetid://7658055825",
    ["14147883091"] = "rbxassetid://7658055825",
    ["135908632589654"] = "rbxassetid://7658055825",
    ["84214501374682"] = "rbxassetid://7658055825",
    ["2108482395"] = "rbxassetid://7658055825",
    ["12261809766"] = "rbxassetid://7658055825",
    ["10196550128"] = "rbxassetid://7658055825",
    ["14147882405"] = "rbxassetid://7658055825",
    ["135908632589654"] = "rbxassetid://7658055825",
    ["84214501374682"] = "rbxassetid://7658055825",
    ["2108482542"] = "rbxassetid://7658055825",
    ["12261809766"] = "rbxassetid://7658055825",
    ["10196549902"] = "rbxassetid://7658055825",
    ["14147881297"] = "rbxassetid://7658055825",
    ["72960281658487"] = "rbxassetid://7658055825",
    ["92138082970751"] = "rbxassetid://7658055825",
    ["2108482676"] = "rbxassetid://7658055825",
    ["10196567794"] = "rbxassetid://7658055825",
    ["12261813678"] = "rbxassetid://7658055825",
    ["14147882761"] = "rbxassetid://7658055825",
    ["12261809766"] = "rbxassetid://7658055825",
    ["135908632589654"] = "rbxassetid://7658055825",
    ["84214501374682"] = "rbxassetid://7658055825",
    ["10196550367"] = "rbxassetid://7658055825",
    ["2108482231"] = "rbxassetid://7658055825",
}

local Assets = {
    {
        name = "deltarune font",
        file = "delta_pack_001_deltarune_font.ttf",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/deltarune.ttf",
        ids = {12187323909, 12187320363, 12187354260, 12187342816, 12187280273, 12187303601, 12187262242, 12187288714, 12187341500, 12187271237, 12187341020},
    },
    {
        name = "replace intro with appearance.wav",
        file = "delta_pack_002_replace_intro_with_appearance_wav.wav",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/AUDIO_APPEARANCE.wav",
        ids = {6384899588},
    },
    {
        name = "replace sparkle pop with weaponpull",
        file = "delta_pack_003_replace_sparkle_pop_with_weaponpull.wav",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_weaponpull.wav",
        ids = {8483887957},
    },
    {
        name = "all heads with ding",
        file = "delta_pack_004_all_heads_with_ding.wav",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_break1.wav",
        ids = {16537337310, 16537449730},
    },
    {
        name = "elim to break2",
        file = "delta_pack_006_elim_to_break2.ogg",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/break2.ogg",
        ids = {17016581922},
    },
    {
        name = "change lose to deltarune",
        file = "delta_pack_007_change_lose_to_deltarune.ogg",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_closet_impact.ogg",
        ids = {16810321565},
    },
    {
        name = "replace d jump with deltarune sndswallow",
        file = "delta_pack_008_replace_d_jump_with_deltarune_sndswallow.wav",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/mus_sfx_a_lithit.wav",
        ids = {16770456156},
    },
    {
        name = "replace click ui with select deltarune",
        file = "delta_pack_009_replace_click_ui_with_select_deltarune.wav",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_select.wav",
        ids = {177266782},
    },
    {
        name = "replace dash with deltadash",
        file = "delta_pack_010_replace_dash_with_deltadash.wav",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_scytheburst.wav",
        ids = {16492958314},
    },
    {
        name = "change elim icon to undertale",
        file = "delta_pack_011_change_elim_icon_to_undertale.png",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/heartbroken.png",
        ids = {16802957270},
    },
    {
        name = "change map init sound to deltarune",
        file = "delta_pack_012_change_map_init_sound_to_deltarune.wav",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_b.wav",
        ids = {103035811146294},
    },
    {
        name = "change lvl icon",
        file = "delta_pack_013_change_lvl_icon.png",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/lvl.png",
        ids = {81461991645938},
    },
    {
        name = "change win to undertale",
        file = "delta_pack_014_change_win_to_undertale.wav",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/mus_sfx_abreak.wav",
        ids = {16810041280},
    },
    {
        name = "kill to undertale",
        file = "delta_pack_015_kill_to_undertale.wav",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/mus_sfx_gigapunch.wav",
        ids = {16530229695, 16530229541, 16530229616},
    },
    {
        name = "heal sfx",
        file = "delta_pack_016_heal_sfx.ogg",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/heal.ogg",
        ids = {17138490999},
    },
    {
        name = "replace the N with heartleft",
        file = "delta_pack_017_replace_the_n_with_heartleft.png",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/heartleft.png",
        ids = {13854780042},
    },
    {
        name = "replace the nosniy logo g with heartright",
        file = "delta_pack_018_replace_the_nosniy_logo_g_with_heartright.png",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/heartright.png",
        ids = {13854780213},
    },
    {
        name = "undertale the logo",
        file = "delta_pack_019_undertale_the_logo.png",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/undlogo.png",
        ids = {17803962335},
    },
    {
        name = "matchmaking to undertale",
        file = "delta_pack_020_matchmaking_to_undertale.wav",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_dimbox.wav",
        ids = {18525513345},
    },
    {
        name = "hitmarker change",
        file = "delta_pack_021_hitmarker_change.wav",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_credit_s.wav",
        ids = {13110130082},
    },
    {
        name = "quick melee fail to snd",
        file = "delta_pack_022_quick_melee_fail_to_snd.wav",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_breakc.wav",
        ids = {17153811469},
    },
    {
        name = "change hud",
        file = "delta_pack_023_change_hud.png",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/lvl.png",
        ids = {13188153054, 13188242420, 13220167472, 13220167337},
    },
    {
        name = "countdown to finale",
        file = "delta_pack_024_countdown_to_finale.ogg",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Finale.ogg",
        ids = {17826470563},
    },
    {
        name = "matchpoint",
        file = "delta_pack_025_matchpoint.wav",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_heavydamage.wav",
        ids = {17026600996},
    },
    {
        name = "sudden death",
        file = "delta_pack_026_sudden_death.ogg",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/sdfinal.ogg",
        ids = {17467242617},
    },
    {
        name = "change win to dumbvictory",
        file = "delta_pack_027_change_win_to_dumbvictory.wav",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/snd_dumbvictory.wav",
        ids = {18221725850, 18239670056, 18221725850, 18221726246},
    },
    {
        name = "onyx skybox support",
        file = "delta_pack_030_onyx_skybox_support.ttf",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/SyneMono-Regular.ttf",
        ids = {127338559130032, 16294586406, 75156669118637, 93477262732302},
    },
    {
        name = "change music",
        file = "delta_pack_031_change_music.mp3",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Hotel.mp3",
        ids = {17697682466, 17733314783},
    },
    {
        name = "flowey",
        file = "delta_pack_032_flowey.png",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/58a20c59c8dd3432c6fa8221.png",
        ids = {133917828562858, 121503061771505},
    },
    {
        name = "arch to x+",
        file = "delta_pack_033_arch_to_x.png",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Archnemisis_heart_1.png",
        ids = {133793956251748},
    },
    {
        name = "nem to x standard",
        file = "delta_pack_034_nem_to_x_standard.png",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Nemisis_heart_1.png",
        ids = {116941545385923},
    },
    {
        name = "bronze 3",
        file = "delta_pack_035_bronze_3.png",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/f.png",
        ids = {106623367501544, 131795064007344, 73543520622815},
    },
    {
        name = "silver 1 to d-",
        file = "delta_pack_036_silver_1_to_d-.png",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Silver_1_heart.png",
        ids = {80716950169934},
    },
    {
        name = "silver 2 to d",
        file = "delta_pack_037_silver_2_to_d.png",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/silver_2_heart.png",
        ids = {136100661820261},
    },
    {
        name = "silver 3 to d+",
        file = "delta_pack_038_silver_3_to_d.png",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/silver_3_heart.png",
        ids = {107898816876115},
    },
    {
        name = "gold 1 to c-",
        file = "delta_pack_039_gold_1_to_c-.png",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Gold_1_heart.png",
        ids = {134520747948636},
    },
    {
        name = "gold 2 to c",
        file = "delta_pack_040_gold_2_to_c.png",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Gold_2_heart.png",
        ids = {114166096331502},
    },
    {
        name = "gold 3 to c+",
        file = "delta_pack_041_gold_3_to_c.png",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Gold_3_heart.png",
        ids = {90039594400813},
    },
    {
        name = "plat 1 to b-",
        file = "delta_pack_042_plat_1_to_b-.png",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Plat_1_heart.png",
        ids = {133903971285645},
    },
    {
        name = "plat 2 to b",
        file = "delta_pack_043_plat_2_to_b.png",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Plat_2_heart.png",
        ids = {82834564754747},
    },
    {
        name = "plat 3 to b+",
        file = "delta_pack_044_plat_3_to_b.png",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Plat_3_heart.png",
        ids = {73345783863790},
    },
    {
        name = "diam 1 to a-",
        file = "delta_pack_045_diam_1_to_a-.png",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Diam_1_heart.png",
        ids = {113997689031026},
    },
    {
        name = "diam2 to A rank",
        file = "delta_pack_046_diam2_to_a_rank.png",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Diam_2_heart.png",
        ids = {88059506918419},
    },
    {
        name = "diam 3 to a+",
        file = "delta_pack_047_diam_3_to_a.png",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Diam_3_heart.png",
        ids = {112183171942172},
    },
    {
        name = "o1 to s",
        file = "delta_pack_048_o1_to_s.png",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Onyx_1_heart.png",
        ids = {104871954739030},
    },
    {
        name = "o2 to ss",
        file = "delta_pack_049_o2_to_ss.png",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Onyx_2_heart.png",
        ids = {109012386782238},
    },
    {
        name = "o3 to u",
        file = "delta_pack_050_o3_to_u.png",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/Onyx_3_heart.png",
        ids = {127982903682334},
    },
    {
        name = "bronze 1 to heart",
        file = "delta_pack_051_bronze_1_to_heart.png",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/bronze_1_heart_fixed_2_times.png",
        ids = {106623367501544},
    },
    {
        name = "b2 to heart",
        file = "delta_pack_052_b2_to_heart.png",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/bronze_2_heart.png",
        ids = {131795064007344},
    },
    {
        name = "streak icon replacement",
        file = "delta_pack_053_streak_icon_replacement.png",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/streak.png",
        ids = {17175092502, 17094014569},
    },
    {
        name = "unraked to heart",
        file = "delta_pack_054_unraked_to_heart.png",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/unranked_heart.png",
        ids = {111599878354131},
    },
    {
        name = "deltarune font",
        file = "delta_pack_055_deltarune_font.ttf",
        url = "https://raw.githubusercontent.com/prism658/undertale-txtpack/main/PixelOperator-Bold.ttf",
        ids = {12187323909, 12187320363, 12187354260, 12187342816, 12187280273, 12187303601, 12187262242, 12187288714, 12187341500, 12187271237, 12187341020},
    },
}

local function downloadAndRegister(asset)
    if not write or not customAsset then
        warn(PREFIX .. "writefile/getcustomasset unavailable; CDN rule skipped: " .. asset.name)
        return nil
    end
    local ok, result = pcall(function()
        local need = true
        if exists then
            local eok, present = pcall(exists, asset.file)
            need = not (eok and present)
        end
        if need then
            local body = game:HttpGet(asset.url)
            if type(body) ~= "string" or #body == 0 then error("empty download") end
            write(asset.file, body)
        end
        local id = customAsset(asset.file)
        if type(id) ~= "string" or id == "" then error("getcustomasset returned no id") end
        return id
    end)
    if not ok then warn(PREFIX .. "failed " .. asset.name .. ": " .. tostring(result)); return nil end
    return result
end

for _, asset in ipairs(Assets) do
    local content = downloadAndRegister(asset)
    if content then for _, id in ipairs(asset.ids) do IdMap[tostring(id)] = content end end
end

local function extractId(v)
    if type(v) ~= "string" then return nil end
    return v:match("rbxassetid://(%d+)") or v:match("[?&]id=(%d+)") or v:match("(%d+)")
end
local function replacementFor(v) local id = extractId(v); return id and IdMap[id] or nil end

local propsByClass = {
    Sound = {"SoundId"},
    ImageLabel = {"Image"},
    ImageButton = {"Image"},
    Decal = {"Texture"},
    Texture = {"Texture"},
    MeshPart = {"TextureID"},
    SpecialMesh = {"TextureId", "MeshId"},
    ParticleEmitter = {"Texture"},
    Trail = {"Texture"},
    Beam = {"Texture"},
    Sky = {"SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp"},
    Shirt = {"ShirtTemplate"},
    Pants = {"PantsTemplate"},
    ShirtGraphic = {"Graphic"},
    Animation = {"AnimationId"},
    VideoFrame = {"Video"},
}

local function replaceProperty(obj, prop)
    local ok, old = pcall(function() return obj[prop] end)
    if not ok or type(old) ~= "string" then return end
    local new = replacementFor(old)
    if new and new ~= old then pcall(function() obj[prop] = new end) end
end

local function replaceFont(obj)
    pcall(function()
        local f = obj.FontFace
        local new = replacementFor(f.Family)
        if new then obj.FontFace = Font.new(new, f.Weight, f.Style) end
    end)
end

-- DETERMINATION-only lightweight mobile mode.
-- Existing relevant objects are processed once. New relevant objects get a few
-- short retries so late-assigned textures can still be caught, with no permanent
-- property listeners and no repeating full-game scan.
local function applyObject(obj)
  local matched = false
  for class, props in pairs(propsByClass) do
    if obj:IsA(class) then
      matched = true
      for _, prop in ipairs(props) do replaceProperty(obj, prop) end
      break
    end
  end
  if obj:IsA('TextLabel') or obj:IsA('TextButton') or obj:IsA('TextBox') then
    matched = true
    replaceFont(obj)
  end
  return matched
end

for _, obj in ipairs(game:GetDescendants()) do
  applyObject(obj)
end

keep(game.DescendantAdded:Connect(function(obj)
  task.defer(function()
    if not obj or not obj.Parent then return end
    if not applyObject(obj) then return end
    for _, delayTime in ipairs({0.15, 0.4, 0.9, 1.8, 3.0}) do
      task.wait(delayTime)
      if not obj or not obj.Parent or env[STATE_KEY] ~= state then return end
      applyObject(obj)
    end
  end)
end))

local count = 0; for _ in pairs(IdMap) do count += 1 end
pcall(function() game:GetService('StarterGui'):SetCore('SendNotification',{Title="DETERMINATION",Text='Loaded '..count..' replacement IDs',Duration=6}) end)
print(PREFIX .. 'loaded ' .. count .. ' replacement IDs')

-- These enabled source rules had no with_id or cdn_url, so no replacement target
-- was present in the uploaded JSON and they were intentionally not guessed:
--   remove ambence on various maps
