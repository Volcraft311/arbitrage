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

include("shared.lua")


AddCSLuaFile("cl_panel.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_lab/clipboard.mdl")
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	self.data = {font = 1, editors = {}, pages = {}}
	self:AddNewPage()

	local physObj = self:GetPhysicsObject()

	if (IsValid(physObj)) then
		physObj:EnableMotion(true)
		physObj:Wake()
	end
end

function ENT:AddNewPage()
	local data = self.data

	self.data.pages[#data.pages + 1] = {
		title = "Заголовок",
		text = "Ваш текст..."
	}
end

function ENT:RemoveLastPage()
	local data = self.data

	self.data.pages[#data.pages] = nil
end

function ENT:AddEditor(steamid)
	self.data.editors[steamid] = true
end

function ENT:RemoveEditor(steamid)
	self.data.editors[steamid] = nil
end

function ENT:AutoAddEditor(client)
	if table.Count(self.data.editors) <= 0 then
		self.data.editors[client:SteamID()] = true
	end
end

function ENT:OpenNote(client, page, bEdit, bClose)
	local info = self.data.pages[page]
	if !info then return end

	local data = {}
	data.editors = self.data.editors
	data.title = info.title
	data.text = info.text
	data.page = page
	data.pages = #self.data.pages
	data.entity = self
	data.edit = bEdit and true or false
	data.font = self.data.font

	netstream.Start(client, "arb.OpenNote", data, bEdit, bClose)
end

function ENT:ReadNote(client, page, bClose)
	self:OpenNote(client, page, false, bClose)
end

function ENT:EditNote(client, page, bClose)
	if !self:HasAccess(self.data.editors, client) then return end

	self:OpenNote(client, page, true, bClose)
end

local actionList = {
	["CHANGE_PAGE"] = function(client, entity, data)
		local page = data[1]
		local bEdit = data[2]

		if bEdit then
			if !entity:HasAccess(entity.data.editors, client) then return end

			entity:EditNote(client, page)
		else
			entity:ReadNote(client, page)
		end
	end,
	["SAVE_PAGE"] = function(client, entity, data)
		local page = data[1]
		local title = data[2]
		local text = data[3]

		if !entity.data.pages[page] then return end
		if !entity:HasAccess(entity.data.editors, client) then return end
		if utf8.len(title) > NOTE_SIZE_TITLE then return end
		if utf8.len(text) > NOTE_SIZE_TEXT then return end

		entity.data.pages[page].title = title
		entity.data.pages[page].text = text

		netstream.Start(client, "arb.Notify", "Вы успешно сохранили страницу №" .. page .. "!", false)
	end,
	["DELETE_PAGE"] = function(client, entity, data)
		local page = data[1]

		if !entity:HasAccess(entity.data.editors, client) then return end

		local last_page = #entity.data.pages
		if last_page <= 1 then return end

		entity.data.pages[last_page] = nil

		if last_page == page then
			entity:EditNote(client, page - 1, true)
		else
			entity:EditNote(client, page)
		end

		netstream.Start(client, "arb.Notify", "Вы успешно удалили страницу №" .. last_page .. "!", false)
	end,
	["CREATE_PAGE"] = function(client, entity, data)
		local page = data[1]

		if !entity:HasAccess(entity.data.editors, client) then return end
		if #entity.data.pages >= NOTE_MAX_PAGES then return end

		entity:AddNewPage()
		entity:EditNote(client, page)

		netstream.Start(client, "arb.Notify", "Вы успешно создали страницу №" .. #entity.data.pages .. "!", false)
	end,
	["READ_PAGE"] = function(client, entity, data)
		local page = data[1]

		if !entity:HasAccess(entity.data.editors, client) then return end

		entity:ReadNote(client, page, true)
	end,
	["REMOVE_EDITOR"] = function(client, entity, data)
		local editor = data[1]

		if !entity:HasAccess(entity.data.editors, client) then return end

		entity.data.editors[editor] = nil
	end,
	["ADD_EDITOR"] = function(client, entity, data)
		local steamid = data[1]

		if !steamid then return end
		if !string.find(steamid, "STEAM_") then return end
		if !entity:HasAccess(entity.data.editors, client) then return end

		entity.data.editors[steamid] = true
	end,
	["CHANGE_FONT"] = function(client, entity, data)
		local page = data[1]
		local font = data[2]

		if !entity:HasAccess(entity.data.editors, client) then return end
		if !NOTE_FONTS[font] then return end

		entity.data.font = font

		entity:EditNote(client, page, true)
	end
}

netstream.Hook("arb.NoteAction", function(client, name, entity, ...)
	local data = {...}

	if !IsValid(entity) then return end
	if entity:GetClass() != "arb_note" then return end
	if client:GetPos():Distance(entity:GetPos()) >= 130 then return end

	if actionList[name] then
		actionList[name](client, entity, data)
	end
end)