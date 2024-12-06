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

function Arbitrage.commands.RunCommand(client, command, data)
    command = string.lower(command)
    local commandData = Arbitrage.commands.data[command]

    if commandData then
        local args = data
        table.insert(args, 1, client)

        local newargs = {}
        newargs[1] = args[1]

        if commandData.arguments and istable(commandData.arguments) and commandData.OnAction then
            local state = {false, "", 1}

            for i = 2, #args do
                local index = i - 1
                local dataArg = args[i]

                if commandData.arguments[index] then
                    local _type = commandData.arguments[index].type
                    local returnArgs = Arbitrage.commands.types[_type](dataArg, args, i)

                    if !returnArgs then
                        local a = index .. "(" .. commandData.arguments[index].name .. ")"

                        state = {true, a, 2}
                        break
                    end

                    newargs[i] = returnArgs
                end
            end

            args = newargs

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

                if Arbitrage.commands.data[command] and Arbitrage.commands.data[command].bNoLog != true then
                    table.remove(args, 1)

                    hook.Run("OnCommandRun", client, command, args)
                end
            else
                Arbitrage.commands.Notify(client, Arbitrage.commands.fault[state[3]], " ", Color(216, 61, 61), state[2], color_white, "!")
            end
        end
    else
        Arbitrage.commands.Notify(client, "Данной команды не существует!")
    end
end

function Arbitrage.commands.PlayerSay(client, data)
    local char = utf8.sub(data, 1, 1)
    local bRusCommand = char == "."

    if char == Arbitrage.commands.syntex or bRusCommand then
        data = utf8.sub(data, 2, utf8.len(data))

        local extra = Arbitrage:ExtractArgs(data)

        local command = extra[1]:utf8lower()
        table.remove(extra, 1)

        if bRusCommand then
            command = Arbitrage.commands.ConvertRusToEng(command)
        end

        Arbitrage.commands.RunCommand(client, command, extra)
    else
        if !client:oldAlive() then return "" end

        if client:IsSpectate() then
            Arbitrage.chat.SendCommand("looc", client, data)
        else
            Arbitrage.chat.SendCommand("ic", client, data)
        end
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


local meta = FindMetaTable("Player")
function meta:ChatNotify(...)
    Arbitrage.commands.Notify(self, ...)
end