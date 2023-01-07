--[[
        © AsterionStaff 2023.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru (not work)
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

-- https://github.com/WilliamVenner/glua-material-avatar/blob/master/material-avatar.lua
local a=86400 local function getAvatarMaterial(c,d)local e if os.time()-file.Time("avatars/"..c..".png","DATA")>a then e=Material("../data/avatars/"..c..".png","smooth")elseif os.time()-file.Time("avatars/"..c..".jpg","DATA")>a then e=Material("../data/avatars/"..c..".jpg","smooth")end if not e or e:IsError()then e=Material("vgui/avatar_default")else return d(e)end http.Fetch("https://steamcommunity.com/profiles/"..c.."?xml=1",function(f,g,h,i)if g==0 or i<200 or i>299 then return d(e,c)end local j,k=f:match("<avatarFull>.-(https?://%S+%f[%.]%.)(%w+).-</avatarFull>")if not j or not k then return d(e,c)end if k=="jpeg"then k="jpg"end http.Fetch(j..k,function(f,g,h,i)if g==0 or i<200 or i>299 then return d(e,c)end local l="avatars/"..c.."."..k file.CreateDir("avatars")file.Write(l,f)local m=Material("../data/"..l,"smooth")if m:IsError()then file.Delete(l)d(e,c)else d(m,c)end end,function()d(e,c)end)end,function()d(e,c)end)end

local PLUGIN = PLUGIN

local PANEL = {}

local size = 0.7
function PANEL:Init()
	if IsValid(Arbitrage.gui.whitelist) then
	    Arbitrage.gui.whitelist:Remove()
	else
	    self:SetAlpha(0)
	    self:AlphaTo(255, 0.3)
	end

	Arbitrage.gui.whitelist = self

	self:SetPos(0, 0)
	self:SetSize(W(1920 * size), H(1080 * size))
	self:MakePopup()
	self:Center()

	self.selectID = {}

	self:CreateTitle()
	self:CreateSearch()
	self:CreateMain()
	self:BottomPanels()
end

function PANEL:CreateTitle()
	local panel = self:Add("DPanel")
	panel:Dock(TOP)
	panel:DockMargin(0, 0, 0, 5)
	panel:SetTall(H(30))
	panel.Paint = function(_, w, h)
	    surface.SetDrawColor(255, 61, 96, 165.75)
	    surface.DrawOutlinedRect(0, 0, w, h, 2)

	    surface.SetDrawColor(255, 61, 96, 20)
	    surface.DrawRect(0, 0, w, h)
	end

	local label = panel:Add("DLabel")
	label:SetText("Whitelist система")
	label:SetFont("arb.Font_FuturaPTDemi_8")
	label:SetTextColor(Color(255, 255, 255))
	label:Dock(FILL)
	label:SetContentAlignment(4)
	label:DockMargin(10, 0, 0, 0)
	label:SizeToContents()

	local close = panel:Add("DButton")
	close:Dock(RIGHT)
	close:DockMargin(0, 0, 5, 0)
	close:SetWide(panel:GetTall())
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
end

function PANEL:CreateSearch()
	local panel = self:Add("DTextEntry")
	panel:SetTall(H(30))
	panel:Dock(TOP)
	panel:DockMargin(W(30), H(15), W(30), H(5))
	panel:SetFont("arb.Font_FuturaPTDemi_7")
	panel:SetPlaceholderText("Вставьте SteamID человека, сюда...")
	panel.OnEnter = function(this)
	    local data = this:GetValue()
	    local id = nil

	    local steamid64 = util.SteamIDTo64(data)
	    local steamid = util.SteamIDFrom64(data)

	    if tonumber(steamid64) != 0 then
	    	id = tostring(steamid64)
	    else
	    	if steamid != "STEAM_0:0:0" then
	    		id = util.SteamIDTo64(steamid)
	    	end
	    end

	    if !id then return end
	    if id == "0" then return end

	    local subPanel = vgui.Create("Whitelist:MenuSub")
	    subPanel:SetData(id)

	    this:SetText("")
	end
end

function PANEL:CreateMain()
	local mainPanel = self:Add("DPanel")
	mainPanel:Dock(FILL)
	mainPanel:DockMargin(W(5), H(15), W(5), H(15))
	mainPanel.Paint = function(_, w, h)
	    surface.SetDrawColor(27, 10, 13, 150)
	    surface.DrawRect(0, 0, w, h)
	end

	local scrollPanel = mainPanel:Add("DScrollPanel")
	scrollPanel:Dock(FILL)
	scrollPanel:DockMargin(20, 20, 3, 20)

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

	self.List = scrollPanel:Add("DIconLayout")
	self.List:Dock(FILL)
	self.List:SetSpaceY(H(5))
	self.List:SetSpaceX(W(10))
end

function PANEL:BottomPanels()
	local privateButton = self:Add("DButton")
    privateButton:DockMargin(0, H(5), 0, H(5))
    privateButton:SetText("")
    privateButton:SetTall(H(25))
    privateButton:Dock(BOTTOM)
    privateButton.alpha = 0
    privateButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText(PLUGIN:IsPublic() and "Сделать сервер приватным" or "Сделать сервер публичным", "arb.Font_FuturaPTBook_8", w / 2, H(0), PLUGIN:IsPublic() and Color(255, 0, 0, _.alpha) or Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end
    privateButton.DoClick = function()
        netstream.Start("Whitelist:ChangePrivate")
    end

    local removeButton = self:Add("DButton")
    removeButton:DockMargin(0, H(5), 0, H(5))
    removeButton:SetText("")
    removeButton:SetTall(H(25))
    removeButton:Dock(BOTTOM)
    removeButton.alpha = 0
    removeButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText("Удалить " .. table.Count(self.selectID) .. " пользователей", "arb.Font_FuturaPTBook_8", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end
    removeButton.DoClick = function()
    	if table.Count(self.selectID) <= 0 then return end

        netstream.Start("Whitelist:Remove", self.selectID)
    end
end

function PANEL:SetData(data)
	for k, v in SortedPairsByMemberValue(data, 2, true) do
		local id = util.SteamIDTo64(k)

		local image = nil
		local steamname = ""

		local time = ""
		local TimeString = os.date("%d/%m/%Y" , v[2])

		if v[1] == 0 then
			time = "∞"
		elseif v[1] - os.time() < 0 then
			time = "delete"
		else
			time = "<" .. string.NiceTime(v[1] - os.time())
		end

		local panel = self.List:Add("DButton")
		panel:SetText("")
		panel:SetSize(W(420), H(88))
		panel.alpha = 0
		panel.Paint = function(_, w, h)
	        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 20 or 0)

	        surface.SetDrawColor(255, 61, 96, _.alpha)
	        surface.DrawRect(0, 0, w, h)

	        surface.SetDrawColor(255, 61, 96, 50)
	        surface.DrawOutlinedRect(0, 0, w, h, 1)

	        if image then
	            surface.SetDrawColor(255, 255, 255)
	            surface.SetMaterial(image)
	            surface.DrawTexturedRect(2, 2, h - 4, h - 4)
	        end

	        local padding = 0

	        local _, _h = draw.SimpleText(steamname, "arb.Font_FuturaPTDemi_9", h + 5, padding, color_white, TEXT_ALIGN_LEFT)
	        padding = padding + _h

	        local _, _h = draw.SimpleText(k, "arb.Font_FuturaPTBook_7", h + 5, padding, color_white, TEXT_ALIGN_LEFT)
	        padding = padding + _h + H(5)

	        local _, _h = draw.SimpleText("Добавлен: " .. TimeString .. "  [Осталось " .. time .. "]", "arb.Font_FuturaPTBook_5", h + 5, padding, Color(255, 255, 255, 100), TEXT_ALIGN_LEFT)
	        padding = padding + _h

	        local _, _h = draw.SimpleText("Добавил: " .. v[4], "arb.Font_FuturaPTBook_5", h + 5, padding, Color(255, 255, 255, 100), TEXT_ALIGN_LEFT)
	        padding = padding + _h

	        if v[3] then
	        	local size = h * 0.4

	        	surface.SetDrawColor(255, 255, 255)
	        	surface.SetMaterial(Material("danganronpa/ui/info_8.png"))
	        	surface.DrawTexturedRect(w - size, 0, size, size)
	        end

	        if self.selectID[k] then
	            surface.SetDrawColor(255, 61, 96, 50)
	            surface.DrawRect(w - 10, 0, 10, h)
	        end
	    end

	    panel.DoClick = function()
	    	if v[3] then return end

	    	if self.selectID[k] then
	    		self.selectID[k] = nil
	    	else
	    		self.selectID[k] = true
	    	end
	    end

	    panel.DoDoubleClick = function()
	    	gui.OpenURL("https://steamcommunity.com/profiles/" .. id)
	    end

	    if LocalPlayer():IsSuperAdmin() then
		    panel.DoRightClick = function()
		    	local menu = DermaMenu()
				menu:AddOption("Защитить", function()
					netstream.Start("Whitelist:Protect", k)
					v[3] = !v[3]
					self.selectID[k] = nil
				end)
				menu:Open()
		    end
		end

	    steamworks.RequestPlayerInfo(id, function(steamName)
			steamname = steamName
		end)

		getAvatarMaterial(id, function(mat)
			image = mat
		end)
	end
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(41, 22, 25)
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(255, 61, 96, 165.75)
	surface.DrawOutlinedRect(0, 0, w, h, 2)
end

vgui.Register("Whitelist:Menu", PANEL, "EditablePanel")



local PANEL = {}

function PANEL:Init()
	self:SetPos(0, 0)
	self:SetSize(ScrW(), ScrH())
	self:MakePopup()
	self:SetAlpha(0)
	self:AlphaTo(255, 0.3)
	self.startTime = SysTime()

	self.time = 86400
	self.id = nil
	self.image = nil
	self.steamname = ""
	self.steamid = ""

	local t = H(300)
	self.main = self:Add("Panel")
	self.main:SetPos(ScrW() / 2 - (W(600)) / 2, ScrH() / 2 - (t / 2))
	self.main:SetSize(W(600), 0)

	self.main.Think = function(this)
	    this:SetTall(Lerp(FrameTime() * 10, this:GetTall(), t))
	end

	self.main.Paint = function(panel, w, h)
	    surface.SetDrawColor(41, 22, 25)
	    surface.DrawRect(0, 0, w, h)

	    surface.SetDrawColor(255, 61, 96, 165.75)
	    surface.DrawOutlinedRect(0, 0, w, h, 2)

	    surface.SetDrawColor(255, 61, 96, 165.75)
	    surface.DrawOutlinedRect(0, 0, w, H(23), 2)

	    surface.SetDrawColor(255, 61, 96, 20)
	    surface.DrawRect(0, 0, w, H(23))

	    draw.DrawText("Добавить нового пользователя", "arb.Font_FuturaPTBook_5", W(10), H(3), color_white, TEXT_ALIGN_LEFT)
	end

	local close = self.main:Add("DButton")
	close:SetPos(self.main:GetWide() - H(70 / 2), 0)
	close:SetSize(H(70 / 2), H(23))
	close:SetText("")
	close.alpha = 40
	close.Paint = function(_, w, h)
	    _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 40)
	    draw.DrawText("X", "arb.Font_FuturaPTBook_5", w / 2, H(4), Color(255, 255, 255, _.alpha), TEXT_ALIGN_LEFT)
	end
	close.DoClick = function()
	    self:AlphaTo(0, 0.2, 0, function()
	        self:Remove()
	    end)
	end

	local infoPanel = self.main:Add("DPanel")
    infoPanel:Dock(FILL)
    infoPanel:DockMargin(0, H(23), 0, 0)
    infoPanel.Paint = function(_, w, h)
        if self.image then
            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(self.image)
            surface.DrawTexturedRect(2, 2, h - 4, h - 4)
        end

        local padding = 0
        local _, h1 = draw.SimpleText(self.steamname, "arb.Font_FuturaPTDemi_7", h + 5, padding, color_white, TEXT_ALIGN_LEFT)
        padding = padding + h1 + 5

        local _, h1 = draw.SimpleText(self.steamid, "arb.Font_FuturaPTBook_5", h + 5, padding, color_white, TEXT_ALIGN_LEFT)
        padding = padding + h1

        local _, h1 = draw.SimpleText(self.id, "arb.Font_FuturaPTBook_5", h + 5, padding, color_white, TEXT_ALIGN_LEFT)
        padding = padding + h1
    end

    local submitButton = self.main:Add("DButton")
    submitButton:DockMargin(0, H(5), 0, H(5))
    submitButton:SetText("")
    submitButton:SetTall(H(25))
    submitButton:Dock(BOTTOM)
    submitButton.alpha = 0
    submitButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText("Добавить", "arb.Font_FuturaPTBook_8", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end
    submitButton.DoClick = function()
        if !self.id then return end

        self:AlphaTo(0, 0.3, 0, function()
            self:Remove()
        end)

        netstream.Start("Whitelist:Add", self.steamid, self.time)
    end

    local openButton = self.main:Add("DButton")
    openButton:DockMargin(0, H(5), 0, H(5))
    openButton:SetText("")
    openButton:SetTall(H(25))
    openButton:Dock(BOTTOM)
    openButton.alpha = 0
    openButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText("Посмотреть", "arb.Font_FuturaPTBook_8", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end
    openButton.DoClick = function()
        if !self.id then return end

        gui.OpenURL("https://steamcommunity.com/profiles/" .. self.id)
    end

    local panelButtons = self.main:Add("Panel")
    panelButtons:SetTall(H(25))
    panelButtons:Dock(BOTTOM)
    panelButtons:DockMargin(5, 5, 5, 5)

    local data = {{"Навсегда", 0}, {"1 Час", 3600}, {"1 День", 86400}, {"1 Неделя", 604800}, {"1 Месяц", 2628000}}
    for k, v in ipairs(data) do
    	local button = panelButtons:Add("DButton")
    	button:Dock(LEFT)
    	button:DockMargin(0, 0, 5, 0)
    	button:SetWide(70)
    	button:SetText(v[1])
        button:SetTextColor(color_white)
        button.alpha = 0.1
        button.Paint = function(_, w, h)
            _.alpha = Lerp(FrameTime() * 10, _.alpha, (_:IsHovered() or self.time == v[2]) and 1 or 0.1)

            _:SetTextColor(Color(255, 255, 255, 255 * _.alpha))

            surface.SetDrawColor(15, 5, 6, 204)
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(155, 35, 57, 255 * _.alpha)
            surface.DrawOutlinedRect(0, 0, w, h, 2)
        end
        button.DoClick = function()
            self.time = v[2]
        end
    end
end

function PANEL:SetData(id)
	self.id = id
	self.steamname = "Загрузка..."
	self.steamid = "Загрузка..."

	self.steamid = util.SteamIDFrom64(self.id)

	steamworks.RequestPlayerInfo(self.id, function(steamName)
		if !IsValid(self) then return end

		self.steamname = steamName
	end)

	getAvatarMaterial(self.id, function(mat)
		if !IsValid(self) then return end

		self.image = mat
	end)
end

function PANEL:Paint(w, h)
	Derma_DrawBackgroundBlur(self, self.startTime)
end

vgui.Register("Whitelist:MenuSub", PANEL, "EditablePanel")