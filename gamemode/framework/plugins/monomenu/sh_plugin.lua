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

PLUGIN.GameData = {}
PLUGIN.AdminData = {}

function PLUGIN:AddGameFunction(name, icon, data)
    data = data or {}

    local info = data
    info.data = name
    info.icon = icon

    self.GameData[#self.GameData + 1] = info
end

function PLUGIN:AddAdminFunction(name, icon, data)
    data = data or {}

    local info = data
    info.data = name
    info.icon = icon

    self.AdminData[#self.AdminData + 1] = info
end


--[[
    ИГРОВЫЕ ФУНКЦИИ
]]--
MonoMenu:AddGameFunction("Игра запущена", "icon16/control_play_blue.png", {
    isCheckBox = true,
    onEnable = function(client)
        if CLIENT then return end

        Arbitrage:StartGame()
    end,
    onDisable = function(client)
        if CLIENT then return end

        Arbitrage:StopGame()
    end,
    OnCheck = function(client)
        return Arbitrage.IsStartGame()
    end
})

MonoMenu:AddGameFunction("Суд запущен", "icon16/control_equalizer_blue.png", {
    isCheckBox = true,
    onEnable = function(client)
        if CLIENT then return end

        Arbitrage:StartLaw()
    end,
    onDisable = function(client)
        if CLIENT then return end

        Arbitrage:EndLaw()
    end,
    OnCheck = function(client)
        return Arbitrage.IsStartLaw()
    end,
    onCreate = function(client)
        return Arbitrage.IsStartGame()
    end
})

MonoMenu:AddGameFunction("Запустить заставку (глава)", "icon16/application_add.png", {
    onRun = function(client)
        if SERVER then return false end

        vgui.Create("arb.MonoMenuSplashScreenSub")
    end
})

MonoMenu:AddGameFunction("Запустить заставку (gameover)", "icon16/application_add.png", {
    onRun = function(client)
        if SERVER then return false end

        vgui.Create("arb.MonoMenuEndGameSub")
    end
})

MonoMenu:AddGameFunction("Запустить заставку (статус)", "icon16/application_add.png", {
    onRun = function(client)
        if SERVER then return false end

        vgui.Create("arb.MonoChangeStyleSub")
    end
})

MonoMenu:AddGameFunction("Запустить голосование", "icon16/application_view_tile.png", {
    onRun = function(client)
        if CLIENT then return end

        PLUGIN:StartVoting()
    end
})

MonoMenu:AddGameFunction("Изменить устав академии", "icon16/book_edit.png", {
    onRun = function(client)
        if SERVER then return false end

        vgui.Create("arb.MonoAcademyCharter")
    end
})

MonoMenu:AddGameFunction("Распределить двери", "icon16/chart_organisation.png", {
    onRun = function(client)
        if CLIENT then return end

        Arbitrage:InitDoors()
    end
})

MonoMenu:AddGameFunction("Заморозить всех игроков", "icon16/shading.png", {
    onRun = function(client)
        if CLIENT then return end

        for k, v in pairs(player.GetAll()) do
            if v:IsAdmin() then continue end
            if v:IsSpectate() then continue end

            v:Freeze(true)
        end
    end
})

MonoMenu:AddGameFunction("Разморозить всех игроков", "icon16/shape_move_front.png", {
    onRun = function(client)
        if CLIENT then return end

        for k, v in pairs(player.GetAll()) do
            if v:IsAdmin() then continue end

            v:Freeze(false)
        end
    end
})

MonoMenu:AddGameFunction("Изменить название главы", "icon16/color_swatch.png", {
    onRun = function(client)
        if SERVER then return false end

        local dermaPanel = DermaMenu()
        local data = {"Эпизод отсутствует", "Пролог", "Эпилог"}

        for i = 1, 9 do
            data[#data + 1] = "Эпизод " .. i
        end

        for k, v in ipairs(data) do
            dermaPanel:AddOption(v, function()
                asterionlib.EmitSound(PLUGIN.ClickSound)
                netstream.Start("arb.MonoSetChapter", v)
            end)
        end

        local customButton = dermaPanel:AddOption("Ввести свое", function()
            Derma_StringRequest("Изменить название главы", "Введите название которое вы хотите установить для главы", "", function(text)
                asterionlib.EmitSound(PLUGIN.ClickSound)
                netstream.Start("arb.MonoSetChapter", text)
            end)
        end)
        customButton:SetIcon("icon16/pencil.png")

        dermaPanel:Open()
    end
})

MonoMenu:AddGameFunction("Открыть WhiteList список", "icon16/application_view_list.png", {
    onRun = function(client)
        if CLIENT then return end

        PLUGIN:OpenMonoWhiteList(client)
    end
})

MonoMenu:AddGameFunction("Открыть список дополнений", "icon16/database_gear.png", {
    onRun = function(client)
        if CLIENT then return end

        WORKSHOP:OpenMenu(client)
    end
})

MonoMenu:AddGameFunction("Открыть список предметов", "icon16/table_edit.png", {
    onRun = function(client)
        if SERVER then return end

        vgui.Create("ItemBase:CreationMenu")
    end
})

MonoMenu:AddGameFunction("Изменить цветокоррекцию", "icon16/color_wheel.png", {
    onRun = function(client)
        if SERVER then return end

        vgui.Create("ColorModify:Menu")
    end
})

MonoMenu:AddGameFunction("Открыть редактор музыки", "icon16/music.png", {
    onRun = function(client)
        if CLIENT then return end

        ScriptMusic:OpenMenu(client)
    end
})

MonoMenu:AddGameFunction("Сбросить всем всю статистику", "icon16/chart_line.png", {
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
})

MonoMenu:AddGameFunction("Остановить всем все звуки", "icon16/sound_none.png", {
    onRun = function(client)
        if CLIENT then return end

        for k, v in pairs(player.GetAll()) do
            v:ConCommand("stopsound")
        end
    end
})

MonoMenu:AddGameFunction("Удалить все улики на карте", "icon16/bug_delete.png", {
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
})

MonoMenu:AddGameFunction("Очистить чат", "icon16/application_delete.png", {
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
})

MonoMenu:AddGameFunction("Надпись ClassTrial", "icon16/chart_curve_add.png", {
    isCheckBox = true,
    onEnable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffShowClassTrial", false)
    end,
    onDisable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffShowClassTrial", true)
    end,
    OnCheck = function(client)
        return !Arbitrage.OffShowClassTrial()
    end
})

MonoMenu:AddGameFunction("OOC чат", "icon16/world_add.png", {
    isCheckBox = true,
    onEnable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffOOC", false)
    end,
    onDisable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffOOC", true)
    end,
    OnCheck = function(client)
        return !Arbitrage.OffOOC()
    end
})

MonoMenu:AddGameFunction("Падение потребности", "icon16/cup.png", {
    isCheckBox = true,
    onEnable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffFallStatictic", false)
    end,
    onDisable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffFallStatictic", true)
    end,
    OnCheck = function(client)
        return !Arbitrage.OffFallStatictic()
    end
})

MonoMenu:AddGameFunction("Смерть из-за потребности", "icon16/transmit.png", {
    isCheckBox = true,
    onEnable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OnDeadLowStatictic", true)
    end,
    onDisable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OnDeadLowStatictic", false)
    end,
    OnCheck = function(client)
        return Arbitrage.OnDeadLowStatictic()
    end
})

MonoMenu:AddGameFunction("Эффект обнаружения трупа", "icon16/camera.png", {
    isCheckBox = true,
    onEnable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffCorpseEffect", false)
    end,
    onDisable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffCorpseEffect", true)
    end,
    OnCheck = function(client)
        return !Arbitrage.OffCorpseEffect()
    end
})

MonoMenu:AddGameFunction("Спавн трупа при смерти", "icon16/status_online.png", {
    isCheckBox = true,
    onEnable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffSpawnPersistent", false)
    end,
    onDisable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffSpawnPersistent", true)
    end,
    OnCheck = function(client)
        return !Arbitrage.OffSpawnPersistent()
    end
})

--[[
    АДМИНСКИЕ ФУНКЦИИ
]]--
MonoMenu:AddAdminFunction("Зайти за администратора", "icon16/star.png", {
    onRun = function(client)
        if CLIENT then return end

        Arbitrage.player.SetTeam(client, TEAM_ADMIN, true)
    end,
    onCreate = function(client)
        return client:Team() != TEAM_ADMIN
    end
})

MonoMenu:AddAdminFunction("PhysGun и ToolGun", "icon16/basket_put.png", {
    isCheckBox = true,
    onEnable = function(client)
        if CLIENT then return end

        client:Give("weapon_physgun")
        client:Give("gmod_tool")
    end,
    onDisable = function(client)
        if CLIENT then return end

        client:StripWeapon("weapon_physgun")
        client:StripWeapon("gmod_tool")
    end,
    OnCheck = function(client)
        return client:HasWeapon("weapon_physgun") or client:HasWeapon("gmod_tool")
    end
})

MonoMenu:AddAdminFunction("Глобальный Voice", "icon16/sound_low.png", {
    isCheckBox = true,
    onEnable = function(client)
        if CLIENT then return end

        client:SetNetVar("arbGlobalVoice", true, client)
    end,
    onDisable = function(client)
        if CLIENT then return end

        client:SetNetVar("arbGlobalVoice", nil, client)
    end,
    OnCheck = function(client)
        return client:GetNetVar("arbGlobalVoice")
    end
})

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_plugin.lua")