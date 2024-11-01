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

Evidence.numID = Evidence.numID or 1

function Evidence:RegisterNewEvidence(data)
    self.list[self.numID] = data
    local idx = self.numID

    netstream.Start(nil, "Evidence:Register", idx, self.list[idx])
    self.numID = self.numID + 1

    return idx
end

function Evidence:SetEntityEvidence(entity, idx)
    if !IsValid(entity) then return "Не валидное Entity!" end
    --if !idx then return "Улики с данным ID не существует!" end // пока комментарии ибо нужно возвращать как-то nil значение для удаления

    entity:SetNetVar("ev_id", idx)

    return "Улика №" .. tostring(idx) .. " была успешно присвоина " .. tostring(entity) .. "."
end

local function reg(data)
    return Evidence:RegisterNewEvidence({
        name = data.name or "Неизвестно",
        description = data.description or "Неизвестно",
        color = data.color or color_white,
        alpha = data.alpha or 255,
        image = tonumber(data.image) and math.floor(data.image) or 1,
        ribbon = tonumber(data.image) and math.floor(data.ribbon) or 1,
        factiondata = table.Count(data.factiondata or {}) > 0 and data.factiondata or nil
    })
end

function Evidence:LeftClick(data)
    if !data then return end

    local idx = reg(data)
    if !idx then return end

    local entity = ents.Create("arb_evidence")
    entity:SetPos(data.position)
    entity:SetAngles(data.angles)
    entity:Spawn()

    return entity:SetEvidence(idx)
end

function Evidence:RightClick(data)
    if !data then return end
    if !IsValid(data.entity) then return end

    local e_idx = data.entity:GetEvidence()
    if e_idx then return end

    local idx = reg(data)
    if !idx then return end

    return data.entity:SetEvidence(idx)
end

function Evidence:Reload(data)
    if !data then return end
    if !IsValid(data.entity) then return end

    local idx = data.entity:GetEvidence()
    if !idx then return end

    local name = tostring(data.entity)

    data.entity:SetEvidence(nil)

    if data.entity:GetClass() == "arb_evidence" then
        data.entity:Remove()
    end

    self:DeleteEvidence(idx)

    return "Вы успешно удалили улику №" .. idx .. " с " .. name .. "."
end

function Evidence:DeleteEvidence(idx)
    self.list[idx] = nil
    netstream.Start(nil, "Evidence:Register", idx, nil)

    for k, v in pairs(MonoPad.instances) do
        v:RemoveEvidence(idx)
        v:Sync()
    end
end




local ENTITY = FindMetaTable("Entity")

function ENTITY:SetEvidence(idx)
    return Evidence:SetEntityEvidence(self, idx)
end


local PLAYER = FindMetaTable("Player")

function PLAYER:AddEvidence(idx, time)
    if !Evidence:GetEvidence(idx) then return "Ошибка при выдаче улики игроку!" end

    local monopad = MonoPad:FindMonoPad(self)
    if !monopad then return "У игрока нету монопада!" end

    local object = monopad.stored
    if !object then return "У монопада отсутствует его объект!" end

    object:AddEvidence(idx, time)
    object:Sync()

    if !Arbitrage.lawEnable then
        netstream.Start(self, "arb.Notify", "Журнал улик монопада обновлён.", false)
    end

    netstream.Start(self, "MonoPad:EditSpecialNotify")

    return "Улика с ID №" .. tostring(idx) .. " была успешно выдана игроку " .. tostring(self) .. "."
end


function Evidence:EntityRemoved(entity)
    local idx = entity:GetEvidence()

    if idx then
        entity:SetEvidence(nil)
        self:DeleteEvidence(idx)
    end
end

local function collect(client, entity, idx)
    Arbitrage.action.ActionRun(client, "Собираем улику", 1, function()
        if !IsValid(entity) then return true end
        if client:GetPos():Distance(entity:GetPos()) >= 200 then return true end

        return false
    end, function()
        client:AddEvidence(idx)
        netstream.Start(client, "Evidence:Draw", entity)
    end)
end

function Evidence:PlayerUse(client, entity)
    local idx = entity:GetEvidence()
    if !idx then return end

    if Arbitrage.OffPickingEvidence() then return end
    if entity:IsPlayer() then return end

    local allow = false

    local data = self:GetEvidence(idx)
    if data.factiondata then
        allow = data.factiondata[client:Team()]
    else
        allow = true
    end

    if !allow then return end

    if !client.evidenceCD or CurTime() >= client.evidenceCD then
        client.evidenceCD = CurTime() + 2

        local monopad = MonoPad:FindMonoPad(client)
        if !monopad then return collect(client, entity, idx) end
        if !client:HasEvidence(idx) then return collect(client, entity, idx) end

        netstream.Start(client, "arb.Notify", "В монопаде уже есть данная улика!", true)
    end
end

function Evidence:PlayerInitialSpawnForRealz(client)
    local info = {}
    for idx, data in pairs(self.list) do
        info[idx] = data
    end

    netstream.Heavy(client, "Evidence:RegisterAllEvidences", info)
end


netstream.Hook("Evidence:SetDescription", function(client, data)
    client.EvidenceDescription = data or "Описание улики"
end)

netstream.Hook("Evidence:SetFactionData", function(client, data)
    client.EvidenceFactionData = data
end)