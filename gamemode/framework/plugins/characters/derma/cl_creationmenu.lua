local infoTable = {
	{
		name = "Команды",
		subTitle = {{"Уникальный ID", "uniqueID"}, {"Название", "name"}, {"Категория", "category"}},
		subMenu = "Character:CreationMenuTeamSub",
		net = {
			add = "Character:CreationRegisterTeam",
			edit = "Character:CreationEditTeam",
			remove = "Character:CreationRemoveTeam"
		},
		key = "team",
		Get = function()
			local data = {}

			for _, v in pairs(Character.team.instances) do
				if v.isCreation then
					local id = v:GetID()

					data[id] = v
				end
			end

			return data
		end
	},
	{
		name = "Спрайты",
		subTitle = {{"Уникальный ID", "uniqueID"}},
		subMenu = "Character:CreationMenuEmojiSub",
		net = {
			add = "Character:CreationRegisterEmoji",
			edit = "Character:CreationEditEmoji",
			remove = "Character:CreationRemoveEmoji"
		},
		key = "emoji",
		Get = function()
			local data = {}

			for k, v in pairs(Character.emoji.instances) do
				if v.isCreation then
					data[k] = v
				end
			end

			return data
		end
	},
	{
		name = "Категории",
		subTitle = {{"Уникальный ID", "uniqueID"}, {"Название", "name"}, {"Иконка", "icon"}},
		subMenu = "Character:CreationMenuCategorySub",
		net = {
			add = "Character:CreationRegisterCategory",
			edit = "Character:CreationEditCategory",
			remove = "Character:CreationRemoveCategory"
		},
		key = "category",
		Get = function()
			local data = {}

			for _, v in pairs(Character.category.instances) do
				if v.isCreation then
					local id = v:GetID()

					data[id] = v
				end
			end

			return data
		end
	}
}


local PANEL = {}

local size = 0.7
function PANEL:Init()
	if IsValid(Arbitrage.gui.creationmenu) then
		Arbitrage.gui.creationmenu:Remove()
	end

	Arbitrage.gui.creationmenu = self

	self:SetTitle("")
	self:SetSize(W(1920) * size, H(1080) * size)
	self:MakePopup()
	self:Center()
	self:SetAlpha(0)
	self:AlphaTo(255, 0.3)
	self:ShowCloseButton(false)

	self.keySelect = -1

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

	local rigthPanel = self:Add("Panel")
	rigthPanel:Dock(RIGHT)
	rigthPanel:DockMargin(5, 15, 5, 5)
	rigthPanel:SetWide(self:GetWide() * 0.65)

	local rightTitle = rigthPanel:Add("DLabel")
	rightTitle:SetText("Информация:")
	rightTitle:SetTextColor(Color(255, 255, 255, 200))
	rightTitle:SetFont("arb.Font_FuturaPTBook_7")
	rightTitle:Dock(TOP)
	rightTitle:SizeToContents()

	local rightInfo = rigthPanel:Add("DPanel")
	rightInfo:Dock(FILL)
	rightInfo:DockMargin(0, 5, 0, 0)
	rightInfo.Paint = function(_, w, h)
	    surface.SetDrawColor(255, 61, 96, 165.75)
	    surface.DrawOutlinedRect(0, 0, w, h, 1)
	end

	self.rightContainer = rightInfo:Add("DScrollPanel")
	self.rightContainer:Dock(FILL)

	local createButton = rightInfo:Add("DButton")
	createButton:Dock(BOTTOM)
	createButton:DockMargin(0, H(5), 0, H(5))
	createButton:SetText("")
	createButton:SetTall(H(20))
	createButton.alpha = 0
	createButton.Paint = function(_, w, h)
		_.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)

		local value = infoTable[self.keySelect] and infoTable[self.keySelect].name
		draw.DrawText(self.keySelect > 0 and "Создать " .. value or "", "arb.Font_FuturaPTBook_6", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

		surface.SetDrawColor(255, 61, 96, 30)
		surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
	end
	createButton.DoClick = function(_, w, h)
		local id = self.keySelect
		if id <= 0 then return end

		vgui.Create(infoTable[self.keySelect].subMenu)
	end

	local leftPanel = self:Add("Panel")
	leftPanel:Dock(FILL)
	leftPanel:DockMargin(5, 15, 5, 5)

	local leftTitle = leftPanel:Add("DLabel")
	leftTitle:SetText("Список данных:")
	leftTitle:SetTextColor(Color(255, 255, 255, 200))
	leftTitle:SetFont("arb.Font_FuturaPTBook_7")
	leftTitle:Dock(TOP)
	leftTitle:SizeToContents()

	local leftContainer = leftPanel:Add("DScrollPanel")
	leftContainer:Dock(FILL)
	leftContainer:DockMargin(0, 5, 0, 0)
	leftContainer.Paint = function(_, w, h)
	    surface.SetDrawColor(255, 61, 96, 165.75)
	    surface.DrawOutlinedRect(0, 0, w, h, 1)
	end

	self:CreateInfo(leftContainer)
end

function PANEL:CreateInfo(parent)
	for k, v in ipairs(infoTable) do
		local button = parent:Add("DButton")
		button:SetText("")
		button:Dock(TOP)
		button:SetTall(H(30))
		button.index = k
		button.alpha = 0
		button.Paint = function(this, w, h)
			if this.index % 2 == 0 then
	            surface.SetDrawColor(255, 61, 96, 1)
	            surface.DrawRect(0, 0, w, h)
	        end

		    this.alpha = Lerp(FrameTime() * 10, this.alpha, (this:IsHovered() or self.keySelect == k) and 10 or 0)

		    surface.SetDrawColor(255, 61, 96, this.alpha)
		    surface.DrawRect(0, 0, w, h)

		    if self.keySelect == k then
	            surface.SetDrawColor(255, 61, 96, this.alpha * 5)
	            surface.DrawOutlinedRect(0, 0, w, h)
	        end

	        draw.SimpleText(v.name, "arb.Font_FuturaPTBook_7", W(10), H(4), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
		end

		button.DoClick = function(_, w, h)
			self.keySelect = k

			self:CreateItemsInfo(self.rightContainer, k)
		end
	end
end

local function paintButton(panel)
	panel.alpha = 0.1
	panel.Paint = function(_, w, h)
		panel.alpha = Lerp(FrameTime() * 10, panel.alpha, panel:IsHovered() and 1 or 0.1)

		panel:SetTextColor(Color(255, 255, 255, 255 * panel.alpha))

		surface.SetDrawColor(15, 5, 6, 204)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(155, 35, 57, 255 * panel.alpha)
		surface.DrawOutlinedRect(0, 0, w, h, 2)
	end
end

function PANEL:CreateItemsInfo(parent, id)
	for k, v in ipairs(parent:GetChildren()[1]:GetChildren()) do
		if IsValid(v) then
			v:Remove()
		end
	end

	local info = infoTable[id]


	local o = {}
	local rightSubTitle = self.rightContainer:Add("DPanel")
	rightSubTitle:Dock(TOP)
	rightSubTitle:SetTall(H(20))
	rightSubTitle.Paint = function(_, w, h)
		o = {}

	    local padding = W(5)
	    for k, v in ipairs(info.subTitle or {}) do
	    	local _w, _h = draw.SimpleText(v[1], "arb.Font_FuturaPTBook_6", padding, 0, Color(255, 220, 228), TEXT_ALIGN_LEFT)
	    	o[k] = padding
	    	padding = padding + _w + W(160)
	    end

	    surface.SetDrawColor(255, 61, 96, 5)
	    surface.DrawRect(0, 0, w, h)
	end

	for k, v in SortedPairs(info.Get and info.Get() or {}) do
		local button = parent:Add("DButton")
		button:SetText("")
		button:Dock(TOP)
		button:SetTall(H(20))
		button.alpha = 0
		button.Paint = function(_, w, h)
		    _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)

		    surface.SetDrawColor(255, 61, 96, (_.alpha - 30) * 0.02)
		    surface.DrawRect(0, 0, w, h)

		    for k2, v2 in ipairs(info.subTitle) do
		    	draw.SimpleText(v[v2[2]], "arb.Font_FuturaPTBook_6", o[k2], 0, Color(255, 220, 228, _.alpha), TEXT_ALIGN_LEFT)
		    end
		end

		button.DoClick = function()
		    local menu = DermaMenu()

		    for k2, v2 in ipairs(info.subTitle) do
		    	local name = v2[1]
		    	local key = v2[2]

		    	menu:AddOption("Скопировать " .. name, function() SetClipboardText(v[key]) end)
		    end

		    menu:AddOption("Вывести все данные в консоль", function() PrintTable(v) end)

		    menu:Open()
		end

		local remove = button:Add("DButton")
		remove:SetText("Удалить")
		remove:Dock(RIGHT)
		remove:DockMargin(0, 0, 5, 0)
		remove:SizeToContents()
		paintButton(remove)
		remove.DoClick = function()
			netstream.Start(infoTable[self.keySelect].net.remove, v.uniqueID)

			timer.Simple(0.5, function()
				vgui.Create("Character:CreationMenu")
			end)
		end

		local edit = button:Add("DButton")
		edit:SetText("Изменить")
		edit:Dock(RIGHT)
		edit:DockMargin(0, 0, 5, 0)
		edit:SizeToContents()
		paintButton(edit)
		edit.DoClick = function()
			local subPanel = vgui.Create(infoTable[self.keySelect].subMenu)
			subPanel:SetUniqueID(v.uniqueID)
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

	draw.DrawText("Редактор персонажей", "arb.Font_FuturaPTDemi_8", W(10), H(3), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
end

vgui.Register("Character:CreationMenu", PANEL, "DFrame")

local PANEL = {}

function PANEL:Init()
	self:SetPos(0, 0)
	self:SetSize(ScrW(), ScrH())
	self:MakePopup()
	self:SetAlpha(0)
	self:AlphaTo(255, 0.3)
	self.startTime = SysTime()

	self.main = self:Add("Panel")
	self.main:SetSize(W(800), 0)
	self.main.Paint = function(panel, w, h)
	    surface.SetDrawColor(41, 22, 25)
	    surface.DrawRect(0, 0, w, h)

	    surface.SetDrawColor(255, 61, 96, 165.75)
	    surface.DrawOutlinedRect(0, 0, w, h, 2)
	end

	local title = self.main:Add("DPanel")
	title:Dock(TOP)
	title:SetTall(H(23))
	title.Paint = function(panel, w, h)
	    surface.SetDrawColor(255, 61, 96, 165.75)
	    surface.DrawOutlinedRect(0, 0, w, h, 2)

	    surface.SetDrawColor(255, 61, 96, 20)
	    surface.DrawRect(0, 0, w, h)

	    draw.DrawText("Редактор команды", "arb.Font_FuturaPTBook_5", W(10), H(3), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
	end

	local close = title:Add("DButton")
	close:Dock(RIGHT)
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


	local submitButton = self.main:Add("DButton")
	submitButton:DockMargin(0, H(5), 0, H(5))
	submitButton:SetText("")
	submitButton:SetTall(H(25))
	submitButton:Dock(BOTTOM)
	submitButton.alpha = 0
	submitButton.Paint = function(_, w, h)
	    _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
	    draw.DrawText(self.isedit and "Изменить" or "Добавить", "arb.Font_FuturaPTBook_8", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

	    surface.SetDrawColor(255, 61, 96, 30)
	    surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
	end

	submitButton.DoClick = function()
		local data = {}

		for k, v in pairs(self.panels or {}) do
			if IsValid(v) then
				local text = v:GetValue(v)
				if k != "uniqueID" and (text == "" or text == " " or text == "  ") then
					local holder = v:GetPlaceholderText()

					text = utf8.sub(holder, 0, utf8.len(holder) - 1)
				end

				if tonumber(text) then
					text = tonumber(text)
				end

				data[k] = text
			end
		end

		for k, v in pairs(data) do
			if v == "" or v == " " or v == "  " then
				data[k] = nil
			end
		end

		if !data.uniqueID then return end

		netstream.Start(self.isedit and infoTable[1].net.edit or infoTable[1].net.add, data)

		if !self.isedit then
			timer.Simple(0.5, function()
				vgui.Create("Character:CreationMenu")
			end)
		end

		self:AlphaTo(0, 0.2, 0, function()
			self:Remove()
		end)
	end

	local data = {
		{
			variable = "uniqueID",
			title = "Уникальный ID *",
			default = "test_team"
		},
		{
			variable = "name",
			title = "Название команды",
			default = "Не указано"
		},
		{
			variable = "title",
			title = "Описание команды",
			default = "Отсутствует"
		},
		{
			variable = "category",
			title = "Категория команды",
			default = "Редактор"
		},
		{
			variable = "model",
			title = "Модель команды",
			default = "models/props_junk/PlasticCrate01a.mdl",
		},
		{
			variable = "evidence_visibility",
			title = "Видимость улик",
			default = 1
		},
		{
			variable = "run_consumption",
			get = function(char)
				return char.stamina.run_consumption
			end,
			title = "Трата выносливости",
			default = 1
		},
		{
			variable = "speed_walk",
			get = function(char)
				return char.speed.walk
			end,
			title = "Скорость ходьбы",
			default = 1
		},
		{
			variable = "speed_run",
			get = function(char)
				return char.speed.run
			end,
			title = "Скорость бега",
			default = 1
		},
		{
			variable = "needs_hunger",
			get = function(char)
				return char.needs.hunger
			end,
			title = "Скорость траты голода (секунды)",
			default = 33
		},
		{
			variable = "needs_thirst",
			get = function(char)
				return char.needs.thirst
			end,
			title = "Скорость страты жажды (секунды)",
			default = 33
		},
		{
			variable = "needs_fatique",
			get = function(char)
				return char.needs.fatique
			end,
			title = "Скорость траты сна (секунды)",
			default = 33
		},
		{
			variable = "scale",
			title = "Размер модели",
			default = 1
		},
	}

	self.panels = {}
	local indent = string.rep(" ", 3)

	local _size = H(68)
	for k, v in ipairs(data) do
		local panel = self.main:Add("Panel")
		panel:SetTall(_size)
		panel:Dock(TOP)
		panel:DockMargin(0, H(5), 0, 0)

		local title = panel:Add("DLabel")
		title:SetText(indent .. v.title)
		title:SetFont("arb.Font_FuturaPTBook_7")
		title:SetTextColor(Color(255, 255, 255))
		title:Dock(TOP)
		title:SizeToContents()

		local default = panel:Add("DLabel")
		default:SetText(indent .. "Пример: " .. v.default)
		default:SetFont("arb.Font_FuturaPTBook_7")
		default:SetTextColor(Color(150, 150, 150))
		default:Dock(TOP)
		default:SizeToContents()

		local entry = panel:Add("DTextEntry")
		entry:Dock(FILL)
		entry:DockMargin(5, 0, 5, 0)
		entry:SetPlaceholderText(v.default .. " ")
		entry:SetFont("arb.Font_FuturaPTBook_8")

		if v.get then
			entry.get = v.get
		end

		self.panels[v.variable] = entry
	end

	local tall = _size * #data + H(80) + (H(5) * #data)

	self.main:SetPos(ScrW() / 2 - (W(800)) / 2, ScrH() / 2 - (tall / 2))
	self.main.Think = function(panel)
	    panel:SetTall(Lerp(FrameTime() * 10, panel:GetTall(), tall))
	end
end

function PANEL:SetUniqueID(uniqueID)
	if uniqueID then
		self.isedit = true

		local faction = Character.team:GetByUniqueID(uniqueID)

		for var, panel in pairs(self.panels or {}) do
			local value = panel.get and panel.get(faction) or faction[var]

			panel:SetValue(value)
		end

		if self.panels and IsValid(self.panels.uniqueID) then
			self.panels.uniqueID:SetEnabled(false)
		end
	end
end

function PANEL:Paint(w, h)
	Derma_DrawBackgroundBlur(self, self.startTime)
end

vgui.Register("Character:CreationMenuTeamSub", PANEL, "EditablePanel")

local PANEL = {}

function PANEL:Init()
	self:SetPos(0, 0)
	self:SetSize(ScrW(), ScrH())
	self:MakePopup()
	self:SetAlpha(0)
	self:AlphaTo(255, 0.3)
	self.startTime = SysTime()
	self.categorys = {}

	self.main = self:Add("Panel")
	self.main:SetSize(W(800), 0)
	self.main.Paint = function(panel, w, h)
	    surface.SetDrawColor(41, 22, 25)
	    surface.DrawRect(0, 0, w, h)

	    surface.SetDrawColor(255, 61, 96, 165.75)
	    surface.DrawOutlinedRect(0, 0, w, h, 2)
	end

	local title = self.main:Add("DPanel")
	title:Dock(TOP)
	title:SetTall(H(23))
	title.Paint = function(panel, w, h)
	    surface.SetDrawColor(255, 61, 96, 165.75)
	    surface.DrawOutlinedRect(0, 0, w, h, 2)

	    surface.SetDrawColor(255, 61, 96, 20)
	    surface.DrawRect(0, 0, w, h)

	    draw.DrawText("Редактор спрайтов", "arb.Font_FuturaPTBook_5", W(10), H(3), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
	end

	local close = title:Add("DButton")
	close:Dock(RIGHT)
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

	local submitButton = self.main:Add("DButton")
	submitButton:DockMargin(0, H(5), 0, H(5))
	submitButton:SetText("")
	submitButton:SetTall(H(25))
	submitButton:Dock(BOTTOM)
	submitButton.alpha = 0
	submitButton.Paint = function(_, w, h)
	    _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
	    draw.DrawText(self.isedit and "Изменить" or "Добавить", "arb.Font_FuturaPTBook_8", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

	    surface.SetDrawColor(255, 61, 96, 30)
	    surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
	end

	submitButton.DoClick = function()
		local uniqueID = self.uniqueIDPanel:GetValue()
		if uniqueID == "" or uniqueID == " " or uniqueID == "  " then return end

		local data = {}
		for k, v in pairs(self.categorys) do
			data[k] = data[k] or {}

			local arr = v.list
			for k2 in SortedPairs(arr) do
				data[k][#data[k] + 1] = k2
			end
		end

		netstream.Start(self.isedit and infoTable[2].net.edit or infoTable[2].net.add, uniqueID, data)

		if !self.isedit then
			timer.Simple(0.5, function()
				vgui.Create("Character:CreationMenu")
			end)
		end

		self:AlphaTo(0, 0.2, 0, function()
			self:Remove()
		end)
	end

	local addcategoryButton = self.main:Add("DButton")
	addcategoryButton:DockMargin(0, H(5), 0, H(5))
	addcategoryButton:SetText("")
	addcategoryButton:SetTall(H(25))
	addcategoryButton:Dock(BOTTOM)
	addcategoryButton.alpha = 0
	addcategoryButton.Paint = function(_, w, h)
	    _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
	    draw.DrawText("Добавить новую категорию", "arb.Font_FuturaPTBook_8", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

	    surface.SetDrawColor(255, 61, 96, 30)
	    surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
	end
	addcategoryButton.DoClick = function()
		Derma_StringRequest("Добавить новую категорию", "Введите название категории которую хотите добавить", "", function(text)
			self:CreateCategory(text)
		end, nil, "Добавить", "Отменить")
	end

	self.uniqueIDPanel = self.main:Add("DTextEntry")
	self.uniqueIDPanel:DockMargin(5, 5, 5, 0)
	self.uniqueIDPanel:SetValue("")
	self.uniqueIDPanel:SetPlaceholderText("Уникальный ID команды")
	self.uniqueIDPanel:SetFont("arb.Font_FuturaPTBook_8")
	self.uniqueIDPanel:Dock(TOP)
	self.uniqueIDPanel:SizeToContents()

	self.scrollPanel = self.main:Add("DScrollPanel")
	self.scrollPanel:Dock(FILL)

	local tall = H(ScrH() * 0.6)

	self.main:SetPos(ScrW() / 2 - (W(800)) / 2, ScrH() / 2 - (tall / 2))
	self.main.Think = function(panel)
	    panel:SetTall(Lerp(FrameTime() * 10, panel:GetTall(), tall))
	end
end

function PANEL:CreateCategory(name, data)
	if self.categorys[name] then return end

	local category = self.scrollPanel:Add("DPanel")
	category.name = name
	category.list = {}
	category:SetTall(H(200))
	category:Dock(TOP)
	category:DockMargin(5, 5, 5, 0)
	category.Paint = function(_, w, h)
		surface.SetDrawColor(41, 22, 25)
	    surface.DrawRect(0, 0, w, h)

	    surface.SetDrawColor(255, 61, 96, 165.75)
	    surface.DrawOutlinedRect(0, 0, w, h, 2)
	end

	local title = category:Add("DPanel")
	title:Dock(TOP)
	title:SetTall(H(23))
	title.Paint = function(panel, w, h)
	    surface.SetDrawColor(255, 61, 96, 165.75)
	    surface.DrawOutlinedRect(0, 0, w, h, 2)

	    surface.SetDrawColor(255, 61, 96, 20)
	    surface.DrawRect(0, 0, w, h)

	    draw.DrawText(name, "arb.Font_FuturaPTBook_5", W(10), H(3), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
	end

	local removeButton = title:Add("DButton")
	removeButton:SetText("")
	removeButton:SetWide(W(30))
	removeButton:Dock(RIGHT)
	removeButton.Paint = function(panel, w, h)
	    draw.DrawText("X", "arb.Font_FuturaPTBook_6", w / 2, H(3), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	end
	removeButton.DoClick = function()
		self.categorys[name] = nil
		category:Remove()
	end

	local scroll = category:Add("DScrollPanel")
	scroll:Dock(FILL)

	local function addBox(val)
		category.list[val] = true

		local box = scroll:Add("DCheckBoxLabel")
		box:SetValue(true)
		box:SetText(val)
		box:Dock(TOP)
		box:SizeToContents()

		box.OnChange = function(this, value)
			if !value then
				this:Remove()

				category.list[val] = nil
			end
		end
	end

	local addButton = category:Add("DButton")
	addButton:DockMargin(0, H(5), 0, H(5))
	addButton:SetText("")
	addButton:SetTall(H(20))
	addButton:Dock(BOTTOM)
	addButton.alpha = 0
	addButton.Paint = function(_, w, h)
	    _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
	    draw.DrawText("Добавить новый спрайт", "arb.Font_FuturaPTBook_5", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

	    surface.SetDrawColor(255, 61, 96, 30)
	    surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
	end
	addButton.DoClick = function()
		Derma_StringRequest("Добавить новый спрайт", "Введите полное название спрайта который вы хотите добавить", "", function(text)
			addBox(text)
		end, nil, "Добавить", "Отменить")
	end

	for k, v in ipairs(data or {}) do
		addBox(v)
	end

	self.categorys[name] = category
end

function PANEL:SetUniqueID(uniqueID)
	if uniqueID then
		self.isedit = true

		for k, v in pairs(Character.emoji.data[uniqueID] or {}) do
			self:CreateCategory(k, v)
		end

		self.uniqueIDPanel:SetValue(uniqueID)
	end
end

function PANEL:Paint(w, h)
	Derma_DrawBackgroundBlur(self, self.startTime)
end

vgui.Register("Character:CreationMenuEmojiSub", PANEL, "EditablePanel")

local PANEL = {}

function PANEL:Init()
	self:SetPos(0, 0)
	self:SetSize(ScrW(), ScrH())
	self:MakePopup()
	self:SetAlpha(0)
	self:AlphaTo(255, 0.3)
	self.startTime = SysTime()

	self.main = self:Add("Panel")
	self.main:SetSize(W(800), 0)
	self.main.Paint = function(panel, w, h)
	    surface.SetDrawColor(41, 22, 25)
	    surface.DrawRect(0, 0, w, h)

	    surface.SetDrawColor(255, 61, 96, 165.75)
	    surface.DrawOutlinedRect(0, 0, w, h, 2)
	end

	local title = self.main:Add("DPanel")
	title:Dock(TOP)
	title:SetTall(H(23))
	title.Paint = function(panel, w, h)
	    surface.SetDrawColor(255, 61, 96, 165.75)
	    surface.DrawOutlinedRect(0, 0, w, h, 2)

	    surface.SetDrawColor(255, 61, 96, 20)
	    surface.DrawRect(0, 0, w, h)

	    draw.DrawText("Редактор команды", "arb.Font_FuturaPTBook_5", W(10), H(3), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
	end

	local close = title:Add("DButton")
	close:Dock(RIGHT)
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


	local submitButton = self.main:Add("DButton")
	submitButton:DockMargin(0, H(5), 0, H(5))
	submitButton:SetText("")
	submitButton:SetTall(H(25))
	submitButton:Dock(BOTTOM)
	submitButton.alpha = 0
	submitButton.Paint = function(_, w, h)
	    _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
	    draw.DrawText(self.isedit and "Изменить" or "Добавить", "arb.Font_FuturaPTBook_8", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

	    surface.SetDrawColor(255, 61, 96, 30)
	    surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
	end

	submitButton.DoClick = function()
		local data = {}

		for k, v in pairs(self.panels or {}) do
			if IsValid(v) then
				local text = v:GetValue(v)
				if k != "uniqueID" and (text == "" or text == " " or text == "  ") then
					local holder = v:GetPlaceholderText()

					text = utf8.sub(holder, 0, utf8.len(holder) - 1)
				end

				if tonumber(text) then
					text = tonumber(text)
				end

				data[k] = text
			end
		end

		for k, v in pairs(data) do
			if v == "" or v == " " or v == "  " then
				data[k] = nil
			end
		end

		if !data.uniqueID then return end

		netstream.Start(self.isedit and infoTable[3].net.edit or infoTable[3].net.add, data)

		if !self.isedit then
			timer.Simple(0.5, function()
				vgui.Create("Character:CreationMenu")
			end)
		end

		self:AlphaTo(0, 0.2, 0, function()
			self:Remove()
		end)
	end

	local data = {
		{
			variable = "uniqueID",
			title = "Уникальный ID *",
			default = "test_category"
		},
		{
			variable = "name",
			title = "Название категории",
			default = "Не указано"
		},
		{
			variable = "icon",
			title = "Иконка категории",
			default = "icon16/contrast.png"
		}
	}

	self.panels = {}
	local indent = string.rep(" ", 3)

	local _size = H(68)
	for k, v in ipairs(data) do
		local panel = self.main:Add("Panel")
		panel:SetTall(_size)
		panel:Dock(TOP)
		panel:DockMargin(0, H(5), 0, 0)

		local title = panel:Add("DLabel")
		title:SetText(indent .. v.title)
		title:SetFont("arb.Font_FuturaPTBook_7")
		title:SetTextColor(Color(255, 255, 255))
		title:Dock(TOP)
		title:SizeToContents()

		local default = panel:Add("DLabel")
		default:SetText(indent .. "Пример: " .. v.default)
		default:SetFont("arb.Font_FuturaPTBook_7")
		default:SetTextColor(Color(150, 150, 150))
		default:Dock(TOP)
		default:SizeToContents()

		local entry = panel:Add("DTextEntry")
		entry:Dock(FILL)
		entry:DockMargin(5, 0, 5, 0)
		entry:SetPlaceholderText(v.default .. " ")
		entry:SetFont("arb.Font_FuturaPTBook_8")

		if v.get then
			entry.get = v.get
		end

		self.panels[v.variable] = entry
	end

	local tall = _size * #data + H(80) + (H(5) * #data)

	self.main:SetPos(ScrW() / 2 - (W(800)) / 2, ScrH() / 2 - (tall / 2))
	self.main.Think = function(panel)
	    panel:SetTall(Lerp(FrameTime() * 10, panel:GetTall(), tall))
	end
end

function PANEL:SetUniqueID(uniqueID)
	if uniqueID then
		self.isedit = true

		local category = Character.category:GetByUniqueID(uniqueID)

		for var, panel in pairs(self.panels or {}) do
			local value = category[var]

			panel:SetValue(value)
		end

		if self.panels and IsValid(self.panels.uniqueID) then
			self.panels.uniqueID:SetEnabled(false)
		end
	end
end

function PANEL:Paint(w, h)
	Derma_DrawBackgroundBlur(self, self.startTime)
end

vgui.Register("Character:CreationMenuCategorySub", PANEL, "EditablePanel")