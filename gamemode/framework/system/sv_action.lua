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

Arbitrage.action = Arbitrage.library.Add("action")

function Arbitrage.action.ActionEnd(index, client)
    if IsValid(client) then
        netstream.Start(client, "arb.ActionEnd")
    end

    hook.Remove("Tick", "arb.ACTION_" .. index)
end

function Arbitrage.action.ActionSend(client, data)
    if !IsValid(client) then return end
    if !client:IsPlayer() then return end

    netstream.Start(client, "arb.ActionRun", data)
end

function Arbitrage.action.ActionRun(client, data, time, funcfail, funccomplite)
    if !IsValid(client) then return end
    if !client:IsPlayer() then return end

    data = data or "Текст отсутствует"
    time = time or 5

    local index = client:EntIndex()
    local endTime = CurTime() + time

    Arbitrage.action.ActionEnd(index, client)
    Arbitrage.action.ActionSend(client, {
        text = data,
        time = time
    })

    hook.Add("Tick", "arb.ACTION_" .. index, function()
        if !IsValid(client) then Arbitrage.action.ActionEnd(index, client) return end

        local ActionFail = funcfail(client)

        if ActionFail then
            Arbitrage.action.ActionEnd(index, client)
        end

        if CurTime() >= endTime and !ActionFail then
            Arbitrage.action.ActionEnd(index, client)

            if !IsValid(client) then return end

            funccomplite(client)
        end
    end)
end