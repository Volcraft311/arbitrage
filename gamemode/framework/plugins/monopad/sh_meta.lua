--[[
        © AsterionStaff 2023.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


local MONOPAD = {}
MONOPAD.__index = MONOPAD
MONOPAD.id = 0
MONOPAD.owner = nil
MONOPAD.team = nil
MONOPAD.receivers = {}

MONOPAD.messagesNotify = 0
MONOPAD.countNotes = 0

MONOPAD.notes = {}
MONOPAD.messages = {}
MONOPAD.evidences = {}

MONOPAD.rulesNotify = {}

MONOPAD.caseStored = {}
MONOPAD.mutedChats = {}
MONOPAD.history = {}

function MONOPAD:__tostring()
	return "monopad[" .. self.id .. "]"
end

function MONOPAD:__eq(other)
	return self:GetID() == other:GetID()
end

function MONOPAD:GetID()
	return self.id
end

function MONOPAD:GetTeam()
	return self.team
end

function MONOPAD:SetOwner(client)
	self.owner = client:SteamID()

	local faction = Character.team:GetByID(client:Team())
	if faction then
		self.team = faction:GetID()
	end
end

function MONOPAD:GetReceivers()
	local data = {}

	for _, client in ipairs(player.GetAll()) do
		local inventory = client:GetInventory()
		if !inventory then continue end

		local items = inventory:GetItems()
		for _, item in ipairs(items) do
			local id = item:GetID()

			if id == self.id then -- and item:GetData("equip") then
				data[#data + 1] = client
			end
		end
	end

	return data
end


function MONOPAD:CreateNotes(title)
	self.countNotes = self.countNotes + 1
	local id = self.countNotes

	self.notes[id] = {
		title = title,
		description = ""
	}
end

function MONOPAD:EditNotes(id, title, description)
	self.notes[id] = {
		title = title,
		description = description
	}
end

function MONOPAD:RemoveNotes(id)
	self.notes[id] = nil
end


function MONOPAD:AddMessage(id, data)
	local info = self.messages[id] or {}
	table.insert(info, data)

	if #info > 50 then
		table.remove(info, 1)
	end

	self.messages[id] = info
end

function MONOPAD:AddEvidence(idx, time)
	if self.evidences[idx] then return end

	time = tonumber(time) or Arbitrage.ReturnTime()
	self.evidences[idx] = time
end

function MONOPAD:RemoveEvidence(idx)
	self.evidences[idx] = nil
end


function MONOPAD:IsReceiver(entity)
	for id, receiver in ipairs(self:GetReceivers()) do
	    if receiver == entity then
	        return true
	    end
	end

	return false
end

if SERVER then
	function MONOPAD:Sync(client)
		MonoPad.instances[self.id] = self

		local messagesNotify = 0
		for k, v in pairs(self.messages) do
			for k2, v2 in ipairs(v) do
				if v2.notify and self.team != v2.faction then
					messagesNotify = messagesNotify + 1
				end
			end
		end

		local function sync(pl)
		    netstream.Start(pl, "MonoPad:SyncObject", self.id, self.team, self.evidences, messagesNotify, self.caseStored, self.mutedChats)
		end

		if IsValid(client) then
		    sync(client)
		end

		for id, receiver in ipairs(self:GetReceivers()) do
		    if IsValid(receiver) and receiver:IsPlayer() and client != receiver then
		        sync(receiver)
		    end
		end
	end

	function MONOPAD:SyncHistory(client)
		local function sync(pl)
			netstream.Start(pl, "MonoPad:SyncObjectHistory", self.id, self.history, self.lastHistory)
		end

		if IsValid(client) then
		    sync(client)
		end

		for id, receiver in ipairs(self:GetReceivers()) do
		    if IsValid(receiver) and receiver:IsPlayer() and client != receiver then
		        sync(receiver)
		    end
		end
	end
end

debug.getregistry().Monopad = MONOPAD