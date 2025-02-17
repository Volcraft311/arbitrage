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


local client_color = Color(63, 162, 184)
local danger_color = Color(223, 66, 66)
local info_color = Color(197, 181, 60)
local info2_color = Color(48, 218, 187)

AdminNotify:AddNewNotify("killed", function(client, target, weapon)
    return danger_color, client, color_white, "#notify_killed_1", client_color, target, color_white, weapon and ("#notify_killed_2" .. weapon) or ""
end)

AdminNotify:AddNewNotify("joincharacter", function(clientSt, character)
    return client_color, clientSt, color_white, "#notify_charjoined", info_color, character
end)

AdminNotify:AddNewNotify("spawn", function(client)
    return client_color, client, color_white, "#notify_spawned"
end)

AdminNotify:AddNewNotify("join", function(client)
    return Color(50, 211, 77), client, color_white, "#notify_serverjoined"
end)

AdminNotify:AddNewNotify("connect", function(name, steamid)
    return Color(211, 147, 50), name .. "(" .. steamid .. ")", color_white, "#notify_serverconnect"
end)

AdminNotify:AddNewNotify("disconnect", function(client)
    return danger_color, client, color_white, "#notify_serverdisconnect"
end)

AdminNotify:AddNewNotify("transfercharacter", function(client, target, faction)
    local character = Character.team:GetByID(faction)

    return client_color, client, color_white, "#notify_transferchar_player", info_color, target, color_white, "#notify_transferchar_faction", info2_color, character.name .. " (" .. faction .. ")"
end)

AdminNotify:AddNewNotify("monocommand", function(client, command, target)
    return client_color, client, color_white, "#notify_monocommand_cmd", info2_color, command, color_white, "#notify_monocommand_ply", info_color, target
end)

AdminNotify:AddNewNotify("monocommandc", function(client, command, target)
    return client_color, client, color_white, "#notify_monocommand_cmd", info2_color, command
end)

AdminNotify:AddNewNotify("setstats", function(client, data, target, amount)
    return client_color, client, color_white, "#notify_setstats_cmd", info2_color, data, color_white, "#notify_toplayer", info_color, target, color_white, "#notify_amount", info2_color, amount
end)

AdminNotify:AddNewNotify("setspeed", function(client, data, target, speed)
    return client_color, client, color_white, "#notify_setspeed", info2_color, data, color_white, "#notify_toplayer", info_color, target, color_white, "#notify_amount", info2_color, speed or 1
end)

AdminNotify:AddNewNotify("setplace", function(client, data, target)
    return client_color, client, color_white, "#notify_setplace", info_color, target, color_white, "#notify_amount", info2_color, data
end)

AdminNotify:AddNewNotify("giveweapon", function(client, target, data)
    return client_color, client, color_white, "#notify_giveweapon_player", info_color, target, color_white, "#notify_giveweapon_wep", info2_color, data
end)

AdminNotify:AddNewNotify("setfakename", function(client, target, data)
    return client_color, client, color_white, "#notify_setfakename", info_color, target, color_white, "#notify_amount", info2_color, data
end)

AdminNotify:AddNewNotify("setchapter", function(client, data)
    return client_color, client, color_white, "#notify_setchapter", info2_color, data
end)

AdminNotify:AddNewNotify("removewhitelist", function(client, data)
    return client_color, client, color_white, "#notify_removewhitelist", info_color, data
end)

AdminNotify:AddNewNotify("addwhitelist", function(client, data)
    return client_color, client, color_white, "#notify_addwhitelist", info_color, data
end)

AdminNotify:AddNewNotify("settingswhitelist", function(client, data)
    return client_color, client, color_white, "#notify_serverwhitelist_change", info2_color, data and "#notify_serverwhitelist_public" or "#notify_serverwhitelist_private"
end)

AdminNotify:AddNewNotify("setmodel", function(client, target, data)
    return client_color, client, color_white, "#notify_setmodel_ply", info_color, target, color_white, "#notify_setmodel_mdl", info2_color, data
end)

AdminNotify:AddNewNotify("changecolormodify", function(client, key, data)
    return client_color, client, color_white, "#notify_changecolormodify", info_color, key, color_white, "#notify_amount", info2_color, data
end)

AdminNotify:AddNewNotify("standartcolormodify", function(client)
    return client_color, client, color_white, "#notify_standartcolormodify"
end)

AdminNotify:AddNewNotify("resetstats", function(client, target)
    return client_color, client, color_white, "#notify_resetstats", info_color, target
end)

AdminNotify:AddNewNotify("changestatus", function(client, target, state)
    return client_color, client, color_white, "#notify_changestatus", info_color, target, color_white, "#notify_amount", info2_color, state
end)

AdminNotify:AddNewNotify("returngame", function(client, target)
    return client_color, client, color_white, "#notify_returngame", info_color, target
end)

AdminNotify:AddNewNotify("removegame", function(client, target)
    return client_color, client, color_white, "#notify_removegame", info_color, target
end)

AdminNotify:AddNewNotify("addgame", function(client, target)
    return client_color, client, color_white, "#notify_addgame", info_color, target
end)

AdminNotify:AddNewNotify("claerinventory", function(client, target)
    return client_color, client, color_white, "#notify_clearinv", info_color, target
end)

AdminNotify:AddNewNotify("openinventory", function(client, target)
    return client_color, client, color_white, "#notify_openinv", info_color, target
end)

AdminNotify:AddNewNotify("scaleinventory", function(client, target, x, y)
    return client_color, client, color_white, "#notify_scaleinv_cmd", info_color, target, color_white, "#notify_amount", info2_color, x, color_white, "#notify_scaleinv_and", info2_color, y
end)

AdminNotify:AddNewNotify("globalvoice", function(client, target, value)
    return client_color, client, color_white, info2_color, value and "#notify_voice_on" or "#notify_voice_off", color_white, "#notify_globalvoice_ply", info_color, target
end)

AdminNotify:AddNewNotify("mutevoice", function(client, target, value)
    return client_color, client, color_white, info2_color, value and "#notify_voice_off" or "#notify_voice_on", color_white, "#notify_mutevoice_ply", info_color, target
end)

AdminNotify:AddNewNotify("mutenonrpchat", function(client, target, value)
    return client_color, client, color_white, info2_color, value and "#notify_mutenonrpchat_off" or "#notify_mutenonrpchat_on", color_white, "#notify_mutenonrpchat_ply", info_color, target
end)

AdminNotify:AddNewNotify("addhost", function(client, target)
    return client_color, client, color_white, "#notify_addhost", info_color, target
end)

AdminNotify:AddNewNotify("removehost", function(client, target)
    return client_color, client, color_white, "#notify_removehost", info_color, target
end)

AdminNotify:AddNewNotify("setdescription", function(client, target)
    return client_color, client, color_white, "#notify_setdescription", info_color, target
end)

AdminNotify:AddNewNotify("setforceddescription", function(client, target)
    return client_color, client, color_white, "#notify_setforceddescription", info_color, target
end)

AdminNotify:AddNewNotify("registeritem", function(client, uniqueID)
    return client_color, client, color_white, "#notify_registeritem", info2_color, uniqueID
end)

AdminNotify:AddNewNotify("edititem", function(client, uniqueID)
    return client_color, client, color_white, "#notify_edititem", info2_color, uniqueID
end)

AdminNotify:AddNewNotify("removeitem", function(client, uniqueID)
    return client_color, client, color_white, "#notify_removeitem", info2_color, uniqueID
end)

AdminNotify:AddNewNotify("protectitem", function(client, uniqueID)
    return client_color, client, color_white, "#notify_protectitem", info2_color, uniqueID
end)

AdminNotify:AddNewNotify("changecharter", function(client)
    return client_color, client, color_white, "#notify_changecharter"
end)

AdminNotify:AddNewNotify("startsplashscreen", function(client)
    return client_color, client, color_white, "#notify_startsplashscreen"
end)

AdminNotify:AddNewNotify("startendgame", function(client)
    return client_color, client, color_white, "#notify_startendgame"
end)

AdminNotify:AddNewNotify("setfallover", function(client, target, delay)
    return client_color, client, color_white, "#notify_setfallover_ply", info_color, target, color_white, "#notify_amount", info2_color, delay or 1, color_white, "#notify_setfallover_secs"
end)

AdminNotify:AddNewNotify("setstandup", function(client, target, delay)
    return client_color, client, color_white, "#notify_setstandup", info_color, target
end)

AdminNotify:AddNewNotify("addstatuseffect", function(client, target, uniqueID, delay)
    return client_color, client, color_white, "#notify_addstatuseffect_cmd", info2_color, uniqueID, color_white, "#notify_addstatuseffect_ply", info_color, target, color_white, "#notify_amount", info2_color, delay
end)

AdminNotify:AddNewNotify("removestatuseffect", function(client, target, uniqueID)
    return client_color, client, color_white, "#notify_removestatuseffect_cmd", info2_color, uniqueID, color_white, "#notify_removestatuseffect_ply", info_color, target
end)

AdminNotify:AddNewNotify("clearstatuseffect", function(client, target)
    return client_color, client, color_white, "#notify_clearstatuseffect", info_color, target
end)

AdminNotify:AddNewNotify("setscale", function(client, target, delay)
    return client_color, client, color_white, "#notify_setscale_player", info_color, target, color_white, "#notify_amount", info2_color, delay
end)

AdminNotify:AddNewNotify("triggercreated", function(client, trigger)
    return client_color, client, color_white, "#notify_triggercreated", info_color, trigger
end)

AdminNotify:AddNewNotify("triggerremoved", function(client, trigger)
    return client_color, client, color_white, "#notify_triggerremoved", info_color, trigger
end)

AdminNotify:AddNewNotify("triggerchanged", function(client, name)
    return client_color, client, color_white, "#notify_triggerchanged", info_color, name
end)

AdminNotify:AddNewNotify("triggerloadconfig", function(client)
    return client_color, client, color_white, "#notify_triggerloadconfig"
end)

AdminNotify:AddNewNotify("triggerremoveall", function(client)
    return client_color, client, color_white, "#notify_triggerremoveall"
end)

AdminNotify:AddNewNotify("triggerlistsreset", function(client)
    return client_color, client, color_white, "#notify_triggerlistsreset"
end)