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

file.CreateDir("academy_colormodify_configs")

local PLUGIN = PLUGIN

PLUGIN.TriggerColor = nil

function PLUGIN:RenderScreenspaceEffects()
    local data
    if PLUGIN.TriggerColor == nil then
        data = self:Get()
        if !data.enabled then return end

        if data.players and !data.playersList[LocalPlayer():SteamID()] then
            return
        end
    else
        data = PLUGIN.TriggerColor
    end
    local ColorModify = {}
    ColorModify["$pp_colour_brightness"] = data.brightness
    ColorModify["$pp_colour_contrast"] = data.contrast
    ColorModify["$pp_colour_colour"] = data.color
    ColorModify["$pp_colour_addr"] = data.addr * 0.025
    ColorModify["$pp_colour_addg"] = data.addg * 0.025
    ColorModify["$pp_colour_addb"] = data.addb * 0.025
    ColorModify["$pp_colour_mulr"] = data.mulr * 0.1
    ColorModify["$pp_colour_mulg"] = data.mulg * 0.1
    ColorModify["$pp_colour_mulb"] = data.mulb * 0.1

    if system.IsOSX() then
        ColorModify["$pp_colour_brightness"] = 0
        ColorModify["$pp_colour_contrast"] = 1
    end

    DrawColorModify(ColorModify)
end