local PLUGIN = PLUGIN

local dist = 650
function PLUGIN:PlayerCanHearPlayersVoice(listener, talker)
    if talker:IsSpectate() then return false end
    if talker:IsRagdolling() then return false end
    if !talker:oldAlive() then return false end
    if talker:GetNetVar("arb.MuteVoice") then return false end

    if Arbitrage.lawEnable then
        if !talker:Alive() then return false end
        if !talker:InGame() then return false end

        if LawSystem.IsRebuttalShowdowns then
            if CurTime() < (LawSystem.RebuttalShowdownsMuted or 0) then
                return false
            end

            if LawSystem.RS_players[talker] then
                return true, false
            else
                return false
            end
        end

        return true, false
    end

    -- глобальный войс
    if talker:GetNetVar("arbGlobalVoice") then
        return true, false
    end

    local getVoiceScale = talker:GetNetVar("arb.voicescale", 0.5)
    if listener:IsSpectating() then
        -- там где находится камера
        local position = listener._CameraPosition
        if position and position:Distance(talker:GetPos()) <= dist * getVoiceScale then
            return true, false
        end

        -- объект за которым закреплен
        local entity = listener._CameraEntity
        if IsValid(entity) then
            position = entity:IsPlayer() and entity:GetShootPos() or entity:GetPos()

            if position and position:Distance(talker:GetPos()) <= dist * getVoiceScale then
                return true, false
            end
        end

        -- для тех кто рядом со мной (обычная позиция без спектейта)
        if listener:GetPos():Distance(talker:GetPos()) <= dist * getVoiceScale then
            return true, false
        end
    end

    if listener:GetPos():Distance(talker:GetPos()) > dist * getVoiceScale then return false end

    return true, true
end

netstream.Hook("VOICEDIST:ChangeVoiceVolume", function(client, data)
    local getVoiceScale = client:GetNetVar("arb.voicescale", 0.5)
    local amount = getVoiceScale + (data and 0.1 or -0.1)
    amount = math.Clamp(amount, 0.1, 1)

    client:SetNetVar("arb.voicescale", amount)
end)