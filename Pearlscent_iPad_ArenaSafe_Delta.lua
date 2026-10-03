-- Pearlscent iPad / Delta Arena-safe edition
-- Same Pearlscent mappings, lighter Arena repair logic for iPad.

local env=(getgenv and getgenv()) or _G
local KEY="__PEARLSCENT_IPAD_ARENA_V1"
for _,k in ipairs({"__PEARLSCENT_RELIABLE_V2",KEY}) do
 local s=env[k]; if s and s.connections then for _,c in ipairs(s.connections) do pcall(function() c:Disconnect() end) end end
end
local state={connections={}}; env[KEY]=state
local function keep(c) if c then table.insert(state.connections,c) end end
local write=writefile
local custom=getcustomasset or getsynasset
if typeof(game.HttpGet)~="function" or not write or not custom then warn("[Pearlscent iPad] Delta asset APIs unavailable") return end

local map={["16537337310"]="rbxassetid://70643163489676",["16537449730"]="rbxassetid://70643163489676"}
local assets={
{"texture","pearlscent_ipad_texture.png","https://raw.githubusercontent.com/H4rb0r-rbx/Fleasion-pearlscent-textures/main/fcc06bbf-0829-4e29-80ac-661bcbb57a22-removebg-preview.png",{7658055825}},
{"double_jump","pearlscent_ipad_double_jump.ogg","https://raw.githubusercontent.com/H4rb0r-rbx/Fleasion-pearlscent-textures/main/bell%20ding%20sfx.ogg",{16770456156,16492958314}},
{"item_background","pearlscent_ipad_item_background.png","https://raw.githubusercontent.com/H4rb0r-rbx/Fleasion-pearlscent-textures/main/IMG_4989.PNG",{13220167337,13188242420,13220167472,13188153054,13188242287}},
{"slide","pearlscent_ipad_slide.wav","https://raw.githubusercontent.com/H4rb0r-rbx/Fleasion-pearlscent-textures/main/sparkle.wav",{16737738420}},
{"click","pearlscent_ipad_click.mp3","https://raw.githubusercontent.com/H4rb0r-rbx/Fleasion-pearlscent-textures/main/universfield-water-drop-131023.mp3",{177266782}},
{"kill","pearlscent_ipad_kill.mp3","https://raw.githubusercontent.com/H4rb0r-rbx/Fleasion-pearlscent-textures/main/benkirb-shine-1-268902.mp3",{16530229616,16530229541,16530229695}},
{"font","pearlscent_ipad_font.ttf","https://raw.githubusercontent.com/prism658/Resources-fleasion/main/Garet-Book.ttf",{12187323909,12187320363,12187354260,12187342816,12187280273,12187303601,12187262242,12187288714,12187341500,12187271237,12187341020}}
}
for _,a in ipairs(assets) do
 local content
 for n=1,4 do
  local ok,r=pcall(function()
   local body=game:HttpGet(a[3]); if type(body)~="string" or #body<32 then error("bad download") end
   write(a[2],body); local x=custom(a[2]); if type(x)~="string" or x=="" then error("bad custom asset") end; return x
  end)
  if ok then content=r break end; task.wait(.3*n)
 end
 if content then for _,id in ipairs(a[4]) do map[tostring(id)]=content end else warn("[Pearlscent iPad] Failed "..a[1]) end
end
local function id(v)
 if type(v)~="string" then return end
 return v:match("rbxassetid://(%d+)") or v:match("[?&]id=(%d+)") or v:match("(%d+)")
end
local function prop(o)
 if o:IsA("Sound") then return "SoundId"
 elseif o:IsA("ImageLabel") or o:IsA("ImageButton") then return "Image"
 elseif o:IsA("Decal") or o:IsA("Texture") or o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Beam") then return "Texture"
 elseif o:IsA("MeshPart") then return "TextureID"
 elseif o:IsA("SpecialMesh") then return "TextureId" end
end
local function patch(o)
 if env[KEY]~=state or not o then return end
 local p=prop(o)
 if p then pcall(function() local old=o[p]; local new=map[id(old)]; if new and new~=old then o[p]=new end end)
 elseif o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox") then
  pcall(function() local f=o.FontFace; local new=map[id(f.Family)]; if new then o.FontFace=Font.new(new,f.Weight,f.Style) end end)
 end
end
local busy=false
local function repair()
 if busy or env[KEY]~=state then return end; busy=true
 for i,o in ipairs(game:GetDescendants()) do patch(o); if i%250==0 then task.wait() end end
 busy=false
end
keep(game.DescendantAdded:Connect(function(o) task.defer(function() patch(o); task.wait(.35); if o.Parent then patch(o) end; task.wait(1.15); if o.Parent then patch(o) end end) end))
task.spawn(repair)
for _,t in ipairs({1.5,4,8,15}) do task.delay(t,repair) end
local lp=game:GetService("Players").LocalPlayer
if lp then keep(lp.CharacterAdded:Connect(function() task.delay(.8,repair); task.delay(3,repair) end)) end
print("[Pearlscent iPad] Arena-safe loaded")
