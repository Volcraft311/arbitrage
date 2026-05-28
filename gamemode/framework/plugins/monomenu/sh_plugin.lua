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

PLUGIN.name = "MonoMenu"
MonoMenu = PLUGIN

PLUGIN.ClickSound = "garrysmod/content_downloaded.wav"

PLUGIN.GameData = {}
PLUGIN.AdminData = {}

PLUGIN.activityInfo = {
    -- Weapon:SetHoldType не работает на Physgun
    weapon_physgun = {
        idle_physgun = "idle_all_01",
        walk_physgun = "walk_all",
        run_physgun = "run_all_01",
        jump_physgun = "jump_slam",
        cidle_physgun = "cidle_all",
    },
    gmod_tool = {}
}

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

local vector_zero = Vector(0, 0, 0)
MonoMenu:AddGameFunction("#monomenu_gm_startgame", "icon16/control_play_blue.png", {
    isCheckBox = true,
    onEnable = function(client)
        if CLIENT then return end

        Arbitrage.StartGame()
    end,
    onDisable = function(client)
        if CLIENT then return end

        Arbitrage.StopGame()
    end,
    OnCheck = function(client)
        return Arbitrage.IsStartGame()
    end,
    onCreate = function(client)
        return !Arbitrage.lawEnable
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_classtrial", "icon16/control_equalizer_blue.png", {
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
    end,
    OnClick = function(client)
        if (Arbitrage.Trial.GetStartCamera().pos == vector_zero) then return client:ChatNotify("Не установлена начальная позиция камеры") end
        if (Arbitrage.Trial.GetEndPosCamera() == vector_zero) then return client:ChatNotify("Не установлена конечная позиция камеры")  end
        return true
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_splashscreen", "icon16/application_add.png", {
    onRun = function(client)
        if SERVER then return false end

        vgui.Create("arb.MonoMenuSplashScreenSub")
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_gameoverscreen", "icon16/application_add.png", {
    onRun = function(client)
        if SERVER then return false end

        vgui.Create("arb.MonoMenuEndGameSub")
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_statusscreen", "icon16/application_add.png", {
    onRun = function(client)
        if SERVER then return false end

        vgui.Create("arb.MonoChangeStyleSub")
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_vote", "icon16/application_view_tile.png", {
    onRun = function(client)
        if CLIENT then return end

        PLUGIN:StartVoting()
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_charter", "icon16/book_edit.png", {
    onRun = function(client)
        if SERVER then return false end

        vgui.Create("arb.MonoAcademyCharter")
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_gamelog", "icon16/calendar_edit.png", {
    onRun = function(client)
        if SERVER then return false end

        vgui.Create("arb.MonoGameLog")
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_statuseffects", "icon16/pill_go.png", {
    onRun = function(client)
        if SERVER then return false end

        vgui.Create("Medical:StatusEffectsEdit")
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_freezeall", "icon16/shading.png", {
    onRun = function(client)
        if CLIENT then return end

        for k, v in pairs(player.GetNoAdmins()) do
            if v:IsSpectate() then continue end

            v:Freeze(true)
        end
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_unfreezeall", "icon16/shape_move_front.png", {
    onRun = function(client)
        if CLIENT then return end

        for k, v in pairs(player.GetNoAdmins()) do
            v:Freeze(false)
        end
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_setepisode", "icon16/color_swatch.png", {
    onRun = function(client)
        if SERVER then return false end

        local dermaPanel = DermaMenu()
        local data = {"#episode_missing", "#episode_prologue", "#episode_epilogue"}

        for i = 1, 9 do
            data[#data + 1] = "#episode_" .. i
        end

        for k, v in ipairs(data) do
            dermaPanel:AddOption(L(v), function()
                asterionlib.EmitSound(PLUGIN.ClickSound)
                netstream.Start("arb.MonoSetChapter", v)
            end)
        end

        local customButton = dermaPanel:AddOption(L("#episode_custom"), function()
            Derma_StringRequest(L("#episode_custom_title"), L("#episode_custom_description"), L(Arbitrage.GetChapter()), function(text)
                asterionlib.EmitSound(PLUGIN.ClickSound)
                netstream.Start("arb.MonoSetChapter", text)
            end)
        end)
        customButton:SetIcon("icon16/pencil.png")

        dermaPanel:Open()
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_whitelist", "icon16/application_view_list.png", {
    onRun = function(client)
        if CLIENT then return end

        Whitelist:OpenMenu(client)
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_addonmenu", "icon16/database_gear.png", {
    onRun = function(client)
        if CLIENT then return end

        WORKSHOP:OpenMenu(client)
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_itemlist", "icon16/table_edit.png", {
    onRun = function(client)
        if SERVER then return end

        vgui.Create("ItemBase:CreationMenu")
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_charlist", "icon16/group_edit.png", {
    onRun = function(client)
        if SERVER then return end

        vgui.Create("Character:CreationMenu")
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_colorcorrection", "icon16/color_wheel.png", {
    onRun = function(client)
        if SERVER then return end

        vgui.Create("ColorModify:Menu")
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_musicplayer", "icon16/music.png", {
    onRun = function(client)
        if CLIENT then return end

        ScriptMusic:OpenMenu(client)
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_clearstats", "icon16/chart_line.png", {
    onRun = function(client)
        if CLIENT then return end

        for k, v in ipairs(player.GetAll()) do
            v:SetHealth(ARBITRAGE_HEALTH)
            v:SetArmor(ARBITRAGE_ARMOR)

            for k2, v2 in pairs(Arbitrage.statistics.list) do
                Arbitrage.statistics.Set(v, v2.data, 100)
            end
        end
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_stopsound", "icon16/sound_none.png", {
    onRun = function(client)
        if CLIENT then return end

        for k, v in ipairs(player.GetAll()) do
            v:ConCommand("stopsound")
        end
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_clearclues", "icon16/bug_delete.png", {
    onRun = function(client)
        if CLIENT then return end

        for k, v in ipairs(ents.GetAll()) do
            if v:GetEvidence() then
                v:Remove()
            end
        end

        Evidence.list = {}
        netstream.Start(nil, "Evidence:Clear")
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_clearchat", "icon16/application_delete.png", {
    onRun = function(client)
        if CLIENT then return end

        for k, v in ipairs(player.GetAll()) do
            v:SendLua([[
                RunConsoleCommand("arb_chatbox_reload")

                timer.Simple(0.5, function()
                    Arbitrage.commands.Notify(nil, "#chat_admin_clear")
                end)
            ]])
        end
    end
})

MonoMenu:AddGameFunction("Изменить время", "icon16/time.png", {
    onRun = function(client)
        if SERVER then return end
        vgui.Create("arb.timeChangeMenu")
    end
})


MonoMenu:AddGameFunction("#monomenu_gm_mapreversion", "icon16/script_code_red.png", {
    isCheckBox = true,
    onEnable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OnMapReversion", true)
    end,
    onDisable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OnMapReversion", false)
    end,
    OnCheck = function(client)
        return Arbitrage.OnMapReversion()
    end
})

MonoMenu:AddGameFunction("Система знакомств", "icon16/heart_add.png", {
    isCheckBox = true,
    onEnable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OnRecognizeDisable", false)
    end,
    onDisable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OnRecognizeDisable", true)
    end,
    OnCheck = function(client)
        return !Arbitrage.OnRecognizeDisable()
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_gmtheme", "icon16/css.png", {
    isCheckBox = true,
    onEnable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OnGamemasterTheme", true)
    end,
    onDisable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OnGamemasterTheme", false)
    end,
    OnCheck = function(client)
        return Arbitrage.OnGamemasterTheme()
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_tabmenu", "icon16/information.png", {
    isCheckBox = true,
    onEnable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffShowFactions", false)
    end,
    onDisable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffShowFactions", true)
    end,
    OnCheck = function(client)
        return !Arbitrage.OffShowFactions()
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_daynight", "icon16/bell.png", {
    isCheckBox = true,
    onEnable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffSoundNightAndDay", false)
    end,
    onDisable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffSoundNightAndDay", true)
    end,
    OnCheck = function(client)
        return !Arbitrage.OffSoundNightAndDay()
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_ctname", "icon16/chart_curve_add.png", {
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

MonoMenu:AddGameFunction("#monomenu_gm_rebuttal", "icon16/photos.png", {
    isCheckBox = true,
    onEnable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffRebuttalShowdown", false)
    end,
    onDisable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffRebuttalShowdown", true)

        if LawSystem.IsRebuttalShowdowns then
            LawSystem:EndRebuttalShowdowns()
        end
    end,
    OnCheck = function(client)
        return !Arbitrage.OffRebuttalShowdown()
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_oocchat", "icon16/world.png", {
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

MonoMenu:AddGameFunction("#monomenu_gm_hunger", "icon16/cup.png", {
    isCheckBox = true,
    onEnable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffFallHunger", false)
    end,
    onDisable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffFallHunger", true)
        for k, v in ipairs(player.GetAll()) do
            Arbitrage.statistics.Set(v, "Hunger", 100)
        end
    end,
    OnCheck = function(client)
        return !Arbitrage.OffFallHunger()
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_thirst", "icon16/cup.png", {
    isCheckBox = true,
    onEnable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffFallThirst", false)
    end,
    onDisable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffFallThirst", true)
        for k, v in ipairs(player.GetAll()) do
            Arbitrage.statistics.Set(v, "Thirst", 100)
        end
    end,
    OnCheck = function(client)
        return !Arbitrage.OffFallThirst()
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_sleep", "icon16/cup.png", {
    isCheckBox = true,
    onEnable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffFallSleep", false)
    end,
    onDisable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffFallSleep", true)
        for k, v in ipairs(player.GetAll()) do
            Arbitrage.statistics.Set(v, "Sleep", 100)
        end
    end,
    OnCheck = function(client)
        return !Arbitrage.OffFallSleep()
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_death", "icon16/transmit.png", {
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

MonoMenu:AddGameFunction("#monomenu_gm_discovery", "icon16/camera_delete.png", {
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

MonoMenu:AddGameFunction("#monomenu_gm_culpritcorpse", "icon16/camera_go.png", {
    isCheckBox = true,
    onEnable = function(client)
        if CLIENT then return end

        SetNetVar("arb.KillerDetectsCorpses", true)
    end,
    onDisable = function(client)
        if CLIENT then return end

        SetNetVar("arb.KillerDetectsCorpses", false)
    end,
    OnCheck = function(client)
        return Arbitrage.KillerDetectsCorpses()
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_portraits", "icon16/tag_blue_delete.png", {
    isCheckBox = true,
    onEnable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffSpawnDeadTablets", false)
    end,
    onDisable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffSpawnDeadTablets", true)
    end,
    OnCheck = function(client)
        return !Arbitrage.OffSpawnDeadTablets()
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_alarm", "icon16/camera_error.png", {
    isCheckBox = true,
    onEnable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffSoundMassFindCorpse", false)
    end,
    onDisable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffSoundMassFindCorpse", true)
    end,
    OnCheck = function(client)
        return !Arbitrage.OffSoundMassFindCorpse()
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_corpsespawn", "icon16/status_online.png", {
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

MonoMenu:AddGameFunction("#monomenu_gm_autoinvestigation", "icon16/cd_add.png", {
    isCheckBox = true,
    onEnable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffAutoInvestigation", false)
    end,
    onDisable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffAutoInvestigation", true)
    end,
    OnCheck = function(client)
        return !Arbitrage.OffAutoInvestigation()
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_collectclues", "icon16/folder_magnify.png", {
    isCheckBox = true,
    onEnable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffPickingEvidence", false)
    end,
    onDisable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffPickingEvidence", true)
    end,
    OnCheck = function(client)
        return !Arbitrage.OffPickingEvidence()
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_givemonopad", "icon16/application_xp_terminal.png", {
    isCheckBox = true,
    onEnable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffGiveMonopads", false)
    end,
    onDisable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffGiveMonopads", true)
    end,
    OnCheck = function(client)
        return !Arbitrage.OffGiveMonopads()
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_monopad_global", "icon16/world_add.png", {
    isCheckBox = true,
    onEnable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffMonopadGlobalChat", false)
    end,
    onDisable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffMonopadGlobalChat", true)
    end,
    OnCheck = function(client)
        return !Arbitrage.OffMonopadGlobalChat()
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_thirdperson", "icon16/magnifier_zoom_in.png", {
    isCheckBox = true,
    onEnable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OnThirdPerson", true)
    end,
    onDisable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OnThirdPerson", false)
    end,
    OnCheck = function(client)
        return Arbitrage.OnThirdPerson()
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_giveweapons", "icon16/gun.png", {
    isCheckBox = true,
    onEnable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffGiveWeapons", false)
    end,
    onDisable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffGiveWeapons", true)
    end,
    OnCheck = function(client)
        return !Arbitrage.OffGiveWeapons()
    end
})

MonoMenu:AddGameFunction("#monomenu_gm_giveitems", "icon16/wand.png", {
    isCheckBox = true,
    onEnable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffGiveItems", false)
    end,
    onDisable = function(client)
        if CLIENT then return end

        SetNetVar("arb.OffGiveItems", true)
    end,
    OnCheck = function(client)
        return !Arbitrage.OffGiveItems()
    end
})

--[[
    АДМИНСКИЕ ФУНКЦИИ
]]--
MonoMenu:AddAdminFunction("#monomenu_admin_role", "icon16/star.png", {
    onRun = function(client)
        if CLIENT then return end

        Character.team:Join(client, TEAM_ADMIN, true)
    end,
    onCreate = function(client)
        return client:Team() != TEAM_ADMIN
    end
})

MonoMenu:AddAdminFunction("#monomenu_admin_tools", "icon16/basket_put.png", {
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

MonoMenu:AddAdminFunction("#monomenu_admin_invisibletools", "icon16/monitor_delete.png", {
    isCheckBox = true,
    onEnable = function(client)
        if CLIENT then return end

        local weaponList = client:GetWeapons()
        for _, weapon in ipairs(weaponList) do
            local class = weapon:GetClass()

            if MonoMenu.activityInfo[class] then
                weapon:SetHoldType("normal")
                weapon:SetNoDraw(true)
            end
        end

        client:SetNetVar("bHideTools", true)
        netstream.Start(nil, "MonoMenu:InvisibleTools")
    end,
    onDisable = function(client)
        if CLIENT then return end

        local weaponList = client:GetWeapons()
        for _, weapon in ipairs(weaponList) do
            local class = weapon:GetClass()

            if MonoMenu.activityInfo[class] then
                weapon:SetHoldType("revolver")
                weapon:SetNoDraw(false)
            end
        end

        client:SetNetVar("bHideTools", false)
        netstream.Start(nil, "MonoMenu:InvisibleTools")
    end,
    OnCheck = function(client)
        return client:GetNetVar("bHideTools", false)
    end
})

MonoMenu:AddAdminFunction("#monomenu_admin_globalvoice", "icon16/sound_low.png", {
    isCheckBox = true,
    onEnable = function(client)
        if CLIENT then return end

        client:SetNetVar("arbGlobalVoice", true)
    end,
    onDisable = function(client)
        if CLIENT then return end

        client:SetNetVar("arbGlobalVoice", nil)
    end,
    OnCheck = function(client)
        return client:GetNetVar("arbGlobalVoice")
    end
})

MonoMenu:AddAdminFunction("#monomenu_admin_fullbright", "icon16/lightbulb.png", {
    isCheckBox = true,
    onEnable = function(client)
        if SERVER then return end

        MonoMenu.onFullBright = true
    end,
    onDisable = function(client)
        if SERVER then return end

        MonoMenu.onFullBright = false
    end,
    OnCheck = function(client)
        return MonoMenu.onFullBright
    end
})

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_plugin.lua")