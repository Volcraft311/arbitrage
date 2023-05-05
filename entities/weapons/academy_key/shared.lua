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
SWEP.ViewModel = Model("models/weapons/c_arms.mdl")

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

local function DoorAction(client, door, bClose)
    client:PlayAnimation(GESTURE_SLOT_CUSTOM, ACT_GMOD_GESTURE_ITEM_PLACE, true)

    for k, v in pairs(ents.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 0.5)) do
        TypingDraw:SetTypingText(v, client, (bClose and "Закрывает" or "Открывает") .. " дверь", Color(255, 170, 23))
    end

    Arbitrage.action.ActionRun(client, bClose and "Закрываем дверь" or "Открываем дверь", 2, function()
        if client:GetEyeTrace().Entity != door then return true end
        if client:GetPos():Distance(door:GetPos()) >= 130 then return true end

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

local doorVar = "Locked"
local doorText = "Данная дверь уже"
function SWEP:InteractionDoor(bClose)
    if CLIENT then return end

    local client = self:GetOwner()
    local trace = client:GetEyeTraceNoCursor()

    local door = trace.Entity
    if !IsValid(door) then return end

    if door:GetPos():Distance(client:GetPos()) > 100 then return end
    if !door:IsDoor() then return end

    if (!client.doorSpam or CurTime() >= client.doorSpam) then
        client.doorSpam = CurTime() + 2

        local doorData = FindDoorData(door)

        local bHaveKeys = FindKey(client, doorData)
        if !bHaveKeys then return Arbitrage.commands.Notify(client, "У вас нету ключей от данной двери!") end

        if !bClose and !door:GetNWBool(doorVar) then
            return Arbitrage.commands.Notify(client, doorText .. " открыта!")
        end

        if bClose and door:GetNWBool(doorVar) then
            return Arbitrage.commands.Notify(client, doorText .. " закрыта!")
        end

        DoorAction(client, door, bClose)
    end
end

function SWEP:SecondaryAttack()
    self:InteractionDoor(false)
end

function SWEP:PrimaryAttack()
    self:InteractionDoor(true)
end

function SWEP:Initialize()
    self:SetHoldType("normal")
end