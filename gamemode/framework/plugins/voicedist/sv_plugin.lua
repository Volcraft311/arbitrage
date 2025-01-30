local PLUGIN = PLUGIN

util.AddNetworkString("VoiceDist:StartVoice")
util.AddNetworkString("VoiceDist:EndVoice")

net.Receive("VoiceDist:StartVoice", function(len, client)
    if !client:oldAlive() then return false end
    if client:Team() == TEAM_SPECTATE then return end
    if client:IsRagdolling() then return end
    if client:GetNetVar("arb.MuteVoice") then return end

    if Arbitrage.lawEnable then
        if !client:Alive() then return end
        if !client:InGame() then return end

        if LawSystem.IsRebuttalShowdowns then
            if CurTime() < (LawSystem.RebuttalShowdownsMuted or 0) then return end
            if !LawSystem.RS_players[client] then return end
        end
    end

    client.isTalking = true

    if client:GetNetVar("arbGlobalVoice") then
        client.isTalkingGlobal = true
    end
end)

net.Receive("VoiceDist:EndVoice", function(len, client)
    client.isTalking = nil
    client.isTalkingGlobal = nil
end)

Arbitrage.GM.PlayerCanHearPlayersVoice = nil
hook("PlayerCanHearPlayersVoice", function(listener, talker)
    if !talker.isTalking then return false end

    if Arbitrage.lawEnable or talker.isTalkingGlobal then
        return true, false
    end

    if listener:IsSpectating() then
        local talkerPos = talker:GetPos()

        -- там где находится камера
        local position = listener._CameraPosition
        if position and position:DistToSqr(talkerPos) < talker.voiceDist then
            return true, false
        end

        -- объект за которым закреплен
        local entity = listener._CameraEntity
        if IsValid(entity) then
            position = entity:GetPos()

            if position:DistToSqr(talkerPos) < talker.voiceDist then
                return true, false
            end
        end

        -- для тех кто рядом со мной (обычная позиция без спектейта)
        if listener:GetPos():DistToSqr(talkerPos) < talker.voiceDist then
            return true, false
        end
    end

    local bCanHear = listener.voiceHear and listener.voiceHear[talker]
    return bCanHear, true
end)

local function calcPlayerCanHearPlayersVoice(listener)
    if !IsValid(listener) then return end

    listener.voiceHear = listener.voiceHear or {}

    local pos = listener:GetPos()
    for _, talker in ipairs(player.GetAll()) do
        if talker.isTalking then
            local talkerPos = talker:GetPos()

            listener.voiceHear[talker] = pos:DistToSqr(talkerPos) < talker.voiceDist
        else
            listener.voiceHear[talker] = false
        end
    end
end

local voiceDist = 650
function PLUGIN:PlayerInitialSpawn(client)
    local dist = voiceDist * 0.5
    client.voiceDist = dist * dist

    local uniqueID = client:SteamID64() .. "canHearPlayersVoice"
    timer.Create(uniqueID, 0.5, 0, function()
        calcPlayerCanHearPlayersVoice(client)
    end)
end

function PLUGIN:PlayerDisconnected(client)
    for k, v in ipairs(player.GetAll()) do
        if !v.voiceHear then continue end

        v.voiceHear[client] = nil
    end

    timer.Remove(client:SteamID64() .. "canHearPlayersVoice")
end

netstream.Hook("VOICEDIST:ChangeVoiceVolume", function(client, data)
    local getVoiceScale = client:GetNetVar("arb.voicescale", 0.5)
    local amount = getVoiceScale + (data and 0.1 or -0.1)
    amount = math.Clamp(amount, 0.1, 1)

    client:SetNetVar("arb.voicescale", amount)

    local dist = voiceDist * amount
    client.voiceDist = dist * dist
end)