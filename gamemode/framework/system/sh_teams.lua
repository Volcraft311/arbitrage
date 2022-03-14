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

Arbitrage.teams = Arbitrage.library.Add("teams")
Arbitrage.teams.data = {}
Arbitrage.teams.index = 2

function Arbitrage.teams.Create(data)
    local team_index = Arbitrage.teams.index
    team.SetUp(team_index, data.name, data.color)

    Arbitrage.teams.index = Arbitrage.teams.index + 1

    local path = data.path
    if path then
        path = path .. "/%s.png"

        data.gradient       =     Format(path, "gradient")
        data.logo           =     Format(path, "logo")
        data.hud            =     Format(path, "hud")
        data.pixel          =     Format(path, "pixel")
        data.dead           =     Format(path, "dead")
        data.white          =     Format(path, "white")
        data.splash         =     Format(path, "splash")
    end

    data.emodjiList = data.emodjiList or {}
    data.emodjiListMin = {}

    for k, v in pairs(data.emodjiList) do
        local clear = string.utf8sub(v, 0, string.utf8len(v) - 4)
        local min = clear .. "_m.png"

        data.emodjiListMin[#data.emodjiListMin + 1] = min
    end

    -- Перенесено в AUTOCACHE
    --[[
    if Arbitrage.util.IsClientSide() then
        -- Кешируем все эмодзи
        local info = {data.emodjiList, data.emodjiListMin}

        for i = 1, #info do
            local element = info[i]

            for k, v in pairs(element) do
                Arbitrage.GetMaterial(v)
            end
        end
    end
    ]]--


    Arbitrage.teams.data[team_index] = data

    if Arbitrage.util.IsServerSide() then
        Arbitrage.util.WriteMessage(Color(29, 137, 252), "{TEAMS} ", Color(255, 255, 255), "Team \"" .. data.name .. "\" has been successfully created!")
    end

    return team_index
end

function Arbitrage.teams.Get(data)
    if !data then return end

    return Arbitrage.teams.data[data]
end