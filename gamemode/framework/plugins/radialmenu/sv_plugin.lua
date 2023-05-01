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

netstream.Hook("RadialMenu:PushAction", function(client)
    if client:IsSpectate() then return end

    local target = PLUGIN:ReturnTracePlayer(client)
    if !IsValid(target) then return end

    local direction = client:GetAimVector() * 150
    direction.z = 0

    target:SetVelocity(direction)
    client:EmitSound("Weapon_Crossbow.BoltHitBody")

    client:ViewPunch(KnockViewPunchAngle)
    target:ViewPunch(KnockViewPunchAngle)

    for k, v in pairs(ents.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 0.5)) do
        TypingDraw:SetTypingText(v, client, "Толкает '" .. target:Name() .. "'", Color(255, 170, 23))
    end
end)

netstream.Hook("RadialMenu:SearchAction", function(client)
    if client:IsSpectate() then return end

    local target = PLUGIN:ReturnTracePlayer(client)
    if !IsValid(target) then return end

    for k, v in pairs(ents.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 0.5)) do
        TypingDraw:SetTypingText(v, client, "Обыскивает '" .. target:Name() .. "'", Color(255, 170, 23))
    end

    Arbitrage.action.ActionRun(client, "Обыскиваем", 15, function()
        if PLUGIN:ReturnTracePlayer(client) != target then return true end

        if (!client.RMSearch or CurTime() >= client.RMSearch) then
            client:PlayAnimation(GESTURE_SLOT_CUSTOM, ACT_GMOD_GESTURE_ITEM_PLACE, true)
            client.RMSearch = CurTime() + 1.5
        end

        return false
    end, function(activator)
        local inventory = target:GetInventory()
        InventoryBase.Open(client, inventory:GetID(), target:Name())

        for k, v in pairs(ents.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 0.5)) do
            TypingDraw:SetTypingText(v, client, "Осматривает '" .. target:Name() .. "'", Color(255, 170, 23))
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
                    endpos = caller:EyePos() + caller:EyeAngles():Forward() * dist,
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