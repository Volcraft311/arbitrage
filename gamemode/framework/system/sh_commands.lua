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
    ["text"] = function(data, args, startArgs)
        local text = ""

        for i = startArgs, #args do
            text = text .. args[i] .. " "
        end

        return text:Trim()
    end,
    ["player"] = function(data)
        if IsValid(data) and data:IsPlayer() then
            return data
        end

        return player.GetByIdentifier(data)
    end
}

Arbitrage.commands.keyList = {
    й = "q",
    ц = "w",
    у = "e",
    к = "r",
    е = "t",
    н = "y",
    г = "u",
    ш = "i",
    щ = "o",
    з = "p",
    х = "[",
    ъ = "]",
    ф = "a",
    ы = "s",
    в = "d",
    а = "f",
    п = "g",
    р = "h",
    о = "j",
    л = "k",
    д = "l",
    ж = ";",
    э = "'",
    я = "z",
    ч = "x",
    с = "c",
    м = "v",
    и = "b",
    т = "n",
    ь = "m",
    б = ",",
    ю = ".",
    ["."] = "/"
}

Arbitrage.commands.fault = {
    [1] = "НЕИЗВЕСТНО",
    [2] = "Вы указали ошибку в аргументе",
    [3] = "У вас не указан аргумент"
}

function Arbitrage.commands.ConvertRusToEng(data)
    local newData = ""
    for i = 1, data:utf8len() do
        local s = data:utf8sub(i, i):utf8lower()

        local n_s = Arbitrage.commands.keyList[s] or s
        newData = newData .. n_s
    end

    return newData
end