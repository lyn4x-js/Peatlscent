-- Pearlscent iPad Arena Fix V2
-- Important change: skips the main world texture replacement (ID 7658055825),
-- which is the one most likely to turn Arena surfaces white/blank on Delta iPad.
-- Keeps Pearlscent sounds, UI background, font, and direct Roblox-ID effects.

local BASE = "https://raw.githubusercontent.com/lyn4x-js/Peatlscent/main/Pearlscent_Reliable_Delta.lua"

local ok, src = pcall(function()
    return game:HttpGet(BASE)
end)

if not ok or type(src) ~= "string" or #src < 1000 then
    warn("[Pearlscent iPad V2] Could not download base script")
    return
end

-- Give this build its own state so it doesn't collide with the old reliable build.
src = src:gsub("__PEARLSCENT_RELIABLE_V2", "__PEARLSCENT_IPAD_ARENA_FIX_V2", 1)

-- Remove ONLY the custom world texture asset.
-- That texture is what can make Arena render as washed-out/blank on Delta iPad.
local removed = 0
src, removed = src:gsub(
    '%s*{%s*name%s*=%s*"texture",.-ids%s*=%s*{7658055825},%s*},',
    '',
    1
)

if removed ~= 1 then
    warn("[Pearlscent iPad V2] Could not remove risky Arena texture")
    return
end

src = src:gsub("%[Pearlscent Reliable%]", "[Pearlscent iPad V2]")

local fn, err = loadstring(src)
if not fn then
    warn("[Pearlscent iPad V2] Compile error: "..tostring(err))
    return
end

fn()
print("[Pearlscent iPad V2] Loaded without the risky Arena world texture")
