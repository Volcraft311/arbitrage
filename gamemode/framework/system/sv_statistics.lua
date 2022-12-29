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

Arbitrage.statistics = Arbitrage.library.Add("statistics")

local function getPlayers(client)
    local data = player.GetAdmins()
    data[#data + 1] = client

    return data
end

function Arbitrage.statistics.Set(client, data, amount)
    if !IsValid(client) then return end

    local index = string.lower(data)
    local tableData = Arbitrage.statistics.list[index]

    if tableData then
        client[tableData.data] = amount
        client:SetNetVar(index, client[tableData.data], getPlayers(client))
    else
        Arbitrage.util.WriteMessage(Color(255, 132, 0), "STATISTICS — ", Color(255, 0, 0), "No query was found \"" .. data .. "\"")
    end
end

function Arbitrage.statistics.PlayerPostThink(client)
    for k, v in pairs(Arbitrage.statistics.list or {}) do
        local vtime = v.time
        local data = tostring(v.data)
        local colddown = tostring(v.data) .. "CD"

        client[data] = tonumber(client[data]) or 100
        client[colddown] = tonumber(client[colddown]) or 0

        if data and (!client[colddown] or CurTime() >= client[colddown]) then
            if v.OnCanRun then
                local allow = v.OnCanRun(client, v)
                if allow == false then
                    continue
                end
            end

            local time = isfunction(vtime) and (tonumber(vtime(client)) or 40) or tonumber(vtime)
            if time <= -1 then
                continue
            end

            client[data] = math.Clamp(tonumber(client[data] - 1), 0, 100)
            client:SetNetVar(k, client[data], getPlayers(client))

            if v.OnRun then
                v.OnRun(client, v)
            end

            client[colddown] = CurTime() + time
        end
    end
end