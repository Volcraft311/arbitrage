--[[
        © AsterionStaff 2024.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


local color_green = Color(86, 253, 9)
local color_red = Color(245, 35, 35)
local color_white = Color(255, 255, 255)

netstream.Hook("Moderation:Log", function(uniqueID, info)
    info = info:gsub("%(<https://steamcommunity.com/profiles/%d+>%),?", "")
    info = F(info)

    MsgC(color_green, "[Moderation]", color_red, " [" .. uniqueID .. "]", color_white, " " .. info .. "\n")
end)

RegisterCommand("goto", "#command_goto", {"player"})
RegisterCommand("bring", "#command_bring", {"player"})
RegisterCommand("tp", "#command_tp", {"player"})
RegisterCommand("pm", "#command_pm", {"player", "text"})
RegisterCommand("return", "#command_return", {"player"})

for _, command in ipairs({"unanonymous", "unincognito", "returnrank", "rr"}) do
    RegisterCommand(command, "#command_unanonymous", {})
end

for _, command in ipairs({"anonymous", "incognito", "takerank", "tr"}) do
    RegisterCommand(command, "#command_anonymous", {})
end

for _, command in ipairs({"a", "admin"}) do
    RegisterCommand(command, "#command_admin", {"text"})
end

for _, command in ipairs({"help", "report"}) do
    RegisterCommand(command, "#command_help", {"text"})
end

for _, command in ipairs({"hp", "health"}) do
    RegisterCommand(command, "#command_health", {"player", "number"})
end

for _, command in ipairs({"ar", "armor"}) do
    RegisterCommand(command, "#command_armor", {"player", "number"})
end

RegisterCommand("hunger", "#command_hunger", {"player", "number"})
RegisterCommand("thirst", "#command_thirst", {"player", "number"})
RegisterCommand("sleep", "#command_sleep", {"player", "number"})
RegisterCommand("cleardecals", "#command_cleardecals", {})
RegisterCommand("freezeprops", "#command_freezeprops")

for _, command in ipairs({"unignite", "unfire", "extinguish"}) do
    RegisterCommand(command, "#command_unignite", {"player"})
end

for _, command in ipairs({"ignite", "fire"}) do
    RegisterCommand(command, "#command_ignite", {"player"}, {"number"})
end

for _, command in ipairs({"kill", "slay"}) do
    RegisterCommand(command, "#command_slay", {"player"})
end

RegisterCommand("slap", "#command_slap", {"player"})

for _, command in ipairs({"map", "changemap", "changelevel"}) do
    RegisterCommand(command, "#command_changemap", {"string"})
end

for _, command in ipairs({"getmaps", "maps"}) do
    RegisterCommand(command, "#command_getmaps", {})
end

RegisterCommand("kick", "#command_kick", {"player", "text"})

RegisterCommand("runconsolecommand", "#command_runconsolecommand", {"text"})

RegisterCommand("reset", "#command_reset", {"player"})
RegisterCommand("respawn", "#command_respawn", {"player"})
RegisterCommand("model", "#command_model", {"player", "string"})
RegisterCommand("guard", "#command_guard", {"player", "string"})
RegisterCommand("unguard", "#command_unguard", {"player"})

RegisterCommand("restartserver", "#command_restartserver", {"number"})
RegisterCommand("unrestartserver", "#command_unrestartserver")

RegisterCommand("freeze", "#command_freeze", {"player"})
RegisterCommand("unfreeze", "#command_unfreeze", {"player"})

for _, command in ipairs({"strip", "strips", "stripweapons", "stripsweapons"}) do
    RegisterCommand(command, "#command_strip", {"player"})
end

RegisterCommand("removesoundscape", "#command_removesoundscape")