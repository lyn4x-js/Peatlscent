-- RIVALS Hand Mesh Diagnostic / Export Helper
-- Finds the known RIVALS hand MeshParts and saves all accessible metadata.
-- NOTE: Roblox normally exposes MeshId but NOT the raw OBJ vertex/UV data.
-- This script does not modify the game.

local TARGETS = {
    ["14523777016"] = "LeftHand",
    ["14523777088"] = "RightHand",
}

local function assetId(v)
    if type(v) ~= "string" then return nil end
    return v:match("rbxassetid://(%d+)") or v:match("[?&]id=(%d+)") or v:match("(%d+)")
end

local lines = {
    "RIVALS HAND MESH DIAGNOSTIC",
    "This file contains metadata accessible to the client.",
    "It may NOT contain raw OBJ vertices/UVs.",
    ""
}

local found = 0

for _,o in ipairs(game:GetDescendants()) do
    if o:IsA("MeshPart") then
        local ok, meshId = pcall(function() return o.MeshId end)
        local id = ok and assetId(meshId) or nil
        if id and TARGETS[id] then
            found += 1
            table.insert(lines, "=== "..TARGETS[id].." ===")
            table.insert(lines, "Path: "..o:GetFullName())
            table.insert(lines, "Name: "..o.Name)
            table.insert(lines, "MeshId: "..tostring(meshId))

            local props = {
                "TextureID","Size","MeshSize","Scale","Position",
                "Orientation","Transparency","Color","Material",
                "CanCollide","Anchored"
            }
            for _,prop in ipairs(props) do
                local good,val = pcall(function() return o[prop] end)
                if good then
                    table.insert(lines, prop..": "..tostring(val))
                end
            end

            local goodTags,tags = pcall(function()
                return game:GetService("CollectionService"):GetTags(o)
            end)
            if goodTags then
                table.insert(lines, "Tags: "..table.concat(tags,", "))
            end
            table.insert(lines, "")
        end
    end
end

table.insert(lines, "Found instances: "..found)
local output = table.concat(lines, "\n")

print(output)

if writefile then
    local ok,err = pcall(function()
        writefile("RIVALS_Hand_Mesh_Info.txt", output)
    end)
    if ok then
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification",{
                Title="Hand Export",
                Text="Saved RIVALS_Hand_Mesh_Info.txt ("..found.." found)",
                Duration=7
            })
        end)
    else
        warn("Could not save file: "..tostring(err))
    end
else
    warn("writefile is unavailable; metadata was printed to console.")
end
