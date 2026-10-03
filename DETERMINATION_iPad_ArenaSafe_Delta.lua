-- DETERMINATION iPad / Delta Arena-Safe
-- Loads your existing reliable build, patches its watcher logic to be lighter on iPad,
-- then runs the patched version.

local URL = "https://raw.githubusercontent.com/lyn4x-js/Peatlscent/main/DETERMINATION_Reliable_Delta.lua"

local ok, src = pcall(function()
    return game:HttpGet(URL)
end)

if not ok or type(src) ~= "string" or #src < 1000 then
    warn("[DETERMINATION iPad] Could not download base script")
    return
end

src = src:gsub(
    "__DELTA_PACK_DETERMINATION_RELIABLE_V2",
    "__DELTA_PACK_DETERMINATION_IPAD_ARENA_V1",
    1
)

local oldBlock = [[
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
]]

local newBlock = [[
local scanBusy=false

local function repairPass()
  if scanBusy or env[STATE_KEY]~=state then return end
  scanBusy=true

  for i,obj in ipairs(game:GetDescendants()) do
    applyObject(obj)
    if i%250==0 then
      task.wait()
    end
  end

  scanBusy=false
end

task.spawn(repairPass)

keep(game.DescendantAdded:Connect(function(obj)
  task.defer(function()
    if not obj or not obj.Parent then return end

    applyObject(obj)

    task.wait(0.35)
    if env[STATE_KEY]~=state or not obj.Parent then return end
    applyObject(obj)

    task.wait(1.15)
    if env[STATE_KEY]~=state or not obj.Parent then return end
    applyObject(obj)
  end)
end))

for _,delayTime in ipairs({1.5,4,8,15}) do
  task.delay(delayTime,repairPass)
end

local lp=game:GetService("Players").LocalPlayer
if lp then
  keep(lp.CharacterAdded:Connect(function()
    task.delay(0.8,repairPass)
    task.delay(3,repairPass)
  end))
end
]]

local patched, n = src:gsub(oldBlock, newBlock, 1)

if n ~= 1 then
    warn("[DETERMINATION iPad] Patch point not found; base script may have changed")
    return
end

patched = patched:gsub("DETERMINATION Reliable", "DETERMINATION iPad Safe")

local fn, err = loadstring(patched)
if not fn then
    warn("[DETERMINATION iPad] Compile error: "..tostring(err))
    return
end

fn()
print("[DETERMINATION iPad] Arena-safe patch loaded")
