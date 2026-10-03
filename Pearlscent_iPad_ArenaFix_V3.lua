-- Pearlscent iPad Arena Fix V3
-- Keeps the Pearlscent texture, but blocks the risky local texture from MeshPart/SpecialMesh/Sky.
-- It can still apply to normal Texture/Decal/UI objects plus all Pearlscent sounds/fonts.

local BASE = "https://raw.githubusercontent.com/lyn4x-js/Peatlscent/main/Pearlscent_Reliable_Delta.lua"

local ok, src = pcall(function()
    return game:HttpGet(BASE)
end)

if not ok or type(src) ~= "string" or #src < 1000 then
    warn("[Pearlscent iPad V3] Could not download base script")
    return
end

src = src:gsub(
    "__PEARLSCENT_RELIABLE_V2",
    "__PEARLSCENT_IPAD_ARENA_FIX_V3",
    1
)

local old = [[
local function replaceProperty(obj, property)
    local ok, old = pcall(function()
        return obj[property]
    end)
    if not ok or type(old) ~= "string" then return end

    local replacement = replacementFor(old)
    if replacement and replacement ~= old then
        pcall(function()
            obj[property] = replacement
        end)
    end
end
]]

local new = [[
local function replaceProperty(obj, property)
    local ok, old = pcall(function()
        return obj[property]
    end)
    if not ok or type(old) ~= "string" then return end

    local sourceId = extractId(old)

    -- Delta/iPad safeguard:
    -- the Pearlscent local world texture can blank MeshPart/SpecialMesh/Sky rendering.
    -- Keep it on ordinary Texture/Decal/UI surfaces instead.
    if sourceId == "7658055825" then
        if obj:IsA("MeshPart") or obj:IsA("SpecialMesh") or obj:IsA("Sky") then
            return
        end
    end

    local replacement = replacementFor(old)
    if replacement and replacement ~= old then
        pcall(function()
            obj[property] = replacement
        end)
    end
end
]]

local patched, n = src:gsub(old, new, 1)
if n ~= 1 then
    warn("[Pearlscent iPad V3] Could not patch texture safety logic")
    return
end

patched = patched:gsub("%[Pearlscent Reliable%]", "[Pearlscent iPad V3]")

local fn, err = loadstring(patched)
if not fn then
    warn("[Pearlscent iPad V3] Compile error: "..tostring(err))
    return
end

fn()
print("[Pearlscent iPad V3] Loaded texture-safe Arena build")
