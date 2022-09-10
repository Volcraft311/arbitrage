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

	self.baseSelect = -1

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
	rightTitle:SetText("Список предметов:")
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
		draw.DrawText("Создать новый предмет", "arb.Font_FuturaPTBook_6", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

		surface.SetDrawColor(255, 61, 96, 30)
		surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
	end

	createButton.DoClick = function(_, w, h)
		local id = self.baseSelect
		if id == -1 then return end

		local subPanel = vgui.Create("ItemBase:CreationMenuSub")
		subPanel:SetBase(id)
	end

	local rightSubTitle = self.rightContainer:Add("DPanel")
	rightSubTitle:Dock(TOP)
	rightSubTitle:SetTall(H(20))
	rightSubTitle.Paint = function(_, w, h)
	    draw.SimpleText("Уникальный ID", "arb.Font_FuturaPTBook_6", W(5), 0, Color(255, 220, 228), TEXT_ALIGN_LEFT)
	    draw.SimpleText("Название предмета", "arb.Font_FuturaPTBook_6", W(150), 0, Color(255, 220, 228), TEXT_ALIGN_LEFT)
	    draw.SimpleText("Категория предмета", "arb.Font_FuturaPTBook_6", W(420), 0, Color(255, 220, 228), TEXT_ALIGN_LEFT)

	    surface.SetDrawColor(255, 61, 96, 5)
	    surface.DrawRect(0, 0, w, h)
	end

	local leftPanel = self:Add("Panel")
	leftPanel:Dock(FILL)
	leftPanel:DockMargin(5, 15, 5, 5)

	local leftTitle = leftPanel:Add("DLabel")
	leftTitle:SetText("Базы для редактирования:")
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

	self:CreateBaseInfo(leftContainer)
end

function PANEL:CreateBaseInfo(parent)
	local index = 0

	local data = {basic = {creationExample = {}, name = "Без функционала"}}
	for k, v in pairs(ItemBase.base) do
		data[k] = v
	end

	for k, v in pairs(data) do
		if !v.creationExample then continue end

		local button = parent:Add("DButton")
		button:SetText("")
		button:Dock(TOP)
		button:SetTall(H(30))
		button.index = index
		button.alpha = 0
		button.Paint = function(this, w, h)
			if this.index % 2 == 0 then
	            surface.SetDrawColor(255, 61, 96, 1)
	            surface.DrawRect(0, 0, w, h)
	        end

		    this.alpha = Lerp(FrameTime() * 10, this.alpha, (this:IsHovered() or self.baseSelect == k) and 10 or 0)

		    surface.SetDrawColor(255, 61, 96, this.alpha)
		    surface.DrawRect(0, 0, w, h)

		    if self.baseSelect == k then
	            surface.SetDrawColor(255, 61, 96, this.alpha * 5)
	            surface.DrawOutlinedRect(0, 0, w, h)
	        end

	        draw.SimpleText(v.name, "arb.Font_FuturaPTBook_7", W(10), H(4), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
		end

		button.DoClick = function(_, w, h)
			self.baseSelect = k

			self:CreateItemsInfo(self.rightContainer)
		end

		index = index + 1
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

function PANEL:CreateItemsInfo(parent)
	for k, v in ipairs(parent:GetChildren()[1]:GetChildren()) do
		if IsValid(v) and v.item then
			v:Remove()
		end
	end

	for k, v in SortedPairsByMemberValue(ItemBase.list, "name") do
		if !v.isCreation then continue end

		if (v.base and v.base == self.baseSelect) or (!v.base and self.baseSelect == ItemBase.defaultBaseID) then
			local button = parent:Add("DButton")
			button:SetText("")
			button.item = true
			button:Dock(TOP)
			button:SetTall(H(20))
			button.alpha = 0
			button.Paint = function(_, w, h)
			    _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)

			    surface.SetDrawColor(255, 61, 96, (_.alpha - 30) * 0.02)
			    surface.DrawRect(0, 0, w, h)

			    if v.isprotect then
			    	surface.SetDrawColor(255, 0, 0, 20)
			    	surface.DrawRect(0, 0, w, h)
			    end

			    draw.DrawText(v.uniqueID, "arb.Font_FuturaPTBook_6", W(5), 0, Color(255, 220, 228, _.alpha), TEXT_ALIGN_LEFT)
			    draw.DrawText(v.name, "arb.Font_FuturaPTBook_6", W(150), 0, Color(255, 220, 228, _.alpha), TEXT_ALIGN_LEFT)
			    draw.DrawText(v.category, "arb.Font_FuturaPTBook_6", W(420), 0, Color(255, 220, 228, _.alpha), TEXT_ALIGN_LEFT)
			end
			button.DoClick = function()
			    local menu = DermaMenu()

			    menu:AddOption("Скопировать ID", function() SetClipboardText(v.uniqueID) end)
			    menu:AddOption("Скопировать название", function() SetClipboardText(v.name) end)
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
				local base = v.base or "basic"

				netstream.Start("ItemBase:CreationRemoveItem", base, v.uniqueID)

				timer.Simple(0.5, function()
					vgui.Create("ItemBase:CreationMenu")
				end)
			end

			local edit = button:Add("DButton")
			edit:SetText("Изменить")
			edit:Dock(RIGHT)
			edit:DockMargin(0, 0, 5, 0)
			edit:SizeToContents()
			paintButton(edit)
			edit.DoClick = function()
				local base = v.base or "basic"

				local subPanel = vgui.Create("ItemBase:CreationMenuSub")
				subPanel:SetBase(base)
				subPanel:SetItem(v)
			end

			local protect = button:Add("DButton")
			protect:SetText(v.isprotect and "Снять защиту" or "Защитить")
			protect:Dock(RIGHT)
			protect:DockMargin(0, 0, 5, 0)
			protect:SizeToContents()
			paintButton(protect)
			protect.DoClick = function()
				local base = v.base or "basic"

				netstream.Start("ItemBase:CreationProtectItem", base, v.uniqueID)
			end

			if !LocalPlayer():IsSuperAdmin() then
				protect:Remove()

				if v.isprotect then
					remove:Remove()
					edit:Remove()
				end
			end
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

	draw.DrawText("Редактор предметов", "arb.Font_FuturaPTDemi_8", W(10), H(3), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
end

vgui.Register("ItemBase:CreationMenu", PANEL, "DFrame")


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

	    draw.DrawText("Редактор предмета", "arb.Font_FuturaPTBook_5", W(10), H(3), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
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
		local data = {base = self.base}

		for k, v in pairs(self.panels or {}) do
			if IsValid(v) then
				data[k] = v:GetValue(v)
			end
		end

		for k, v in pairs(data) do
			if v == "" or v == " " or v == "  " then
				data[k] = nil
			end
		end

		if !data.uniqueID then return end
		netstream.Start(self.isedit and "ItemBase:CreationEditItem" or "ItemBase:CreationRegisterItem", data)

		if !self.isedit then
			timer.Simple(0.5, function()
				vgui.Create("ItemBase:CreationMenu")
			end)
		end

		self:AlphaTo(0, 0.2, 0, function()
			self:Remove()
		end)
	end
end

local function createExample(info)
	local data = {
		{
			variable = "uniqueID",
			title = "Уникальный ID *",
			default = "test_item"
		},
		{
			variable = "name",
			title = "Название предмета",
			default = "Не указано"
		},
		{
			variable = "description",
			title = "Описание предмета",
			default = "Не указано"
		},
		{
			variable = "model",
			title = "Модель предмета",
			default = "models/props_junk/PlasticCrate01a.mdl",
		},
		{
			variable = "icon",
			title = "Иконка предмета",
			default = "danganronpa/inventory/items/antiquebooktest.png"
		}
	}

	for k, v in ipairs(info or {}) do
		data[#data + 1] = v
	end

	return data
end

function PANEL:SetBase(id)
	self.base = id

	local example = nil

	if id == ItemBase.defaultBaseID then
		example = {
			{
				variable = "category",
				title = "Категория",
				default = "Остальное"
			}
		}
	else
		local itemBase = ItemBase.base[id]
		if !itemBase then return end

		example = itemBase.creationExample
	end

	if !example then return end

	local data = createExample(example)

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

		self.panels[v.variable] = entry
	end

	local tall = _size * #data + H(80) + (H(5) * #data)

	self.main:SetPos(ScrW() / 2 - (W(800)) / 2, ScrH() / 2 - (tall / 2))
	self.main.Think = function(panel)
	    panel:SetTall(Lerp(FrameTime() * 10, panel:GetTall(), tall))
	end
end

function PANEL:SetItem(item)
	self.isedit = true

	for k, v in pairs(self.panels or {}) do
		v:SetValue(item[k])
	end

	if self.panels and IsValid(self.panels.uniqueID) then
		self.panels.uniqueID:SetEnabled(false)
	end
end

function PANEL:Paint(w, h)
	Derma_DrawBackgroundBlur(self, self.startTime)
end

vgui.Register("ItemBase:CreationMenuSub", PANEL, "EditablePanel")