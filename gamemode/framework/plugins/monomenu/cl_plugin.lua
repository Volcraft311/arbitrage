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
        local category = v.category or "Остальные"

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
        local info = k > 0 and k .. " место" or (k == 0 and "* Место Монокума" or "- Обнулить место")

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
                Derma_StringRequest("Выдать статус эфект", "Введите время, насколько вы хотите выдать игроку данный эффект\n(Если вы хотите установить его навсегда, то введите 0)", "", function(text)
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
            name = "Выдать",
            icon = "icon16/pill_add.png",
            data = all_effects
        },
        {
            name = "Забрать",
            icon = "icon16/pill_delete.png",
            data = client_effects
        },
        {
            name = "Очистить все эффекты",
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
    local m_status = clientinfo.alive and "Жив" or "Мертв"
    local m_character = faction and faction.name or clientinfo.faction

    local s_health = a_isvalid and client:Health() or "Неизвестно"
    local s_armor = a_isvalid and client:Armor() or "Неизвестно"
    local s_hunger = a_isvalid and (Arbitrage.statistics.Get(client, "Hunger") or 100) or "Неизвестно"
    local s_thirst = a_isvalid and (Arbitrage.statistics.Get(client, "Thirst") or 100) or "Неизвестно"
    local s_sleep = a_isvalid and (Arbitrage.statistics.Get(client, "Sleep") or 100) or "Неизвестно"

    -- Люблю гмод, чтобы на всякий не было ошибок (которые появляются у одного игрока в 9999 лет)
    m_name, m_steamname, m_steamid, m_time, m_status, m_character, s_health, s_armor, s_hunger, s_thirst, s_sleep = tostring(m_name), tostring(m_steamname), tostring(m_steamid), tostring(m_time), tostring(m_status), tostring(m_character), tostring(s_health), tostring(s_armor), tostring(s_hunger), tostring(s_thirst), tostring(s_sleep)

    return {
        {
            {
                name = "Имя: " .. m_name,
                icon = "icon16/book.png",
                data = function()
                    SetClipboardText(m_name)
                end
            },
            {
                name = "SteamName: " .. m_steamname,
                icon = "icon16/book_addresses.png",
                data = function()
                    SetClipboardText(m_steamname)
                end
            },
            {
                name = "SteamID: " .. m_steamid,
                icon = "icon16/book_link.png",
                data = function()
                    SetClipboardText(m_steamid)
                end
            },
            {
                name = "Время на сервере: " .. m_time,
                icon = "icon16/clock.png",
                data = function()
                    SetClipboardText(m_time)
                end
            },
            {
                name = "Состояние: " .. m_status,
                icon = "icon16/status_online.png",
                data = function()
                    SetClipboardText(m_status)
                end
            },
            {
                name = "Персонаж: " .. m_character,
                icon = "icon16/user.png",
                data = function()
                    SetClipboardText(m_character)
                end
            },
            {
                name = "Здоровье: " .. s_health,
                icon = "icon16/heart.png",
                data = function()
                    SetClipboardText(s_health)
                end
            },
            {
                name = "Броня: " .. s_armor,
                icon = "icon16/shape_square.png",
                data = function()
                    SetClipboardText(s_armor)
                end
            },
            {
                name = "Голод: " .. s_hunger,
                icon = "icon16/cake.png",
                data = function()
                    SetClipboardText(s_hunger)
                end
            },
            {
                name = "Жажда: " .. s_thirst,
                icon = "icon16/cup.png",
                data = function()
                    SetClipboardText(s_thirst)
                end
            },
            {
                name = "Сон: " .. s_sleep,
                icon = "icon16/contrast_high.png",
                data = function()
                    SetClipboardText(s_sleep)
                end
            }
        },
        {
            {
                name = "Изменить персонажа",
                icon = "icon16/user_go.png",
                data = getCharacters(m_steamid)
            },
            {
                name = "Изменить роль",
                icon = "icon16/ruby_gear.png",
                data = {
                    {
                        name = "Сделать участником",
                        icon = "icon16/ruby_delete.png",
                        data = function()
                            runAction("removehost", m_steamid)
                        end,
                        check = function()
                            return IsHost(m_steamid)
                        end
                    },
                    {
                        name = "Сделать ведущим",
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
                name = "Действия с игрой",
                icon = "icon16/database_go.png",
                data = {
                    {
                        name = "Добавить в игру",
                        icon = "icon16/database_add.png",
                        data = function()
                            runAction("addgame", client)
                        end,
                        -- check = function()
                        --     return !clientinfo.ingame
                        -- end
                    },
                    {
                        name = "Убрать из игры",
                        icon = "icon16/database_delete.png",
                        data = function()
                            runAction("removegame", m_steamid)
                        end,
                        -- check = function()
                        --     return clientinfo.ingame
                        -- end
                    },
                    {
                        name = "Вернуть в игру",
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
                name = "Изменить имя",
                icon = "icon16/page_white_edit.png",
                data = function()
                    Derma_StringRequest("Изменить имя", "Введите имя, которое вы хотите присвоить данному персонажу.\n(Если вы хотите вернуть стандартное имя, то оставьте это поле пустым)", IsValid(client) and client:GetNetVar("fakename", "") or "", function(text)
                        runAction("setfakename", client, text)
                    end)
                end,
                check = function()
                    return a_isvalid
                end
            },
            {
                name = "Возродить",
                icon = "icon16/arrow_refresh.png",
                data = function()
                    runAction("setfaction", m_steamid, client:Team(), true)
                end,
                check = function()
                    return a_isvalid
                end
            },
            {
                name = "Чат",
                icon = "icon16/sound.png",
                data = {
                    {
                        name = "Включить глобальный войс",
                        icon = "icon16/sound_add.png",
                        data = function()
                            runAction("globalvoice", client, true)
                        end,
                        check = function()
                            return a_isvalid and !client:GetNetVar("arbGlobalVoice")
                        end
                    },
                    {
                        name = "Выключить глобальный войс",
                        icon = "icon16/sound_low.png",
                        data = function()
                            runAction("globalvoice", client, false)
                        end,
                        check = function()
                            return a_isvalid and client:GetNetVar("arbGlobalVoice")
                        end
                    },
                    {
                        name = "Включить микрофон",
                        icon = "icon16/sound_none.png",
                        data = function()
                            runAction("mutevoice", client, false)
                        end,
                        check = function()
                            return a_isvalid and client:GetNetVar("arb.MuteVoice")
                        end
                    },
                    {
                        name = "Выключить микрофон",
                        icon = "icon16/sound_mute.png",
                        data = function()
                            runAction("mutevoice", client, true)
                        end,
                        check = function()
                            return a_isvalid and !client:GetNetVar("arb.MuteVoice")
                        end
                    },
                    {
                        name = "Включить NonRP чат",
                        icon = "icon16/comment.png",
                        data = function()
                            runAction("mutenonrpchat", client, false)
                        end,
                        check = function()
                            return a_isvalid and client:GetNetVar("arb.MuteNonRPChat")
                        end
                    },
                    {
                        name = "Выключить NonRP чат",
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
                name = "Изменить игровой статус",
                icon = "icon16/world_go.png",
                data = {
                    {
                        name = "Сделать живым",
                        icon = "icon16/world_add.png",
                        data = function()
                            runAction("changestatus", client, nil)
                        end,
                        check = function()
                            return !clientinfo.alive and a_isvalid and client:IsPlaying()
                        end
                    },
                    {
                        name = "Сделать мертвым",
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
                name = "Изменить место на суде",
                icon = "icon16/group.png",
                data = getPlaces(m_steamid)
            },
            {
                name = "Изменить инвентарь",
                icon = "icon16/package_go.png",
                data = {
                    {
                        name = "Очистить все предметы",
                        icon = "icon16/package_delete.png",
                        data = function()
                            runAction("claerinventory", client)
                        end,
                        check = function()
                            return a_isvalid
                        end
                    },
                    {
                        name = "Посмотреть содержимое",
                        icon = "icon16/package_link.png",
                        data = function()
                            runAction("openinventory", client)
                        end,
                        check = function()
                            return a_isvalid and client != LocalPlayer()
                        end
                    },
                    {
                        name = "Изменить размер",
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

                            Derma_StringRequest("Изменить инвентарь", "Введите размер инвентаря по ширине", x, function(inventoryX)
                                if !tonumber(inventoryX) then return end

                                Derma_StringRequest("Изменить инвентарь", "Введите размер инвентаря по высоте", y, function(inventoryY)
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
                name = "Изменить модель",
                icon = "icon16/report_user.png",
                data = function()
                    Derma_StringRequest("Изменить модель", "Укажите путь к моделе которую вы хотите поменять игроку", IsValid(client) and client:GetModel() or "", function(text)
                        runAction("setmodel", client, text)
                    end)
                end,
                check = function()
                    return a_isvalid
                end
            },
            {
                name = "Изменить описание персонажа",
                icon = "icon16/page_white_copy.png",
                data = {
                    {
                        name = "Обычное описание",
                        icon = "icon16/page_white_edit.png",
                        data = function()
                            Derma_StringRequest("Изменить обычно описание", "Введите какое описание которое вы хотите установить игроку", IsValid(client) and client:GetNetVar("description", "") or "", function(text)
                                runAction("setdescription", client, text)
                            end)
                        end,
                        check = function()
                            return a_isvalid
                        end
                    },
                    {
                        name = "Принудительное описание",
                        icon = "icon16/page_white_zip.png",
                        data = function()
                            Derma_StringRequest("Изменить принудительное описание", "Введите какое описание которое вы хотите установить игроку", IsValid(client) and client:GetNetVar("forced_description", "") or "", function(text)
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
                name = "Изменить размер персонажа",
                icon = "icon16/link_break.png",
                data = function()
                    Derma_StringRequest("Изменить размер", "Введите размер который вы хотите установить персонажу\n1 - стандартная", IsValid(client) and client:GetModelScale() or 1, function(text)
                        if !tonumber(text) then return end

                        runAction("setscale", client, text)
                    end)
                end,
                check = function()
                    return a_isvalid
                end
            },
            {
                name = "Изменить статистику",
                icon = "icon16/bricks.png",
                data = {
                    {
                        name = "Сбросить все характеристики",
                        icon = "icon16/chart_line.png",
                        data = function()
                            runAction("resetstats", client)
                        end,
                        check = function()
                            return a_isvalid
                        end
                    },
                    {
                        name = "Установить здоровье",
                        icon = "icon16/heart.png",
                        data = function()
                            Derma_StringRequest("Установить здоровье", "Введите количество здоровье которое вы хотите установить игроку", IsValid(client) and client:Health() or 100, function(text)
                                if !tonumber(text) then return end

                                runAction("setstats", client, "health", tonumber(text))
                            end)
                        end,
                        check = function()
                            return a_isvalid
                        end
                    },
                    {
                        name = "Установить броню",
                        icon = "icon16/shape_square.png",
                        data = function()
                            Derma_StringRequest("Установить броню", "Введите количество брони которое вы хотите установить игроку", IsValid(client) and client:Armor() or 100, function(text)
                                if !tonumber(text) then return end

                                runAction("setstats", client, "armor", tonumber(text))
                            end)
                        end,
                        check = function()
                            return a_isvalid
                        end
                    },
                    {
                        name = "Установить голод",
                        icon = "icon16/cake.png",
                        data = function()
                            Derma_StringRequest("Установить голод", "Введите количество голода которое вы хотите установить игроку", IsValid(client) and (Arbitrage.statistics.Get(client, "Hunger") or 100) or 100, function(text)
                                if !tonumber(text) then return end

                                runAction("setstats", client, "hunger", math.Clamp(tonumber(text), 1, 100))
                            end)
                        end,
                        check = function()
                            return a_isvalid
                        end
                    },
                    {
                        name = "Установить жажду",
                        icon = "icon16/cup.png",
                        data = function()
                            Derma_StringRequest("Установить жажду", "Введите количество жажды которое вы хотите установить игроку", IsValid(client) and (Arbitrage.statistics.Get(client, "Thirst") or 100) or 100, function(text)
                                if !tonumber(text) then return end

                                runAction("setstats", client, "thirst", math.Clamp(tonumber(text), 1, 100))
                            end)
                        end,
                        check = function()
                            return a_isvalid
                        end
                    },
                    {
                        name = "Установить сон",
                        icon = "icon16/contrast_high.png",
                        data = function()
                            Derma_StringRequest("Установить сон", "Введите количество сна которое вы хотите установить игроку", IsValid(client) and (Arbitrage.statistics.Get(client, "Sleep") or 100) or 100, function(text)
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
                name = "Изменить статус эффекты",
                icon = "icon16/pill_go.png",
                data = getAllTemporaryStatusEffects(client)
            },
            {
                name = "Изменить скорость",
                icon = "icon16/arrow_switch.png",
                data = {
                    {
                        name = "Скорость ходьбы",
                        icon = "icon16/bullet_go.png",
                        data = function()
                            Derma_StringRequest("Изменить скорость ходьбы", "Введите значение на которое вы хотите изменить скорость ходьбы.\n1 - стандартная скорость", 1, function(text)
                                if !tonumber(text) then return end

                                runAction("setspeed", client, "walk", tonumber(text))
                            end)
                        end,
                        check = function()
                            return a_isvalid
                        end
                    },
                    {
                        name = "Скорость бега",
                        icon = "icon16/arrow_right.png",
                        data = function()
                            Derma_StringRequest("Изменить скорость бега", "Введите значение на которое вы хотите изменить скорость бега.\n1 - стандартная скорость", 1, function(text)
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
                name = "Изменить статус регдулла",
                icon = "icon16/zoom.png",
                data = {
                    {
                        name = "Опрокинуть",
                        icon = "icon16/zoom_in.png",
                        data = function()
                            Derma_StringRequest("Изменить регдулл статус", "Введите значение на которое вы хотите опрокинуть игрока.\n0 - дать ему возможность встать самому\n-1 - навсегда", 0, function(text)
                                if !tonumber(text) then return end

                                runAction("setfallover", client, tonumber(text))
                            end)
                        end,
                        check = function()
                            return a_isvalid and !client:IsRagdolling()
                        end
                    },
                    {
                        name = "Поднять",
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
                name = "Слежка за игроком",
                icon = "icon16/arrow_inout.png",
                data = {
                    {
                        name = "Включить подсветку",
                        icon = "icon16/arrow_in.png",
                        data = function()
                            table.insert(PLUGIN.entityList, m_steamid)

                            Arbitrage.notify.NotifyChat("Вы включили подсветку за игроком: " .. client:FullName())
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
                        name = "Выключить подстветку",
                        icon = "icon16/arrow_out.png",
                        data = function()
                            for k, v in ipairs(PLUGIN.entityList) do
                                if v == m_steamid then
                                    table.remove(PLUGIN.entityList, k)

                                    Arbitrage.notify.NotifyChat("Вы выключили подсветку за игроком: " .. client:FullName())
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
                        name = "Включить слежку за чатом",
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
                        name = "Выключить слежку за чатом",
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
                name = "Модерация",
                icon = "icon16/plugin.png",
                data = {
                    {
                        name = "Убить",
                        icon = "icon16/cross.png",
                        data = function()
                            RunConsoleCommand("say", "/slay " .. m_steamid)
                        end,
                        check = function()
                            return a_isvalid
                        end
                    },
                    {
                        name = "Телепортироваться",
                        icon = "icon16/control_play_blue.png",
                        data = function()
                            RunConsoleCommand("say", "/goto " .. m_steamid)
                        end,
                        check = function()
                            return a_isvalid
                        end
                    },
                    {
                        name = "Телепортировать",
                        icon = "icon16/control_repeat_blue.png",
                        data = function()
                            RunConsoleCommand("say", "/bring " .. m_steamid)
                        end,
                        check = function()
                            return a_isvalid
                        end
                    },
                    {
                        name = "Пнуть",
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

        panel = parent:AddOption(text, info.data)
    else
        subMenu, panel = parent:AddSubMenu(text)
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