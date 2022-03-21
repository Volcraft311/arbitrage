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

PLUGIN.name = "MonoMenu"

PLUGIN.ClickSound = "garrysmod/content_downloaded.wav"

-- надо бы эту таблицу на sv перенести, но мне лень)
PLUGIN.WhiteListStandart = {
    ["STEAM_0:1:127526733"] = "Selenter",
    ["STEAM_0:0:560521676"] = "Kalkamiya",
    ["STEAM_0:1:45558340"] = "Nitorogi",
    ["STEAM_0:0:453627339"] = "Shoujou_bun",
    ["STEAM_0:0:210940539"] = "Redzhi",
    ["STEAM_0:1:109093755"] = "SeekerForDreams"
}

PLUGIN.GameData = {
    {
        data = "Запустить игру",
        icon = "icon16/control_play_blue.png",
        onRun = function(client)
            if CLIENT then return end

            Arbitrage:StartGame()
        end,
        onCreate = function(client)
            return !Arbitrage.IsStartGame()
        end
    },
    {
        data = "Остановить игру",
        icon = "icon16/control_stop_blue.png",
        onRun = function(client)
            if CLIENT then return end

            Arbitrage:StopGame()
        end,
        onCreate = function(client)
            return Arbitrage.IsStartGame()
        end
    },
    {
        data = "Запустить суд",
        icon = "icon16/control_equalizer_blue.png",
        onRun = function(client)
            if CLIENT then return end

            Arbitrage:StartLaw()
        end,
        onCreate = function(client)
            return Arbitrage.law.placesList[game.GetMap()] and (Arbitrage.IsStartGame() and !GetNetVar("arb.StartLaw")) or false
        end
    },
    {
        data = "Остановить суд",
        icon = "icon16/control_eject_blue.png",
        onRun = function(client)
            if CLIENT then return end

            Arbitrage:EndLaw()
        end,
        onCreate = function(client)
            return Arbitrage.IsStartGame() and GetNetVar("arb.StartLaw")
        end
    },
    {
        data = "Запустить заставку",
        icon = "icon16/application_add.png",
        onRun = function(client)
            if SERVER then return false end

            vgui.Create("arb.MonoMenuSplashScreenSub")
        end
    },
    {
        data = "Запустить голосование",
        icon = "icon16/application_view_tile.png",
        onRun = function(client)
            if CLIENT then return end

            PLUGIN:StartVoting()
        end
    },
    {
        data = "Изменить устав академии",
        icon = "icon16/book_edit.png",
        onRun = function(client)
            if SERVER then return false end

            vgui.Create("arb.MonoAcademyCharter")
        end
    },
    {
        data = "Распределить двери",
        icon = "icon16/chart_organisation.png",
        onRun = function(client)
            if CLIENT then return end

            Arbitrage:InitDoors()
        end
    },
    {
        data = "Заморозить всех игроков",
        icon = "icon16/shading.png",
        onRun = function(client)
            if CLIENT then return end

            for k, v in pairs(player.GetAll()) do
                if v:IsAdmin() then continue end

                v:Freeze(true)
            end
        end
    },
    {
        data = "Разморозить всех игроков",
        icon = "icon16/shape_move_front.png",
        onRun = function(client)
            if CLIENT then return end

            for k, v in pairs(player.GetAll()) do
                if v:IsAdmin() then continue end

                v:Freeze(false)
            end
        end
    },
    {
        data = "Изменить номер главы",
        icon = "icon16/color_swatch.png",
        onRun = function(client)
            if SERVER then return false end

            local dermaPanel = DermaMenu()
            for i = 0, 9 do
                local data = i > 0 and i or "Глава отсутствует"

                dermaPanel:AddOption(data, function()
                    Arbitrage.Client():EmitSound(PLUGIN.ClickSound)
                    netstream.Start("arb.MonoSetChapter", i)
                end)
            end
            dermaPanel:Open()
        end
    },
    {
        data = "Открыть WhiteList список",
        icon = "icon16/application_view_list.png",
        onRun = function(client)
            if CLIENT then return end

            PLUGIN:OpenMonoWhiteList(client)
        end
    },
    {
        data = "Открыть редактор музыки",
        icon = "icon16/music.png",
        onRun = function(client)
            if CLIENT then return end

            ScriptMusic:OpenMenu(client)
        end
    },
    {
        data = "Сбросить всем все харак...",
        icon = "icon16/chart_line.png",
        onRun = function(client)
            if CLIENT then return end

            for k, v in pairs(player.GetAll()) do
                v:SetHealth(ARBITRAGE_HEALTH)
                v:SetArmor(ARBITRAGE_ARMOR)

                for k2, v2 in pairs(Arbitrage.statistics.list) do
                    Arbitrage.statistics.Set(v, v2.data, 100)
                end
            end
        end
    },
    {
        data = "Остановить всем все звуки",
        icon = "icon16/sound_none.png",
        onRun = function(client)
            if CLIENT then return end

            for k, v in pairs(player.GetAll()) do
                v:ConCommand("stopsound")
            end
        end
    },
    {
        data = "Удалить все улики на карте",
        icon = "icon16/bug_delete.png",
        onRun = function(client)
            if CLIENT then return end

            for k, v in pairs(ents.GetAll()) do
                if v:IsNPC() then v:Remove() end
                if v:GetClass() == "arb_weapon" then v:Remove() end
                if v:GetClass() == "arb_evidence" then v:Remove() end
                if v:GetClass() == "prop_ragdoll" then v:Remove() end

                if v:GetEvidence() then
                    v:Remove()
                end
            end

            Evidence.list = {}
            netstream.Start(nil, "evidence.Clear")
        end
    },
    {
        data = "Вкл отображение ClassTrial",
        icon = "icon16/chart_curve_add.png",
        onRun = function(client)
            if CLIENT then return end

            SetNetVar("arb.ClassTrial", true)

            for k, v in ipairs(player.GetAll()) do
                v:SyncVars()
            end
        end,
        onCreate = function(client)
            return !Arbitrage.IsShowClassTrial()
        end
    },
    {
        data = "Выкл отображение ClassTrial",
        icon = "icon16/chart_curve_delete.png",
        onRun = function(client)
            if CLIENT then return end

            SetNetVar("arb.ClassTrial", false)

            for k, v in ipairs(player.GetAll()) do
                v:SyncVars()
            end
        end,
        onCreate = function(client)
            return Arbitrage.IsShowClassTrial()
        end
    }
}

PLUGIN.AdminData = {
    {
        data = "Зайти за администратора",
        icon = "icon16/star.png",
        onRun = function(client)
            if CLIENT then return end

            Arbitrage.player.SetTeam(client, TEAM_ADMIN, true)
        end,
        onCreate = function(client)
            return client:Team() != TEAM_ADMIN
        end
    },
    {
        data = "Выдать physgun и toolgun",
        icon = "icon16/basket_put.png",
        onRun = function(client)
            if CLIENT then return end

            client:Give("weapon_physgun")
            client:Give("gmod_tool")
        end,
        onCreate = function(client)
            return !client:HasWeapon("weapon_physgun") or !client:HasWeapon("gmod_tool")
        end
    },
    {
        data = "Забрать physgun и toolgun",
        icon = "icon16/basket_remove.png",
        onRun = function(client)
            if CLIENT then return end

            client:StripWeapon("weapon_physgun")
            client:StripWeapon("gmod_tool")
        end,
        onCreate = function(client)
            return client:HasWeapon("weapon_physgun") or client:HasWeapon("gmod_tool")
        end
    },
    {
        data = "Включить глобальный voice",
        icon = "icon16/sound_low.png",
        onRun = function(client)
            if CLIENT then return end

            client:SetNetVar("arbGlobalVoice", true, client)
        end,
        onCreate = function(client)
            return !client:GetNetVar("arbGlobalVoice")
        end
    },
    {
        data = "Выключить глобальный voice",
        icon = "icon16/sound_mute.png",
        onRun = function(client)
            if CLIENT then return end

            client:SetNetVar("arbGlobalVoice", nil, client)
        end,
        onCreate = function(client)
            return client:GetNetVar("arbGlobalVoice")
        end
    },
}

PLUGIN.ActionData = {
    {
        {
            data = function(client)
                return "SteamName: " .. client.steamname
            end,
            icon = "icon16/information.png"
        },
        {
            data = function(client)
                return "SteamID: " .. client.steamid
            end,
            icon = "icon16/information.png"
        },
        {
            data = function(client)
                return "Состояние: " .. (client.alive and "Жив" or "Мертв")
            end,
            icon = "icon16/information.png"
        },
        {
            data = function(client)
                return "Место на суде: " .. (client.place > 0 and client.place or (client.place == 0 and "Монокум" or "Не задано"))
            end,
            icon = "icon16/information.png"
        },
        {
            data = function(client)
                local faction = Arbitrage.teams.Get(client.faction)

                return "Фракция: " .. (faction and faction.name or client.faction)
            end,
            icon = "icon16/information.png"
        },
        {
            data = function(client)
                return "На сервере: " .. (player.GetBySteamID(client.steamid) and "Да" or "Нет")
            end,
            icon = "icon16/information.png"
        },
    },
    {
        {
            data = "Скопировать SteamName",
            icon = "icon16/user.png",
            onRun = function(client)
                if SERVER then return false end

                SetClipboardText(client.steamname)
            end
        },
        {
            data = "Скопировать SteamID",
            icon = "icon16/book.png",
            onRun = function(client)
                if SERVER then return false end

                SetClipboardText(client.steamid)
            end
        },
        {
            data = "Скопировать SteamID64",
            icon = "icon16/book_addresses.png",
            onRun = function(client)
                if SERVER then return false end

                SetClipboardText(util.SteamIDTo64(client.steamid))
            end
        },
    },
    {
        {
            data = "Добавить в игру",
            icon = "icon16/database_add.png",
            onRun = function(client)
                if CLIENT then return false end

                local count = table.Count(Arbitrage.players)

                Arbitrage.players[client.steamid] = {
                    faction = client.client:Team(),
                    place = Arbitrage.law.placesList[game.GetMap()] and math.Clamp(count + 1, 1, #Arbitrage.law.placesList[game.GetMap()]) or -1,
                    steamname = client.client:SteamName()
                }

                client.client:SetNetVar("arbLaw", count + 1, client.client)
            end,
            onCreate = function(client)
                return !client.ingame
            end
        },
        {
            data = "Убрать из игры",
            icon = "icon16/database_delete.png",
            onRun = function(client)
                if CLIENT then return end

                Arbitrage.players[client.steamid] = nil

                if IsValid(client.client) then
                    client.client:SetNetVar("arbLaw", -1, client.client)
                end
            end,
            onCreate = function(client)
                return client.ingame
            end
        },
        {
            data = "Вернуть в игру",
            icon = "icon16/control_repeat_blue.png",
            onRun = function(client)
                if CLIENT then return end

                local pl = player.GetBySteamID(client.steamid)
                if !pl then return end

                local data = pl:GetNetVar("arb.oldData")
                if !data then return end

                pl:SetNetVar("arb.oldData", nil)

                Arbitrage.player.SetTeam(pl, data[1], true)
                timer.Simple(0.1, function()
                    pl:SetPos(data[2])
                    Arbitrage.player.SetupHealth(pl)
                end)
            end,
            onCreate = function(client)
                local pl = player.GetBySteamID(client.steamid)

                return pl and pl:GetNetVar("arb.oldData") -- player.GetBySteamID(client.steamid) and GetNetVar("arb.StartGame") and (SERVER and true or Arbitrage.gui.monomenu.data.character[client.steamid])
            end
        },
        {
            data = "Изменить персонажа",
            icon = "icon16/page_edit.png",
            onRun = function(client)
                if SERVER then return false end

                local dermaPanel = DermaMenu()
                for k, v in pairs(Arbitrage.teams.data) do
                    dermaPanel:AddOption(v.name .. " (" .. k .. ")", function()
                        Arbitrage.Client():EmitSound(PLUGIN.ClickSound)
                        netstream.Start("arb.MonoSetTeam", client, k, false)
                    end)
                end
                dermaPanel:Open()
            end,
            onCreate = function(client)
                return player.GetBySteamID(client.steamid)
            end
        },
        {
            data = "Изменить персонажа (С ВОЗРАЖДЕНИЕМ)",
            icon = "icon16/page_edit.png",
            onRun = function(client)
                if SERVER then return false end

                local dermaPanel = DermaMenu()
                for k, v in pairs(Arbitrage.teams.data) do
                    dermaPanel:AddOption(v.name .. " (" .. k .. ")", function()
                        Arbitrage.Client():EmitSound(PLUGIN.ClickSound)
                        netstream.Start("arb.MonoSetTeam", client, k, true)
                    end)
                end
                dermaPanel:Open()
            end,
            onCreate = function(client)
                return player.GetBySteamID(client.steamid)
            end
        },
        {
            data = "Сделать живым",
            icon = "icon16/world_add.png",
            onRun = function(client)
                if CLIENT then return end

                client.client:SetNetVar("arbAlive", nil)
            end,
            onCreate = function(client)
                return !client.alive and player.GetBySteamID(client.steamid) and client.client:IsPlaying()
            end
        },
        {
            data = "Сделать мертвым",
            icon = "icon16/world_delete.png",
            onRun = function(client)
                if CLIENT then return end

                client.client:SetNetVar("arbAlive", false)
            end,
            onCreate = function(client)
                return player.GetBySteamID(client.steamid) and client.alive and client.client:IsPlaying()
            end
        },
        {
            data = "Изменить место в суде",
            icon = "icon16/group.png",
            onRun = function(client)
                if SERVER then return false end

                if !Arbitrage.law.placesList[game.GetMap()] then return end

                local dermaPanel = DermaMenu()
                for i = -1, #Arbitrage.law.placesList[game.GetMap()] do
                    local data = i > 0 and i .. " место" or (i == 0 and "* Место Монокума" or "- Обнулить место")

                    dermaPanel:AddOption(data, function()
                        Arbitrage.Client():EmitSound(PLUGIN.ClickSound)
                        netstream.Start("arb.MonoSetPlace", client.steamid, i)
                    end)
                end
                dermaPanel:Open()
            end,
            onCreate = function(client)
                return client.ingame
            end
        },
        {
            data = "Выдать оружие",
            icon = "icon16/wand.png",
            onRun = function(client)
                if SERVER then return false end

                Derma_StringRequest("Выдать оружие", "Введите UniquieID оружия которое вы хотите выдать", "weapon_physgun", function(text)
                    Arbitrage.Client():EmitSound(PLUGIN.ClickSound)
                    netstream.Start("arb.MonoGiveWeapon", client, text)
                end)
            end,
            onCreate = function(client)
                return player.GetBySteamID(client.steamid)
            end
        },
        {
            data = "Изменить модель",
            icon = "icon16/report_user.png",
            onRun = function(client)
                if SERVER then return false end

                Derma_StringRequest("Изменить модель", "Укажите путь к моделе которую вы хотите поменять игроку", "models/player/combine_super_soldier.mdl", function(text)
                    Arbitrage.Client():EmitSound(PLUGIN.ClickSound)
                    netstream.Start("arb.MonoSetModel", client, text)
                end)
            end,
            onCreate = function(client)
                return player.GetBySteamID(client.steamid)
            end
        }
    },
    {
        {
            data = "Сбросить все характеристики",
            icon = "icon16/chart_line.png",
            onRun = function(client)
                if CLIENT then return end

                client.client:SetHealth(ARBITRAGE_HEALTH)
                client.client:SetArmor(ARBITRAGE_ARMOR)

                for k, v in pairs(Arbitrage.statistics.list) do
                    Arbitrage.statistics.Set(client.client, v.data, 100)
                end
            end,
            onCreate = function(client)
                return player.GetBySteamID(client.steamid) and client.client:IsPlaying()
            end
        },
        {
            data = "Установить здоровье",
            icon = "icon16/heart.png",
            onRun = function(client)
                if SERVER then return false end

                Derma_StringRequest("Установить здоровье", "Введите количество здоровье которое вы хотите установить игроку", 100, function(text)
                    if !tonumber(text) then return end

                    Arbitrage.Client():EmitSound(PLUGIN.ClickSound)
                    netstream.Start("arb.MonoSetStats", client, "health", math.Clamp(tonumber(text), 1, 1000))
                end)
            end,
            onCreate = function(client)
                return player.GetBySteamID(client.steamid) and client.client:IsPlaying()
            end
        },
        {
            data = "Установить броню",
            icon = "icon16/shape_square.png",
            onRun = function(client)
                if SERVER then return false end

                Derma_StringRequest("Установить броню", "Введите количество брони которое вы хотите установить игроку", 100, function(text)
                    if !tonumber(text) then return end

                    Arbitrage.Client():EmitSound(PLUGIN.ClickSound)
                    netstream.Start("arb.MonoSetStats", client, "armor", math.Clamp(tonumber(text), 0, 1000))
                end)
            end,
            onCreate = function(client)
                return player.GetBySteamID(client.steamid) and client.client:IsPlaying()
            end
        },
        {
            data = "Установить голод",
            icon = "icon16/cake.png",
            onRun = function(client)
                if SERVER then return false end

                Derma_StringRequest("Установить голод", "Введите количество голода которое вы хотите установить игроку", 100, function(text)
                    if !tonumber(text) then return end

                    Arbitrage.Client():EmitSound(PLUGIN.ClickSound)
                    netstream.Start("arb.MonoSetStats", client, "hunger", math.Clamp(tonumber(text), 0, 100))
                end)
            end,
            onCreate = function(client)
                return player.GetBySteamID(client.steamid) and client.client:IsPlaying()
            end
        },
        {
            data = "Установить жажду",
            icon = "icon16/cup.png",
            onRun = function(client)
                if SERVER then return false end

                Derma_StringRequest("Установить жажду", "Введите количество жажды которое вы хотите установить игроку", 100, function(text)
                    if !tonumber(text) then return end

                    Arbitrage.Client():EmitSound(PLUGIN.ClickSound)
                    netstream.Start("arb.MonoSetStats", client, "thirst", math.Clamp(tonumber(text), 0, 100))
                end)
            end,
            onCreate = function(client)
                return player.GetBySteamID(client.steamid) and client.client:IsPlaying()
            end
        },
        {
            data = "Установить сон",
            icon = "icon16/contrast_high.png",
            onRun = function(client)
                if SERVER then return false end

                Derma_StringRequest("Установить сон", "Введите количество сна которое вы хотите установить игроку", 100, function(text)
                    if !tonumber(text) then return end

                    Arbitrage.Client():EmitSound(PLUGIN.ClickSound)
                    netstream.Start("arb.MonoSetStats", client, "sleep", math.Clamp(tonumber(text), 0, 100))
                end)
            end,
            onCreate = function(client)
                return player.GetBySteamID(client.steamid) and client.client:IsPlaying()
            end
        }
    }
}

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_plugin.lua")