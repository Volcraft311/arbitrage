local PLUGIN = PLUGIN

local succ, err = pcall(function()
	require("workshop")
end)

print(succ, err)

if !succ then return end