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

Arbitrage.commands.syntex = "/"
Arbitrage.commands.data = {}
Arbitrage.commands.types = {
    ["string"] = function(data)
        return tostring(data)
    end,
    ["number"] = function(data)
        return tonumber(data)
    end,
    ["bool"] = function(data)
        return tostring(data) == "true" or tostring(data) == "false"
    end,
    ["text"] = function(data, args)
        return table.concat(args, " ", 2)
    end,
}

Arbitrage.commands.fault = {
    [1] = "НЕИЗВЕСТНО",
    [2] = "Вы указали ошибку в аргументе",
    [3] = "У вас не указан аргумент"
}

function Arbitrage.commands.WordsInArray(data)
    if !data then return end

    local tableData = {}

    for k, v in pairs(data) do
        local a = 0
        local b = 0

        if string.match(v, [["(.+)]]) then
            a = k

            for i = k, #data do
                if string.match(data[i], [[(.+)"]]) then
                    b = i
                    break
                end
            end
        end

        if a != 0 and b != 0 then
            tableData[#tableData + 1] = {a, b}
        end
    end

    return tableData
end