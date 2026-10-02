-- RIVALS Hand/Arm ID Finder for Delta
-- Diagnostic only: does NOT replace or modify any meshes/textures.

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local seen = {}
local found = {}

local function add(kind,obj,prop,value)
    if type(value)~="string" or value=="" then return end
    local key=kind.."|"..value
    if seen[key] then return end
    seen[key]=true
    table.insert(found,{kind=kind,path=obj:GetFullName(),prop=prop,value=value})
end

local function inspect(obj)
    if obj:IsA("MeshPart") then
        pcall(function() add("Mesh",obj,"MeshId",obj.MeshId) end)
        pcall(function() add("Texture",obj,"TextureID",obj.TextureID) end)
    elseif obj:IsA("SpecialMesh") then
        pcall(function() add("Mesh",obj,"MeshId",obj.MeshId) end)
        pcall(function() add("Texture",obj,"TextureId",obj.TextureId) end)
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        pcall(function() add("Texture",obj,"Texture",obj.Texture) end)
    end
end

-- Focus on likely first-person/viewmodel containers.
for _,obj in ipairs(game:GetDescendants()) do
    local path=obj:GetFullName():lower()
    if path:find("view",1,true) or path:find("arm",1,true) or
       path:find("hand",1,true) or path:find("weapon",1,true) or
       path:find("camera",1,true) then
        inspect(obj)
    end
end

print("========== RIVALS HAND ID FINDER ==========")
if #found==0 then
    warn("No likely hand/viewmodel assets found. Equip a weapon and run again.")
else
    for i,v in ipairs(found) do
        print(("[%d] %s | %s.%s | %s"):format(i,v.kind,v.path,v.prop,v.value))
    end
end
print("========== END HAND ID FINDER ==========")

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title="Hand ID Finder",
        Text=#found>0 and ("Found "..#found.." candidate assets. Open Delta console.") or "Nothing found; equip a weapon and rerun.",
        Duration=7
    })
end)
