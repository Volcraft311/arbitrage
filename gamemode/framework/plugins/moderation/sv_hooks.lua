--[[
        © AsterionStaff 2024.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


Moderation:AddLog("spawnProp", {
    name = "Создание пропа",
    color = 1752220,
    format = function(client, entity, model)
        return ("%s создал %s %s"):format(
            Moderation:HighlightPlayer(client),
            Moderation:HighlightPrimary(entity),
            Moderation:HighlightPrimary(model)
        )
    end
})

function Moderation:PlayerSpawnedProp(client, model, entity)
    self:SendLog(client, "spawnProp", entity, model)
end

Moderation.PlayerSpawnedEffect = Moderation.PlayerSpawnedProp
Moderation.PlayerSpawnedRagdoll = Moderation.PlayerSpawnedProp

Moderation:AddLog("spawnEntity", {
    name = "Создание энтити",
    color = 1146986,
    format = function(client, entity)
        return ("%s создал %s"):format(
            Moderation:HighlightPlayer(client),
            Moderation:HighlightPrimary(entity)
        )
    end
})

function Moderation:PlayerSpawnedNPC(client, entity)
    self:SendLog(client, "spawnEntity", entity)
end

Moderation.PlayerSpawnedSWEP = Moderation.PlayerSpawnedNPC
Moderation.PlayerSpawnedSENT = Moderation.PlayerSpawnedNPC
Moderation.PlayerSpawnedVehicle = Moderation.PlayerSpawnedNPC

Moderation:AddLog("initPlayer", {
    name = "Подключение к серверу",
    color = 5763719,
    format = function(client)
        return ("%s подключился"):format(
            Moderation:HighlightPlayer(client)
        )
    end
})

function Moderation:PlayerInitialSpawn(client)
    self:SendLog(client, "initPlayer")
end

Moderation:AddLog("disconnectPlayer", {
    name = "Отключение от сервера",
    color = 15548997,
    format = function(client)
        return ("%s отключился"):format(
            Moderation:HighlightPlayer(client)
        )
    end
})

function Moderation:PlayerDisconnected(client)
    self:SendLog(client, "disconnectPlayer")
end

Moderation:AddLog("itemDestroy", {
    name = "Уничтожение предмета",
    color = 10038562,
    format = function(client, item)
        return ("%s уничтожил предмет %s"):format(
            client:IsPlayer() and Moderation:HighlightPlayer(client) or Moderation:HighlightPrimary(client),
            Moderation:HighlightPrimary(("%s[%s]"):format(item:GetName(), item:GetID()))
        )
    end
})

hook("OnItemDestroy", function(client, item)
    if IsValid(client) and client:IsPlayer() then
        Moderation:SendLog(client, "itemDestroy", item)
    end
end)

Moderation:AddLog("itemDrop", {
    name = "Выбрасывание предмета",
    color = 2123412,
    format = function(client, item)
        return ("%s выбросил предмет %s"):format(
            Moderation:HighlightPlayer(client),
            Moderation:HighlightPrimary(("%s[%s]"):format(item:GetName(), item:GetID()))
        )
    end
})

hook("OnItemDrop", function(client, item)
    Moderation:SendLog(client, "itemDrop", item)
end)

Moderation:AddLog("itemGave", {
    name = "Отдавание предмета",
    color = 2123412,
    format = function(client, item, target)
        return ("%s отдал предмет %s %s"):format(
            client:IsPlayer() and Moderation:HighlightPlayer(client) or Moderation:HighlightPrimary(client),
            Moderation:HighlightPrimary(("%s[%s]"):format(item:GetName(), item:GetID())),
            target:IsPlayer() and Moderation:HighlightPlayer(target) or Moderation:HighlightPrimary(target)
        )
    end
})

Moderation:AddLog("itemTook", {
    name = "Забирание предмета",
    color = 2123412,
    format = function(client, item, target)
        return ("%s забрал предмет %s у %s"):format(
            client:IsPlayer() and Moderation:HighlightPlayer(client) or Moderation:HighlightPrimary(client),
            Moderation:HighlightPrimary(("%s[%s]"):format(item:GetName(), item:GetID())),
            target:IsPlayer() and Moderation:HighlightPlayer(target) or Moderation:HighlightPrimary(target)
        )
    end
})

Moderation:AddLog("itemTake", {
    name = "Поднятие предмета",
    color = 3447003,
    format = function(client, item, target)
        return ("%s поднял предмет %s"):format(
            Moderation:HighlightPlayer(client),
            Moderation:HighlightPrimary(("%s[%s]"):format(item:GetName(), item:GetID()))
        )
    end
})

hook("OnItemTransfer", function(client, item, inventory)
    local inventoryOwner = inventory:GetOwner()

    if client == nil then -- поднятие предмета
        if IsValid(inventoryOwner) and inventoryOwner:IsPlayer() then
            client = inventoryOwner

            Moderation:SendLog(client, "itemTake", item)
        end
    elseif IsValid(client) then -- передача предмета
        if client:IsPlayer() then -- отдал
            Moderation:SendLog(client, "itemGave", item, inventoryOwner)
        elseif inventoryOwner:IsPlayer() then -- забрал
            Moderation:SendLog(inventoryOwner, "itemTook", item, client)
        end
    end
end)

Moderation:AddLog("itemAction", {
    name = "Действие с предметом",
    color = 3447003,
    format = function(client, item, action)
        return ("%s выполнил действие %s с предметом %s"):format(
            Moderation:HighlightPlayer(client),
            Moderation:HighlightPrimary(action),
            Moderation:HighlightPrimary(("%s[%s]"):format(item:GetName(), item:GetID()))
        )
    end
})

hook("OnItemAction", function(client, item, action)
    Moderation:SendLog(client, "itemAction", item, action)
end)

Moderation:AddLog("runCommand", {
    name = "Запуск команды",
    color = 10181046,
    format = function(client, command, args)
        if args then
            local text = ""

            if istable(args) then
                for i = 1, #args do
                    text = text .. tostring(args[i])

                    if i != #args then
                        text = text .. "; "
                    end
                end
            else
                text = tostring(args)
            end

            if text:Trim() != "" then
                return ("%s запустил команду %s с %s"):format(
                    Moderation:HighlightPlayer(client),
                    Moderation:HighlightPrimary(command),
                    Moderation:HighlightPrimary(text)
                )
            end
        end

        return ("%s запустил команду %s"):format(
            Moderation:HighlightPlayer(client),
            Moderation:HighlightPrimary(command)
        )
    end
})

hook("OnCommandRun", function(client, command, args)
    Moderation:SendLog(client, "runCommand", command, args)
end)

Moderation:AddLog("chatSay", {
    name = "Сообщение в чате",
    color = 12370112,
    format = function(client, chatType, text)
        return ("%s написал в %s %s"):format(
            Moderation:HighlightPlayer(client),
            Moderation:HighlightPrimary(chatType),
            Moderation:HighlightPrimary(text)
        )
    end
})

hook("OnChatSay", function(client, chatType, text)
    Moderation:SendLog(client, "chatSay", chatType, text)
end)

Moderation:AddLog("obServerEnter", {
    name = "Вход в Noclip",
    color = 3426654,
    format = function(client)
        return ("%s зашел в Noclip"):format(
            Moderation:HighlightPlayer(client)
        )
    end
})

hook("OnObServerEnter", function(client)
    Moderation:SendLog(client, "obServerEnter")
end)

Moderation:AddLog("obServerExit", {
    name = "Выход из Noclip",
    color = 2899536,
    format = function(client)
        return ("%s вышел из Noclip"):format(
            Moderation:HighlightPlayer(client)
        )
    end
})

hook("OnObServerExit", function(client)
    Moderation:SendLog(client, "obServerExit")
end)

Moderation:AddLog("inventoryOpen", {
    name = "Открытие инвентаря",
    color = 15277667,
    format = function(client, inventory)
        local inventoryOwner = inventory:GetOwner()

        return ("%s открыл инвентарь %s"):format(
            Moderation:HighlightPlayer(client),
            IsValid(inventoryOwner) and (inventoryOwner:IsPlayer() and Moderation:HighlightPlayer(inventoryOwner) or Moderation:HighlightPrimary(inventoryOwner)) or Moderation:HighlightPrimary(inventory)
        )
    end
})

hook("OnInventoryOpen", function(client, inventory)
    Moderation:SendLog(client, "inventoryOpen", inventory)
end)

Moderation:AddLog("characterJoin", {
    name = "Заход за персонажа",
    color = 16776960,
    format = function(client, character)
        return ("%s зашел за персонажа %s"):format(
            Moderation:HighlightPlayer(client, true),
            Moderation:HighlightPrimary(("%s[%s]"):format(character:GetName(), character:GetID()))
        )
    end
})

hook("OnCharacterJoin", function(client, character)
    Moderation:SendLog(client, "characterJoin", character)
end)

Moderation:AddLog("bedEnter", {
    name = "Лег на кровать",
    color = 15105570,
    format = function(client, entity)
        return ("%s лег на кровать %s"):format(
            Moderation:HighlightPlayer(client),
            Moderation:HighlightPrimary(entity)
        )
    end
})

hook("OnBedEnter", function(client, entity)
    Moderation:SendLog(client, "bedEnter", entity)
end)

Moderation:AddLog("bedExit", {
    name = "Встал с кровати",
    color = 11027200,
    format = function(client)
        return ("%s встал с кровати"):format(
            Moderation:HighlightPlayer(client)
        )
    end
})

hook("OnBedExit", function(client)
    Moderation:SendLog(client, "bedExit")
end)

Moderation:AddLog("spectateEnter", {
    name = "Заход в Spectate",
    color = 3426654,
    format = function(client, target)
        if target then
            return ("%s зашел в Spectate за %s"):format(
                Moderation:HighlightPlayer(client),
                target:IsPlayer() and Moderation:HighlightPlayer(target) or Moderation:HighlightPrimary(target)
            )
        else
            return ("%s зашел в Spectate"):format(
                Moderation:HighlightPlayer(client)
            )
        end
    end
})

hook("OnSpectateEnter", function(client, target)
    Moderation:SendLog(client, "spectateEnter", target)
end)

Moderation:AddLog("spectateExit", {
    name = "Выход из Spectate",
    color = 2899536,
    format = function(client)
        return ("%s вышел из Spectate"):format(
            Moderation:HighlightPlayer(client)
        )
    end
})

hook("OnSpectateExit", function(client)
    Moderation:SendLog(client, "spectateExit")
end)

Moderation:AddLog("spectateSetPos", {
    name = "Телепорт через Spectate",
    color = 2899536,
    format = function(client)
        return ("%s телепортировался на позицию через Spectate"):format(
            Moderation:HighlightPlayer(client)
        )
    end
})

hook("OnSpectateTeleport", function(client, vector, angles)
    Moderation:SendLog(client, "spectateSetPos", vector, angles)
end)

Moderation:AddLog("playerDeath", {
    name = "Смерть игрока",
    color = 15548997,
    format = function(client, attacker, weapon)
        if weapon then
            return ("%s был убил %s при помощи %s"):format(
                Moderation:HighlightPlayer(client),
                IsValid(attacker) and (attacker:IsPlayer() and Moderation:HighlightPlayer(attacker) or Moderation:HighlightPrimary(attacker)) or Moderation:HighlightPrimary(attacker),
                Moderation:HighlightPrimary(weapon)
            )
        else
            return ("%s был убил %s"):format(
                Moderation:HighlightPlayer(client),
                IsValid(attacker) and (attacker:IsPlayer() and Moderation:HighlightPlayer(attacker) or Moderation:HighlightPrimary(attacker)) or Moderation:HighlightPrimary(attacker)
            )
        end
    end
})

function Moderation:PlayerDeath(client, inflictor, attacker)
    local attackerEntity = attacker
    local attackerWeapon = nil

    if IsValid(attacker) then
        if attacker:IsPlayer() then
            local weapon = attacker:GetActiveWeapon()
            if IsValid(weapon) then
                attackerWeapon = weapon.GetClass and weapon:GetClass() or weapon
            end
        else
            attackerEntity = attacker:GetName() != "" and attacker:GetName() or attacker:GetClass()
        end
    end

    self:SendLog(client, "playerDeath", attackerEntity, attackerWeapon)
end

Moderation:AddLog("playerHurt", {
    name = "Получение урона",
    color = 10038562,
    format = function(client, damage, attacker, weapon)
        if weapon then
            return ("%s получил %s урона от %s при помощи %s"):format(
                Moderation:HighlightPlayer(client),
                Moderation:HighlightPrimary(damage),
                IsValid(attacker) and (attacker:IsPlayer() and Moderation:HighlightPlayer(attacker) or Moderation:HighlightPrimary(attacker)) or Moderation:HighlightPrimary(attacker),
                Moderation:HighlightPrimary(weapon)
            )
        else
            return ("%s получил %s урона от %s"):format(
                Moderation:HighlightPlayer(client),
                Moderation:HighlightPrimary(damage),
                IsValid(attacker) and (attacker:IsPlayer() and Moderation:HighlightPlayer(attacker) or Moderation:HighlightPrimary(attacker)) or Moderation:HighlightPrimary(attacker)
            )
        end
    end
})

function Moderation:PlayerHurt(client, attacker, health, damage)
    local attackerEntity = attacker
    local attackerWeapon = nil

    if IsValid(attacker) then
        if attacker:IsPlayer() then
            local weapon = attacker:GetActiveWeapon()
            if IsValid(weapon) then
                attackerWeapon = weapon.GetClass and weapon:GetClass() or weapon
            end
        else
            attackerEntity = attacker:GetName() != "" and attacker:GetName() or attacker:GetClass()
        end
    end

    self:SendLog(client, "playerHurt", math.floor(damage), attackerEntity, attackerWeapon)
end