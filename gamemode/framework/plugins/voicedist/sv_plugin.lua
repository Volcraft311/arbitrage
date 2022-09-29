local PLUGIN = PLUGIN

function PLUGIN:PlayerCanHearPlayersVoice(listener, talker)
    if talker:IsSpectate() then return false end
    if !talker:oldAlive() then return false end

    if Arbitrage.lawEnable then
        if !talker:Alive() then return false end
        if !talker:InGame() then return false end

        if LawSystem.IsRebuttalShowdowns then
            if LawSystem.RS_players[talker] then
                return true, false
            else
                return false
            end
        end

        return true, false
    end

    if talker:GetNetVar("arbGlobalVoice") then
        return true, false
    end

    local GetVoiceScale = talker:GetNetVar("arb.voicescale", 0.5)

    if listener:GetPos():Distance(talker:GetPos()) > 650 * GetVoiceScale then return false end

    return true, true
end

netstream.Hook("VOICEDIST:ChangeVoiceVolume", function(client, data)
    local GetVoiceScale = client:GetNetVar("arb.voicescale", 0.5)

    local amount = GetVoiceScale + (data and 0.1 or -0.1)
    amount = math.Clamp(amount, 0.1, 1)

    client:SetNetVar("arb.voicescale", amount, client)
end)