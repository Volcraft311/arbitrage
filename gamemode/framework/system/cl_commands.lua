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

RegisterCommand("me", "#command_me", {"text"}, nil, false)
RegisterCommand("mec", "#command_mec", {"text"}, nil, false)
RegisterCommand("mel", "#command_mel", {"text"}, nil, false)
RegisterCommand("meanon", "#command_meanon", {"text"}, nil, false)

RegisterCommand("try", "#command_try", {"text"}, nil, false)
RegisterCommand("tryc", "#command_tryc", {"text"}, nil, false)
RegisterCommand("tryl", "#command_tryl", {"text"}, nil, false)
RegisterCommand("tryanon", "Анонимное возможное действие случая.", {"text"}, nil, false)

for _, command in ipairs({"it", "do"}) do
    RegisterCommand(command, "#command_it", {"text"}, nil, false)
    RegisterCommand(command .. "c", "#command_itc", {"text"}, nil, false)
    RegisterCommand(command .. "l", "#command_itl", {"text"}, nil, false)
    RegisterCommand(command .. "anon", "#command_itanon", {"text"}, nil, false)
end

RegisterCommand("w", "#command_whispers", {"text"}, nil, false)
RegisterCommand("y", "#command_yell", {"text"}, nil, false)

RegisterCommand("looc", "#command_looc", {"text"}, nil, false)
RegisterCommand("ooc", "#command_ooc", {"text"}, nil, false)

for _, command in ipairs({"broadcast", "announce", "global"}) do
    RegisterCommand(command, "#command_broadcast", {"text"}, nil, true)
end

RegisterCommand("event", "#command_event", {"text"}, nil, true)
RegisterCommand("eventlocal", "#command_eventlocal", {"text"}, nil, true)

RegisterCommand("sg", "#command_sg", {"player"}, nil, true)
RegisterCommand("settime", "#command_settime", {"time"}, nil, true)
RegisterCommand("roll", "#command_roll", nil, {"number"}, false)
RegisterCommand("editor", "#command_editor", nil, nil, true)
RegisterCommand("unstuck", "#command_unstuck", nil, nil, false)
RegisterCommand("exitaction", "#command_exitaction", nil, nil, false)
RegisterCommand("action", "#command_action", {"text"}, nil, false)
RegisterCommand("sitting", "#command_sitting", {"number"}, nil, false)
RegisterCommand("mood", "#command_mood", {"number"}, nil, false)
RegisterCommand("lookaround", "#command_lookaround", nil, nil, false)
RegisterCommand("settimespeed", "#command_settimespeed", {"number"}, nil, true)
RegisterCommand("fallover", "#command_fallover", nil, {"number"}, true)
RegisterCommand("spectate", "#command_spectate", nil, {"player"}, true)

netstream.Hook("arb.ChatNotify", function(data)
    if !data then return end

    LocalPlayer():ChatNotify(data)
end)

local function notify(data)
    if !data then return end

    if !istable(data) then
        data = {data}
    end

    for k, v in ipairs(data) do
        if isstring(v) then
            data[k] = F(v)
        end
    end

    chat.AddText(Color(255, 61, 96), "| ", color_white, unpack(data))
end

function Arbitrage.commands.Notify(client, ...)
    if client == LocalPlayer() or client == nil then
        local data = {...}

        notify(data)
    end
end

local PLAYER = FindMetaTable("Player")

function PLAYER:ChatNotify(...)
    Arbitrage.commands.Notify(self, ...)
end