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


local PANEL = {}

local path = "interactiontool"
file.CreateDir(path)

local ValidExtension = {
    realm = {
        ["png"] = true,
        ["jpg"] = true,
        ["jfif"] = true
    },
    content = {
        ["image/png"] = true,
        ["image/jpeg"] = true
    }
}

local function CheckExtensionImage(body, header)
    local content = header["Content-Type"]
    local extension = ValidExtension

    local urlLowerPNG = string.lower(string.sub(body, 2, 4))
    local urlLowerJPEG = string.lower(string.sub(body, 7, 10))

    if extension.realm[urlLowerPNG] or extension.realm[urlLowerJPEG] or extension.content[content] then
        return true
    end

    return false
end

local pagenext = Material("danganronpa/ui/pagenext.png")
local pageback = Material("danganronpa/ui/pageback.png")

function PANEL:Init()
    self:SetTitle("")
    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()
    self:SetDraggable(false)
    self:SetAlpha(0)
    self:AlphaTo(255, 2)
    self.image = "error.png"

    self.ImagePanel = self:Add("DPanel")
    self.ImagePanel:DockMargin(50, 50, 50, 50)
    self.ImagePanel:SetAlpha(0)
    self.ImagePanel:Dock(FILL)
    self.ImagePanel.Paint = function(_, w, h)
        local id = "data/" .. self.image
        local image = Material(id)

        if type(image) == "IMaterial" and !image:IsError() then
            local size = 0.9
            local width = math.Clamp(image:Width() * size, 0, w)
            local height = math.Clamp(image:Height() * size, 0, h)

            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(image)
            surface.DrawTexturedRect(w / 2 - width / 2, h / 2 - height / 2, width, height)
        else
            local curtime = CurTime()
            local alpha = math.sin(curtime * 2) * 255
            local dotA = math.sin(curtime * 1) * 255
            local dot = math.floor(math.abs(dotA) * 0.015)
            local dotStr = string.rep(".", dot + 1)

            local sizeW, sizeH = w / 2, h / 2

            surface.SetDrawColor(255, alpha, 255)
            surface.DrawRect(w / 2 - sizeW / 2, h / 2 - sizeH / 2, sizeW, sizeH)
            draw.DrawText("Loading" .. dotStr, "Default", sizeW, sizeH, Color(alpha, 0, 0), TEXT_ALIGN_CENTER)

            if Material.cache and Material.old then
            	Material.cache[id] = Material.old(id)
            end
        end
    end

    self.LeftButton = self:Add("DButton")
    self.LeftButton:SetWide(45)
    self.LeftButton:DockMargin(10, 0, 0, 0)
    self.LeftButton:SetText("")
    self.LeftButton:Dock(LEFT)
    self.LeftButton.color = Color(255, 255, 255)
    self.LeftButton.Paint = function(_, w, h)
        local frametime = FrameTime() * 5
        if !_:IsEnabled() then
            _.color.r = Lerp(frametime, _.color.r, 10)
            _.color.g = Lerp(frametime, _.color.g, 10)
            _.color.b = Lerp(frametime, _.color.b, 10)
        elseif _:IsHovered() then
            _.color.r = Lerp(frametime, _.color.r, 255)
            _.color.g = Lerp(frametime, _.color.g, 61)
            _.color.b = Lerp(frametime, _.color.b, 96)
        else
            _.color.r = Lerp(frametime, _.color.r, 255)
            _.color.g = Lerp(frametime, _.color.g, 255)
            _.color.b = Lerp(frametime, _.color.b, 255)
        end

        local sizeW, sizeH = w, w * 3

        surface.SetDrawColor(_.color)
        surface.SetMaterial(pageback)
        surface.DrawTexturedRect(0, h / 2 - sizeH / 2, sizeW, sizeH)
    end
    self.LeftButton.DoClick = function()
        self:OpenPage(self.page - 1)
    end

    self.RightButton = self:Add("DButton")
    self.RightButton:SetWide(45)
    self.RightButton:DockMargin(0, 0, 10, 0)
    self.RightButton:SetText("")
    self.RightButton:Dock(RIGHT)
    self.RightButton.color = Color(255, 255, 255)
    self.RightButton.Paint = function(_, w, h)
        local frametime = FrameTime() * 5
        if !_:IsEnabled() then
            _.color.r = Lerp(frametime, _.color.r, 10)
            _.color.g = Lerp(frametime, _.color.g, 10)
            _.color.b = Lerp(frametime, _.color.b, 10)
        elseif _:IsHovered() then
            _.color.r = Lerp(frametime, _.color.r, 255)
            _.color.g = Lerp(frametime, _.color.g, 61)
            _.color.b = Lerp(frametime, _.color.b, 96)
        else
            _.color.r = Lerp(frametime, _.color.r, 255)
            _.color.g = Lerp(frametime, _.color.g, 255)
            _.color.b = Lerp(frametime, _.color.b, 255)
        end

        local sizeW, sizeH = w, w * 3

        surface.SetDrawColor(_.color)
        surface.SetMaterial(pagenext)
        surface.DrawTexturedRect(0, h / 2 - sizeH / 2, sizeW, sizeH)
    end
    self.RightButton.DoClick = function()
        self:OpenPage(self.page + 1)
    end
end

function PANEL:OpenPage(page)
    if !self.data[page] then return end

    local image = self.data[page][1]
    local music = self.data[page][2]

    local uniqueID = util.CRC(image)
    self.image = path .. "/" .. uniqueID .. ".png"
    self.page = page

    self.ImagePanel:SetAlpha(0)
    self.ImagePanel:AlphaTo(255, 0.4)

    if IsValid(self.LeftButton) then
        self.LeftButton:SetDisabled(!self.data[self.page - 1])
    end

    if IsValid(self.RightButton) then
        self.RightButton:SetDisabled(!self.data[self.page + 1])
    end

    if music then
        local s = self.station
        if s and type(s) == "IGModAudioChannel" and s:IsValid() then
            s:Stop()
            self.station = nil
        end

        sound.PlayURL(music, "", function(station)
            if !IsValid(station) then return end

            station:Play()
            self.station = station
        end)
    end
end

function PANEL:OpenData(data)
    self.data = data

    for k, v in ipairs(data) do
        local imageURL = v[1]
        local uniqueID = util.CRC(imageURL)

        imageURL = imageURL:gsub("cdn.discordapp.com", "media.discordapp.net")

        http.Fetch(imageURL, function(body, size, headers)
            local extension = CheckExtensionImage(body, headers)
            if !extension then return end

            file.Write(path .. "/" .. uniqueID .. ".png", body)
        end)
    end

    if data[1] then
        self:OpenPage(1)
    end

    if #data <= 1 then
        self.LeftButton:Remove()
        self.RightButton:Remove()
    end
end

function PANEL:OnRemove()
    local s = self.station
    if s and type(s) == "IGModAudioChannel" and s:IsValid() then
        s:Stop()
        self.station = nil
    end
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 120)
    surface.DrawRect(0, 0, w, h)

    asterionlib.DrawBlur(self, 5)
end

vgui.Register("arb.InteractionMenu", PANEL, "DFrame")