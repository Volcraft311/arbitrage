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
local cacheW = {}
function Arbitrage.ResolutionW(size)
    if cacheW[size] then
        return cacheW[size]
    end

    local data = IsSixByNine() and ScrW() * (size / 1920) or math.Clamp(1920 * (size / 1920) / testSize, 0, ScrW())
    cacheW[size] = data

    return data
end

local cacheH = {}
function Arbitrage.ResolutionH(size)
    if cacheH[size] then
        return cacheH[size]
    end

    local data = IsSixByNine() and ScrH() * (size / 1080) or math.Clamp(1080 * (size / 1080) / testSize, 0, ScrH())
    cacheH[size] = data

    return data
end

W = Arbitrage.ResolutionW
H = Arbitrage.ResolutionH

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

do
    Arbitrage.hud.AddCircle("health", {
        value = function()
            return LocalPlayer():Health()
        end,
        color = Color(255, 61, 96),
        image = Material("danganronpa/hud/health.png")
    })

    Arbitrage.hud.AddCircle("hunger", {
        value = function()
            return Arbitrage.statistics.Get(LocalPlayer(), "hunger")
        end,
        color = Color(255, 220, 228),
        image = Material("danganronpa/hud/hunger.png")
    })

    Arbitrage.hud.AddCircle("thirst", {
        value = function()
            return Arbitrage.statistics.Get(LocalPlayer(), "thirst")
        end,
        color = Color(255, 220, 228),
        image = Material("danganronpa/hud/thirst.png")
    })

    Arbitrage.hud.AddCircle("sleep", {
        value = function()
            return Arbitrage.statistics.Get(LocalPlayer(), "sleep")
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

    hook.Add("asterionlib.rpc:AppID", "asterionlib.rpc", function()
        return "948976762136719380"
    end)

    hook.Add("asterionlib.rpc:Update", "asterionlib.rpc", function()
    	local client = LocalPlayer()
    	local upperText = string.format("%s [%s]", Arbitrage.GetChapter(), Arbitrage.IsDay() and "День" or "Ночь")
    	local lowerText = string.format("%s (%s/%s)", game.GetMap(), #player.GetAll(), game.MaxPlayers())

    	rpc:Set("details", upperText)
        rpc:Set("state", lowerText)

        local faction = Arbitrage.teams.Get(client:Team())
        if faction then
        	local username = client:Name()
        	local steamname = client:SteamName()
        	local factionname = faction.name

        	local lImageText = "Играет за персонажа: " .. (username == steamname and (factionname and factionname or "Не выбран") or username)
        	rpc:Set("largeImageText", lImageText)

        	local lImageKey = faction.uniqueID or "big"
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

-- OLD
-- function Arbitrage:KeyPress(client, key)
--     if key == IN_USE and client:oldAlive() then
--         local entity = Arbitrage.ReturnEntity(client)

--         if IsValid(entity) then
--             local action = Arbitrage.actionlist[entity:GetClass()]
--             if !action then return end

--             local parentMenu = DermaMenu()

--             for k, v in pairs(action) do
--                 if v.isadmin and !LocalPlayer():IsAdmin() then continue end

--                 local panel = parentMenu:AddOption(k, function()
--                     netstream.Start("arb.ActionEntity", entity, k)
--                 end)

--                 if v.icon then
--                     panel:SetIcon(v.icon)
--                 end
--             end

--             parentMenu:Open(ScrW() / 2, ScrH() / 2)
--         end
--     end
-- end

function Arbitrage:HUDShouldDraw(name)
    if Arbitrage.DisableElements[name] then
        return false
    end
end

function Arbitrage:ContextMenuOpen()
    gui.EnableScreenClicker(true)

    return LocalPlayer():IsUseTool()
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
end

local ActionPressIDList = {
    ["open_context"] = function(client, id, bIsVisibleGUI)
        if bIsVisibleGUI then return end
        if client:IsUseTool() then return end

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
        if IsValid(Arbitrage.gui.logmenu) then
            Arbitrage.gui.logmenu:AlphaTo(0, 0.3, 0, function()
                Arbitrage.gui.logmenu:Remove()
            end)

            return
        end

        Arbitrage.gui.logmenu = vgui.Create("arb.EvidenceMenu")
    end,
    ["open_interface"] = function(client, id, bIsVisibleGUI)
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

function Arbitrage:IsDeveloping()
    local client = LocalPlayer()

    if !client:IsAdmin() then return false end

    return GetConVar("developer"):GetInt() > 0
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

netstream.Hook("arb.PlayerSetAnim", function(client, slot, activity, autokill)
    if !IsValid(client) then return end

    client:AnimRestartGesture(slot, activity, autokill)
end)