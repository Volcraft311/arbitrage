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

local function getAdmins()
    local data = {}

    for k, v in ipairs(player.GetAll()) do
        if v:IsAdmin() then
            data[#data + 1] = v
        end
    end

    return data
end

function Arbitrage.statistics.Set(client, data, amount)
    if !IsValid(client) then return end

    local index = string.lower(data)
    local tableData = Arbitrage.statistics.list[index]

    if tableData then
        client[tableData.data] = amount
        client:SetNetVar(index, client[tableData.data], getAdmins())
    else
        Arbitrage.util.WriteMessage(Color(255, 132, 0), "STATISTICS — ", Color(255, 0, 0), "No query was found \"" .. data .. "\"")
    end
end

function Arbitrage.statistics.PlayerPostThink(client)
    if !IsValid(client) then return end
    if !client:Alive() then return end
    if !client:IsPlaying() then return end

    if !Arbitrage.IsStartGame() then return end
    if Arbitrage.lawEnable then return end
    if Arbitrage.OffFallStatictic() then return end

    for k, v in pairs(Arbitrage.statistics.list or {}) do
        local data = v.data
        local colddown = v.data .. "CD"

        client[data] = client[data] or 100
        client[colddown] = client[colddown] or 0

        if v.data and (!client[colddown] or CurTime() >= client[colddown]) then
            client[data] = client[data] - 1
            client:SetNetVar(k, math.Clamp(client[data], 0, 100), getAdmins())

            if v.action then
                v.action(client, v)
            end

            local time = isfunction(v.time) and v.time(client) or v.time
            client[colddown] = CurTime() + time
        end
    end
end