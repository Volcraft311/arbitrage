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

    local font_name = string.match(font, "%a+.%a+_%a+")
    local font_size = string.match(font, "%d+")

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
        local upperText = string.format("%s (%s/%s)", Arbitrage.GetChapter(), #player.GetAll(), game.MaxPlayers())
        local lowerText = string.format("%s [%s]", Arbitrage.GetTheme(), Arbitrage.IsDay() and "День" or "Ночь")

    	rpc:Set("details", upperText)
        rpc:Set("state", lowerText)

        local faction = Character.team:GetByID(client:Team())
        if faction then
        	local username = client:Name()
        	local steamname = client:SteamName()
        	local factionname = faction:GetName()

        	local lImageText = "Играет за персонажа: " .. (username == steamname and (factionname and factionname or "Не выбран") or username)
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

function Arbitrage:HUDPaint()
    Arbitrage.hud.SpectateDraw()
    Arbitrage.hud.CrosshairDraw()
    Arbitrage.hud.PlayerInfoDraw()
    Arbitrage.hud.ALTMenuDraw()
    Arbitrage.action.Draw()
    Arbitrage.evidence.Draw()
end

function Arbitrage:RenderScreenspaceEffects()
    Arbitrage.hud.GrayCorrect()
    Arbitrage.hud.VignetteDraw()
    Arbitrage.hud.LowHealthDraw()
end

netstream.Hook("arb.OpenURL", function(data)
    if !data then return end

    gui.OpenURL(tostring(data))
end)

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

function Arbitrage:HUDShouldDraw(name)
    if Arbitrage.DisableElements[name] then
        return false
    end
end

function Arbitrage:ContextMenuOpen()
    gui.EnableScreenClicker(true)

    return LocalPlayer():IsHoldingSBoxTool()
end

function Arbitrage:ArbitrageContextMenu(data)
    for k, v in pairs(ARBITRAGE_CONTEXT_DATA.dance) do
        data:AddDance(v, k)
    end

    for k, v in pairs(ARBITRAGE_CONTEXT_DATA.action) do
        local mat = v[1] and Material(v[1])
        local func = v[2]

        data:AddAction(k, func, mat)
    end

    if LocalPlayer():IsToko() then
        data:AddAction("Вкл/Откл случайные чихания", function(client)
            netstream.Start("arb.TokoSneezing")
        end)
    end

    local character = Character.team:GetByID(LocalPlayer():Team())
    if !character then return end

    local uniqueID = character:GetUniqueID()
    if uniqueID == "chiaki" or uniqueID == "himiko" then
        data:AddAction("Уснуть/Проснуться", function(client)
            netstream.Start("arb.Sleeping")
        end)
    end
end

local ActionPressIDList = {
    ["open_context"] = function(client, id, bIsVisibleGUI)
        if bIsVisibleGUI then return end
        if client:IsHoldingSBoxTool() then return end

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
        if bIsVisibleGUI then return end

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

        if !monopad then
            return chat.AddText("У вас нету монопада!")
        end


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
            vgui.Create("InventoryBase:Menu")
        end
    end
}

function Arbitrage:KeyPressID(client, id, bIsVisibleGUI)
    if ActionPressIDList[id] then
        ActionPressIDList[id](client, id, bIsVisibleGUI)
    end
end

local ActionReleaseIDList = {
    ["open_context"] = function(client, id, bIsVisibleGUI)
        if IsValid(Arbitrage.gui.context) then
            Arbitrage.gui.context:AlphaTo(0, 0.1, 0, function()
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

function Arbitrage:KeyReleaseID(client, id, bIsVisibleGUI)
    if ActionReleaseIDList[id] then
        ActionReleaseIDList[id](client, id, bIsVisibleGUI)
    end
end


function Arbitrage:OnContextMenuClose()
    gui.EnableScreenClicker(false)
end

function Arbitrage:SpawnMenuOpen()
    local client = LocalPlayer()
    local weapon = client:GetActiveWeapon()

    if IsValid(weapon) then
        local class = weapon:GetClass()
        if !class then return false end

        return class == "gmod_tool" or class == "weapon_physgun"
    end

    return false
end

function Arbitrage:ChatText(index, name, text, type)
    return ARBITRAGE_DISABLE_DATA[type]
end

function Arbitrage:OnSettingsLoad()
    local panel = asterionlib.netgui:Create("arb.MainRemake:UI")

    if SETTINGS.options.Get("show_beta_test") then
        panel:Menu()
    else
        panel:Intro()
    end

    RunConsoleCommand("stopsound")
end

function Arbitrage:PreDrawViewModel(vm, client, weapon)
    if client:IsSpectate() then
        return true
    end
end

local function DingDongBingBong()
    timer.Simple(2, function() -- Исправление проблемы с текстом
        local data = Arbitrage.IsDay() and "Наступило дневное время!" or "Наступило ночное время!"
        Arbitrage.notify.NotifyChat(data)

        if !Arbitrage.lawEnable then
            asterionlib.EmitSound("dingdong.wav")
        end
    end)

    Arbitrage.DingDongBingBongCD = CurTime() + 5
end


timer.Create("arb.DayChangeNotifications", 1, 0, function()
    if !Arbitrage.IsStartGame() then return end
    if LocalPlayer().IsPlaying and !LocalPlayer():IsPlaying() then return end
    if Arbitrage.OffSoundNightAndDay() then return end

    local oldType = Arbitrage.IsDay()

    timer.Simple(1, function()
        if oldType != Arbitrage.IsDay() then
            if (!Arbitrage.DingDongBingBongCD or CurTime() >= Arbitrage.DingDongBingBongCD) then
                DingDongBingBong()
            end
        end
    end)
end)

timer.Create("arb.BillSound", 1, 1, function()
    timer.Remove("arb.BillSound")

    system.FlashWindow()
    sound.PlayFile("sound/hl1/fvox/bell.wav", "", zero)
end)

function Arbitrage:GetPos(client)
    local pos, ang = client:GetPos() + Vector(0, 0, 64), client:GetAngles()

    return pos, ang
end

concommand.Add("arb_getpos", function(client, cmd, args)
    local r = math.Round
    local m_r = 3
    local pos, ang = Arbitrage:GetPos(client)
    local text = Format("Vector(%s, %s, %s), Angle(%s, %s, %s)",
        r(pos.x, m_r), r(pos.y, m_r), r(pos.z, m_r),
        r(ang[1], m_r), r(ang[2], m_r), r(ang[3], m_r))

    MsgC(Color(0, 255, 0), text .. "\n")
end)


netstream.Hook("arb.SendMessage", function(...)
    chat.AddText(...)
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