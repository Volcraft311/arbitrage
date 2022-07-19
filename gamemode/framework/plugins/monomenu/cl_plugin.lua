--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru (not work)
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

local categoryIcons = {
    ["KILLING HARMONY"] = "icon16/bullet_red.png",
    ["TRIGGER HAPPY HAVOC"] = "icon16/bullet_blue.png",
    ["GOODBYE DESPAIR"] = "icon16/bullet_orange.png",
    ["Остальные"] = "icon16/bullet_black.png",
    ["Ведущие"] = "icon16/bullet_star.png"
}

local function getCharacters(steamid)
    local data = {}

    local info = {}
    for k, v in pairs(Arbitrage.teams.data) do
        local category = v.category or "Остальные"

        info[category] = info[category] or {}
        info[category][#info[category] + 1] = {
            name = v.name,
            icon = v.pixel,
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

        if categoryIcons[k] then
            data[#data].icon = categoryIcons[k]
        end
    end

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
            place = clientinfo:GetNetVar("arbLaw", -1),
            steamid = clientinfo:SteamID(),
            steamname = clientinfo:SteamName(),
            alive = clientinfo:Alive()
        }
    end

    local curtime = CurTime()
    local client = getClient(clientinfo.client, clientinfo.steamid)

    local a_isvalid = IsValid(client)

    local faction = Arbitrage.teams.Get(clientinfo.faction)
    local time = string.FormattedTime(curtime - (a_isvalid and client:GetNetVar("connectedTime", curtime) or curtime))

    local m_name = a_isvalid and client:Name() or clientinfo.steamname
    local m_steamname = clientinfo.steamname
    local m_steamid = clientinfo.steamid
    local m_time = string.format("%s:%s:%s", time.h, time.m, time.s)
    local m_status = clientinfo.alive and "Жив" or "Мертв"
    local m_character = faction and faction.name or client.faction

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
            }
        },
        {
            {
                name = "Изменить персонажа",
                icon = "icon16/user_go.png",
                data = getCharacters(m_steamid)
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
                        check = function()
                            return !clientinfo.ingame
                        end
                    },
                    {
                        name = "Убрать из игры",
                        icon = "icon16/database_delete.png",
                        data = function()
                            runAction("removegame", m_steamid)
                        end,
                        check = function()
                            return clientinfo.ingame
                        end
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
                    Derma_StringRequest("Изменить имя", "Введите имя, которое вы хотите присвоить данному персонажу.\n(Если вы хотите вернуть стандартное имя, то оставьте это поле пустым)", "", function(text)
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
                data = getPlaces(m_steamid),
                check = function()
                    return a_isvalid
                end
            },
            {
                name = "Изменить инвентарь",
                icon = "icon16/box.png",
                data = {
                    {
                        name = "Очистить инвентарь",
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
                            return a_isvalid
                        end
                    }
                }
            },
            {
                name = "Изменить модель",
                icon = "icon16/report_user.png",
                data = function()
                    Derma_StringRequest("Изменить модель", "Укажите путь к моделе которую вы хотите поменять игроку", "models/player/combine_super_soldier.mdl", function(text)
                        runAction("setmodel", client, text)
                    end)
                end,
                check = function()
                    return a_isvalid
                end
            },
            {
                name = "Изменить характеристики",
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
                            Derma_StringRequest("Установить здоровье", "Введите количество здоровье которое вы хотите установить игроку", 100, function(text)
                                if !tonumber(text) then return end

                                runAction("setstats", client, "health", math.Clamp(tonumber(text), 1, 1000))
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
                            Derma_StringRequest("Установить броню", "Введите количество брони которое вы хотите установить игроку", 100, function(text)
                                if !tonumber(text) then return end

                                runAction("setstats", client, "armor", math.Clamp(tonumber(text), 1, 1000))
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
                            Derma_StringRequest("Установить голод", "Введите количество голода которое вы хотите установить игроку", 100, function(text)
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
                            Derma_StringRequest("Установить жажду", "Введите количество жажды которое вы хотите установить игроку", 100, function(text)
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
                            Derma_StringRequest("Установить сон", "Введите количество сна которое вы хотите установить игроку", 100, function(text)
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
        },
        {
            {
                name = "ServerGuard",
                icon = "icon16/plugin.png",
                data = {
                    {
                        name = "Кикнуть",
                        icon = "icon16/stop.png",
                        data = function()
                            serverguard.command.Run("kick", false, m_steamid, "Вы были кикнуты администратором")
                        end,
                        check = function()
                            return a_isvalid
                        end
                    },
                    {
                        name = "Заморозить/Разморозить",
                        icon = "icon16/vector.png",
                        data = function()
                            serverguard.command.Run("freeze", false, m_steamid)
                        end,
                        check = function()
                            return a_isvalid
                        end
                    },
                    {
                        name = "Пнуть",
                        icon = "icon16/ipod_cast.png",
                        data = function()
                            serverguard.command.Run("slap", false, m_steamid)
                        end,
                        check = function()
                            return a_isvalid
                        end
                    },
                    {
                        name = "Отправить сообщение",
                        icon = "icon16/comments.png",
                        data = function()
                            Derma_StringRequest("Отправить сообщение", "Напишите сообщение, которое вы хотите отправить игроку", "", function(text)
                                serverguard.command.Run("pm", false, m_steamid, text)
                            end)
                        end,
                        check = function()
                            return a_isvalid
                        end
                    }
                }
            },
        }
    }
end

local function paintMenu(panel)
    panel.Paint = function(_, w, h)
        draw.RoundedBox(3, 0, 0, w, h, Color(200, 200, 200))
        draw.RoundedBox(3, 2, 0, w - 2, h, Color(230, 230, 230))
    end
end

local function paintOption(panel, drawline)
    panel:SetTextColor(Color(100, 100, 100))

    panel.alpha = 0
    panel.Paint = function(_, w, h)
        local color = Color(100, 100, 100)

        if _:IsHovered() and _:IsEnabled() then
            draw.RoundedBox(3, 2, 0, w - 2, h, Color(255, 61, 96))

            color = Color(200, 200, 200)
        end

        if !_:IsEnabled() then
            draw.RoundedBox(3, 2, 0, w - 2, h, Color(255, 0, 0))

            color = Color(200, 200, 200)
        end

        panel:SetTextColor(color)

        if drawline then
            surface.SetDrawColor(0, 0, 0, 100)
            surface.DrawRect(2, h - 1, w, 1)
        end
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
    end

    paintOption(panel, drawline)
    panel:SetImage(info.icon)

    for k2, v2 in ipairs(panel:GetChildren()) do
        if v2:GetName() == "DImage" and !string.find(v2:GetImage(), "icon16/") then
            local size = parent:GetTall() * 1.5

            v2:SetSize(size, size)
        end
    end

    if !bAllow then
        panel:SetEnabled(false)
    end
end

function PLUGIN:OpenEntityMenu(entity)
    local actionList = getActionList(entity)

    local Menu = DermaMenu()
    paintMenu(Menu)

    for k, v in ipairs(actionList) do
        for k2, v2 in ipairs(v) do
            CreateMenu(v2, Menu, k2 == #v)
        end
    end

    Menu:Open()

    Menu:SetAlpha(0)
    Menu:AlphaTo(255, 0.3)
end

local function OnScreenClick(eyepos, eyevec)
    local ent = GetHovered(eyepos, eyevec)
    if !IsValid(ent) then return end
    if !ent:IsPlayer() then return end

    PLUGIN:OpenEntityMenu(ent)
end

hook.Add("GUIMousePressed", "MonoMenu:Properties", function(code, vector)
    if (!IsValid( vgui.GetHoveredPanel() ) or !vgui.GetHoveredPanel():IsWorldClicker()) then return end

    if (code == MOUSE_RIGHT and !input.IsButtonDown(MOUSE_LEFT)) then
        OnScreenClick(EyePos(), vector)
    end
end)

function PLUGIN:ArbitrageContextMenu(data)
    if LocalPlayer():IsAdmin() then
        data:AddAction("Открыть Моно-Меню", function(client)
            netstream.Start("arb.OpenMonoMenu")
        end, Material("danganronpa/hud/action/mono.png"))
    end
end

netstream.Hook("arb.OpenMonoMenu", function(data)
    local panel = IsValid(Arbitrage.gui.monomenu) and Arbitrage.gui.monomenu or vgui.Create("arb.MonoMenu")
    panel:SetData(data)
end)

netstream.Hook("arb.UpdateMonoMenu", function(data)
    if IsValid(Arbitrage.gui.monomenu) then
        Arbitrage.gui.monomenu:SetData(data)
    end
end)

netstream.Hook("arb.OpenMonoWhiteList", function(data)
    data = (istable(data) and table.Count(data) > 0) and data or { -- PLUGIN:GetData() - always returns some `table`, but not a `nil` value
        players = {},
        settings = false,
    }

    local panel = IsValid(Arbitrage.gui.whitelist) and Arbitrage.gui.whitelist or vgui.Create("arb.MonoMenuWhiteList")
    panel:SetData(data)
end)

netstream.Hook("arb.OpenSplashScreen", function(data)
    local panel = vgui.Create("arb.SplashScreen")
    panel:SetData(data)
end)

netstream.Hook("arb.OpenVotingScreen", function(data, votingList)
    local panel = vgui.Create("arb.VoteScreen")
    panel:SetData(data, votingList)
end)

netstream.Hook("arb.EndVoting", function(data)
    if !IsValid(Arbitrage.gui.votescreen) then return end

    Arbitrage.gui.votescreen:RemovingPanels()

    timer.Simple(1, function()
        Arbitrage.gui.votescreen:ShowWinning(data)
    end)
end)