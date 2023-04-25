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

MapReversion.shouldHidden = false
MapReversion.startDrawing = MapReversion.startDrawing or false
MapReversion.material = MapReversion.material or nil
MapReversion.tex = MapReversion.tex or nil
MapReversion.frame = MapReversion.frame or nil

MapReversion.vec = MapReversion.vec or Vector()
MapReversion.ang = MapReversion.ang or Angle()
MapReversion.fov = MapReversion.fov or 90


function MapReversion:CreateTex()
	local tex = GetRenderTarget("MapReversion_" .. CurTime(), ScrW(), ScrH())
	local mat = CreateMaterial("MapReversion_" .. CurTime(), "UnlitGeneric", {
		["$basetexture"] = "",
		["$basetexturetransform"] = "center .5 .5 scale -1 1 rotate 0 translate 0 0",
	})

	return tex, mat
end

function MapReversion:GetMaterial()
	return self.material
end

function MapReversion:GetFrame()
	return self.frame
end

function MapReversion:CreateFrame()
	self.startDrawing = false -- если начинаем рисовать сразу, то появляется белый квадрат
	self.tex, self.material = self:CreateTex()

	local frame = vgui.Create("EditablePanel")
	frame:SetPos(0, 0)
	frame:SetSize(ScrW(), ScrH())
	frame.Paint = function(this, w, h)
		if Arbitrage.OnMapReversion() then
			local client = LocalPlayer()
			if !IsValid(client) then return end

			render.SetRenderTarget(self.tex)
				self.shouldHidden = true
					render.RenderView({
						origin = self.vec,
						angles = self.ang,
						fov = self.fov,
						x = 0,
						y = 0,
						w = w,
						h = h,
						drawviewmodel = false
					})
				self.shouldHidden = false
			render.SetRenderTarget()

			self.material:SetTexture("$basetexture", self.tex)
			self.startDrawing = true
		else
			this:Remove()
		end
	end

	self.frame = frame
end


function MapReversion:InputMouseApply(cmd, x, y, angle)
	if Arbitrage.OnMapReversion() then
		local ui = MonoPad:GetUI()

		if !IsValid(ui) or !ui.editing then
			local pitch = y * GetConVar("m_pitch"):GetFloat()
			local yaw = x * -GetConVar("m_yaw"):GetFloat()

			angle.p = angle.p + pitch
			angle.y = angle.y + yaw * -1
			cmd:SetViewAngles(angle)

			return true
		end
	end
end

function MapReversion:CreateMove(cmd)
	if Arbitrage.OnMapReversion() then
		cmd:SetSideMove(-cmd:GetSideMove())
	end
end

function MapReversion:Render()
	if Arbitrage.OnMapReversion() then
		local frame = self:GetFrame()
		if !IsValid(frame) then
			self:CreateFrame()
		else
			local material = self:GetMaterial()

			if material and self.startDrawing then
				surface.SetDrawColor(255, 255, 255)
				surface.SetMaterial(material)
				surface.DrawTexturedRect(-1, -1, ScrW() + 1, ScrH() + 1)
			end
		end
	end
end

function MapReversion:PrePlayerDraw(client)
	if Arbitrage.OnMapReversion() and client == LocalPlayer() and !self.shouldHidden then
		return true
	end
end

function MapReversion:RenderScene(vec, ang, fov)
	if Arbitrage.OnMapReversion() then
		self.vec = vec
		self.ang = ang
		self.fov = fov
	end
end


local metaVec = FindMetaTable("Vector")
metaVec.oldToScreen = metaVec.oldToScreen or metaVec.ToScreen
function metaVec:ToScreen(...)
	local data = self:oldToScreen(...)

	if Arbitrage.OnMapReversion() then
		data.x = ScrW() - data.x
	end

	return data
end