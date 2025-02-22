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

        local oldData = data
        data = data:Trim():utf8lower()

        if data == "" then return end

        local players = {}
        for _, client in ipairs(player.GetAll()) do
            local character = client:GetCharacter()
            if !character then continue end

            local name = character:GetName()
            if name:utf8sub(1, 1) == "#" then
                local info = {}

                for id, lang in pairs(Arbitrage.language.stored) do
                    local lang_name = lang.data[name]
                    if lang_name then
                        info[id] = lang_name:Trim():utf8lower()
                    end
                end

                players[client] = info
            end
        end

        for client, info in pairs(players) do
            for _, lang_name in pairs(info) do
                if lang_name:find(data) then
                    return client
                end
            end
        end

        return player.GetByIdentifier(oldData)
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
    [1] = "#command_fault_unknown",
    [2] = "#command_argument_error",
    [3] = "#command_argument_unknown"
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

function Arbitrage.commands:FindPlayer(data)
    return self.types.player(data)
end