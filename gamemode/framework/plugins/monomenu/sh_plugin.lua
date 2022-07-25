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

PLUGIN.name = "MonoMenu"
MonoMenu = PLUGIN

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
            return Arbitrage.placesList and (Arbitrage.IsStartGame() and !GetNetVar("arb.StartLaw")) or false
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
                if v:IsSpectate() then continue end

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
        data = "Изменить название главы",
        icon = "icon16/color_swatch.png",
        onRun = function(client)
            if SERVER then return false end

            local dermaPanel = DermaMenu()
            local data = {"Эпизод отсутствует", "Пролог", "Эпилог"}

            for i = 1, 9 do
                data[#data + 1] = "Эпизод " .. i
            end

            for k, v in ipairs(data) do
                dermaPanel:AddOption(v, function()
                    LocalPlayer():EmitSound(PLUGIN.ClickSound)
                    netstream.Start("arb.MonoSetChapter", v)
                end)
            end

            local customButton = dermaPanel:AddOption("Ввести свое", function()
                Derma_StringRequest("Изменить название главы", "Введите название которое вы хотите установить для главы", "", function(text)
                    LocalPlayer():EmitSound(PLUGIN.ClickSound)
                    netstream.Start("arb.MonoSetChapter", text)
                end)
            end)
            customButton:SetIcon("icon16/pencil.png")

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
        data = "Изменить цветокоррекцию",
        icon = "icon16/color_wheel.png",
        onRun = function(client)
            if SERVER then return end

            vgui.Create("ColorModify:Menu")
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
        data = "Сбросить всем все характери...",
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
        data = "Очистить чат",
        icon = "icon16/application_delete.png",
        onRun = function(client)
            if CLIENT then return end

            for k, v in pairs(player.GetAll()) do
                v:SendLua([[
                    RunConsoleCommand("arb_chatbox_reload")

                    timer.Simple(0.5, function()
                        chat.AddText("Администрация очистила чат!")
                    end)
                ]])
            end
        end
    },
    {
        data = "Вкл отображение ClassTrial",
        icon = "icon16/chart_curve_add.png",
        onRun = function(client)
            if CLIENT then return end

            SetNetVar("arb.ClassTrial", true)
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

        end,
        onCreate = function(client)
            return Arbitrage.IsShowClassTrial()
        end
    },
    {
        data = "Включить OOC",
        icon = "icon16/world_add.png",
        onRun = function(client)
            if CLIENT then return end

            SetNetVar("arb.OffOOC", false)
        end,
        onCreate = function(client)
            return Arbitrage.OffOOC()
        end
    },
    {
        data = "Выключить OOC",
        icon = "icon16/world_delete.png",
        onRun = function(client)
            if CLIENT then return end

            SetNetVar("arb.OffOOC", true)
        end,
        onCreate = function(client)
            return !Arbitrage.OffOOC()
        end
    },
    {
        data = "Включить трату характеристик",
        icon = "icon16/cup_add.png",
        onRun = function(client)
            if CLIENT then return end

            SetNetVar("arb.OffFallStatictic", false)
        end,
        onCreate = function(client)
            return Arbitrage.OffFallStatictic()
        end
    },
    {
        data = "Выключить трату характеристик",
        icon = "icon16/cup_delete.png",
        onRun = function(client)
            if CLIENT then return end

            SetNetVar("arb.OffFallStatictic", true)
        end,
        onCreate = function(client)
            return !Arbitrage.OffFallStatictic()
        end
    },
    {
        data = "Включить смерть из-за характ...",
        icon = "icon16/cup_add.png",
        onRun = function(client)
            if CLIENT then return end

            SetNetVar("arb.OnDeadLowStatictic", true)
        end,
        onCreate = function(client)
            return !Arbitrage.OnDeadLowStatictic()
        end
    },
    {
        data = "Выключить смерть из-за харак...",
        icon = "icon16/cup_delete.png",
        onRun = function(client)
            if CLIENT then return end

            SetNetVar("arb.OnDeadLowStatictic", false)
        end,
        onCreate = function(client)
            return Arbitrage.OnDeadLowStatictic()
        end
    },
    {
        data = "Включить эффект от трупа",
        icon = "icon16/world_add.png",
        onRun = function(client)
            if CLIENT then return end

            SetNetVar("arb.OffCorpseEffect", false)
        end,
        onCreate = function(client)
            return Arbitrage.OffCorpseEffect()
        end
    },
    {
        data = "Выключить эффект от трупа",
        icon = "icon16/world_delete.png",
        onRun = function(client)
            if CLIENT then return end

            SetNetVar("arb.OffCorpseEffect", true)
        end,
        onCreate = function(client)
            return !Arbitrage.OffCorpseEffect()
        end
    },
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

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_plugin.lua")