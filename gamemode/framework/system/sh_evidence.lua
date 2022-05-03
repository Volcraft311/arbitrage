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

Arbitrage.evidence = Arbitrage.library.Add("evidence")
Arbitrage.evidence.data = Arbitrage.evidence.data or {}
Arbitrage.evidence.array = Arbitrage.evidence.array or {}
Arbitrage.evidence.repository = Arbitrage.evidence.repository or {}
Arbitrage.evidence.entities = Arbitrage.evidence.entities or {}
Arbitrage.evidence.materials = {}

function Arbitrage.evidence.AddMaterial(data)
    if !data then return end

    data = Format("danganronpa/evidence/" .. "%s.png", data)

    Arbitrage.evidence.materials[#Arbitrage.evidence.materials + 1] = data
end

function Arbitrage.evidence.Get(name)
    if !name then return end

    return Arbitrage.evidence.data[name]
end

function Arbitrage.evidence.Find(data, value)
    local pos = data

    if isentity(data) and IsValid(data) then
        pos = data:GetPos()
    end

    if !isvector(pos) then return end

    local tableData = {}
    for k, v in pairs(Arbitrage.evidence.repository or {}) do
        local evidencePos = v.data

        if isentity(evidencePos) and IsValid(evidencePos) then
            evidencePos = v.data:GetPos()
        end

        if !isvector(evidencePos) then continue end

        if pos:Distance(evidencePos) <= value then
            v.num = k
            tableData[#tableData + 1] = v
        end
    end

    return tableData
end

function Arbitrage.evidence.Add(name, data)
    if !name then return end
    if !data then return end

    Arbitrage.evidence.data[name] = data
end

function Arbitrage.evidence.AddEnt(name, data)
    if !name then return end
    if !data then return end

    Arbitrage.evidence.entities[name] = data
end