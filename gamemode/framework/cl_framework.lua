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

Arbitrage.DisableElements = Arbitrage.DisableElements or {}
Arbitrage.gui = Arbitrage.gui or {}

Arbitrage.Gradients = {
    [GRADIENT_CENTER] = surface.GetTextureID("gui/center_gradient"),
    [GRADIENT_RIGHT] = surface.GetTextureID("vgui/gradient-r"),
    [GRADIENT_LEFT] = surface.GetTextureID("vgui/gradient-l"),
    [GRADIENT_DOWN] = surface.GetTextureID("vgui/gradient-d"),
    [GRADIENT_UP] = surface.GetTextureID("vgui/gradient-u"),
    [GRADIENT_ROUNDING] = Material("vgui/gradient-rounding.png")
}

function Arbitrage.DrawGradient(gradientType, x, y, width, height, color)
    local data = Arbitrage.Gradients[gradientType]

    surface.SetDrawColor(color)
    surface.SetTexture(data)
    surface.DrawTexturedRect(x, y, width, height)
end

function Arbitrage.DrawTextBlur(text, font, x, y, color, xAlign, cb)
    local alpha = color.a or 255
    if alpha <= 0.01 then return end

    local font_name = font:match("%a+.%a+_%a+")
    local font_size = font:match("%d+")

    local font_normal = font_name .. "BlurN_" .. font_size
    local font_blur = font_name .. "Blur_" .. font_size

    cb = cb or Color(254, 110, 21)
    local color_blur = ColorAlpha(cb, alpha)

    for i = 1, 2 do
        draw.SimpleText(text, font_blur, x, y, color_blur, xAlign)
    end

    draw.SimpleText(text, font_normal, x, y, color, xAlign)
end

function Arbitrage.DrawOutlinedRectBlur(x, y, w, h, color, thickness, size, cb)
    local alpha = color.a or 255
    if alpha <= 0.01 then return end

    cb = cb or Color(254, 110, 21)
    local color_blur = ColorAlpha(cb, alpha)

    Arbitrage.DrawGradient(GRADIENT_DOWN, x, y - size, w, size, color_blur)
    Arbitrage.DrawGradient(GRADIENT_UP, x, y + h, w, size, color_blur)
    Arbitrage.DrawGradient(GRADIENT_RIGHT, x - size, y, size, h, color_blur)
    Arbitrage.DrawGradient(GRADIENT_LEFT, x + w, y, size, h, color_blur)

    surface.SetDrawColor(color_blur)
    surface.SetMaterial(Arbitrage.Gradients[GRADIENT_ROUNDING])
    surface.DrawTexturedRectRotated(x - size / 2, y - size / 2, size, size, 180)
    surface.DrawTexturedRectRotated(x + w + size / 2, y - size / 2, size, size, 90)
    surface.DrawTexturedRectRotated(x - size / 2, y + h + size / 2, size, size, -90)
    surface.DrawTexturedRectRotated(x + w + size / 2, y + h + size / 2, size, size, 0)

    surface.SetDrawColor(color)
    surface.DrawOutlinedRect(x, y, w, h, thickness)
end

function Arbitrage.AddDisableElement(data)
    if !data then return end

    Arbitrage.DisableElements[data] = true
end

do
    Arbitrage.AddDisableElement("CHudHealth")
    Arbitrage.AddDisableElement("CHudBattery")
    Arbitrage.AddDisableElement("CHudAmmo")
    Arbitrage.AddDisableElement("CHudCrosshair")
    Arbitrage.AddDisableElement("CHudDeathNotice")
    Arbitrage.AddDisableElement("CTargetID")
    Arbitrage.AddDisableElement("CHudHintDisplay")
    Arbitrage.AddDisableElement("CHudSuitPower")
    Arbitrage.AddDisableElement("CHudHistoryResource")
    Arbitrage.AddDisableElement("CHudZoom")
end

do
    Arbitrage.hud.AddCircle("health", {
        value = function()
            return LocalPlayer():Health() or 100
        end,
        color = Color(255, 61, 96),
        image = Material("danganronpa/hud/health.png")
    })

    Arbitrage.hud.AddCircle("hunger", {
        value = function()
            return Arbitrage.statistics.Get(LocalPlayer(), "hunger") or 100
        end,
        color = Color(255, 220, 228),
        image = Material("danganronpa/hud/hunger.png")
    })

    Arbitrage.hud.AddCircle("thirst", {
        value = function()
            return Arbitrage.statistics.Get(LocalPlayer(), "thirst") or 100
        end,
        color = Color(255, 220, 228),
        image = Material("danganronpa/hud/thirst.png")
    })

    Arbitrage.hud.AddCircle("sleep", {
        value = function()
            return Arbitrage.statistics.Get(LocalPlayer(), "sleep") or 100
        end,
        color = Color(255, 220, 228),
        image = Material("danganronpa/hud/sleep.png")
    })
end

do
    local rpc = asterionlib.rpc

    rpc:Set("smallImageKey", "small")
    rpc:Set("largeImageKey", "big")

    rpc:Set("buttonText", "Присоединиться")
    rpc:Set("buttonURL", "https://asterion.games")
    rpc:Set("smallImageText", "Карта: " .. game.GetMap())

    hook.Add("asterionlib.rpc:AppID", "asterionlib.rpc", function()
        return "948976762136719380"
    end)

    hook.Add("asterionlib.rpc:Update", "asterionlib.rpc", function()
    	local client = LocalPlayer()
        local upperText = ("%s (%s/%s)"):format(Arbitrage.GetChapter(), #player.GetAll(), game.MaxPlayers())
        local lowerText = ("%s [%s]"):format(Arbitrage.GetTheme(), Arbitrage.IsDay() and L("#discord_rpc_day") or L("#discord_rpc_night"))

    	rpc:Set("details", upperText)
        rpc:Set("state", lowerText)

        local faction = Character.team:GetByID(client:Team())
        if faction then
        	local username = client:Name()
        	local steamname = client:SteamName()
        	local factionname = faction:GetName()

        	local lImageText = L("#discord_rpc_image_text") .. " " .. (username == steamname and (factionname and factionname or L("#discord_rpc_image_unknown")) or username)
        	rpc:Set("largeImageText", lImageText)

        	local lImageKey = faction:GetUniqueID() or "big"
        	rpc:Set("largeImageKey", lImageKey)
        end
    end)
end

do
    hook.Add("asterionlib.cleaner:Initialize", "asterionlib.cleaner", function()
        local cleaner = asterionlib.cleaner

        -- Base
        cleaner:DeathNotice()
        cleaner:HudPickup()
        cleaner:PickTeam()
        cleaner:ScoreBoard()
        cleaner:TargetID()
        cleaner:Voice()

        -- Sandbox
        cleaner:Hints()
        cleaner:PhysgunBeam()
        cleaner:PropSpawnEffect()
        cleaner:WorldTips()
    end)
end

do
    hook.Add("asterionlib.loading:Initialize", "asterionlib.loading", function()
        local loading = asterionlib.loading
        local instances = loading.instances

        instances.image.material = Material("asterion/academy/ui/loading/image.png")
        instances.char_assets.material = Material("asterion/academy/ui/loading/char_assets.png")

        local titleFont = "arb.Font_FuturaPTMedium_9"
        local titleHeight = draw.GetFontHeight(titleFont)
        local titleColor = Color(255, 255, 255)

        local descriptionFont = "arb.Font_FuturaPTBook_5"
        local descriptionHeight = draw.GetFontHeight(descriptionFont)
        local descriptionColor = Color(255, 255, 255, 60)

        local progressFont = "arb.Font_FuturaPTHeavy_5"
        local progressHeight = 3
        local progressColor = Color(218, 19, 40)

        local padding = 20
        local sizeH = titleHeight + descriptionHeight + progressHeight + padding * 2
        function loading:Paint()
            if !self:GetConVar() then return end

            local realTime = RealTime()
            local ft = FrameTime()

            local i = 1
            for uniqueID, data in pairs(self.instances) do
                if data.maxID <= 0 then continue end

                if data.delay < realTime and data.currentID >= data.maxID then
                    self:Clear(uniqueID)

                    continue
                end

                if data.delayDelete < realTime and data.delayDelete > 0 then
                    self:Clear(uniqueID)

                    continue
                end

                local x, y = padding, padding + (i - 1) * sizeH + (i - 1) * padding + (i - 1) * 20
                local w, h = titleHeight * 20, sizeH

                asterionlib.DrawBlurAt(x, y, w, h, 2)

                surface.SetDrawColor(0, 0, 0, 180)
                surface.DrawRect(x, y, w, h)

                surface.SetDrawColor(255, 255, 255, 60)
                surface.SetMaterial(data.material)
                surface.DrawTexturedRect(x, y, h, h)

                draw.SimpleText(data.name .. ":", titleFont, padding + x, y + padding - titleHeight * 0.25, titleColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                draw.SimpleText(data.information, descriptionFont, padding + x, y + padding + titleHeight - descriptionHeight * 0.4, descriptionColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                draw.SimpleText(data.currentID .. "/" .. data.maxID, progressFont, x + w - padding, y + padding + titleHeight - descriptionHeight * 0.4, progressColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

                local mp_c = data.maxID
                local mp_mc = data.currentID
                local mp_interest = mp_mc / mp_c

                data.interest = Lerp(ft * 10, data.interest, mp_interest)

                surface.SetDrawColor(255, 255, 255, 25)
                surface.DrawRect(x + padding, y + padding + titleHeight + descriptionHeight, w - padding * 2, progressHeight)

                surface.SetDrawColor(progressColor.r, progressColor.g, progressColor.b)
                surface.DrawRect(x + padding, y + padding + titleHeight + descriptionHeight, w * data.interest - padding * 2, progressHeight)

                i = i + 1
            end
        end
    end)
end

hook("HUDPaint", function()
    Arbitrage.hud.SpectateDraw()
    Arbitrage.hud.CrosshairDraw()
end)

hook("RenderScreenspaceEffects", function()
    MapReversion:Render()

    Arbitrage.hud.GrayCorrect()
    Arbitrage.hud.VignetteDraw()
    Arbitrage.hud.LowHealthDraw()
end)

hook("HUDShouldDraw", function(name)
    if Arbitrage.DisableElements[name] then
        return false
    end
end)

hook("ContextMenuOpen", function()
    return LocalPlayer():IsHoldingSBoxTool()
end)

local ActionPressIDList = {
    ["open_context"] = function(client, id, bIsVisibleGUI)
        if bIsVisibleGUI then return end
        if client:IsHoldingSBoxTool() then return end

        if IsValid(Arbitrage.gui.context) then
            Arbitrage.gui.context:Remove()
        end

        vgui.Create("arb.ContextMenu")
    end,
    ["open_scoreboard"] = function(client, id, bIsVisibleGUI)
        if bIsVisibleGUI then return end

        if IsValid(Arbitrage.gui.scoreboard) then
            Arbitrage.gui.scoreboard:Remove()
        end

        vgui.Create("arb.ScoreBoard")
    end,
    ["open_mainmenu_ui"] = function(client, id, bIsVisibleGUI)
        if IsValid(Arbitrage.menu) then
            if IsValid(Arbitrage.menu.content) then return end

            Arbitrage.menu:AlphaTo(0, 0.3, 0, function()
                Arbitrage.menu:Remove()
            end)

            return
        end

        local panel = vgui.Create("arb.MainRemake:UI")
        panel:Menu()
    end,
    ["open_monomenu_ui"] = function(client, id, bIsVisibleGUI)
        if IsValid(Arbitrage.gui.monomenu) then
            Arbitrage.gui.monomenu:AlphaTo(0, 0.3, 0, function()
                Arbitrage.gui.monomenu:Remove()
            end)

            return
        end

        netstream.Start("arb.OpenMonoMenu")
    end,
    ["open_material_ui"] = function(client, id, bIsVisibleGUI)
        if !Arbitrage.lawEnable and bIsVisibleGUI then
            local ui = MonoPad:GetUI()
            if IsValid(ui) and ui.noWeapon then
                ui:AlphaTo(0, 0.3, 0, function()
                    ui:Remove()
                end)
            end

            return
        end

        local function findClass(class)
            for k, v in ipairs(LocalPlayer():GetWeapons()) do
                if v:GetClass() == class then
                    return v
                end
            end
        end

        if IsValid(MonoPad:GetUI()) then
            MonoPad:GetUI():AlphaTo(0, 0.3, 0, function()
                MonoPad:GetUI():Remove()
            end)

            local class = LocalPlayer():GetActiveWeaponClass()
            if class == "academy_monopad" then
                local key = findClass("academy_key")

                if key then
                    input.SelectWeapon(key)
                end
            end

            return
        end

        local monopad = nil
        local inventory = LocalPlayer():GetInventory()
        if inventory then
            local items = inventory:GetItems()

            for _, item in ipairs(items) do
                if item.uniqueID == "monopad" and item:GetData("equip") then
                    monopad = item.stored
                    break
                end
            end
        end

        if !monopad then return chat.AddText("#no_have_monopad") end

        local weapon = findClass("academy_monopad")
        if weapon and !Arbitrage.lawEnable then
            input.SelectWeapon(weapon)
        else
            local panel = MonoPad:CreateTablet()
            panel:MakePopup()
            panel.noWeapon = true

            panel:SetAlpha(0)
            panel:AlphaTo(255, 0.2)

            local w, h = panel:GetSize()
            panel:SetPos(ScrW() / 2 - w / 2, ScrH() / 2 - h / 2)

            timer.Simple(0.5, function()
                MonoPad:EnableTablet(nil, true, panel)
            end)
        end
    end,
    ["open_interface"] = function(client, id, bIsVisibleGUI)
        if IsValid(Arbitrage.gui.inventory) then
            Arbitrage.gui.inventory:SetMouseInputEnabled(false)

            Arbitrage.gui.inventory:AlphaTo(0, 0.5, 0, function()
                Arbitrage.gui.inventory:Remove()
            end)

            return
        end

        if !vgui.CursorVisible() or Arbitrage.lawEnable then
            if Arbitrage.gui.chat:GetActive() then return end

            vgui.Create("InventoryBase:Menu")
        end
    end
}

hook("KeyPressID", function(client, id, bIsVisibleGUI)
    if ActionPressIDList[id] then
        ActionPressIDList[id](client, id, bIsVisibleGUI)
    end
end)

local ActionReleaseIDList = {
    ["open_context"] = function(client, id, bIsVisibleGUI)
        if IsValid(Arbitrage.gui.context) then
            Arbitrage.gui.context:SetMouseInputEnabled(false)
            Arbitrage.gui.context:SetKeyboardInputEnabled(false)

            Arbitrage.gui.context.bClose = true

            Arbitrage.gui.context:AlphaTo(0, 0.5, 0, function()
                Arbitrage.gui.context:Remove()
            end)
        end
    end,
    ["open_scoreboard"] = function(client, id, bIsVisibleGUI)
        if IsValid(Arbitrage.gui.scoreboard) then
            Arbitrage.gui.scoreboard:SetMouseInputEnabled(false)
            Arbitrage.gui.scoreboard:SetKeyboardInputEnabled(false)

            Arbitrage.gui.scoreboard:AlphaTo(0, 0.5, 0, function()
                Arbitrage.gui.scoreboard:Remove()
            end)
        end
    end
}

hook("KeyReleaseID", function(client, id, bIsVisibleGUI)
    if ActionReleaseIDList[id] then
        ActionReleaseIDList[id](client, id, bIsVisibleGUI)
    end
end)

hook("OnContextMenuClose", function()
    gui.EnableScreenClicker(false)
end)

hook("SpawnMenuOpen", function()
    local client = LocalPlayer()
    local weapon = client:GetActiveWeapon()

    if IsValid(weapon) then
        local class = weapon:GetClass()
        if !class then return false end

        return class == "gmod_tool" or class == "weapon_physgun"
    end

    return false
end)

hook("OnSettingsLoad", function()
    local panel = asterionlib.netgui:Create("arb.MainRemake:UI")
    panel:Content()

    -- new menu...
    --[[
    local panel = vgui.Create("arb.mainmenu:Primary")
    panel.content = panel:Add("arb.mainmenu:Content")
    panel.content:Dock(FILL)
    ]]--

    RunConsoleCommand("stopsound")
end)

hook("PreDrawViewModel", function(vm, client, weapon)
    if client:IsSpectate() then
        return true
    end
end)

hook("PrePlayerDraw", function(client, flags)
    if client:IsSpectate() then
        return true
    end
end)


local function DingDongBingBong()
    timer.Simple(2, function() -- Исправление проблемы с текстом
        local data = Arbitrage.IsDay() and "#day_notification" or "#night_notification"
        Arbitrage.notify.NotifyChat(data)

        if !Arbitrage.lawEnable then
            asterionlib.EmitSound("dingdong.wav")
        end
    end)
end

local oldType = Arbitrage.IsDay()
timer.Create("arb.DayChangeNotifications", 1, 0, function()
    if !Arbitrage.IsStartGame() then return end
    if LocalPlayer().IsPlaying and !LocalPlayer():IsPlaying() then return end
    if Arbitrage.OffSoundNightAndDay() then return end

    if oldType != Arbitrage.IsDay() and (!Arbitrage.DingDongBingBongCD or CurTime() >= Arbitrage.DingDongBingBongCD) then
        DingDongBingBong()

        Arbitrage.DingDongBingBongCD = CurTime() + 5
    end

    oldType = Arbitrage.IsDay()
end)

timer.Create("arb.BillSound", 1, 1, function()
    timer.Remove("arb.BillSound")

    local panel = vgui.Create("Panel")
    panel.PlaySound = function(this)
        system.FlashWindow()
        sound.PlayFile("sound/hl1/fvox/bell.wav", "", zero)

        this:Remove()
    end
    panel.Think = function(this)
        if !IsValid(LocalPlayer()) then return end

        this.Think = nil
        this:PlaySound()
    end
end)


concommand.Add("arb_getpos", function(client, cmd, args)
    local r = math.Round
    local m_r = 3
    local pos, ang = client:GetPos() + Vector(0, 0, 64), client:GetAngles()
    local text = Format("Vector(%s, %s, %s), Angle(%s, %s, %s)",
        r(pos.x, m_r), r(pos.y, m_r), r(pos.z, m_r),
        r(ang[1], m_r), r(ang[2], m_r), r(ang[3], m_r))

    MsgC(Color(0, 255, 0), text .. "\n")
end)


netstream.Hook("arb.SendMessage", function(...)
    local data = {...}

    for k, v in ipairs(data) do
        if isstring(v) then
            data[k] = F(v)
        end
    end

    chat.AddText(unpack(data))
end)

netstream.Hook("arb.SendCommand", function(command, ...)
    RunConsoleCommand(command, unpack(...))
end)

netstream.Hook("arb.ReturnCurTime", function(data)
    if !data then return end

    Arbitrage.CurTime = tonumber(data)
end)

netstream.Hook("arb.TailentScreen", function()
    local character = Character.team:GetByID(LocalPlayer():Team())
    if !character then return end

    local assets = character:GetAssets()
    if !assets then return end

    local hud = assets.hud
    if !hud then return end

    Material(hud) -- cache

    timer.Simple(7, function()
        vgui.Create("arb.TailentScreen")
    end)
end)