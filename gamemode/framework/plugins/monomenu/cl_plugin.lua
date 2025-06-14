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

local PLUGIN = PLUGIN

local function GetHovered( eyepos, eyevec )
    local ply = LocalPlayer()
    local filter = ply:GetViewEntity()

    if (filter == ply) then
        local veh = ply:GetVehicle()

        if (veh:IsValid() and (!veh:IsVehicle() or !veh:GetThirdPersonMode())) then
            filter = {filter, veh, unpack( ents.FindByClass("phys_bone_follower"))}
        end
    end

    local trace = util.TraceLine( {
        start = eyepos,
        endpos = eyepos + eyevec * 1024,
        filter = filter
    })

    if (!trace.Hit or !IsValid(trace.Entity)) then
        trace = util.TraceLine( {
            start = eyepos,
            endpos = eyepos + eyevec * 1024,
            filter = filter,
            mask = MASK_ALL
        })
    end

    if (!trace.Hit or !IsValid(trace.Entity )) then return end

    return trace.Entity, trace
end

local function runAction(name, ...)
    netstream.Start("arb.MonoRunCommand", name, ...)
end

local function getCharacters(steamid)
    local data = {}

    local info = {}
    for k, v in SortedPairsByMemberValue(Character.team.instances, "name") do
        local category = v.category or "#monomenu_other"

        info[category] = info[category] or {}
        info[category][#info[category] + 1] = {
            name = v:GetName(),
            icon = v:GetAssets().pixel,
            category = category,
            data = function()
                runAction("setfaction", steamid, k, false)
            end
        }
    end

    for k, v in pairs(info) do
        data[#data + 1] = {
            name = k,
            data = v
        }

        local categoryData = Character.category:GetByName(k)
        if categoryData then
            data[#data].icon = categoryData.icon
        end
    end

    table.sort(data, function(a, b)
        local categoryA = Character.category:GetByName(a.name)
        local categoryB = Character.category:GetByName(b.name)

        return categoryA.id < categoryB.id
    end)

    return data
end

local function getPlaces(steamid)
    local data = {}

    local copy = table.Copy(Arbitrage.placesList or {})
    copy[-1] = true -- обнуление места

    for k, v in pairs(copy) do
        local info = k > 0 and k .. " #monomenu_ct_place" or (k == 0 and "* #monomenu_ct_monokuma" or "- #monomenu_ct_null")

        data[#data + 1] = {
            name = info,
            icon = "icon16/text_list_bullets.png",
            data = function()
                runAction("setplace", steamid, k)
            end
        }
    end

    return data
end

local function getAllTemporaryStatusEffects(client)
    local disable = GetNetVar("medical:statuseffects_disable", {})
    local all_effects = {}
    for k, v in SortedPairsByMemberValue(Medical.t_status_effects, "name") do
        all_effects[#all_effects + 1] = {
            name = v.name,
            icon = isfunction(v.icon) and v.icon(client) or v.icon,
            data = function()
                Derma_StringRequest(L("#monomenu_ply_status_givestatus"), L("#monomenu_ply_status_timestatus"), "", function(text)
                    text = tonumber(text)
                    if !text then return end

                    runAction("addtemporarystatuseffect", client, k, text)
                end)
            end,
            check = function()
                return IsValid(client) and !disable[k]
            end
        }
    end

    local client_effects = {}
    if IsValid(client) then
        for _, v in SortedPairsByMemberValue(client:GetTemporaryStatusEffects(), "delay") do
            local uniqueID = v.uniqueID
            local info = Medical.t_status_effects[uniqueID]
            local delay = v.delay <= 0 and "∞" or math.floor(v.delay - CurTime())

            client_effects[#client_effects + 1] = {
                name = info.name .. " (" .. delay .. " sec)",
                icon = isfunction(info.icon) and info.icon(client) or info.icon,
                data = function()
                    runAction("removetemporarystatuseffect", client, uniqueID)
                end
            }
        end
    end

    local data = {
        {
            name = "#monomenu_ply_status_give",
            icon = "icon16/pill_add.png",
            data = all_effects
        },
        {
            name = "#monomenu_ply_status_take",
            icon = "icon16/pill_delete.png",
            data = client_effects
        },
        {
            name = "#monomenu_ply_status_clearall",
            icon = "icon16/pill.png",
            data = function()
                runAction("cleartemporarystatuseffects", client)
            end,
            check = function()
                return IsValid(client) and #client_effects > 0
            end
        }
    }

    return data
end

local function getClient(client, steamid)
    if IsValid(client) then
        return client
    else
        local new_client = player.GetBySteamID(steamid)

        if IsValid(new_client) then
            return new_client
        end
    end

    return client
end

local function getActionList(clientinfo)
    if clientinfo.IsPlayer and clientinfo:IsPlayer() then
        clientinfo = {
            client = clientinfo,
            faction = clientinfo:Team(),
            place = clientinfo:LawPlace(),
            steamid = clientinfo:SteamID(),
            steamname = clientinfo:SteamName(),
            alive = clientinfo:Alive()
        }
    end

    local curtime = CurTime()
    local client = getClient(clientinfo.client, clientinfo.steamid)

    local a_isvalid = IsValid(client)

    local faction = Character.team:GetByID(clientinfo.faction)
    local time = string.FormattedTime(curtime - (a_isvalid and client:GetNetVar("connectedTime", curtime) or curtime))

    local m_name = a_isvalid and client:Name() or clientinfo.steamname
    local m_steamname = clientinfo.steamname
    local m_steamid = clientinfo.steamid
    local m_time = ("%s:%s:%s"):format(time.h, time.m, time.s)
    local m_status = clientinfo.alive and "#monomenu_stats_alive" or "#monomenu_stats_dead"
    local m_character = faction and faction.name or clientinfo.faction

    local s_health = a_isvalid and client:Health() or "#monomenu_unknown"
    local s_armor = a_isvalid and client:Armor() or "#monomenu_unknown"
    local s_hunger = a_isvalid and (Arbitrage.statistics.Get(client, "Hunger") or 100) or "#monomenu_unknown"
    local s_thirst = a_isvalid and (Arbitrage.statistics.Get(client, "Thirst") or 100) or "#monomenu_unknown"
    local s_sleep = a_isvalid and (Arbitrage.statistics.Get(client, "Sleep") or 100) or "#monomenu_unknown"

    -- Люблю гмод, чтобы на всякий не было ошибок (которые появляются у одного игрока в 9999 лет)
    m_name, m_steamname, m_steamid, m_time, m_status, m_character, s_health, s_armor, s_hunger, s_thirst, s_sleep = tostring(m_name), tostring(m_steamname), tostring(m_steamid), tostring(m_time), tostring(m_status), tostring(m_character), tostring(s_health), tostring(s_armor), tostring(s_hunger), tostring(s_thirst), tostring(s_sleep)

    return {
        {
            {
                name = "#monomenu_stats_name " .. m_name,
                icon = "icon16/book.png",
                data = function()
                    SetClipboardText(m_name)
                end
            },
            {
                name = "#monomenu_stats_steamname " .. m_steamname,
                icon = "icon16/book_addresses.png",
                data = function()
                    SetClipboardText(m_steamname)
                end
            },
            {
                name = "#monomenu_stats_steamid " .. m_steamid,
                icon = "icon16/book_link.png",
                data = function()
                    SetClipboardText(m_steamid)
                end
            },
            {
                name = "#monomenu_stats_uptime " .. m_time,
                icon = "icon16/clock.png",
                data = function()
                    SetClipboardText(m_time)
                end
            },
            {
                name = "#monomenu_stats_status " .. m_status,
                icon = "icon16/status_online.png",
                data = function()
                    SetClipboardText(m_status)
                end
            },
            {
                name = "#monomenu_stats_char " .. m_character,
                icon = "icon16/user.png",
                data = function()
                    SetClipboardText(m_character)
                end
            },
            {
                name = "#monomenu_stats_health " .. s_health,
                icon = "icon16/heart.png",
                data = function()
                    SetClipboardText(s_health)
                end
            },
            {
                name = "#monomenu_stats_armor " .. s_armor,
                icon = "icon16/shape_square.png",
                data = function()
                    SetClipboardText(s_armor)
                end
            },
            {
                name = "#monomenu_stats_hunger " .. s_hunger,
                icon = "icon16/cake.png",
                data = function()
                    SetClipboardText(s_hunger)
                end
            },
            {
                name = "#monomenu_stats_thirst " .. s_thirst,
                icon = "icon16/cup.png",
                data = function()
                    SetClipboardText(s_thirst)
                end
            },
            {
                name = "#monomenu_stats_sleep " .. s_sleep,
                icon = "icon16/contrast_high.png",
                data = function()
                    SetClipboardText(s_sleep)
                end
            }
        },
        {
            {
                name = "#monomenu_stats_setchar",
                icon = "icon16/user_go.png",
                data = getCharacters(m_steamid)
            },
            {
                name = "#monomenu_stats_setrole",
                icon = "icon16/ruby_gear.png",
                data = {
                    {
                        name = "#monomenu_stats_setplayer",
                        icon = "icon16/ruby_delete.png",
                        data = function()
                            runAction("removehost", m_steamid)
                        end,
                        check = function()
                            return IsHost(m_steamid)
                        end
                    },
                    {
                        name = "#monomenu_stats_setgm",
                        icon = "icon16/ruby_add.png",
                        data = function()
                            runAction("addhost", m_steamid)
                        end,
                        check = function()
                            return !IsHost(m_steamid)
                        end
                    }
                }
            },
            {
                name = "#monomenu_stats_actions",
                icon = "icon16/database_go.png",
                data = {
                    {
                        name = "#monomenu_stats_addgame",
                        icon = "icon16/database_add.png",
                        data = function()
                            runAction("addgame", client)
                        end,
                        -- check = function()
                        --     return !clientinfo.ingame
                        -- end
                    },
                    {
                        name = "#monomenu_stats_removegame",
                        icon = "icon16/database_delete.png",
                        data = function()
                            runAction("removegame", m_steamid)
                        end,
                        -- check = function()
                        --     return clientinfo.ingame
                        -- end
                    },
                    {
                        name = "#monomenu_stats_returngame",
                        icon = "icon16/database_refresh.png",
                        data = function()
                            runAction("returngame", client)
                        end,
                        check = function()
                            return a_isvalid and client:GetNetVar("arb.oldData")
                        end
                    }
                }
            },
            {
                name = "#monomenu_stats_setname",
                icon = "icon16/page_white_edit.png",
                data = function()
                    Derma_StringRequest(L("#monomenu_stats_setname"), L("#monomenu_stats_nameex"), IsValid(client) and client:GetNetVar("fakename", "") or "", function(text)
                        runAction("setfakename", client, text)
                    end)
                end,
                check = function()
                    return a_isvalid
                end
            },
            {
                name = "#monomenu_stats_respawn",
                icon = "icon16/arrow_refresh.png",
                data = function()
                    runAction("setfaction", m_steamid, client:Team(), true)
                end,
                check = function()
                    return a_isvalid
                end
            },
            {
                name = "#monomenu_comms_chat",
                icon = "icon16/sound.png",
                data = {
                    {
                        name = "#monomenu_comms_globalon",
                        icon = "icon16/sound_add.png",
                        data = function()
                            runAction("globalvoice", client, true)
                        end,
                        check = function()
                            return a_isvalid and !client:GetNetVar("arbGlobalVoice")
                        end
                    },
                    {
                        name = "#monomenu_comms_globaloff",
                        icon = "icon16/sound_low.png",
                        data = function()
                            runAction("globalvoice", client, false)
                        end,
                        check = function()
                            return a_isvalid and client:GetNetVar("arbGlobalVoice")
                        end
                    },
                    {
                        name = "#monomenu_comms_micon",
                        icon = "icon16/sound_none.png",
                        data = function()
                            runAction("mutevoice", client, false)
                        end,
                        check = function()
                            return a_isvalid and client:GetNetVar("arb.MuteVoice")
                        end
                    },
                    {
                        name = "#monomenu_comms_micoff",
                        icon = "icon16/sound_mute.png",
                        data = function()
                            runAction("mutevoice", client, true)
                        end,
                        check = function()
                            return a_isvalid and !client:GetNetVar("arb.MuteVoice")
                        end
                    },
                    {
                        name = "#monomenu_comms_nrpon",
                        icon = "icon16/comment.png",
                        data = function()
                            runAction("mutenonrpchat", client, false)
                        end,
                        check = function()
                            return a_isvalid and client:GetNetVar("arb.MuteNonRPChat")
                        end
                    },
                    {
                        name = "#monomenu_comms_nrpoff",
                        icon = "icon16/comment_delete.png",
                        data = function()
                            runAction("mutenonrpchat", client, true)
                        end,
                        check = function()
                            return a_isvalid and !client:GetNetVar("arb.MuteNonRPChat")
                        end
                    }
                }
            },
            {
                name = "#monomenu_ply_gamestatus",
                icon = "icon16/world_go.png",
                data = {
                    {
                        name = "#monomenu_ply_statusalive",
                        icon = "icon16/world_add.png",
                        data = function()
                            runAction("changestatus", client, nil)
                        end,
                        check = function()
                            return !clientinfo.alive and a_isvalid and client:IsPlaying()
                        end
                    },
                    {
                        name = "#monomenu_ply_statusdead",
                        icon = "icon16/world_delete.png",
                        data = function()
                            runAction("changestatus", client, false)
                        end,
                        check = function()
                            return a_isvalid and clientinfo.alive and client:IsPlaying()
                        end
                    }
                }
            },
            {
                name = "#monomenu_ply_setctplace",
                icon = "icon16/group.png",
                data = getPlaces(m_steamid)
            },
            {
                name = "#monomenu_inv_change",
                icon = "icon16/package_go.png",
                data = {
                    {
                        name = "#monomenu_inv_clearall",
                        icon = "icon16/package_delete.png",
                        data = function()
                            runAction("claerinventory", client)
                        end,
                        check = function()
                            return a_isvalid
                        end
                    },
                    {
                        name = "#monomenu_inv_check",
                        icon = "icon16/package_link.png",
                        data = function()
                            runAction("openinventory", client)
                        end,
                        check = function()
                            return a_isvalid and client != LocalPlayer()
                        end
                    },
                    {
                        name = "#monomenu_inv_change",
                        icon = "icon16/package.png",
                        data = function()
                            local x, y = 4, 2
                            if IsValid(client) then
                                local inventory = client:GetInventory()

                                if inventory then
                                    x = inventory.w or 4
                                    y = inventory.h or 2
                                end
                            end

                            Derma_StringRequest(L("#monomenu_inv_change"), L("#monomenu_inv_widght"), x, function(inventoryX)
                                if !tonumber(inventoryX) then return end

                                Derma_StringRequest(L("#monomenu_inv_change"), L("#monomenu_inv_height"), y, function(inventoryY)
                                    if !tonumber(inventoryY) then return end

                                    runAction("scaleinventory", client, inventoryX, inventoryY)
                                end)
                            end)
                        end,
                        check = function()
                            return a_isvalid
                        end
                    }
                }
            },
            {
                name = "#monomenu_ply_setmodel",
                icon = "icon16/report_user.png",
                data = function()
                    Derma_StringRequest(L("#monomenu_ply_setmodel"), L("#monomenu_ply_modelpath"), IsValid(client) and client:GetModel() or "", function(text)
                        runAction("setmodel", client, text)
                    end)
                end,
                check = function()
                    return a_isvalid
                end
            },
            {
                name = "#monomenu_ply_setdesc",
                icon = "icon16/page_white_copy.png",
                data = {
                    {
                        name = "#monomenu_ply_regdesc",
                        icon = "icon16/page_white_edit.png",
                        data = function()
                            Derma_StringRequest(L("#monomenu_ply_setregdesc"), L("#monomenu_ply_writedesc"), IsValid(client) and client:GetNetVar("description", "") or "", function(text)
                                runAction("setdescription", client, text)
                            end)
                        end,
                        check = function()
                            return a_isvalid
                        end
                    },
                    {
                        name = "#monomenu_ply_forceddesc",
                        icon = "icon16/page_white_zip.png",
                        data = function()
                            Derma_StringRequest(L("#monomenu_ply_setforced"), L("#monomenu_ply_writedesc"), IsValid(client) and client:GetNetVar("forced_description", "") or "", function(text)
                                runAction("setforceddescription", client, text)
                            end)
                        end,
                        check = function()
                            return a_isvalid
                        end
                    }
                }
            },
            {
                name = "#monomenu_ply_setsizechar",
                icon = "icon16/link_break.png",
                data = function()
                    Derma_StringRequest(L("#monomenu_ply_setsize"), L("#monomenu_ply_writesize"), IsValid(client) and client:GetModelScale() or 1, function(text)
                        if !tonumber(text) then return end

                        runAction("setscale", client, text)
                    end)
                end,
                check = function()
                    return a_isvalid
                end
            },
            {
                name = "#monomenu_ply_setstats",
                icon = "icon16/bricks.png",
                data = {
                    {
                        name = "#monomenu_ply_clearstats",
                        icon = "icon16/chart_line.png",
                        data = function()
                            runAction("resetstats", client)
                        end,
                        check = function()
                            return a_isvalid
                        end
                    },
                    {
                        name = "#monomenu_ply_sethealth",
                        icon = "icon16/heart.png",
                        data = function()
                            Derma_StringRequest(L("#monomenu_ply_sethealth"), L("#monomenu_ply_healthdesc"), IsValid(client) and client:Health() or 100, function(text)
                                if !tonumber(text) then return end

                                runAction("setstats", client, "health", tonumber(text))
                            end)
                        end,
                        check = function()
                            return a_isvalid
                        end
                    },
                    {
                        name = "#monomenu_ply_setarmor",
                        icon = "icon16/shape_square.png",
                        data = function()
                            Derma_StringRequest(L("#monomenu_ply_setarmor"), L("#monomenu_ply_armordesc"), IsValid(client) and client:Armor() or 100, function(text)
                                if !tonumber(text) then return end

                                runAction("setstats", client, "armor", tonumber(text))
                            end)
                        end,
                        check = function()
                            return a_isvalid
                        end
                    },
                    {
                        name = "#monomenu_ply_sethunger",
                        icon = "icon16/cake.png",
                        data = function()
                            Derma_StringRequest(L("#monomenu_ply_sethunger"), L("#monomenu_ply_hungerdesc"), IsValid(client) and (Arbitrage.statistics.Get(client, "Hunger") or 100) or 100, function(text)
                                if !tonumber(text) then return end

                                runAction("setstats", client, "hunger", math.Clamp(tonumber(text), 1, 100))
                            end)
                        end,
                        check = function()
                            return a_isvalid
                        end
                    },
                    {
                        name = "#monomenu_ply_setthirst",
                        icon = "icon16/cup.png",
                        data = function()
                            Derma_StringRequest(L("#monomenu_ply_setthirst"), L("#monomenu_ply_thirstdesc"), IsValid(client) and (Arbitrage.statistics.Get(client, "Thirst") or 100) or 100, function(text)
                                if !tonumber(text) then return end

                                runAction("setstats", client, "thirst", math.Clamp(tonumber(text), 1, 100))
                            end)
                        end,
                        check = function()
                            return a_isvalid
                        end
                    },
                    {
                        name = "#monomenu_ply_setsleep",
                        icon = "icon16/contrast_high.png",
                        data = function()
                            Derma_StringRequest(L("#monomenu_ply_setsleep"), L("#monomenu_ply_sleepdesc"), IsValid(client) and (Arbitrage.statistics.Get(client, "Sleep") or 100) or 100, function(text)
                                if !tonumber(text) then return end

                                runAction("setstats", client, "sleep", math.Clamp(tonumber(text), 1, 100))
                            end)
                        end,
                        check = function()
                            return a_isvalid
                        end
                    }
                }
            },
            {
                name = "#monomenu_ply_setstatuseffects",
                icon = "icon16/pill_go.png",
                data = getAllTemporaryStatusEffects(client)
            },
            {
                name = "#monomenu_ply_setspeed",
                icon = "icon16/arrow_switch.png",
                data = {
                    {
                        name = "#monomenu_ply_walkspeed",
                        icon = "icon16/bullet_go.png",
                        data = function()
                            Derma_StringRequest(L("#monomenu_ply_setwalkspeed"), L("#monomenu_ply_writewalkspeed"), 1, function(text)
                                if !tonumber(text) then return end

                                runAction("setspeed", client, "walk", tonumber(text))
                            end)
                        end,
                        check = function()
                            return a_isvalid
                        end
                    },
                    {
                        name = "#monomenu_ply_runspeed",
                        icon = "icon16/arrow_right.png",
                        data = function()
                            Derma_StringRequest(L("#monomenu_ply_setrunspeed"), L("#monomenu_ply_writerunspeed"), 1, function(text)
                                if !tonumber(text) then return end

                                runAction("setspeed", client, "run", tonumber(text))
                            end)
                        end,
                        check = function()
                            return a_isvalid
                        end
                    }
                }
            },
            {
                name = "#monomenu_ply_setragdoll",
                icon = "icon16/zoom.png",
                data = {
                    {
                        name = "#monomenu_ply_fallover",
                        icon = "icon16/zoom_in.png",
                        data = function()
                            Derma_StringRequest(L("#monomenu_ply_setragdoll"), L("#monomenu_ply_writeragdoll"), 0, function(text)
                                if !tonumber(text) then return end

                                runAction("setfallover", client, tonumber(text))
                            end)
                        end,
                        check = function()
                            return a_isvalid and !client:IsRagdolling()
                        end
                    },
                    {
                        name = "#monomenu_ply_setstandup",
                        icon = "icon16/zoom_out.png",
                        data = function()
                            runAction("setstandup", client)
                        end,
                        check = function()
                            return a_isvalid and client:IsRagdolling()
                        end
                    }
                }
            },
            {
                name = "#monomenu_ply_spectate",
                icon = "icon16/arrow_inout.png",
                data = {
                    {
                        name = "#monomenu_ply_backlightturnon",
                        icon = "icon16/arrow_in.png",
                        data = function()
                            table.insert(PLUGIN.entityList, m_steamid)

                            LocalPlayer():ChatNotify("#monomenu_ply_backlightturnedon " .. client:FullName())
                        end,
                        check = function()
                            local bShow = false
                            for k, v in ipairs(PLUGIN.entityList) do
                                if v == m_steamid then
                                    bShow = true
                                end
                            end

                            return a_isvalid and !bShow
                        end
                    },
                    {
                        name = "#monomenu_ply_backlightturnoff",
                        icon = "icon16/arrow_out.png",
                        data = function()
                            for k, v in ipairs(PLUGIN.entityList) do
                                if v == m_steamid then
                                    table.remove(PLUGIN.entityList, k)

                                    LocalPlayer():ChatNotify("#monomenu_ply_backlightturnedoff " .. client:FullName())
                                end
                            end
                        end,
                        check = function()
                            local bShow = false
                            for k, v in ipairs(PLUGIN.entityList) do
                                if v == m_steamid then
                                    bShow = true
                                end
                            end

                            return a_isvalid and bShow
                        end
                    },
                    {
                        name = "#monomenu_ply_chatspectateon",
                        icon = "icon16/arrow_in.png",
                        data = function()
                            netstream.Start("arb.StartSpectateCommand", m_steamid)
                        end,
                        check = function()
                            local data = LocalPlayer():GetLocalVar("spectatescommand", {})

                            return a_isvalid and !data[m_steamid]
                        end
                    },
                    {
                        name = "#monomenu_ply_chatspectateoff",
                        icon = "icon16/arrow_out.png",
                        data = function()
                            netstream.Start("arb.EndSpectateCommand", m_steamid)
                        end,
                        check = function()
                            local data = LocalPlayer():GetLocalVar("spectatescommand", {})

                            return a_isvalid and data[m_steamid]
                        end
                    }
                }
            },
            {
                name = "#monomenu_ply_moderation",
                icon = "icon16/plugin.png",
                data = {
                    {
                        name = "#monomenu_ply_kill",
                        icon = "icon16/cross.png",
                        data = function()
                            RunConsoleCommand("say", "/slay " .. m_steamid)
                        end,
                        check = function()
                            return a_isvalid
                        end
                    },
                    {
                        name = "#monomenu_ply_teleportto",
                        icon = "icon16/control_play_blue.png",
                        data = function()
                            RunConsoleCommand("say", "/goto " .. m_steamid)
                        end,
                        check = function()
                            return a_isvalid
                        end
                    },
                    {
                        name = "#monomenu_ply_teleportfrom",
                        icon = "icon16/control_repeat_blue.png",
                        data = function()
                            RunConsoleCommand("say", "/bring " .. m_steamid)
                        end,
                        check = function()
                            return a_isvalid
                        end
                    },
                    {
                        name = "#monomenu_ply_slap",
                        icon = "icon16/ipod_cast.png",
                        data = function()
                            RunConsoleCommand("say", "/slap " .. m_steamid)
                        end,
                        check = function()
                            return a_isvalid
                        end
                    }
                }
            }
        }
    }
end

local cornerRadius = 5
local function paintMenu(panel)
    panel.Paint = function(_, w, h)
        draw.RoundedBox(cornerRadius, 0, 0, w, h, Color(255, 61, 96, 165.75))
        draw.RoundedBox(cornerRadius, 2, 2, w - 4, h - 4, Color(41, 22, 25))
    end
end

local function paintOption(panel, drawline)
    panel:SetFont("arb.Font_FuturaPTBook_6")
    panel.Paint = function(_, w, h)
        local alpha = 130

        if _:IsHovered() and _:IsEnabled() then
            surface.SetDrawColor(27, 10, 13, 200)
            surface.DrawRect(2, 2, w - 4, h - 4)

            alpha = 255
        end

        if !_:IsEnabled() then
            surface.SetDrawColor(255, 0, 0, 20)
            surface.DrawRect(2, 0, w - 4, h)

            alpha = 255
        end

        panel:SetTextColor(Color(240, 240, 240, alpha))

        if drawline then
            surface.SetDrawColor(255, 255, 255, 50)
            surface.DrawRect(w * 0.1, h - 2, w - w * 0.2, 2)
        end
    end
end

local barMargin = 23
local function paintBar(panel)
    local children = panel:GetChildren()
    local bar = children[2]
    if !IsValid(bar) then return end

    bar:SetWide(30)
    bar:DockMargin(0, 0, 0, 0)

    bar.Paint = function(_, w, h)
        surface.SetDrawColor(255, 255, 255, 3)
        surface.DrawRect(barMargin, 30, w - barMargin - 4, h - 60)
    end
    bar.btnUp.Paint = function(_, w, h) end
    bar.btnDown.Paint = function(_, w, h) end
    bar.btnGrip.Paint = function(_, w, h)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawRect(barMargin, 0, w - barMargin - 4, h)
    end
end

local function CreateMenu(info, parent, drawline)
    local text = isfunction(info.name) and info.name() or info.name

    local bAllow = true
    if info.check then
        bAllow = info.check()
    end

    local panel, subMenu = nil, nil
    if isfunction(info.data) or info.data == nil then
        if !bAllow then
            info.data = nil
        end

        panel = parent:AddOption(F(text), info.data)
    else
        subMenu, panel = parent:AddSubMenu(F(text))
        paintMenu(subMenu)

        for k, v in ipairs(info.data) do
            CreateMenu(v, subMenu)
        end

        paintBar(subMenu)
    end

    paintOption(panel, drawline)

    if info.icon then
        panel:SetImage(info.icon)
    end

    for k2, v2 in ipairs(panel:GetChildren()) do
        if v2:GetName() == "DImage" and !v2:GetImage():find("icon16/") then
            local size = parent:GetTall() * 1.5

            v2:SetSize(size, size)
        end
    end

    if !bAllow then
        panel:SetEnabled(false)
    end
end

function PLUGIN:OpenEntityMenu(entity, w, h)
    local actionList = getActionList(entity)

    local Menu = DermaMenu()
    paintMenu(Menu)

    for k, v in ipairs(actionList) do
        for k2, v2 in ipairs(v) do
            CreateMenu(v2, Menu, k2 == #v and #actionList != k)
        end
    end

    Menu:Open(w, h)

    Menu:SetAlpha(0)
    Menu:AlphaTo(255, 0.3)

    return Menu
end

local function OnScreenClick(eyepos, eyevec)
    local entity = GetHovered(eyepos, eyevec)
    if !IsValid(entity) then return end

    if entity:IsPlayer() then
        PLUGIN:OpenEntityMenu(entity)
    elseif entity:GetClass() == "prop_ragdoll" then
        local ragdollSteamID = entity:GetNetVar("sIsRagdoll")

        if ragdollSteamID then
            entity = player.GetBySteamID(ragdollSteamID)

            if IsValid(entity) then
                PLUGIN:OpenEntityMenu(entity)
            end
        end
    end
end

hook.Add("GUIMousePressed", "MonoMenu:Properties", function(code, vector)
    if (!IsValid( vgui.GetHoveredPanel() ) or !vgui.GetHoveredPanel():IsWorldClicker()) then return end

    if (code == MOUSE_RIGHT and !input.IsButtonDown(MOUSE_LEFT)) then
        OnScreenClick(EyePos(), vector)
    end
end)

local cur_time1 = 6
local cur_time2 = 60
local cur_time3 = 1
local speed = 0.3
PLUGIN.entityList = PLUGIN.entityList or {}
function PLUGIN:HUDPaint()
    if #self.entityList <= 0 then return end
    if !LocalPlayer():IsAdmin() then return end

    local r = HSVToColor(RealTime() * speed % cur_time1 * cur_time2, cur_time3, cur_time3)
    local color = Color(r.r, r.g, r.b)

    local entities = {}
    for k, v in ipairs(self.entityList) do
        local client = player.GetBySteamID(v)

        if IsValid(client) then
            table.insert(entities, client)
        end
    end

    outline.Add(entities, color, 0)

    local x, y = ScrW() / 2 , ScrH()
    for k, v in ipairs(entities) do
        local point = v:GetPos()
        local data2D = point:ToScreen()
        if !data2D.visible then continue end

        surface.SetDrawColor(color)
        surface.DrawLine(x, y, data2D.x, data2D.y)
    end
end

local function dRender(data)
    if MonoMenu.onFullBright then
        render.SetLightingMode(data)
    end
end

function PLUGIN:PreRender()
    dRender(1)
end

function PLUGIN:PostRender()
    dRender(0)
end

function PLUGIN:PreDrawHUD()
    dRender(0)
end

function PLUGIN:UpdateInvisibleTools()
    local players = {}

    for _, client in ipairs(player.GetAll()) do
        local bHide = client:GetNetVar("bHideTools")
        if !bHide then continue end

        players[client] = true
    end

    for _, client in ipairs(player.GetAll()) do
        local bHide = players[client]
        local weaponList = client:GetWeapons()

        for _, weapon in ipairs(weaponList) do
            local class = weapon:GetClass()

            if self.activityInfo[class] then
                weapon:SetHoldType(bHide and "normal" or "revolver")
                weapon:SetNoDraw(bHide and true or false)
            end
        end
    end

    if table.Count(players) <= 0 then
        hook.Remove("CalcMainActivity", "InvisibleTools")
    else
        hook.Add("CalcMainActivity", "InvisibleTools", function(client)
            if !players[client] then return end

            local weapon = client:GetActiveWeapon()
            if !IsValid(weapon) then return end

            local class = weapon:GetClass()
            if !class then return end

            local data = self.activityInfo[class]
            if !data then return end

            weapon:SetHoldType("normal")
            weapon:SetNoDraw(true)

            local sequence = client:GetSequence()
            local sequenceName = client:GetSequenceName(sequence)

            local info = data[sequenceName]
            if !info then return end

            local lSequence = client:LookupSequence(info)

            return -1, lSequence
        end)
    end
end

netstream.Hook("MonoMenu:InvisibleTools", function()
    timer.Simple(0, function() -- wait netvars
        PLUGIN:UpdateInvisibleTools()
    end)
end)

timer.Simple(5, function()
    PLUGIN:UpdateInvisibleTools()
end)