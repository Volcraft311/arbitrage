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

    for k, v in ipairs(ents.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 0.5)) do
        TypingDraw:SetTypingText(v, client, "Поднимает '" .. name .. "'", Color(255, 170, 23))
    end

    Arbitrage.action.ActionRun(client, "Поднимаем", delay, function()
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

        for k, v in ipairs(ents.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 0.5)) do
            TypingDraw:SetTypingText(v, client, "Поднимает '" .. name .. "'", Color(255, 170, 23))
        end
    end)
end)

netstream.Hook("RadialMenu:PushAction", function(client)
    if client:IsSpectate() then return end

    local target = PLUGIN:ReturnTracePlayer(client)
    if !IsValid(target) then return end

    if (!client.PushActionCD or CurTime() >= client.PushActionCD) then
        local direction = client:GetAimVector() * 150
        direction.z = 0

        target:SetVelocity(direction)
        client:EmitSound("Weapon_Crossbow.BoltHitBody")

        client:PlayGesture(ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND)
        client:ViewPunch(KnockViewPunchAngle)
        target:ViewPunch(KnockViewPunchAngle)

        local name = target:Name()

        for k, v in ipairs(ents.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 0.5)) do
            TypingDraw:SetTypingText(v, client, "Толкает '" .. name .. "'", Color(255, 170, 23))
        end

        client.PushActionCD = CurTime() + 1
    end
end)

netstream.Hook("RadialMenu:SearchAction", function(client)
    if client:IsSpectate() then return end

    local entity, ragdollClient = PLUGIN:ReturnTracePlayer(client)
    if !IsValid(entity) then return end

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

    for k, v in ipairs(ents.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 0.5)) do
        TypingDraw:SetTypingText(v, client, "Обыскивает '" .. name .. "'", Color(255, 170, 23))
    end

    Arbitrage.action.ActionRun(client, "Обыскиваем", IsValid(ragdollClient) and 23 or 15, function()
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

        for k, v in ipairs(ents.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 0.5)) do
            TypingDraw:SetTypingText(v, client, "Осматривает '" .. name .. "'", Color(255, 170, 23))
        end
    end)
end)

netstream.Hook("RadialMenu:ExchangeAction", function(client)
    if client:IsSpectate() then return end

    local target = PLUGIN:ReturnTracePlayer(client)
    if !IsValid(target) then return end

    local clientName, clientSteamID = client:Name(), client:SteamID()
    local targetName, targetSteamID = target:Name(), target:SteamID()

    client.ExchangeID = targetSteamID

    local uniqueID = "RadialMenu:Exchange_" .. util.SHA1(clientSteamID .. targetSteamID)
    if timer.Exists(uniqueID) then return end

    client:ChatNotify("Вы предложили обмен " .. targetName .. ".")
    target:ChatNotify(clientName .. " предложил вам обмен!")

    local function remove()
        hook.Remove("InventoryBase:StopReceiving", uniqueID)
        timer.Remove(uniqueID)

        if IsValid(client) then
            client.ExchangeID = nil
        end

        if IsValid(target) then
            target.ExchangeID = nil
        end
    end

    timer.Create(uniqueID, 0.5, 0, function()
        if !IsValid(client) then return remove() end
        if !IsValid(target) then return remove() end

        local dist = client:GetPos():DistToSqr(target:GetPos())
        if dist >= 10000 then client:ChatNotify("Предложение обмена было отменено! " .. targetName .. " находится слишком далеко.") return remove() end

        if client.ExchangeID == targetSteamID and target.ExchangeID == clientSteamID then
            remove()

            local inventory = InventoryBase.CreateInventory(4, 4)
            InventoryBase.Open(client, inventory:GetID(), "Обмен с " .. targetName)
            InventoryBase.Open(target, inventory:GetID(), "Обмен с " .. clientName)

            hook.Add("InventoryBase:StopReceiving", uniqueID, function(caller, invID)
                if caller != client and caller != target and invID != inventory:GetID() then return end
                remove()

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
            end)
        end
    end)
end)

netstream.Hook("RadialMenu:DragPlayerAction", function(client)
    if client:IsSpectate() then return end

    local target = PLUGIN:ReturnTracePlayer(client)
    if !IsValid(target) then return end

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

    for k, v in ipairs(ents.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 0.5)) do
        TypingDraw:SetTypingText(v, client, "Тянет за собой '" .. target:Name() .. "'", Color(255, 170, 23))
    end

    client.bDragPlayer = true

    hook.Add("Think", uniqueID, function()
        if !IsValid(client) then return remove() end
        if !IsValid(target) then return remove() end

        local pullerPos = client:GetPos()
        local targetPos = target:GetPos()
        local dist = pullerPos:DistToSqr(targetPos)

        if dist >= 15000 then
            return remove()
        else
            if dist > 1500 then
                local pullDirection = (pullerPos - targetPos):GetNormalized()

                target:SetVelocity(pullDirection * 9)
            end
        end
    end)
end)