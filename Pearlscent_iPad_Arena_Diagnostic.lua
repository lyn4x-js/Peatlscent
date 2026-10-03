-- Pearlscent iPad Arena Diagnostic
-- DOES NOT replace any textures.
-- It only finds objects using source asset 7658055825 and shows them on-screen.

local TARGET = "7658055825"

local function extractId(v)
    if type(v) ~= "string" then return nil end
    return v:match("rbxassetid://(%d+)") or v:match("[?&]id=(%d+)") or v:match("(%d+)")
end

local props = {
    MeshPart = {"TextureID"},
    SpecialMesh = {"TextureId"},
    Decal = {"Texture"},
    Texture = {"Texture"},
    ImageLabel = {"Image"},
    ImageButton = {"Image"},
    ParticleEmitter = {"Texture"},
    Trail = {"Texture"},
    Beam = {"Texture"},
    Shirt = {"ShirtTemplate"},
    Pants = {"PantsTemplate"},
    ShirtGraphic = {"Graphic"},
}

local found = {}

local function add(obj, prop, value)
    if extractId(value) ~= TARGET then return end
    local path = obj:GetFullName()
    table.insert(found, {
        class = obj.ClassName,
        name = obj.Name,
        prop = prop,
        path = path,
        value = value,
    })
end

for _, obj in ipairs(game:GetDescendants()) do
    for class, list in pairs(props) do
        if obj:IsA(class) then
            for _, prop in ipairs(list) do
                local ok, value = pcall(function() return obj[prop] end)
                if ok then add(obj, prop, value) end
            end
            break
        end
    end
end

local gui = Instance.new("ScreenGui")
gui.Name = "PearlscentArenaDiagnostic"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.92, 0, 0.72, 0)
frame.Position = UDim2.new(0.04, 0, 0.14, 0)
frame.BackgroundTransparency = 0.15
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 44)
title.Position = UDim2.new(0, 10, 0, 8)
title.BackgroundTransparency = 1
title.TextWrapped = true
title.TextScaled = true
title.Text = "Pearlscent iPad Diagnostic — matches: "..tostring(#found)
title.Parent = frame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -70)
scroll.Position = UDim2.new(0, 10, 0, 58)
scroll.CanvasSize = UDim2.new(0, 0, 0, math.max(1, #found) * 100)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.None
scroll.ScrollBarThickness = 8
scroll.Parent = frame

for i, info in ipairs(found) do
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 92)
    label.Position = UDim2.new(0, 5, 0, (i-1)*100)
    label.BackgroundTransparency = 0.2
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.TextWrapped = true
    label.TextScaled = false
    label.TextSize = 16
    label.Text = string.format(
        "%d) %s | %s\n%s\n%s",
        i, info.class, info.prop, info.name, info.path
    )
    label.Parent = scroll
end

if #found == 0 then
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 80)
    label.Position = UDim2.new(0, 5, 0, 5)
    label.BackgroundTransparency = 1
    label.TextWrapped = true
    label.TextScaled = true
    label.Text = "No objects currently use asset 7658055825."
    label.Parent = scroll
end

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 90, 0, 36)
close.Position = UDim2.new(1, -100, 0, 10)
close.Text = "CLOSE"
close.Parent = frame
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

print("[Pearlscent Diagnostic] Found "..tostring(#found).." matching objects")
