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
MonoPad = PLUGIN

PLUGIN.name = "Monopad"
PLUGIN.class = "academy_monopad" -- class weapon

MonoPad.instances = MonoPad.instances or {}
MonoPad.stored = MonoPad.stored or {notes = {}}

MonoPad.sounds = {
    message_sent = "academy/monopad/message_sent.mp3",
    message_came = "academy/monopad/message_came.mp3",
    notification = "academy/monopad/notification.mp3",
    planshet_beep = "academy/monopad/planshet_beep.mp3"
}

MonoPad.chapterTypes = {
    [1] = {"Завершено", Color(11, 255, 108)},
    [2] = {"Активное расследование", Color(255, 176, 56)},
    [3] = {"Классный суд", Color(233, 66, 66)}
}

function MonoPad:New(id)
    if self.instances[id] then
        return self.instances[id]
    end

    local monopad = {id = id}
    setmetatable(monopad, table.Copy(Arbitrage.meta.monopad))

    self.instances[id] = monopad
    return monopad
end

function MonoPad:IsActive(client)
    local weapon = client:GetActiveWeapon()
    if IsValid(weapon) then
        local class = weapon:GetClass()

        return class == self.class
    end

    return false
end

function MonoPad:FindMonoPad(client)
    client = client or (CLIENT and LocalPlayer())

    local inventory = client:GetInventory()
    if !inventory then return end

    local items = inventory:GetItems()
    for _, item in ipairs(items) do
        local uniqueID = item:GetUniqueID()

        if uniqueID == "monopad" and item:GetData("equip") then
            return item
        end
    end
end

function MonoPad:GetObject(client)
    client = client or (CLIENT and LocalPlayer())

    local item = self:FindMonoPad(client)
    if item then
        local object = item.stored

        if object then
            return object
        end
    end
end

MonoPad.clip = include("libs/cl_3d2dclipping.lua")

Arbitrage.base.Include("sh_meta.lua")
Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_plugin.lua")