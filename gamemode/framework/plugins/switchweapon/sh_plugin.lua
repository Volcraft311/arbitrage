--[[
        © Asterion Project 2021.
        This script was created from the developers of the AsterionTeam.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru
            Discord - https://discord.gg/Cz3EQJ7WrF
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

local PLUGIN = PLUGIN
PLUGIN.name = "SwitchWeapon"

function PLUGIN:PlayerSwitchWeapon(client, old, new)
    if !IsValid(client) then return false end
    if !client:oldAlive() then return false end
    local weapon = old -- client:GetActiveWeapon()
    if !IsValid(weapon) then return false end

    local class = weapon:GetClass()
    if !class then return false end

    if class == new:GetClass() then return false end

    local weaponData = Arbitrage.weapon.views
    if !weaponData then return false end

    if Arbitrage.util.IsServerSide() then
        Arbitrage.action.ActionEnd(client:EntIndex(), client)
    end

    if weaponData[new:GetClass()] then
        if Arbitrage.util.IsServerSide() and !client.allowSwitch then
            Arbitrage.action.ActionRun(client, "Достаем оружие", 2, function()
                if !client.switchAnim or CurTime() >= client.switchAnim then
                    netstream.Start(nil, "arb.PlayerSetAnim", client, GESTURE_SLOT_CUSTOM, ACT_GMOD_GESTURE_ITEM_PLACE, true)

                    client.switchAnim = CurTime() + 1.2
                end

                return false
            end, function(activator)
                activator.allowSwitch = true

                if IsValid(new) then
                    activator:SelectWeapon(new:GetClass())
                end

                timer.Simple(1, function()
                    if !IsValid(activator) then return end

                    activator.allowSwitch = false
                end)
            end)
        end

        return !client.allowSwitch
    end

    return false
end