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

PLUGIN.CurrentTColor = {
    brightness = 0,
    contrast = 1,
    color = 1,
    mulr = 0,
    mulg = 0,
    mulb = 0,
    addr = 0,
    addg = 0,
    addb = 0,
}

PLUGIN.AllTweens = {}


for k, v in pairs(PLUGIN.CurrentTColor) do
    local tween = Tween(v, v, 1, TWEEN_EASE_LINEAR)
    PLUGIN.AllTweens[k] = tween
end

PLUGIN.TargetTColor = nil
PLUGIN.DefaultTColor = table.Copy(PLUGIN.CurrentTColor)



local function _createColorModify(data)
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
    return ColorModify
end


function PLUGIN:ApplyColorModify()

    if PLUGIN.TargetTColor == nil then
        local data = PLUGIN:Get()
        if !data.enabled then return end

        if data.players and !data.playersList[LocalPlayer():SteamID()] then return end
        local colorTable = _createColorModify(data)
        if system.IsOSX() then
            colorTable["$pp_colour_brightness"] = 0
            colorTable["$pp_colour_contrast"] = 1
        end
        DrawColorModify(colorTable)

    else
        local colorTable = _createColorModify(PLUGIN.CurrentTColor)
        DrawColorModify(colorTable)
    end
end


function PLUGIN:RenderScreenspaceEffects()
    ColorModify:ApplyColorModify()
end