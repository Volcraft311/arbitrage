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

Arbitrage.evidence = Arbitrage.library.Add("evidence")
Arbitrage.evidence.list = Arbitrage.evidence.list or 1


--[[    ПЕРЕПИСАНО В ПЛАГИН `evidence`
function Arbitrage.evidence.Create(data, index)
    if !index then return end
    if !Arbitrage.evidence.Get(index) then return end
    if !isvector(data) and !isentity(data) then return end

    Arbitrage.evidence.repository[Arbitrage.evidence.list] = {
        data = data,
        index = index,
        num = Arbitrage.evidence.list
    }

    if isvector(data) then
        local evidence = ents.Create("arb_evidence")
        evidence:SetModel("models/hunter/blocks/cube025x025x025.mdl")
        evidence:SetPos(data)
        evidence:Spawn()

        evidence.id = Arbitrage.evidence.list
    end

    for k, v in pairs(player.GetAll()) do
        netstream.Start(v, "arbAddEvidence", Arbitrage.evidence.repository)
    end

    Arbitrage.evidence.list = Arbitrage.evidence.list + 1
end

for k, v in pairs(Arbitrage.data.Get("evidence", {})) do
    Arbitrage.evidence.Add(k, {
        name = v.name or "No data",
        desc = v.desc or "No data",
        creator = v.creator or "No data",
        time = v.time or 0,
        mat = v.mat or 1
    })
end

function Arbitrage.evidence.SendInfo(client, replace)
    netstream.Start(client, "arb.evidenceSend", Arbitrage.evidence.data, replace)
    netstream.Start(client, "arb.evidenceDataSend", Arbitrage.evidence.repository)
end

function Arbitrage.evidence.CreateNewEvidence(index, data)
    if !data then return end
    if !istable(data) then return end

    Arbitrage.evidence.Add(index, {
        name = data.name or "No data",
        desc = data.desc or "No data",
        creator = data.creator or "No data",
        time = data.time or 0,
        mat = data.mat or 1
    })

    local evidenceData = Arbitrage.data.Get("evidence", {})
    evidenceData[index] = data

    Arbitrage.data.Set("evidence", evidenceData)

    for k, v in pairs(player.GetAll()) do
        Arbitrage.evidence.SendInfo(v)
    end
end

function Arbitrage.evidence.ClearAll()
    for k, v in pairs(ents.GetAll()) do
        netstream.Start(v, "arb.evidenceClearAll")
    end

    Arbitrage.evidence.repository = {}
end

netstream.Hook("arb.CreateNewEvidence", function(client, index, data)
    if !client:IsAdmin() then return end
    if !data then return end
    if !istable(data) then return end

    data.creator = client:SteamName() .. " (" .. client:SteamID() .. ")"
    data.time = os.time()

    Arbitrage.evidence.CreateNewEvidence(index, data)
end)

netstream.Hook("arb.RemoveEvidence", function(client, index)
    if !client:IsAdmin() then return end
    if !index then return end

    local evidenceData = Arbitrage.data.Get("evidence", {})
    evidenceData[index] = nil
    Arbitrage.evidence.data[index] = nil

    Arbitrage.data.Set("evidence", evidenceData)

    for k, v in pairs(player.GetAll()) do
        Arbitrage.evidence.SendInfo(v, true)
    end
end)

netstream.Hook("arb.CreateWorld", function(client, index)
    if !client:IsAdmin() then return end
    if !index then return end

    local trace = client:GetEyeTrace()
    local hitpos = trace.HitPos

    Arbitrage.evidence.Create(hitpos, index)
end)
]]--