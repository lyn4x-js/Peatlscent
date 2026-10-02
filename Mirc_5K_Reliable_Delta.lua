-- Mirc's 5k Pack [updated] - Delta/iOS asset replacement payload
-- Generated from the uploaded Fleasion JSON. Paste this whole file into Delta,
-- or host it on GitHub and execute it with loadstring(game:HttpGet(RAW_URL))().

local PREFIX = "[Mirc's 5k Pack [updated]] "
local env = (getgenv and getgenv()) or _G
local write = rawget(env, "writefile") or writefile
local exists = rawget(env, "isfile") or isfile
local customAsset = rawget(env, "getcustomasset") or getcustomasset or getsynasset

if typeof(game.HttpGet) ~= "function" then
    warn(PREFIX .. "game:HttpGet is unavailable")
    return
end

-- Clean up listeners from an earlier run of this same payload.
local STATE_KEY = "__DELTA_PACK_MIRC_RELIABLE_V2"
if env[STATE_KEY] and env[STATE_KEY].connections then
    for _, c in ipairs(env[STATE_KEY].connections) do pcall(function() c:Disconnect() end) end
end
local state = {connections = {}}
env[STATE_KEY] = state
local function keep(c) if c then table.insert(state.connections, c) end end

local IdMap = {
    ["16537337310"] = "rbxassetid://70643163489676",
    ["16537449730"] = "rbxassetid://70643163489676",
    ["15109829804"] = "rbxassetid://109303978243933",
    ["81461991645938"] = "rbxassetid://16834713626",
    ["99135525400251"] = "rbxassetid://7712639823",
    ["17175092502"] = "rbxassetid://72106446453934",
    ["17094014569"] = "rbxassetid://72106446453934",
    ["70643163489676"] = "rbxassetid://17405655409",
    ["16802957270"] = "rbxassetid://130413597135596",
}

local Assets = {
    {
        name = "change map select to tetrio",
        file = "delta_pack_002_change_map_select_to_tetrio.ogg",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/allclear.base.ogg",
        ids = {103035811146294},
    },
    {
        name = "change win to tetrio",
        file = "delta_pack_003_change_win_to_tetrio.ogg",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/allclear.base.ogg",
        ids = {16810041280},
    },
    {
        name = "change lose to tetrio",
        file = "delta_pack_004_change_lose_to_tetrio.ogg",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/allclear.base.ogg",
        ids = {16810321565},
    },
    {
        name = "dafont???",
        file = "delta_pack_006_dafont.ttf",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/Garet-Book.ttf",
        ids = {12187323909, 12187320363, 12187354260, 12187342816, 12187280273, 12187303601, 12187262242, 12187288714, 12187341500, 12187271237, 12187341020},
    },
    {
        name = "replace countdown with kewl music",
        file = "delta_pack_008_replace_countdown_with_kewl_music.ogg",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/theeyellow.ogg",
        ids = {17826470563},
    },
    {
        name = "arena dark mode",
        file = "delta_pack_011_arena_dark_mode.png",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/grods.png",
        ids = {7658055825},
    },
    {
        name = "changes the win theme to a better theme",
        file = "delta_pack_012_changes_the_win_theme_to_a_better_theme.ogg",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/winnerwinner.ogg",
        ids = {18221725850, 18239670056, 18221725850, 18221726246},
    },
    {
        name = "replace logo with stupid old me",
        file = "delta_pack_014_replace_logo_with_stupid_old_me.png",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/attachment.png",
        ids = {17803962335},
    },
    {
        name = "change match point to tetrio score",
        file = "delta_pack_017_change_match_point_to_tetrio_score.ogg",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/showscore.base.ogg",
        ids = {17026600996},
    },
    {
        name = "kill1 with tetrio combo1",
        file = "delta_pack_018_kill1_with_tetrio_combo1.ogg",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/kill1.ogg",
        ids = {16530229616},
    },
    {
        name = "kill2 with combo2",
        file = "delta_pack_019_kill2_with_combo2.ogg",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/kill2.ogg",
        ids = {16530229541},
    },
    {
        name = "kill3 with combopower3",
        file = "delta_pack_020_kill3_with_combopower3.ogg",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/kill3.ogg",
        ids = {16530229695},
    },
    {
        name = "chickn",
        file = "delta_pack_021_chickn.webp",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/mine.webp",
        ids = {133917828562858},
    },
    {
        name = "onyx removal",
        file = "delta_pack_022_onyx_removal.ttf",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/SyneMono-Regular.ttf",
        ids = {127338559130032, 16294586406, 75156669118637, 93477262732302},
    },
    {
        name = "SBK",
        file = "delta_pack_023_sbk.tex",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/sky512_bk.tex",
        ids = {2108482005, 14147881792, 135908632589654, 84214501374682, 10196550937, 12261809766},
    },
    {
        name = "SDN",
        file = "delta_pack_024_sdn.tex",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/sky512_dn.tex",
        ids = {2108545280, 10196550667, 14147882149, 103020541883227, 89972436184102, 12261813110},
    },
    {
        name = "SLF",
        file = "delta_pack_025_slf.tex",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/sky512_lf.tex",
        ids = {14147883091, 135908632589654, 84214501374682, 2108482395, 12261809766, 10196550128},
    },
    {
        name = "SRT",
        file = "delta_pack_026_srt.tex",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/sky512_rt.tex",
        ids = {14147882405, 135908632589654, 84214501374682, 2108482542, 12261809766, 10196549902},
    },
    {
        name = "SUP",
        file = "delta_pack_027_sup.tex",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/sky512_up.tex",
        ids = {14147881297, 72960281658487, 92138082970751, 2108482676, 10196567794, 12261813678},
    },
    {
        name = "SFT",
        file = "delta_pack_028_sft.tex",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/sky512_ft.tex",
        ids = {14147882761, 12261809766, 135908632589654, 84214501374682, 10196550367, 2108482231},
    },
    {
        name = "arch to x+",
        file = "delta_pack_030_arch_to_x.png",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/top200xrank.png",
        ids = {133793956251748},
    },
    {
        name = "nem to x standard",
        file = "delta_pack_031_nem_to_x_standard.png",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/nemx.png",
        ids = {116941545385923},
    },
    {
        name = "bronze to f rank",
        file = "delta_pack_032_bronze_to_f_rank.png",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/f.png",
        ids = {106623367501544, 131795064007344, 73543520622815},
    },
    {
        name = "silver 1 to d-",
        file = "delta_pack_033_silver_1_to_d-.png",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/d-.png",
        ids = {80716950169934},
    },
    {
        name = "silver 2 to d",
        file = "delta_pack_034_silver_2_to_d.png",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/d.png",
        ids = {136100661820261},
    },
    {
        name = "silver 3 to d+",
        file = "delta_pack_035_silver_3_to_d.png",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/d+.png",
        ids = {107898816876115},
    },
    {
        name = "gold 1 to c-",
        file = "delta_pack_036_gold_1_to_c-.png",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/c-.png",
        ids = {134520747948636},
    },
    {
        name = "gold 2 to c",
        file = "delta_pack_037_gold_2_to_c.png",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/c.png",
        ids = {114166096331502},
    },
    {
        name = "gold 3 to c+",
        file = "delta_pack_038_gold_3_to_c.png",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/c+.png",
        ids = {90039594400813},
    },
    {
        name = "plat 1 to b-",
        file = "delta_pack_039_plat_1_to_b-.png",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/b-.png",
        ids = {133903971285645},
    },
    {
        name = "plat 2 to b",
        file = "delta_pack_040_plat_2_to_b.png",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/b.png",
        ids = {82834564754747},
    },
    {
        name = "plat 3 to b+",
        file = "delta_pack_041_plat_3_to_b.png",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/b+.png",
        ids = {73345783863790},
    },
    {
        name = "diam 1 to a-",
        file = "delta_pack_042_diam_1_to_a-.png",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/a-.png",
        ids = {113997689031026},
    },
    {
        name = "diam2 to A rank",
        file = "delta_pack_043_diam2_to_a_rank.png",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/a.png",
        ids = {88059506918419},
    },
    {
        name = "diam 3 to a+",
        file = "delta_pack_044_diam_3_to_a.png",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/a+.png",
        ids = {112183171942172},
    },
    {
        name = "o1 to s",
        file = "delta_pack_045_o1_to_s.png",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/s.png",
        ids = {104871954739030},
    },
    {
        name = "o2 to ss",
        file = "delta_pack_046_o2_to_ss.png",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/ss.png",
        ids = {109012386782238},
    },
    {
        name = "o3 to u",
        file = "delta_pack_047_o3_to_u.png",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/u.png",
        ids = {127982903682334},
    },
    {
        name = "self snitching",
        file = "delta_pack_049_self_snitching.png",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/icbtw.png",
        ids = {99115398611290},
    },
    {
        name = "upd data",
        file = "delta_pack_050_upd_data.json",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/upddata.json",
        ids = {101218118381254},
    },
    {
        name = "ding to the bird",
        file = "delta_pack_051_ding_to_the_bird.ogg",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/clearspin.base.ogg",
        ids = {8483887957},
    },
    {
        name = "intro theme to lego brick",
        file = "delta_pack_052_intro_theme_to_lego_brick.mp3",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/lego-build.mp3",
        ids = {6384899588},
    },
    {
        name = "incubatron",
        file = "delta_pack_053_incubatron.webp",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/incubatron.webp",
        ids = {121503061771505},
    },
    {
        name = "replace slide sfx with uk slide",
        file = "delta_pack_054_replace_slide_sfx_with_uk_slide.mp3",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/Sliding.mp3",
        ids = {16737738420},
    },
    {
        name = "replace demote rank with awwww",
        file = "delta_pack_056_replace_demote_rank_with_awwww.mp3",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/studio-audience-awwww-sound-fx.mp3",
        ids = {91547731028928},
    },
    {
        name = "replace promote with final fantasy fanfare",
        file = "delta_pack_057_replace_promote_with_final_fantasy_fanfare.mp3",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/final-fantasy-vii-victory-fanfare-1.mp3",
        ids = {138975587469438},
    },
    {
        name = "replace the nosniy logo g with an emoticon :)",
        file = "delta_pack_059_replace_the_nosniy_logo_g_with_an_emoticon.png",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/logo.png",
        ids = {13854780213},
    },
    {
        name = "replace lobby music with tetrio",
        file = "delta_pack_060_replace_lobby_music_with_tetrio.mp3",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/kuchu-toshi.mp3",
        ids = {17697682466, 17733314783},
    },
    {
        name = "replace click with tetrio click",
        file = "delta_pack_062_replace_click_with_tetrio_click.ogg",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/menuclick.base.ogg",
        ids = {177266782},
    },
    {
        name = "change matchmaking to tetrio",
        file = "delta_pack_063_change_matchmaking_to_tetrio.ogg",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/achievement_3.base.ogg",
        ids = {18525513345},
    },
    {
        name = "hitmarker with target.base.ogg",
        file = "delta_pack_065_hitmarker_with_target_base_ogg.ogg",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/target.base.ogg",
        ids = {13110130082},
    },
    {
        name = "change sudden death to epic suspense music",
        file = "delta_pack_066_change_sudden_death_to_epic_suspense_music.ogg",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/bluer.ogg",
        ids = {17467242617},
    },
    {
        name = "elim to warzone",
        file = "delta_pack_067_elim_to_warzone.mp3",
        url = "https://raw.githubusercontent.com/prism658/Resources-fleasion/main/elimin.mp3",
        ids = {17016581922},
    },
}

local function downloadAndRegister(asset)
    if not write or not customAsset then
        warn(PREFIX .. "writefile/getcustomasset unavailable; CDN rule skipped: " .. asset.name)
        return nil
    end

    local lastErr
    for attempt = 1, 3 do
        local ok, result = pcall(function()
            local body = game:HttpGet(asset.url)
            if type(body) ~= "string" or #body < 4 then error("empty/invalid download") end
            -- Fresh write every run prevents stale/broken cache entries.
            write(asset.file, body)
            local id = customAsset(asset.file)
            if type(id) ~= "string" or id == "" then error("getcustomasset returned no id") end
            return id
        end)
        if ok then return result end
        lastErr = result
        task.wait(0.35 * attempt)
    end

    warn(PREFIX .. "failed " .. asset.name .. " after retries: " .. tostring(lastErr))
    return nil
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

local watched = setmetatable({}, {__mode='k'})
local function attach(obj)
    if watched[obj] then return end
    watched[obj] = true
    for class, props in pairs(propsByClass) do
        if obj:IsA(class) then
            for _, prop in ipairs(props) do
                replaceProperty(obj, prop)
                local ok, c = pcall(function() return obj:GetPropertyChangedSignal(prop):Connect(function() replaceProperty(obj, prop) end) end)
                if ok then keep(c) end
            end
            break
        end
    end
    if obj:IsA('TextLabel') or obj:IsA('TextButton') or obj:IsA('TextBox') then
        replaceFont(obj)
        local ok, c = pcall(function() return obj:GetPropertyChangedSignal('FontFace'):Connect(function() replaceFont(obj) end) end)
        if ok then keep(c) end
    end
end

for _, obj in ipairs(game:GetDescendants()) do attach(obj) end
keep(game.DescendantAdded:Connect(function(obj)
    task.defer(function()
        attach(obj)
        for _, delayTime in ipairs({0.2, 0.7, 1.8, 4.0}) do
            task.wait(delayTime)
            if env[STATE_KEY] ~= state or not obj or not obj.Parent then return end
            local props
            for class, p in pairs(propsByClass) do if obj:IsA(class) then props = p; break end end
            if props then for _, prop in ipairs(props) do replaceProperty(obj, prop) end end
            if obj:IsA('TextLabel') or obj:IsA('TextButton') or obj:IsA('TextBox') then replaceFont(obj) end
        end
    end)
end))

-- A few bounded passes catch late UI without permanent whole-game polling.
for _, delayTime in ipairs({1.5, 4, 8}) do
    task.delay(delayTime, function()
        if env[STATE_KEY] ~= state then return end
        for _, obj in ipairs(game:GetDescendants()) do
            task.defer(attach, obj)
        end
    end)
end

local count = 0; for _ in pairs(IdMap) do count += 1 end
pcall(function() game:GetService('StarterGui'):SetCore('SendNotification',{Title="Mirc's 5k Reliable",Text='Loaded '..count..' replacement IDs',Duration=6}) end)
print(PREFIX .. 'loaded ' .. count .. ' replacement IDs')

-- These enabled source rules had no with_id or cdn_url, so no replacement target
-- was present in the uploaded JSON and they were intentionally not guessed:
--   heal sfx
--   replace d jump with old roblox sfx
--   remove item background
--   lose to laugh
--   remove ambence on various maps
--   remove the n
--   remove the lil pattern on the maps
