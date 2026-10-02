-- RIVALS Hand Mesh Info - On Screen
-- Diagnostic only. Changes nothing.

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "RIVALS_Hand_Info_OnScreen"
gui.ResetOnSpawn = false

local old = player.PlayerGui:FindFirstChild(gui.Name)
if old then old:Destroy() end
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.92,0,0.72,0)
frame.Position = UDim2.new(0.04,0,0.12,0)
frame.BackgroundColor3 = Color3.fromRGB(28,28,32)
frame.BackgroundTransparency = 0.08
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-50,0,48)
title.BackgroundTransparency = 1
title.Text = "RIVALS HAND MESH INFO"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local close = Instance.new("TextButton")
close.Size = UDim2.new(0,44,0,44)
close.Position = UDim2.new(1,-47,0,2)
close.Text = "X"
close.TextScaled = true
close.Parent = frame
close.MouseButton1Click:Connect(function() gui:Destroy() end)

local box = Instance.new("TextLabel")
box.Position = UDim2.new(0,12,0,55)
box.Size = UDim2.new(1,-24,1,-67)
box.BackgroundColor3 = Color3.fromRGB(12,12,15)
box.TextColor3 = Color3.new(1,1,1)
box.TextXAlignment = Enum.TextXAlignment.Left
box.TextYAlignment = Enum.TextYAlignment.Top
box.Font = Enum.Font.Code
box.TextSize = 15
box.TextWrapped = true
box.Parent = frame

local targets = {
    ["14523777016"]="LeftHand",
    ["14523777088"]="RightHand"
}

local function aid(v)
    if type(v)~="string" then return nil end
    return v:match("rbxassetid://(%d+)") or v:match("[?&]id=(%d+)") or v:match("(%d+)")
end

local lines = {}
local found = 0
for _,o in ipairs(game:GetDescendants()) do
    if o:IsA("MeshPart") then
        local ok,m = pcall(function() return o.MeshId end)
        local id = ok and aid(m)
        if id and targets[id] then
            found += 1
            local function prop(name)
                local good,v=pcall(function() return o[name] end)
                return good and tostring(v) or "N/A"
            end
            table.insert(lines,
                "["..found.."] "..targets[id]..
                "\nPath: "..o:GetFullName()..
                "\nMeshId: "..prop("MeshId")..
                "\nTextureID: "..prop("TextureID")..
                "\nSize: "..prop("Size")..
                "\nMeshSize: "..prop("MeshSize")..
                "\n")
        end
    end
end

box.Text = "Found "..found.." matching hand meshes.\n\n"..table.concat(lines,"\n")
