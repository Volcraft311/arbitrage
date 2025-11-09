--[[
        © AsterionStaff 2023.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

local PLUGIN = PLUGIN

local KnockViewPunchAngle = Angle(-1.3, 1.8, 0)

netstream.Hook("RadialMenu:StandUp", function(client)
    if client:IsSpectate() then return end

    local entity, ragdollClient = PLUGIN:ReturnTracePlayer(client)
    if !IsValid(ragdollClient) then return end

    local delay = ragdollClient.fallOverDelay == nil and 10 or (ragdollClient.fallOverDelay <= -1 and 60 or ragdollClient.fallOverDelay)
    local name = ragdollClient:Name()

    local bSequenceAction = false
    local eyePosZ = Arbitrage.player.GetEyesPos(client)
    eyePosZ = eyePosZ + client:GetPos().z
    local itemPosZ = entity:GetPos().z

    local dist = eyePosZ - itemPosZ
    if dist > 30 and client:IsOnGround() then
        bSequenceAction = true

        if client:LookupSequence("checkmalepost") > -1 then
            client:SetAction("checkmalepost", -1, true)
        else
            bSequenceAction = false
        end
    end

    TypingDraw:SendSphere(0.5, client, "#typingdraw_raises '" .. name .. "'", Color(255, 170, 23))

    Arbitrage.action.ActionRun(client, "#action_we_raise", delay, function()
        if !IsValid(entity) then return end

        if bSequenceAction then
            if entity:GetPos():DistToSqr(client:GetPos()) > 12000 then client:ExitAction(true) return true end

            local seqName = client:GetAction()
            if !seqName then return true end
        else
            if PLUGIN:ReturnTracePlayer(client) != entity then return true end
        end

        return false
    end, function(activator)
        client:ExitAction(true)
        ragdollClient:StandUp()

        TypingDraw:SendSphere(0.5, client, "#typingdraw_raises '" .. name .. "'", Color(255, 170, 23))
    end)
end)

netstream.Hook("RadialMenu:PushAction", function(client)
    if client:IsSpectate() then return end

    local target = PLUGIN:ReturnTracePlayer(client)
    if !IsValid(target) then return end
    if client:GetPos():Distance(target:GetPos()) > 150 then return end

    if (!client.PushActionCD or CurTime() >= client.PushActionCD) then
        local direction = client:GetAimVector() * 150
        direction.z = 0

        target:SetVelocity(direction)
        client:EmitSound("Weapon_Crossbow.BoltHitBody")

        client:PlaySequence("new_push")

        client:ViewPunch(KnockViewPunchAngle)
        target:ViewPunch(KnockViewPunchAngle)

        TypingDraw:SendSphere(0.5, client, "#typingdraw_pushes '" .. target:Name() .. "'", Color(255, 170, 23))

        client.PushActionCD = CurTime() + 1
    end
end)

netstream.Hook("RadialMenu:SearchAction", function(client)
    if client:IsSpectate() then return end

    local entity, ragdollClient = PLUGIN:ReturnTracePlayer(client)
    if !IsValid(entity) then return end
    if client:GetPos():Distance(entity:GetPos()) > 150 then return end

    local name = IsValid(ragdollClient) and ragdollClient:Name() or entity:Name()

    local bSequenceAction = false
    local eyePosZ = Arbitrage.player.GetEyesPos(client)
    eyePosZ = eyePosZ + client:GetPos().z
    local itemPosZ = entity:GetPos().z

    local dist = eyePosZ - itemPosZ
    if dist > 30 and client:IsOnGround() and IsValid(ragdollClient) then
        bSequenceAction = true

        if client:LookupSequence("d1_town05_Jacobs_Heal") > -1 then
            client:SetAction("d1_town05_Jacobs_Heal", -1, true)
        elseif client:LookupSequence("d1_town05_Daniels_Kneel_Idle") > -1 then
            client:SetAction("d1_town05_Daniels_Kneel_Idle", -1, true)
        else
            bSequenceAction = false
        end
    end

    TypingDraw:SendSphere(0.5, client, "#typingdraw_searches '" .. name .. "'", Color(255, 170, 23))

    Arbitrage.action.ActionRun(client, "#action_searching", IsValid(ragdollClient) and 23 or 15, function()
        if !IsValid(entity) then return end

        if bSequenceAction then
            if entity:GetPos():DistToSqr(client:GetPos()) > 12000 then client:ExitAction(true) return true end

            local seqName = client:GetAction()
            if !seqName then return true end
        else
            if PLUGIN:ReturnTracePlayer(client) != entity then return true end

            if (!client.RMSearch or CurTime() >= client.RMSearch) then
                client:PlayGesture(ACT_GMOD_GESTURE_ITEM_PLACE)
                client.RMSearch = CurTime() + 1.5
            end
        end

        return false
    end, function(activator)
        local inventory = IsValid(ragdollClient) and ragdollClient:GetInventory() or entity:GetInventory()
        local inventoryID = inventory:GetID()

        InventoryBase.Open(client, inventoryID, name)
        if bSequenceAction then
            hook.Add("InventoryBase:StopReceiving", "SearchStopSequence_" .. client:SteamID(), function(_client, invID)
                if _client == client and inventoryID == invID then
                    client:ExitAction(true)
                    hook.Remove("InventoryBase:StopReceiving", "SearchStopSequence_" .. client:SteamID())
                end
            end)
        end

        TypingDraw:SendSphere(0.5, client, "#typingdraw_examines '" .. name .. "'", Color(255, 170, 23))
    end)
end)

netstream.Hook("RadialMenu:ExchangeAction", function(client)
    if client:IsSpectate() then return end

    local target = PLUGIN:ReturnTracePlayer(client)
    if !IsValid(target) then return end

    if client:GetPos():Distance(target:GetPos()) > 150 then return end
    if client.bIsAnim then return end
    if target.bIsAnim then return end

    if target.ignorePlayersTrade then
        local data = target.ignorePlayersTrade[client]

        if data then
            local delay = data.delay
            local time = CurTime()

            if delay > time then
                return client:ChatNotify(("Данный игрок уже отказал вам в данном действие. Повторите попытку через %s секунд!"):format(math.floor(delay - time)))
            end
        end
    end

    local clientName = client:Name()
    local targetName = target:Name()

    client:ChatNotify(L(client, "#notify_you_offered_exchange", targetName))

    Arbitrage.doing.Send(target, {
        entity = client,
        title = clientName .. " предлагает вам обмен",
        description = "Данный пользователь предлагает вам обменяться предметами. Хотите принять его? Сделайте выбор в меню, чтобы продолжить.",
        icon = "danganronpa/radialmenu/exchange.png",
        actions = {
            yes = {
                name = "Да",
                func = function()
                    if !IsValid(client) then return end
                    if !IsValid(target) then return end

                    if client:GetPos():Distance(target:GetPos()) > 150 then return end
                    if client.bIsAnim then return end
                    if target.bIsAnim then return end

                    target.ignorePlayersTrade = target.ignorePlayersTrade or {}
                    target.ignorePlayersTrade[client] = {count = 0, delay = 0}

                    client.ignorePlayersTrade = client.ignorePlayersTrade or {}
                    client.ignorePlayersTrade[target] = {count = 0, delay = 0}

                    client.bIsAnim = true
                    target.bIsAnim = true

                    local inventory = InventoryBase.CreateInventory(4, 4)
                    InventoryBase.Open(client, inventory:GetID(), "#exchange_with " .. targetName)
                    InventoryBase.Open(target, inventory:GetID(), "#exchange_with " .. clientName)

                    local uniqueID = "RadialMenu:Exchange_" .. util.SHA1(clientName .. targetName)
                    hook.Add("InventoryBase:StopReceiving", uniqueID, function(caller, invID)
                        if caller != client and caller != target and invID != inventory:GetID() then return end

                        hook.Remove("InventoryBase:StopReceiving", uniqueID)

                        local tr = util.TraceLine({
                            start = caller:EyePos(),
                            endpos = caller:EyePos() + caller:EyeAngles():Forward() * 100,
                            filter = caller
                        })

                        for _, item in ipairs(inventory:GetItems()) do
                            item:Remove(true, true)
                            item:Spawn(tr.HitPos + Vector(0, 0, 5))
                        end

                        local code = [[if IsValid(Arbitrage.gui.inventory) then Arbitrage.gui.inventory:Remove() end]]
                        if IsValid(client) then inventory.receivers[client] = nil client:SendLua(code) end
                        if IsValid(target) then inventory.receivers[target] = nil target:SendLua(code) end

                        client.bIsAnim = nil
                        target.bIsAnim = nil
                    end)
                end
            },
            no = {
                name = "Нет",
                func = function()
                    if !IsValid(client) then return end
                    if !IsValid(target) then return end

                    target.ignorePlayersTrade = target.ignorePlayersTrade or {}
                    target.ignorePlayersTrade[client] = target.ignorePlayersTrade[client] or {
                        count = 0,
                        delay = 0
                    }

                    target.ignorePlayersTrade[client].count = target.ignorePlayersTrade[client].count + 1
                    target.ignorePlayersTrade[client].delay = CurTime() + (target.ignorePlayersTrade[client].count * 60)
                end
            }
        }
    })
end)

netstream.Hook("RadialMenu:DragPlayerAction", function(client)
    if client:IsSpectate() then return end

    local target = PLUGIN:ReturnTracePlayer(client)
    if !IsValid(target) then return end
    if client:GetPos():Distance(target:GetPos()) > 150 then return end

    local uniqueID = "RadialMenu:DragPlayer_" .. client:SteamID()
    local function remove()
        if IsValid(client) then
            client.bDragPlayer = nil
        end

        hook.Remove("Think", uniqueID)
    end

    if hook.GetTable().Think[uniqueID] then
        return remove()
    end

    TypingDraw:SendSphere(0.5, client, "#typingdraw_pulls_along '" .. target:Name() .. "'", Color(255, 170, 23))

    client.bDragPlayer = true

    hook.Add("Think", uniqueID, function()
        if !IsValid(client) then return remove() end
        if !IsValid(target) then return remove() end

        local pullerPos = client:GetPos()
        local targetPos = target:GetPos()
        local dist = pullerPos:DistToSqr(targetPos)

        if dist >= 13000 then
            return remove()
        else
            if dist > 1500 then
                local pullDirection = (pullerPos - targetPos):GetNormalized()
                local scale = 10 -- scale зависит очень сильно от тикрейта сервера потому что обрабатывается в Think. На академии тикрейт 32

                target:SetVelocity(pullDirection * scale)
            end
        end
    end)
end)

local function CalculateKissPositions(entity1, entity2, targetDistance, backwardOffset)
    targetDistance = targetDistance or 35
    backwardOffset = backwardOffset or 10

    local pos1 = entity1:GetPos()
    local pos2 = entity2:GetPos()

    local directionToTarget = (pos2 - pos1):GetNormalized()

    local directionToSource = (pos1 - pos2):GetNormalized()

    local middlePoint = (pos1 + pos2) / 2

    local newPos1 = middlePoint - directionToTarget * (targetDistance / 2)
    local newPos2 = middlePoint + directionToTarget * (targetDistance / 2)

    newPos1 = newPos1 - directionToTarget * backwardOffset
    newPos2 = newPos2 - directionToSource * backwardOffset

    return newPos1, newPos2
end

local function CalculateKissAngles(entity1, entity2)
    local pos1 = entity1:GetPos()
    local pos2 = entity2:GetPos()

    local angles1 = (pos2 - pos1):Angle()

    local angles2 = (pos1 - pos2):Angle()

    return angles1, angles2
end

local function FindKissAnimation(client)
    local seqID = client:LookupSequence("f_kiss")
    if seqID > 0 then
        return "f_kiss"
    end

    return "m_kiss"
end

netstream.Hook("RadialMenu:KissPlayerAction", function(client)
    if client:IsSpectate() then return end

    local target = PLUGIN:ReturnTracePlayer(client)
    if !IsValid(target) then return end

    if client:GetPos():Distance(target:GetPos()) > 150 then return end
    if client.bIsAnim then return end
    if target.bIsAnim then return end

    if target.ignorePlayersKiss then
        local data = target.ignorePlayersKiss[client]

        if data then
            local delay = data.delay
            local time = CurTime()

            if delay > time then
                return client:ChatNotify(("Данный игрок уже отказал вам в данном действие. Повторите попытку через %s секунд!"):format(math.floor(delay - time)))
            end
        end
    end

    local clientName = client:Name()
    local targetName = target:Name()

    client:ChatNotify(("Вы предложили поцелуй %s."):format(targetName))

    Arbitrage.doing.Send(target, {
        entity = client,
        title = clientName .. " хочет с вами поцеловаться",
        description = "Данный пользователь предлагает вам совместный поцелуй. Хотите принять его? Сделайте выбор в меню, чтобы продолжить.",
        icon = "asterion/academy/ui/radial/action/kiss.png",
        actions = {
            yes = {
                name = "Да",
                func = function()
                    if !IsValid(client) then return end
                    if !IsValid(target) then return end

                    if client:GetPos():Distance(target:GetPos()) > 150 then return end
                    if client.bIsAnim then return end
                    if target.bIsAnim then return end

                    target.ignorePlayersKiss = target.ignorePlayersKiss or {}
                    target.ignorePlayersKiss[client] = {count = 0, delay = 0}

                    client.ignorePlayersKiss = client.ignorePlayersKiss or {}
                    client.ignorePlayersKiss[target] = {count = 0, delay = 0}

                    client.bIsAnim = true
                    target.bIsAnim = true

                    TypingDraw:SendSphere(0.5, client, "Поцеловал(а) '" .. targetName .. "'", Color(255, 170, 23))
                    TypingDraw:SendSphere(0.5, target, "Поцеловал(а) '" .. clientName .. "'", Color(255, 170, 23))

                    local min1, max1 = client:GetHull()
                    local min2, max2 = target:GetHull()

                    client:SetHull(Vector(-4, -4, 0), Vector(4, 4, max1.z), true)
                    target:SetHull(Vector(-4, -4, 0), Vector(4, 4, max2.z), true)

                    local oldVector1, oldVector2 = client:GetPos(), target:GetPos()
                    local vector1, vector2 = CalculateKissPositions(client, target, 35 * 0.32, 10 * 0.32)
                    client:SetPos(vector1)
                    target:SetPos(vector2)

                    timer.Simple(0.1, function()
                        local angle1, angle2 = CalculateKissAngles(client, target)

                        client:SetEyeAngles(angle1)
                        target:SetEyeAngles(angle2)

                        client:SetRenderAngles(angle1)
                        target:SetRenderAngles(angle2)

                        timer.Simple(0.2, function()
                            client:SetAction(FindKissAnimation(client), 2.5, true, function()
                                client:ExitAction(true)
                            end)

                            target:SetAction(FindKissAnimation(target), 2.5, true, function()
                                target:ExitAction(true)
                            end)

                            timer.Simple(2.5, function()
                                client:SetPos(oldVector1)
                                client:SetHull(min1, max1, true)

                                client.bIsAnim = nil

                                target:SetPos(oldVector2)
                                target:SetHull(min2, max2, true)

                                target.bIsAnim = nil
                            end)
                        end)
                    end)
                end
            },
            no = {
                name = "Нет",
                func = function()
                    if !IsValid(client) then return end
                    if !IsValid(target) then return end

                    target.ignorePlayersKiss = target.ignorePlayersKiss or {}
                    target.ignorePlayersKiss[client] = target.ignorePlayersKiss[client] or {
                        count = 0,
                        delay = 0
                    }

                    target.ignorePlayersKiss[client].count = target.ignorePlayersKiss[client].count + 1
                    target.ignorePlayersKiss[client].delay = CurTime() + (target.ignorePlayersKiss[client].count * 60)
                end
            }
        }
    })
end)

local function FindHugAnimation(client)
    local seqID = client:LookupSequence("f_hug_female")
    if seqID > 0 then
        return "f_hug_female"
    end

    return "male_hug_female"
end

netstream.Hook("RadialMenu:HugPlayerAction", function(client)
    if client:IsSpectate() then return end

    local target = PLUGIN:ReturnTracePlayer(client)
    if !IsValid(target) then return end

    if client:GetPos():Distance(target:GetPos()) > 150 then return end
    if client.bIsAnim then return end
    if target.bIsAnim then return end

    if target.ignorePlayersHug then
        local data = target.ignorePlayersHug[client]

        if data then
            local delay = data.delay
            local time = CurTime()

            if delay > time then
                return client:ChatNotify(("Данный игрок уже отказал вам в данном действие. Повторите попытку через %s секунд!"):format(math.floor(delay - time)))
            end
        end
    end

    local clientName = client:Name()
    local targetName = target:Name()

    client:ChatNotify(("Вы предложили обняться %s."):format(targetName))

    Arbitrage.doing.Send(target, {
        entity = client,
        title = clientName .. " хочет с вами обняться",
        description = "Данный пользователь предлагает вам совместное обнимание. Хотите принять его? Сделайте выбор в меню, чтобы продолжить.",
        icon = "asterion/academy/ui/radial/action/hug.png",
        actions = {
            yes = {
                name = "Да",
                func = function()
                    if !IsValid(client) then return end
                    if !IsValid(target) then return end

                    if client:GetPos():Distance(target:GetPos()) > 150 then return end
                    if client.bIsAnim then return end
                    if target.bIsAnim then return end

                    target.ignorePlayersHug = target.ignorePlayersHug or {}
                    target.ignorePlayersHug[client] = {count = 0, delay = 0}

                    client.ignorePlayersHug = client.ignorePlayersHug or {}
                    client.ignorePlayersHug[target] = {count = 0, delay = 0}

                    client.bIsAnim = true
                    target.bIsAnim = true

                    TypingDraw:SendSphere(0.5, client, "Обнял(а) '" .. targetName .. "'", Color(255, 170, 23))
                    TypingDraw:SendSphere(0.5, target, "Обнял(а) '" .. clientName .. "'", Color(255, 170, 23))

                    local min1, max1 = client:GetHull()
                    local min2, max2 = target:GetHull()

                    client:SetHull(Vector(-4, -4, 0), Vector(4, 4, max1.z), true)
                    target:SetHull(Vector(-4, -4, 0), Vector(4, 4, max2.z), true)

                    local oldVector1, oldVector2 = client:GetPos(), target:GetPos()
                    local vector1, vector2 = CalculateKissPositions(client, target, 35 * 0.135, 10 * 0.135)
                    client:SetPos(vector1)
                    target:SetPos(vector2)

                    timer.Simple(0.1, function()
                        local angle1, angle2 = CalculateKissAngles(client, target)

                        client:SetEyeAngles(angle1)
                        target:SetEyeAngles(angle2)

                        client:SetRenderAngles(angle1)
                        target:SetRenderAngles(angle2)

                        timer.Simple(0.2, function()
                            client:SetAction(FindHugAnimation(client), 7, true, function()
                                client:ExitAction(true)
                            end)

                            target:SetAction(FindHugAnimation(target), 7, true, function()
                                target:ExitAction(true)
                            end)

                            timer.Simple(7, function()
                                client:SetPos(oldVector1)
                                client:SetHull(min1, max1, true)

                                client.bIsAnim = nil

                                target:SetPos(oldVector2)
                                target:SetHull(min2, max2, true)

                                target.bIsAnim = nil
                            end)
                        end)
                    end)
                end
            },
            no = {
                name = "Нет",
                func = function()
                    if !IsValid(client) then return end
                    if !IsValid(target) then return end

                    target.ignorePlayersHug = target.ignorePlayersHug or {}
                    target.ignorePlayersHug[client] = target.ignorePlayersHug[client] or {
                        count = 0,
                        delay = 0
                    }

                    target.ignorePlayersHug[client].count = target.ignorePlayersHug[client].count + 1
                    target.ignorePlayersHug[client].delay = CurTime() + (target.ignorePlayersHug[client].count * 60)
                end
            }
        }
    })
end)