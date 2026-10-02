-- Valorant Hands ONLY - Delta/iOS standalone script
-- Extracted from the uploaded valorant.json. No guns, dagger, sniper, or sounds.
local PREFIX="[VALORANT HANDS] "
local env=(getgenv and getgenv()) or _G
local write=rawget(env,"writefile") or writefile
local customAsset=rawget(env,"getcustomasset") or getcustomasset or getsynasset
if not write or not customAsset then warn(PREFIX.."file/custom-asset API unavailable"); return end

local STATE_KEY="__VALORANT_HANDS_ONLY_V1"
if env[STATE_KEY] and env[STATE_KEY].connections then
  for _,c in ipairs(env[STATE_KEY].connections) do pcall(function() c:Disconnect() end) end
end
local state={connections={}}
env[STATE_KEY]=state
local function keep(c) if c then table.insert(state.connections,c) end end

local replacements={}
local assets={
  {name="Profile 4",url="https://raw.githubusercontent.com/engnyg/123f1/refs/heads/main/valorant/arm/valorant-leftV2.obj",file="valorant_hands_v1_1.obj",kind="mesh",ids={"12307734932"}},
  {name="Profile 5",url="https://raw.githubusercontent.com/engnyg/123f1/refs/heads/main/valorant/arm/valorant-rightV2.obj",file="valorant_hands_v1_2.obj",kind="mesh",ids={"12307583853"}},
  {name="Profile 6",url="https://raw.githubusercontent.com/engnyg/123f1/refs/heads/main/valorant/arm/FP_Wushu_S0_DF.png",file="valorant_hands_v1_3.png",kind="image",ids={"144076357"}},
}

local function valid(body,kind)
  if type(body)~="string" or #body<4 then return false end
  if kind=="image" then return body:sub(1,8)=="\137PNG\r\n\26\n" end
  if kind=="mesh" then
    local head=body:sub(1,256):lower()
    return head:find("v ",1,true) or head:find("o ",1,true) or head:find("#",1,true)
  end
  return true
end

for _,a in ipairs(assets) do
  local ok,res=pcall(function()
    local body=game:HttpGet(a.url)
    if not valid(body,a.kind) then error("invalid "..a.kind.." download") end
    write(a.file,body)
    local id=customAsset(a.file)
    if type(id)~="string" or id=="" then error("custom asset failed") end
    return id
  end)
  if ok then
    for _,id in ipairs(a.ids) do replacements[id]={value=res,kind=a.kind} end
  else
    warn(PREFIX.."skipped "..a.name..": "..tostring(res))
  end
end

local function extract(v)
  if type(v)~="string" then return nil end
  return v:match("rbxassetid://(%d+)") or v:match("[?&]id=(%d+)") or v:match("(%d+)")
end

local props={
  MeshPart={{"MeshId","mesh"},{"TextureID","image"}},
  SpecialMesh={{"MeshId","mesh"},{"TextureId","image"}},
  Decal={{"Texture","image"}}, Texture={{"Texture","image"}},
  ImageLabel={{"Image","image"}}, ImageButton={{"Image","image"}},
}

local function apply(obj)
  local relevant=false
  for class,list in pairs(props) do
    if obj:IsA(class) then
      relevant=true
      for _,p in ipairs(list) do
        local prop,kind=p[1],p[2]
        local ok,old=pcall(function() return obj[prop] end)
        if ok then
          local r=replacements[extract(old)]
          if r and r.kind==kind and r.value~=old then pcall(function() obj[prop]=r.value end) end
        end
      end
      break
    end
  end
  return relevant
end

for _,obj in ipairs(game:GetDescendants()) do apply(obj) end
keep(game.DescendantAdded:Connect(function(obj)
  task.defer(function()
    if not obj or not obj.Parent or not apply(obj) then return end
    for _,t in ipairs({0.2,0.6,1.4,3.0}) do
      task.wait(t)
      if env[STATE_KEY]~=state or not obj or not obj.Parent then return end
      apply(obj)
    end
  end)
end))

pcall(function()
  game:GetService("StarterGui"):SetCore("SendNotification",{
    Title="Valorant Hands",Text="Hands-only pack loaded",Duration=5
  })
end)
print(PREFIX.."loaded")
