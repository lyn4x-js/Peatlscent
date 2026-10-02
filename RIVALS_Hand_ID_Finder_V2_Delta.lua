-- RIVALS Hand ID Finder V2
-- Shows likely first-person hand/arm assets directly on screen.
-- Diagnostic only: does NOT modify meshes or textures.

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

local old = pg:FindFirstChild("RIVALS_HandFinderV2")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "RIVALS_HandFinderV2"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999
gui.Parent = pg

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.88,0,0.62,0)
frame.Position = UDim2.new(0.06,0,0.17,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,30)
frame.BackgroundTransparency = 0.08
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-50,0,42)
title.Position = UDim2.new(0,10,0,4)
title.BackgroundTransparency = 1
title.Text = "RIVALS Hand ID Finder V2"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local close = Instance.new("TextButton")
close.Size = UDim2.new(0,42,0,42)
close.Position = UDim2.new(1,-46,0,4)
close.Text = "X"
close.TextScaled = true
close.Parent = frame
close.MouseButton1Click:Connect(function() gui:Destroy() end)

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,-20,1,-58)
scroll.Position = UDim2.new(0,10,0,52)
scroll.BackgroundTransparency = 0.2
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ScrollBarThickness = 8
scroll.Parent = frame

local text = Instance.new("TextLabel")
text.Size = UDim2.new(1,-12,0,0)
text.AutomaticSize = Enum.AutomaticSize.Y
text.Position = UDim2.new(0,6,0,6)
text.BackgroundTransparency = 1
text.TextColor3 = Color3.new(1,1,1)
text.TextSize = 17
text.Font = Enum.Font.Code
text.TextXAlignment = Enum.TextXAlignment.Left
text.TextYAlignment = Enum.TextYAlignment.Top
text.TextWrapped = true
text.Parent = scroll

local function val(obj, prop)
    local ok,v=pcall(function() return obj[prop] end)
    if ok and type(v)=="string" and v~="" then return v end
end

local candidates={}
local seen={}
local function add(score,obj,prop,v)
    if not v then return end
    local key=obj:GetFullName().."|"..prop.."|"..v
    if seen[key] then return end
    seen[key]=true
    table.insert(candidates,{score=score,obj=obj,prop=prop,value=v})
end

local cam=workspace.CurrentCamera
if not cam then
    text.Text="No CurrentCamera found. Close this, equip a weapon, and run again."
    return
end

-- Only inspect the CurrentCamera tree. RIVALS first-person viewmodels normally live here.
for _,obj in ipairs(cam:GetDescendants()) do
    local n=obj.Name:lower()
    local path=obj:GetFullName():lower()
    local score=0
    if n:find("hand",1,true) then score+=100 end
    if n:find("arm",1,true) then score+=90 end
    if path:find("hand",1,true) then score+=50 end
    if path:find("arm",1,true) then score+=45 end
    if path:find("view",1,true) then score+=30 end
    if path:find("weapon",1,true) then score+=10 end

    if obj:IsA("MeshPart") then
        add(score,obj,"MeshId",val(obj,"MeshId"))
        add(score+5,obj,"TextureID",val(obj,"TextureID"))
    elseif obj:IsA("SpecialMesh") then
        add(score,obj,"MeshId",val(obj,"MeshId"))
        add(score+5,obj,"TextureId",val(obj,"TextureId"))
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        add(score+5,obj,"Texture",val(obj,"Texture"))
    elseif obj:IsA("SurfaceAppearance") then
        add(score+5,obj,"ColorMap",val(obj,"ColorMap"))
    end
end

table.sort(candidates,function(a,b) return a.score>b.score end)

local lines={
    "Equip a weapon BEFORE running this.",
    "Only CurrentCamera/viewmodel assets are shown.",
    "Send ChatGPT a photo of this box.",
    "----------------------------------------"
}

local max=math.min(#candidates,40)
if max==0 then
    table.insert(lines,"NO CANDIDATES FOUND.")
    table.insert(lines,"Close this box, equip a weapon so normal hands are visible, then run V2 again.")
else
    table.insert(lines,"Found "..#candidates.." camera candidates; showing top "..max..":")
    for i=1,max do
        local c=candidates[i]
        local short=c.obj.Name
        table.insert(lines,("\n[%02d] score=%d\n%s.%s\n%s"):format(i,c.score,short,c.prop,c.value))
    end
end
text.Text=table.concat(lines,"\n")
