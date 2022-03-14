--[[
        © Asterion Project 2021.
        This script was created from the developers of the AsterionTeam.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru
            Discord - https://discord.gg/Cz3EQJ7WrF
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

Arbitrage.commands = Arbitrage.library.Add("commands")

-- local function UnPackExplode(explode, wordexplode)
--     if !explode then return end
--     if !wordexplode then return end

--     local wordtable = {}
--     local wordunpack = {}

--     for k, v in pairs(wordexplode or {}) do
--         wordtable[k] = wordtable[k] or {}

--         for i = v[1], v[2] do
--             wordtable[k][#wordtable[k] + 1] = explode[i]:gsub('"', "")
--         end
--     end

--     for k, v in pairs(wordtable) do
--         local str = ""
--         for k2, v2 in pairs(v) do
--             str = str .. " " .. tostring(v2)
--         end

--         wordunpack[#wordunpack + 1] = str
--     end

--     for k, v in pairs(wordexplode) do
--         for i = v[1], v[2] do
--             explode[i] = nil
--         end

--         explode[v[2]] = wordunpack[k]
--     end

--     for k, v in pairs(explode) do
--         if utf8.sub(v, 1, 1) == " " then
--             explode[k] = utf8.sub(v, 2, utf8.len(v))
--         end
--     end

--     return explode
-- end

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

        Arbitrage.commands.RunCommand(client, command, extra)
    else
        if client:IsSpectate() or !client:oldAlive() then return "" end

        Arbitrage.chat.SendCommand("ic", client, data)
    end

    return ""
end


-- function Arbitrage.commands.PlayerSay(client, data)
--     local char = data:sub(1, 1)

--     print(data)

--     if char == Arbitrage.commands.syntex then
--         data = utf8.sub(data, 2, utf8.len(data)) --data:sub(2)
--         -- local commandExplode = string.Explode(" ", data, false)

--         -- local wordExplode = Arbitrage.commands.WordsInArray(commandExplode)
--         -- local explode = UnPackExplode(commandExplode, wordExplode)

--         -- local lastExplode = {}
--         -- for k, v in pairs(explode) do
--         --     lastExplode[#lastExplode + 1] = v
--         -- end

--         -- local command = string.lower(explode[1])
--         -- local args = {}

--         -- args[#args + 1] = client
--         -- for i = 2, #lastExplode do
--         --     args[#args + 1] = lastExplode[i]
--         -- end

--         --PrintTable(args)
--         --print(data)

--         --print(data)

--         local args = Arbitrage:ExtractArgs(data)
--         table.insert(args, 1, client)

--         local command = string.lower(args[2])
--         table.remove(args, 2)

--         local commandData = Arbitrage.commands.data[command]

--         if commandData then
--             if commandData.arguments and istable(commandData.arguments) and commandData.OnAction then
--                 local state = {false, "", 1}

--                 for i = 2, #args do
--                     local index = i - 1
--                     local dataArg = args[i]

--                     if commandData.arguments[index] then
--                         local _type = commandData.arguments[index].type
--                         local returnArgs = Arbitrage.commands.types[_type](dataArg, args)

--                         if !returnArgs then
--                             local a = index .. "(" .. commandData.arguments[index].name .. ")"

--                             state = {true, a, 2}
--                             break
--                         end

--                         if _type == "text" then
--                             local newargs = {}

--                             newargs[1] = args[1]
--                             newargs[2] = returnArgs

--                             args = newargs
--                             break
--                         end
--                     end
--                 end

--                 if !state[1] then
--                     for i = 1, #commandData.arguments do
--                         local dataArg = args[i + 1]
--                         local important = commandData.arguments[i].important

--                         if !dataArg and important then
--                             local a = i .. "(" .. commandData.arguments[i].name .. ")"

--                             state = {true, a, 3}
--                             break
--                         end
--                     end
--                 end

--                 if !state[1] then
--                     commandData.OnAction(unpack(args))
--                 else
--                     Arbitrage.commands.Notify(client, Arbitrage.commands.fault[state[3]], " ", Color(216, 61, 61), state[2], Color(255, 255, 255), "!")
--                 end
--             end
--         else
--             Arbitrage.commands.Notify(client, "Данной команды не существует!")
--         end

--         return ""
--     else
--         --if client:IsSpectate() or !client:Alive() then
--         --    return ""
--         --end
--         if client:IsSpectate() or !client:oldAlive() then
--             return ""
--         end

--         Arbitrage.chat.SendCommand("ic", client, data)
--         return ""
--     end
-- end


function Arbitrage.commands.Notify(client, ...)
    local dataTable = {...}

    if !IsValid(client) then return end

    netstream.Start(client, "arb.ChatNotify", dataTable)
end

function Arbitrage.commands.Add(name, data)
    if !data then return end

    Arbitrage.commands.data[string.lower(name)] = data
end


-- Arbitrage.commands.Add("test", {
--     arguments = {
--         [1] = {
--             name = "arg1",
--             type = "string",
--             important = false
--         },
--         [2] = {
--             name = "arg2",
--             type = "number",
--             important = false
--         },
--         [3] = {
--             name = "arg3",
--             type = "bool",
--             important = false
--         }
--     },
--     OnAction = function(client, arg1, arg2, arg3)
--     end
-- })