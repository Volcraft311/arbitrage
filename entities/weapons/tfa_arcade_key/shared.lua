AddCSLuaFile()

if CLIENT then
    SWEP.Slot = 1
    SWEP.SlotPos = 1
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false
end

SWEP.PrintName = "Ключи"
SWEP.Author = "Selenter"
SWEP.Instructions = "Левая клик - Закрыть дверь\nПравый клик - Открыть дверь"
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.WorldModel = ""
SWEP.ViewModel = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "Asterion: Arbitrage"

SWEP.Primary.Delay = 0.3
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.Delay = 0.3
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

local soundList = {"knocking.wav", "loud_knocking.wav"}

function SWEP:SecondaryAttack()
    if CLIENT then return end

    local client = self:GetOwner()
    local trace = client:GetEyeTraceNoCursor()
    local door = trace.Entity

    if IsValid(door) and (door:GetClass() == "prop_door_rotating" or door:GetClass() == "func_door_rotating") and (!client.doorSpam or CurTime() >= client.doorSpam) and door:GetPos():Distance(client:GetPos()) <= 100 then

        local doorData
        for k, v in pairs(Arbitrage.plugin.list["doors"].DoorsData) do
            if v.indexDoor == door:EntIndex() then
                doorData = Arbitrage.plugin.list["doors"].DoorsData[k]
            end
        end

        local owned = false

        if doorData then
            local doorOwned = doorData.arbOwnerID[client:SteamID()]

            if doorOwned then
                Arbitrage.action.ActionRun(client, "Открываем дверь", 2, function()
                    if client:GetEyeTrace().Entity != door then return true end
                    if client:GetPos():Distance(door:GetPos()) >= 130 then return true end

                    if !client.keyAnim or CurTime() >= client.keyAnim then
                        netstream.Start(nil, "arb.PlayerSetAnim", client, GESTURE_SLOT_CUSTOM, ACT_GMOD_GESTURE_ITEM_PLACE, true)

                        client.keyAnim = CurTime() + 0.9
                    end

                    return false
                end, function(activator)
                    door:Fire("UnLock")
                    client:EmitSound("doors/door_latch3.wav")
                end)

                owned = true
            end
        end

        if !owned then
            local sound, _ = table.Random(soundList)
            client:EmitSound(sound)
        end

        client.doorSpam = CurTime() + 2
    end
end

function SWEP:PrimaryAttack()
    if CLIENT then return end

    local client = self:GetOwner()
    local trace = client:GetEyeTraceNoCursor()
    local door = trace.Entity

    if IsValid(door) and (door:GetClass() == "prop_door_rotating" or door:GetClass() == "func_door_rotating") and (!client.doorSpam or CurTime() >= client.doorSpam) and door:GetPos():Distance(client:GetPos()) <= 100 then
        local doorData
        for k, v in pairs(Arbitrage.plugin.list["doors"].DoorsData) do
            if v.indexDoor == door:EntIndex() then
                doorData = Arbitrage.plugin.list["doors"].DoorsData[k]
            end
        end

        local owned = false

        if doorData then
            local doorOwned = doorData.arbOwnerID[client:SteamID()]

            if doorOwned then
                Arbitrage.action.ActionRun(client, "Закрываем дверь", 2, function()
                    if client:GetEyeTrace().Entity != door then return true end
                    if client:GetPos():Distance(door:GetPos()) >= 130 then return true end

                    if !client.keyAnim or CurTime() >= client.keyAnim then
                        netstream.Start(nil, "arb.PlayerSetAnim", client, GESTURE_SLOT_CUSTOM, ACT_GMOD_GESTURE_ITEM_PLACE, true)

                        client.keyAnim = CurTime() + 0.9
                    end

                    return false
                end, function(activator)
                    door:Fire("Lock")
                    client:EmitSound("doors/door_latch3.wav")
                end)

                owned = true
            end
        end

        if !owned then
            local sound, _ = table.Random(soundList)
            client:EmitSound(sound)
        end

        client.doorSpam = CurTime() + 2
    end
end

function SWEP:Initialize()
    self:SetHoldType("normal")
end