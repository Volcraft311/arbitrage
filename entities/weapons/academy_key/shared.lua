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

local function DoorAction(client, door, bClose)
    Arbitrage.action.ActionRun(client, bClose and "Закрываем дверь" or "Открываем дверь", 2, function()
        if client:GetEyeTrace().Entity != door then return true end
        if client:GetPos():Distance(door:GetPos()) >= 130 then return true end

        if !client.keyAnim or CurTime() >= client.keyAnim then
            netstream.Start(nil, "arb.PlayerSetAnim", client, GESTURE_SLOT_CUSTOM, ACT_GMOD_GESTURE_ITEM_PLACE, true)

            client.keyAnim = CurTime() + 2.1
        end

        return false
    end, function(activator)
        door:Fire(bClose and "Lock" or "UnLock")
        client:EmitSound("doors/door_latch3.wav")
        door:SetNWBool("Locked", bClose)
    end)
end

local function FindDoorData(door)
    local idx = door:EntIndex()
    local data = Arbitrage.plugin.list["doors"].DoorsData

    for k, v in pairs(data) do
        if v.idx == idx then
            return data[k]
        end
    end
end

local function FindKey(client, doorData)
    doorData = doorData or {}

    local data = doorData.list or {}

    local inventory = client:GetInventory()
    if !inventory then return false end

    local keys = {}
    local items = inventory:GetItems()

    for k, v in pairs(items) do
        local id = v:GetData("faction")

        if v.uniqueID == "keys_all" then
            return true
        end

        if v.uniqueID == "keys" and id then
            keys[id] = true
        end
    end

    for idKey in pairs(keys) do
        for idDoor in pairs(data) do
            if idKey == idDoor then
                return true
            end
        end
    end

    return false
end

function SWEP:SecondaryAttack()
    if CLIENT then return end

    local client = self:GetOwner()
    local trace = client:GetEyeTraceNoCursor()

    local door = trace.Entity
    if !IsValid(door) then return end

    if door:GetPos():Distance(client:GetPos()) > 100 then return end

    local class = door:GetClass()
    if class != "prop_door_rotating" and class != "func_door_rotating" then return end

    if (!client.doorSpam or CurTime() >= client.doorSpam) then
        local doorData = FindDoorData(door)
        local bHaveKeys = FindKey(client, doorData)

        if bHaveKeys then
            if !door:GetNWBool("Locked") then return Arbitrage.commands.Notify(client, "Данная дверь уже открыта!") end

            DoorAction(client, door, false)
        else
            local s, _ = table.Random(soundList)
            client:EmitSound(s)
        end

        client.doorSpam = CurTime() + 2
    end
end

function SWEP:PrimaryAttack()
    if CLIENT then return end

    local client = self:GetOwner()
    local trace = client:GetEyeTraceNoCursor()

    local door = trace.Entity
    if !IsValid(door) then return end

    if door:GetPos():Distance(client:GetPos()) > 100 then return end

    local class = door:GetClass()
    if class != "prop_door_rotating" and class != "func_door_rotating" then return end

    if (!client.doorSpam or CurTime() >= client.doorSpam) then
        local doorData = FindDoorData(door)
        local bHaveKeys = FindKey(client, doorData)

        if bHaveKeys then
            if door:GetNWBool("Locked") then return Arbitrage.commands.Notify(client, "Данная дверь уже закрыта!") end

            DoorAction(client, door, true)
        else
            local s, _ = table.Random(soundList)
            client:EmitSound(s)
        end

        client.doorSpam = CurTime() + 2
    end
end

function SWEP:Initialize()
    self:SetHoldType("normal")
end