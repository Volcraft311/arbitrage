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


local PLUGIN = PLUGIN
PLUGIN.numID = PLUGIN.numID or 1

function PLUGIN:RegisterNewEvidence(data)
    self.list[self.numID] = data
    local idx = self.numID

    netstream.Start(nil, "evidence.Register", idx, self.list[idx])
    self.numID = self.numID + 1

    return idx
end

function PLUGIN:SetEntityEvidence(entity, idx)
    if !IsValid(entity) then return "Не валидное Entity!" end
    --if !idx then return "Улики с данным ID не существует!" end // пока комментарии ибо нужно возвращать как-то nil значение для удаления

    entity:SetNetVar("ev_id", idx)

    return "Улика №" .. tostring(idx) .. " была успешно присвоина " .. tostring(entity) .. "."
end

local function reg(data)
    return PLUGIN:RegisterNewEvidence({
        name = data.name or "Неизвестно",
        description = data.description or "Неизвестно",
        color = data.color or Color(255, 255, 255),
        alpha = data.alpha or 255,
        image = tonumber(data.image) and math.floor(data.image) or 1,
        ribbon = tonumber(data.image) and math.floor(data.ribbon) or 1
    })
end

function PLUGIN:LeftClick(data)
    if !data then return end

    local idx = reg(data)
    if !idx then return end

    local entity = ents.Create("arb_evidence")
    entity:SetPos(data.position)
    entity:SetAngles(data.angles)
    entity:Spawn()

    return entity:SetEvidence(idx)
end

function PLUGIN:RightClick(data)
    if !data then return end
    if !IsValid(data.entity) then return end

    local e_idx = data.entity:GetEvidence()
    if e_idx then return end

    local idx = reg(data)
    if !idx then return end

    return data.entity:SetEvidence(idx)
end

function PLUGIN:Reload(data)
    if !data then return end
    if !IsValid(data.entity) then return end

    local idx = data.entity:GetEvidence()

    if idx then
        local name = tostring(data.entity)

        data.entity:SetEvidence(nil)

        if data.entity:GetClass() == "arb_evidence" then
            data.entity:Remove()
        end

        for k, v in ipairs(player.GetAll()) do
            if !v:HasEvidence(idx) then continue end

            v:DeleteEvidence(idx)
        end

        self:DeleteEvidence(idx)

        return "Вы успешно удалили улику №" .. idx .. " с " .. name .. "."
    end
end

function PLUGIN:DeleteEvidence(idx)
    self.list[idx] = nil
    netstream.Start(nil, "evidence.Register", idx, nil)
end




local ENTITY = FindMetaTable("Entity")

function ENTITY:SetEvidence(idx)
    return PLUGIN:SetEntityEvidence(self, idx)
end


local PLAYER = FindMetaTable("Player")

function PLAYER:AddEvidence(idx)
    if !PLUGIN:GetEvidence(idx) then return "Ошибка при выдаче улики игроку!" end

    local data = self:GetNetVar("ev_list", {})

    data[idx] = true

    self:SetNetVar("ev_list", data)

    return "Улика с ID №" .. tostring(idx) .. " была успешно выдана игроку " .. tostring(self) .. "."
end

function PLAYER:DeleteEvidence(idx)
    local data = self:GetNetVar("ev_list", {})

    data[idx] = nil

    self:SetNetVar("ev_list", data)

    return "Улика с ID №" .. tostring(idx) .. " была успешно удалена у игрока " .. tostring(self) .. "."
end





function PLUGIN:EntityRemoved(entity)
    local idx = entity:GetEvidence()

    if idx then
        entity:SetEvidence(nil)
        self:DeleteEvidence(idx)

        for k, v in ipairs(player.GetAll()) do
            if !v:HasEvidence(idx) then continue end

            v:DeleteEvidence(idx)
        end
    end
end

function PLUGIN:PlayerUse(client, entity)
    local idx = entity:GetEvidence()
    if !idx then return end

    if entity:IsPlayer() then return end

    if !client.evidenceCD or CurTime() >= client.evidenceCD then
        if !client:HasEvidence(idx) then
            Arbitrage.action.ActionRun(client, "Собираем улику", 1, function()
                if client:GetPos():Distance(entity:GetPos()) >= 200 then return true end

                return false
            end, function(activator)
                netstream.Start(client, "arb.Notify", "Ваш журнал улик обновлён.", false)

                local evidence = self:GetEvidence(idx)
                netstream.Start(client, "Evidence:Draw", entity, evidence)

                client:AddEvidence(idx)
            end)
        else
            netstream.Start(client, "arb.Notify", "Вы уже нашли эту улику!", true)
        end

        client.evidenceCD = CurTime() + 2
    end
end

function PLUGIN:PlayerInitialSpawn(client)
    for k, v in pairs(self.list) do
        netstream.Start(client, "evidence.Register", k, v)
    end
end


netstream.Hook("Evidence:SetDescription", function(client, data)
    client.EvidenceDescription = data or "Описание улики"
end)