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

Arbitrage.DisableElements = Arbitrage.DisableElements or {}
Arbitrage.gui = Arbitrage.gui or {}

local function aEqualto(b, c)
    if b == c then
        return true
    else
        for i = 1, 12 do
            if b == (c - i) or b == (c + i) then
                return true
            end
        end
    end

    return false
end

local isSixByNine = nil

local function IsSixByNine()
    if isSixByNine == nil then
        isSixByNine = aEqualto(ScrW(), math.Round(ScrH() * 1.77777777778))
    end

    return isSixByNine
end

local testSize = 1.5 -- ScrW() / (ScrW() * 0.65)
function Arbitrage.ResolutionW(size)
    return IsSixByNine() and ScrW() * (size / 1920) or math.Clamp(1920 * (size / 1920) / testSize, 0, ScrW())
end

function Arbitrage.ResolutionH(size)
    return IsSixByNine() and ScrH() * (size / 1080) or math.Clamp(1080 * (size / 1080) / testSize, 0, ScrH())
end

W = Arbitrage.ResolutionW
H = Arbitrage.ResolutionH

Arbitrage.Gradients = {
    [GRADIENT_CENTER] = surface.GetTextureID("gui/center_gradient"),
    [GRADIENT_RIGHT] = surface.GetTextureID("vgui/gradient-r"),
    [GRADIENT_LEFT] = surface.GetTextureID("vgui/gradient-l"),
    [GRADIENT_DOWN] = surface.GetTextureID("vgui/gradient-d"),
    [GRADIENT_UP] = surface.GetTextureID("vgui/gradient-u"),
    [GRADIENT_ROUNDING] = Arbitrage.GetMaterial("vgui/gradient-rounding.png")
}

function Arbitrage.DrawGradient(gradientType, x, y, width, height, color)
    local data = Arbitrage.Gradients[gradientType]
    if !data then return end

    surface.SetDrawColor(color)
    surface.SetTexture(data)
    surface.DrawTexturedRect(x, y, width, height)
end

function Arbitrage.DrawTextBlur(text, font, x, y, color, xAlign)
    local alpha = color.a or 255
    if alpha <= 0.01 then return end

    local font_name = string.match(font, "%a+.%a+_%a+")
    local font_size = string.match(font, "%d+")

    local font_normal = font_name .. "BlurN_" .. font_size
    local font_blur = font_name .. "Blur_" .. font_size

    for i = 1, 2 do
        draw.SimpleText(text, font_blur, x, y, ColorAlpha(Color(254, 110, 21), alpha), xAlign)
    end

    draw.SimpleText(text, font_normal, x, y, color, xAlign)
end

function Arbitrage.DrawOutlinedRectBlur(x, y, w, h, color, thickness, size)
    local alpha = color.a or 255
    if alpha <= 0.01 then return end

    local color_blur = ColorAlpha(Color(254, 110, 21), alpha)

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

function Arbitrage.GetChapter()
    return !GetNetVar("arb.Chapter") and "Эпизод отсутствует" or GetNetVar("arb.Chapter")
end

function Arbitrage.GetTime()
    local thisTime = Arbitrage.ReturnTime()

    local hours = math.floor(math.fmod(thisTime, 86400) / 3600)
    local minutes = math.floor(math.fmod(thisTime, 3600) / 60)

    local _h = string.format("%d", hours)
    local _m = string.format("%d", minutes)

    if tonumber(_h) < 10 then _h = "0" .. _h end
    if tonumber(_m) < 10 then _m = "0" .. _m end

    return Format("%s:%s", _h, _m)
end

function Arbitrage.IsClient(client)
    return client == LocalPlayer()
end

function Arbitrage.AddDisableElement(data)
    if !data then return end

    Arbitrage.DisableElements[data] = true
end

Arbitrage.hud.AddCircle("health", {
    value = function()
        return LocalPlayer():Health()
    end,
    color = Color(255, 61, 96),
    image = Arbitrage.GetMaterial("danganronpa/hud/health.png")
})

Arbitrage.hud.AddCircle("hunger", {
    value = function()
        return Arbitrage.statistics.Get(LocalPlayer(), "hunger")
    end,
    color = Color(255, 220, 228),
    image = Arbitrage.GetMaterial("danganronpa/hud/hunger.png")
})

Arbitrage.hud.AddCircle("thirst", {
    value = function()
        return Arbitrage.statistics.Get(LocalPlayer(), "thirst")
    end,
    color = Color(255, 220, 228),
    image = Arbitrage.GetMaterial("danganronpa/hud/thirst.png")
})

Arbitrage.hud.AddCircle("sleep", {
    value = function()
        return Arbitrage.statistics.Get(LocalPlayer(), "sleep")
    end,
    color = Color(255, 220, 228),
    image = Arbitrage.GetMaterial("danganronpa/hud/sleep.png")
})

function Arbitrage:HUDPaint()
    if !Arbitrage.hud then return end

    Arbitrage.hud.SpectateDraw()
    Arbitrage.hud.CrosshairDraw()
    Arbitrage.hud.StaminaDraw()
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

function Arbitrage:KeyPress(client, key)
    if key == IN_USE and client:oldAlive() then
        local entity = Arbitrage.ReturnEntity(client)

        if IsValid(entity) then
            local action = Arbitrage.actionlist[entity:GetClass()]
            if !action then return end

            local parentMenu = DermaMenu()

            for k, v in pairs(action) do
                if v.isadmin and !LocalPlayer():IsAdmin() then continue end

                local panel = parentMenu:AddOption(k, function()
                    netstream.Start("arb.ActionEntity", entity, k)
                end)

                if v.icon then
                    panel:SetIcon(v.icon)
                end
            end

            parentMenu:Open(ScrW() / 2, ScrH() / 2)
        end
    end
end

function Arbitrage:HUDShouldDraw(name)
    if Arbitrage.DisableElements[name] then
        return false
    end
end

function Arbitrage:ContextMenuOpen()
    gui.EnableScreenClicker(true)

    local client = LocalPlayer()
    local weapon = client:GetActiveWeapon()

    if IsValid(weapon) then
        local class = weapon:GetClass()
        if !class then return false end

        if class == "gmod_tool" or class == "weapon_physgun" then
            return true
        end

        return false
    end

    return true
end

function Arbitrage:ArbitrageContextMenu(data)
    for k, v in pairs(ARBITRAGE_CONTEXT_DATA.dance) do
        data:AddDance(v, k)
    end

    for k, v in pairs(ARBITRAGE_CONTEXT_DATA.action) do
        local mat = v[1] and Arbitrage.GetMaterial(v[1])
        local func = v[2]

        data:AddAction(k, func, mat)
    end
end

function Arbitrage:KeyPressID(client, id, bIsVisibleGUI)
    if bIsVisibleGUI then return end

    local isUseTool = false
    local weapon = client:GetActiveWeapon()

    if IsValid(weapon) then
        local class = weapon:GetClass()
        if !class then return false end

        isUseTool = class == "gmod_tool" or class == "weapon_physgun"
    end

    if id == "open_context" and !IsValid(Arbitrage.gui.context) and !IsValid(Arbitrage.menu) and !isUseTool and !Arbitrage.gui.chat:GetActive() then
        vgui.Create("arb.ContextMenu")
    elseif id == "open_scoreboard" and !IsValid(Arbitrage.menu) and !Arbitrage.gui.chat:GetActive() then
        if IsValid(Arbitrage.gui.scoreboard) then
            Arbitrage.gui.scoreboard:Remove()
        end

        vgui.Create("arb.ScoreBoard")
    elseif id == "open_mainmenu_ui" then
        if IsValid(Arbitrage.menu) then
            Arbitrage.menu:AlphaTo(0, 0.3, 0, function()
                Arbitrage.menu:Remove()
            end)

            return
        end

        local panel = vgui.Create("arb.MainRemake:UI")
        panel:Menu()
    elseif id == "open_monomenu_ui" then
        if IsValid(Arbitrage.gui.monomenu) then
            Arbitrage.gui.monomenu:AlphaTo(0, 0.3, 0, function()
                Arbitrage.gui.monomenu:Remove()
            end)

            return
        end

        netstream.Start("arb.OpenMonoMenu")
    elseif id == "open_material_ui" then
        if IsValid(Arbitrage.gui.logmenu) then
            Arbitrage.gui.logmenu:AlphaTo(0, 0.3, 0, function()
                Arbitrage.gui.logmenu:Remove()
            end)

            return
        end

        Arbitrage.gui.logmenu = vgui.Create("arb.EvidenceMenu")
    elseif id == "open_interface" then
        if IsValid(Arbitrage.gui.inventory) then
            Arbitrage.gui.inventory:SetMouseInputEnabled(false)

            Arbitrage.gui.inventory:AlphaTo(0, 0.5, 0, function()
                Arbitrage.gui.inventory:Remove()
            end)

            return
        end

        if !vgui.CursorVisible() then
            vgui.Create("InventoryBase:Menu")
        end
    end
end

function Arbitrage:KeyReleaseID(client, id)
    if id == "open_context" and IsValid(Arbitrage.gui.context) then
        Arbitrage.gui.context:AlphaTo(0, 0.1, 0, function()
            Arbitrage.gui.context:Remove()
        end)
    elseif id == "open_scoreboard" and IsValid(Arbitrage.gui.scoreboard) then
        Arbitrage.gui.scoreboard:SetMouseInputEnabled(false)
        Arbitrage.gui.scoreboard:SetKeyboardInputEnabled(false)

        Arbitrage.gui.scoreboard:AlphaTo(0, 0.5, 0, function()
            Arbitrage.gui.scoreboard:Remove()
        end)
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

function Arbitrage:IsDeveloping()
    local client = LocalPlayer()

    if !client:IsAdmin() then return false end

    return GetConVar("developer"):GetInt() > 0
end

function Arbitrage:ChatText(index, name, text, type)
    return ARBITRAGE_DISABLE_DATA[type]
end

function Arbitrage:OnSettingsLoad()
    Arbitrage.menu = vgui.Create("arb.MainRemake:UI")

    if SETTINGS.options.Get("show_beta_test") then
        Arbitrage.menu:Menu()
    else
        Arbitrage.menu:Intro()
    end

    RunConsoleCommand("stopsound")
end

function Arbitrage:PreDrawViewModel(vm, client, weapon)
    if client:IsSpectate() then
        return true
    end
end


timer.Create("arb.DayChangeNotifications", 1, 0, function()
    if !Arbitrage.IsStartGame() then return end
    if LocalPlayer().IsPlaying and !LocalPlayer():IsPlaying() then return end

    local oldType = Arbitrage.IsDay()

    timer.Simple(1, function()
        if oldType != Arbitrage.IsDay() then
            local data = Arbitrage.IsDay() and "Наступило дневное время!" or "Наступило ночное время!"

            Arbitrage.notify.NotifyChat(data)
            LocalPlayer():EmitSound("dingdong.wav")
        end
    end)
end)

timer.Create("arb.BillSound", 1, 1, function()
    timer.Remove("arb.BillSound")

    system.FlashWindow()
    sound.PlayFile("sound/hl1/fvox/bell.wav", "", function() end)
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

netstream.Hook("arb.OpenMainMenu", function(bState)
    local panel = vgui.Create("arb.MainRemake:UI")

    if bState then
        panel:Menu()
    else
        panel:Intro()
    end
end)

netstream.Hook("arb.OpenDeathMenu", function()
    vgui.Create("arb.DeathMenu")
end)

netstream.Hook("arb.PlayerSetAnim", function(client, slot, activity, autokill)
    if !IsValid(client) then return end

    client:AnimRestartGesture(slot, activity, autokill)
end)