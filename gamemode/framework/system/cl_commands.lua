--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

Arbitrage.commands = Arbitrage.library.Add("commands")
Arbitrage.commands.stored = {}

function RegisterCommand(command, help, arguments, optionalArguments, bAdminOnly)
    Arbitrage.commands.stored[command] = {
        help = help,
        arguments = arguments,
        optionalArguments = optionalArguments,
        bAdminOnly = bAdminOnly
    }
end

RegisterCommand("me", "#command_me", {"text"})
RegisterCommand("mec", "#command_mec", {"text"})
RegisterCommand("mel", "#command_mel", {"text"})
RegisterCommand("meanon", "#command_meanon", {"text"})

RegisterCommand("try", "#command_try", {"text"})
RegisterCommand("tryc", "#command_tryc", {"text"})
RegisterCommand("tryl", "#command_tryl", {"text"})
RegisterCommand("tryanon", "Анонимное возможное действие случая.", {"text"})

for _, command in ipairs({"it", "do"}) do
    RegisterCommand(command, "#command_it", {"text"})
    RegisterCommand(command .. "c", "#command_itc", {"text"})
    RegisterCommand(command .. "l", "#command_itl", {"text"})
    RegisterCommand(command .. "anon", "#command_itanon", {"text"})
end

RegisterCommand("w", "#command_whispers", {"text"})
RegisterCommand("y", "#command_yell", {"text"})

RegisterCommand("looc", "#command_looc", {"text"})
RegisterCommand("ooc", "#command_ooc", {"text"})

for _, command in ipairs({"broadcast", "announce", "global"}) do
    RegisterCommand(command, "#command_broadcast", {"text"})
end

RegisterCommand("event", "#command_event", {"text"})
RegisterCommand("eventlocal", "#command_eventlocal", {"text"})

RegisterCommand("sg", "#command_sg", {"player"})
RegisterCommand("settime", "#command_settime", {"time"})
RegisterCommand("roll", "#command_roll", nil, {"number"})
RegisterCommand("editor", "#command_editor")
RegisterCommand("unstuck", "#command_unstuck")
RegisterCommand("exitaction", "#command_exitaction")
RegisterCommand("action", "#command_action", {"text"})
RegisterCommand("sitting", "#command_sitting", {"number"})
RegisterCommand("mood", "#command_mood", {"number"})
RegisterCommand("lookaround", "#command_lookaround")
RegisterCommand("settimespeed", "#command_settimespeed", {"number"})
RegisterCommand("fallover", "#command_fallover", nil, {"number"})
RegisterCommand("spectate", "#command_spectate", nil, {"player"})

netstream.Hook("arb.ChatNotify", function(data)
    if !data then return end

    Arbitrage.notify.NotifyChat(data)
end)