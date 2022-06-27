--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru (not work)
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

Arbitrage.commands = Arbitrage.library.Add("commands")

function Arbitrage.commands.RunCommand(client, command, data)
    command = string.lower(command)
    local commandData = Arbitrage.commands.data[command]

    if commandData then
        local args = data
        table.insert(args, 1, client)

        if commandData.arguments and istable(commandData.arguments) and commandData.OnAction then
            local state = {false, "", 1}

            for i = 2, #args do
                local index = i - 1
                local dataArg = args[i]

                if commandData.arguments[index] then
                    local _type = commandData.arguments[index].type
                    local returnArgs = Arbitrage.commands.types[_type](dataArg, args)

                    if !returnArgs then
                        local a = index .. "(" .. commandData.arguments[index].name .. ")"

                        state = {true, a, 2}
                        break
                    end

                    if _type == "text" then
                        local newargs = {}

                        newargs[1] = args[1]
                        newargs[2] = returnArgs

                        args = newargs
                        break
                    end
                end
            end

            if !state[1] then
                for i = 1, #commandData.arguments do
                    local dataArg = args[i + 1]
                    local important = commandData.arguments[i].important

                    if !dataArg and important then
                        local a = i .. "(" .. commandData.arguments[i].name .. ")"

                        state = {true, a, 3}
                        break
                    end
                end
            end

            if !state[1] then
                commandData.OnAction(unpack(args))
            else
                Arbitrage.commands.Notify(client, Arbitrage.commands.fault[state[3]], " ", Color(216, 61, 61), state[2], Color(255, 255, 255), "!")
            end
        end
    else
        Arbitrage.commands.Notify(client, "Данной команды не существует!")
    end
end

function Arbitrage.commands.PlayerSay(client, data)
    local char = utf8.sub(data, 1, 1)

    if char == Arbitrage.commands.syntex then
        data = utf8.sub(data, 2, utf8.len(data))

        local extra = Arbitrage:ExtractArgs(data)

        local command = extra[1]
        table.remove(extra, 1)

        if serverguard.command.stored[command:lower()] then
            table.insert(extra, 1, command)
            netstream.Start(client, "arb.SendCommand", "sg", extra)
        else
            Arbitrage.commands.RunCommand(client, command, extra)
        end
    else
        if client:IsSpectate() or !client:oldAlive() then return "" end

        Arbitrage.chat.SendCommand("ic", client, data)
    end

    return ""
end

function Arbitrage.commands.Notify(client, ...)
    local dataTable = {...}

    if !IsValid(client) then return end

    netstream.Start(client, "arb.ChatNotify", dataTable)
end

function Arbitrage.commands.Add(name, data)
    if !data then return end

    Arbitrage.commands.data[string.lower(name)] = data
end