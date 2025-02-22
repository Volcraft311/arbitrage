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

local PANEL = {}

function PANEL:Init()
    self:SetTitle("")
    self:SetPos(0, 0)
    self:SetSize(W(960 * 1.3), H(540 * 1.3))
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self:Center()
    self:ShowCloseButton(false)

    local close = self:Add("DButton")
    close:SetPos(self:GetWide() - H(70), 0)
    close:SetSize(H(70), H(30))
    close:SetText("")
    close.alpha = 40
    close.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 40)
        draw.DrawText("X", "arb.Font_FuturaPTBook_7", w / 2, H(4), Color(255, 255, 255, _.alpha), TEXT_ALIGN_LEFT)
    end
    close.DoClick = function()
        self:AlphaTo(0, 0.2, 0, function()
            self:Remove()
        end)
    end

    self:InitColorModify()
end

function PANEL:InitColorModify()
    self.mainPanel = self:Add("Panel")
    self.mainPanel:SetWide(W(250))
    self.mainPanel:Dock(TOP)
    self.mainPanel:DockMargin(W(5), H(45), W(5), H(5))
    self.mainPanel.Paint = function(_, w, h)
        surface.SetDrawColor(27, 10, 13, 150)
        surface.DrawRect(0, 0, w, h)
    end

    local size = H(30) + H(3) + H(20)
    local data = PLUGIN:Get()

    local enableButton = self.mainPanel:Add("DCheckBoxLabel")
    enableButton:SetTall(H(30))
    enableButton:Dock(TOP)
    enableButton:DockMargin(W(25), H(3), 0, H(20))
    enableButton:SetText("#colorcorrection_turnon")
    enableButton:SetFont("arb.Font_FuturaPTBook_8")
    enableButton:SetValue(data.enabled)
    enableButton.OnChange = function(_, value)
        netstream.Start("ColorModify:Set", "enabled", tobool(value))
    end

    for k, v in pairs(data) do
        local info = PLUGIN:GetInfo(k)
        if !info then continue end

        local panel = self.mainPanel:Add("Panel")
        panel:SetTall(H(30))
        panel:Dock(TOP)
        panel:DockMargin(0, H(3), 0, 0)

        local slider = panel:Add("DNumSlider")
        slider:Dock(FILL)
        slider:SetText(info.name)
        slider:SetMin(info.minimum)
        slider:SetMax(info.maximum)
        slider:SetDecimals(info.decimals)
        slider:SetValue(v)
        slider.OnValueChanged = function(_, value)
            if value != data[k] then
                local timerName = "ColorModifySet: " .. k
                timer.Create(timerName, FrameTime(), 0, function()
                    if !input.IsMouseDown(MOUSE_LEFT) then
                        timer.Remove(timerName)

                        value = math.Round(value, info.decimals)
                        netstream.Start("ColorModify:Set", k, value)
                    end
                end)
            end
        end

        local label = slider:GetChildren()[3]
        label:SetFont("arb.Font_FuturaPTBook_8")
        label:SetTextColor(color_white)
        label:DockMargin(W(25), 0, 0, 0)

        size = size + H(30) + H(3)
    end

    self.mainPanel:SetTall(size)

    local returnButton = self:Add("DButton")
    returnButton:SetText("")
    returnButton:SetTall(H(25))
    returnButton:Dock(BOTTOM)
    returnButton.alpha = 0
    returnButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText("#colorcorrection_restore", "arb.Font_FuturaPTBook_8", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end
    returnButton.DoClick = function()
        netstream.Start("ColorModify:Standart")

        timer.Simple(0.5, function()
            self:Remove()
            vgui.Create("ColorModify:Menu")
        end)
    end

    local saveButton = self:Add("DButton")
    saveButton:SetText("")
    saveButton:SetTall(H(25))
    saveButton:Dock(BOTTOM)
    saveButton.alpha = 0
    saveButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText("#colorcorrection_configs", "arb.Font_FuturaPTBook_8", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end
    saveButton.DoClick = function()
        local Menu = DermaMenu()
        Menu:AddOption("#colorcorrection_savecc", function()
            Derma_StringRequest("#colorcorrection_savecc", "#colorcorrection_savefile", "", function(text)
                local data = PLUGIN:Get()

                local array = {}
                array.brightness = data.brightness
                array.contrast = data.contrast
                array.color = data.color
                array.mulr = data.mulr
                array.mulg = data.mulg
                array.mulb = data.mulb
                array.addr = data.addr
                array.addg = data.addg
                array.addb = data.addb

                file.Write("academy_colormodify_configs/" .. text .. ".txt", util.TableToJSON(array))
            end, nil, "#colorcorrection_save", "#colorcorrection_cancel")
        end):SetIcon("icon16/add.png")

        local Child, Parent = Menu:AddSubMenu("#colorcorrection_loadcc")
        Parent:SetIcon("icon16/arrow_down.png")

        local files = file.Find("academy_colormodify_configs/*", "DATA")
        for k, v in ipairs(files) do
            Child:AddOption(v, function()
                local data = util.JSONToTable(file.Read("academy_colormodify_configs/" .. v, "DATA"))

                netstream.Start("ColorModify:LoadConfig", data)

                timer.Simple(0.5, function()
                    self:Remove()
                    vgui.Create("ColorModify:Menu")
                end)
            end)
        end

        Menu:Open()
    end

    local playersPanel = self:Add("DPanel")
    playersPanel:SetTall(200)
    playersPanel:Dock(FILL)
    playersPanel:DockMargin(W(5), H(5), W(5), H(5))
    playersPanel.Paint = function(_, w, h)
        surface.SetDrawColor(27, 10, 13, 150)
        surface.DrawRect(0, 0, w, h)
    end

    local enablePlayersButton = playersPanel:Add("DCheckBoxLabel")
    enablePlayersButton:SetTall(H(30))
    enablePlayersButton:Dock(TOP)
    enablePlayersButton:DockMargin(W(25), H(3), 0, H(20))
    enablePlayersButton:SetText("#colorcorrection_turnply")
    enablePlayersButton:SetFont("arb.Font_FuturaPTBook_8")
    enablePlayersButton:SetValue(data.players)
    enablePlayersButton.OnChange = function(_, value)
        netstream.Start("ColorModify:Set", "players", tobool(value))
    end

    local scrollPanel = playersPanel:Add("DScrollPanel")
    scrollPanel:Dock(FILL)

    do
        local bar = scrollPanel:GetVBar()
        bar:SetWide(3)
        bar:DockMargin(0, 0, 0, 0)

        bar.Paint = function(_, w, h)
            surface.SetDrawColor(255, 255, 255, 3)
            surface.DrawRect(0, 0, w, h)
        end
        bar.btnUp.Paint = function(_, w, h) end
        bar.btnDown.Paint = function(_, w, h) end
        bar.btnGrip.Paint = function(_, w, h)
            surface.SetDrawColor(255, 255, 255)
            surface.DrawRect(0, 0, w, h)
        end
    end

    for k, v in ipairs(player.GetAll()) do
        local steamid = v:SteamID()

        local checkbox = scrollPanel:Add("DCheckBoxLabel")
        checkbox:Dock(TOP)
        checkbox:DockMargin(W(25), 0, 0, 0)
        checkbox:SetText(v:Name() .. " (" .. v:SteamName() .. ")")
        checkbox:SetValue(data.playersList[steamid])
        checkbox:SizeToContents()
        checkbox.OnChange = function(_)
            netstream.Start("ColorModify:AddPlayer", steamid)
        end
    end
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(41, 22, 25)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(255, 61, 96, 165.75)
    surface.DrawOutlinedRect(0, 0, w, h, 2)

    surface.SetDrawColor(255, 61, 96, 165.75)
    surface.DrawOutlinedRect(0, 0, w, H(30), 2)

    surface.SetDrawColor(255, 61, 96, 20)
    surface.DrawRect(0, 0, w, H(30))

    draw.DrawText("#colorcorrection_title", "arb.Font_FuturaPTDemi_8", W(10), H(3), color_white, TEXT_ALIGN_LEFT)

    draw.DrawText("#colorcorrection_name", "arb.Font_FuturaPTBook_7", W(30), H(45), color_white, TEXT_ALIGN_LEFT)
    draw.DrawText("#colorcorrection_desc", "arb.Font_FuturaPTBook_7", W(550), H(45), color_white, TEXT_ALIGN_LEFT)
end

vgui.Register("ColorModify:Menu", PANEL, "DFrame")