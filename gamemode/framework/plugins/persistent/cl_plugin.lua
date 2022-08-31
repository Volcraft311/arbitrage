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


local PLUGIN = PLUGIN

PLUGIN.alpha = 255
PLUGIN.isOn = false
PLUGIN.bodyList = PLUGIN.bodyList or {}

local vignitte = surface.GetTextureID("vgui/vignette")
function PLUGIN:RenderScreenspaceEffects()
	if self.alpha >= 250 then return end

	local ba = math.abs(math.sin(RealTime()))

	local tab = {
	    ["$pp_colour_addr"] = 0,
	    ["$pp_colour_addg"] = 0,
	    ["$pp_colour_addb"] = 0,
	    ["$pp_colour_brightness"] = 0,
	    ["$pp_colour_contrast"] = 1,
	    ["$pp_colour_colour"] = self.alpha / 255 + ba * 0.3,
	    ["$pp_colour_mulr"] = 0,
	    ["$pp_colour_mulg"] = 0,
	    ["$pp_colour_mulb"] = 0
	}

	DrawColorModify(tab)
	DrawSobel(math.random(self.alpha + 1, 10))
end

local static = Material("danganronpa/hud/static.png")
local lens = Material("effects/strider_pinch_dudv")

function PLUGIN:HUDPaint()
	self.alpha = Lerp(FrameTime(), self.alpha, self.isOn and 0 or 255)
	if self.alpha >= 250 then return end

	local ba = math.abs(math.sin(RealTime()))
	local size = 50
	local w, h = ScrW() + size, ScrH() + size
	local staticX, staticY = w / 2, h / 2

	lens:SetFloat("$refractamount",	(255 - self.alpha) * 0.00015)

	surface.SetMaterial(lens)
	surface.SetDrawColor(Color(255,255,255,1))
	surface.DrawTexturedRectRotated(staticX + math.Rand(-15,15), staticY + math.Rand(-15,15), w * math.Rand(0.8,2), h * math.Rand(0.8,2), 0)

	surface.SetDrawColor(255, 255, 255, math.random(10, 100) - self.alpha / 2)
	surface.SetMaterial(static)
	surface.DrawTexturedRect(ScrW() / 2 - w / 2 + math.random(-size, size), ScrH() / 2 - h / 2 + math.random(-size, size), w, h)

	surface.SetDrawColor(0, 0, 0, math.random(0, 50) - self.alpha)
	surface.DrawRect(0, 0, w, h)

	for i = 1, 2 do
		surface.SetTexture(vignitte)
		surface.SetDrawColor(255, 255, 255, (ba * 255) - self.alpha)
		surface.DrawTexturedRect(-1, -1, ScrW() + 2, ScrH() + 2)
	end
end

function PLUGIN:EnableEffect(entity)
	self.isOn = true

	if !timer.Exists("fb:DisableEffect") then
	    timer.Create("fb:DisableEffect", self.turnoff_time, 1, function()
	        self.isOn = false
	    end)

	    local volume = SETTINGS.options.Get("corpse_find_volume") or 50
	    sound.PlayFile("sound/discoverycreepy.wav", "", function(station)
	        if IsValid(station) then
	            station:SetVolume(volume / 100)
	        end
	    end)

	    netstream.Start("fb:ChangeFOV")
	end

	netstream.Start("fb:TraceBody", entity)
end

function PLUGIN:IsOn()
	return self.isOn
end

timer.Create("fb:CheckTrace", 0.1, 0, function()
	local client = LocalPlayer()
	if !IsValid(client) then return end

	if Arbitrage.OffCorpseEffect() then return end
	if !PLUGIN:AllowDetectCorpse(client) then return end

	local trace = client:GetEyeTrace()
	local entity = trace.Entity
	if !IsValid(entity) then return end

	local attackerID = entity:IsCorpse()
	if !attackerID then return end
	if attackerID == LocalPlayer():SteamID() then return end

	local dist = client:GetPos():DistToSqr(entity:GetPos())
	if dist >= 270000 then return end

	if !PLUGIN.bodyList[entity] then
	    PLUGIN.bodyList[entity] = true

	    PLUGIN:EnableEffect(entity)
	end
end)