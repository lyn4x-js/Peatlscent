-- RIVALS Hand ID Finder V3
-- Diagnostic only. Does NOT change meshes/textures.
-- Finds likely local first-person hand/arm assets without assuming CurrentCamera.

local Players=game:GetService("Players")
local lp=Players.LocalPlayer
local pg=lp:WaitForChild("PlayerGui")

local old=pg:FindFirstChild("RIVALS_HandFinderV3")
if old then old:Destroy() end

local gui=Instance.new("ScreenGui")
gui.Name="RIVALS_HandFinderV3"
gui.ResetOnSpawn=false
gui.DisplayOrder=999999
gui.Parent=pg

local frame=Instance.new("Frame")
frame.Size=UDim2.new(.92,0,.72,0)
frame.Position=UDim2.new(.04,0,.12,0)
frame.BackgroundColor3=Color3.fromRGB(25,25,30)
frame.BackgroundTransparency=.05
frame.Parent=gui

local title=Instance.new("TextLabel")
title.Size=UDim2.new(1,-50,0,42)
title.Position=UDim2.new(0,8,0,4)
title.BackgroundTransparency=1
title.Text="RIVALS Hand ID Finder V3"
title.TextColor3=Color3.new(1,1,1)
title.TextScaled=true
title.Font=Enum.Font.GothamBold
title.Parent=frame

local close=Instance.new("TextButton")
close.Size=UDim2.new(0,42,0,42)
close.Position=UDim2.new(1,-46,0,4)
close.Text="X"
close.TextScaled=true
close.Parent=frame
close.MouseButton1Click:Connect(function() gui:Destroy() end)

local scroll=Instance.new("ScrollingFrame")
scroll.Size=UDim2.new(1,-16,1,-54)
scroll.Position=UDim2.new(0,8,0,50)
scroll.BackgroundTransparency=.2
scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
scroll.CanvasSize=UDim2.new()
scroll.ScrollBarThickness=8
scroll.Parent=frame

local label=Instance.new("TextLabel")
label.Size=UDim2.new(1,-12,0,0)
label.AutomaticSize=Enum.AutomaticSize.Y
label.Position=UDim2.new(0,6,0,6)
label.BackgroundTransparency=1
label.TextColor3=Color3.new(1,1,1)
label.TextSize=15
label.Font=Enum.Font.Code
label.TextWrapped=true
label.TextXAlignment=Enum.TextXAlignment.Left
label.TextYAlignment=Enum.TextYAlignment.Top
label.Parent=scroll

local function read(obj,p)
    local ok,v=pcall(function() return obj[p] end)
    if ok and type(v)=="string" and v~="" then return v end
end

local roots={}
local function root(obj,bonus,why)
    if obj then table.insert(roots,{obj=obj,bonus=bonus,why=why}) end
end

root(lp.Character,120,"LocalPlayer.Character")
root(lp:FindFirstChild("Backpack"),70,"LocalPlayer.Backpack")
root(workspace.CurrentCamera,45,"CurrentCamera")

-- Add likely local/viewmodel containers, but only as roots instead of treating the whole game equally.
for _,obj in ipairs(game:GetDescendants()) do
    local n=obj.Name:lower()
    local score=0
    if n:find("viewmodel",1,true) then score=110
    elseif n=="viewmodel" or n=="viewmodels" then score=110
    elseif n:find("firstperson",1,true) or n:find("first_person",1,true) then score=100
    elseif n:find("arms",1,true) then score=90
    elseif n=="hands" or n=="hand" then score=90
    end
    if score>0 then root(obj,score,"named "..obj.Name) end
end

local results={}
local seen={}
local function add(obj,prop,value,score,why)
    if not value then return end
    local k=obj:GetFullName().."|"..prop.."|"..value
    if seen[k] then return end
    seen[k]=true
    table.insert(results,{obj=obj,prop=prop,value=value,score=score,why=why})
end

for _,r in ipairs(roots) do
    local list={r.obj}
    local ok,desc=pcall(function() return r.obj:GetDescendants() end)
    if ok then for _,x in ipairs(desc) do table.insert(list,x) end end

    -- Ignore enormous generic roots.
    if #list<=2500 then
        for _,obj in ipairs(list) do
            local n=obj.Name:lower()
            local path=obj:GetFullName():lower()
            local s=r.bonus
            if n:find("hand",1,true) then s+=140 end
            if n:find("arm",1,true) then s+=130 end
            if path:find("hand",1,true) then s+=55 end
            if path:find("arm",1,true) then s+=50 end
            if path:find("view",1,true) then s+=35 end
            if path:find("weapon",1,true) or path:find("gun",1,true) then s+=15 end

            if obj:IsA("MeshPart") then
                add(obj,"MeshId",read(obj,"MeshId"),s,r.why)
                add(obj,"TextureID",read(obj,"TextureID"),s+8,r.why)
            elseif obj:IsA("SpecialMesh") then
                add(obj,"MeshId",read(obj,"MeshId"),s,r.why)
                add(obj,"TextureId",read(obj,"TextureId"),s+8,r.why)
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                add(obj,"Texture",read(obj,"Texture"),s+8,r.why)
            elseif obj:IsA("SurfaceAppearance") then
                add(obj,"ColorMap",read(obj,"ColorMap"),s+8,r.why)
            end
        end
    end
end

table.sort(results,function(a,b) return a.score>b.score end)

local lines={
    "Keep a weapon equipped with NORMAL hands visible.",
    "This script changes NOTHING.",
    "Send ChatGPT photos of the highest entries.",
    "-------------------------------------------"
}

local count=math.min(#results,30)
if count==0 then
    table.insert(lines,"NO ASSET IDS FOUND.")
else
    table.insert(lines,"Found "..#results.." narrowed candidates; top "..count..":")
    for i=1,count do
        local x=results[i]
        local path=x.obj:GetFullName()
        if #path>85 then path="..."..path:sub(-82) end
        table.insert(lines,("\n[%02d] SCORE %d | %s\n%s\n%s = %s"):format(
            i,x.score,x.why,path,x.prop,x.value))
    end
end
label.Text=table.concat(lines,"\n")
