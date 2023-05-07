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


local function returnKeyData(tbl)
    local min = 0
    local max = 0

    local data = {}
    for k, v in pairs(tbl) do
        data[#data + 1] = k
    end

    min = math.min(unpack(data))
    max = math.max(unpack(data))

    return min, max
end

local PANEL = {}

function PANEL:Init()
    self.list = {}

    --debug
    -- self:SetPos(0, 0)
    -- self:SetSize(ScrW(), ScrH())
    -- self:MakePopup()

    -- self:Start()
end

function PANEL:Start(callback)
    local main = MonoPad:GetUI()
    main.isLoading = true
    
    self.size = self:GetWide() / 10
    self.padding = (self.size * 10) - self:GetTall()

    for y = 1, 10 do
        for x = 1, 10 do
            self.list[x] = self.list[x] or {}

            local object = {
                x = (x - 1) * self.size,
                y = (y - 1) * self.size - self.padding / 2,
                size = 0,
                sizeTo = 0,
                alpha = 0,
                white = false,

                GetX = function(this)
                    return this.x
                end,
                GetY = function(this)
                    return this.y
                end,
                GetSize = function(this)
                    return math.min(this.size, self.size + 1)
                end,
                SetSize = function(this, amount)
                    this.sizeTo = amount + 2
                end,
                White = function(this, time)
                    this.white = true

                    timer.Simple(time, function()
                        this.white = false
                    end)
                end,
                Draw = function(this)
                    local x, y = this.x, this.y
                    local w, h = self.size, self.size
                    local size = this.size

                    local _x, _y = x + w / 2 - size / 2, y + h / 2 - size / 2
                    surface.SetDrawColor(31, 31, 31)
                    surface.DrawRect(_x, _y, size, size)

                    surface.SetDrawColor(255, 255, 255, this.alpha)
                    surface.DrawRect(_x, _y, size, size)
                end,
                Think = function(this)
                    this.size = Lerp(FrameTime() * 10, this.size, this.sizeTo)
                    this.alpha = Lerp(FrameTime() * 10, this.alpha, this.white and 70 or -1)
                end
            }

            self.list[x][y] = object
        end
    end

    self:CreateLogo()

    self:StartAnimation(self.size, function()
        timer.Simple(0.3, function()
            if callback then
                callback()
            end
        end)

        local id = "MonoPad:LoadingWhiteRect"
        timer.Create(id, FrameTime() * 10, 0, function()
            if !IsValid(self) then
                return timer.Remove(id)
            end

            local ran1, ran2 = math.random(1, 10), math.random(1, 10)

            local object = self.list[ran1][ran2]
            object:White(math.random() * 0.2)
        end)

        timer.Simple(math.random(1, 5), function()
            timer.Remove(id)
            if !IsValid(self) then return end

            self:EndAnimation()
        end)
    end)
end

local innercircleMat = Material("danganronpa/monopad/load_innercircle.png")
local outercircleMat = Material("danganronpa/monopad/load_outercircle.png")
local size = 200
function PANEL:CreateLogo()
    self.logo = self:Add("DPanel")
    self.logo:SetAlpha(0)
    self.logo:AlphaTo(255, 1.5)
    self.logo:SizeTo(size, size, 0.5, 0, -1, function()
        self.logo:SizeTo(size * 1.3, size * 1.3, 1)
    end)
    self.logo:SetSize(size * 3, size * 3)
    self.logo.Think = function()
        self.logo:SetPos(self:GetWide() / 2 - self.logo:GetWide() / 2, self:GetTall() / 2 - self.logo:GetTall() / 2)
    end

    self.logo.Paint = function(_, w, h)
        local amount = CurTime() * 200 % 360

        surface.SetDrawColor(255, 255, 255)

        surface.SetMaterial(innercircleMat)
        surface.DrawTexturedRectRotated(w / 2, h / 2, w, h, amount)

        surface.SetMaterial(outercircleMat)
        surface.DrawTexturedRectRotated(w / 2, h / 2, w, h, -amount)
    end
end

--[[
    local data = {
        [1] = {
            [5] = {5, 6},
            [6] = {5, 6}
        },
        [2] = {
            [4] = {5, 6},
            [5] = {4, 7},
            [6] = {4, 7},
            [7] = {5, 6},
        },
        [3] = {
            [3] = {5, 6},
            [4] = {4, 7},
            [5] = {3, 8},
            [6] = {3, 8},
            [7] = {4, 7},
            [8] = {5, 6},
        },
        [4] = -- и так далее до 10
    }
]]--
local function getAnimInfo()
    local startData = {5, 6}
    local data = {{[5] = startData, [6] = startData}}

    for i = 2, 10 do
        data[i] = data[i] or {}

        local old = data[i - 1]

        for k, v in pairs(old) do
            data[i][k] = {old[k][1] - 1, old[k][2] + 1}
        end

        local min, max = returnKeyData(old)

        data[i][min - 1] = startData
        data[i][max + 1] = startData
    end

    return data
end

local speed = 0.07
function PANEL:StartAnimation(amount, callback)
    local data = getAnimInfo()

    for index, v in ipairs(data) do
        for y, v2 in pairs(v) do
            for _, x in ipairs(v2) do
                timer.Simple((index - 1) * speed, function()
                    if !IsValid(self) then return end

                    local object = istable(self.list[x]) and self.list[x][y]
                    if !object then return end

                    object:SetSize(amount)
                end)
            end
        end
    end

    timer.Simple(#data * speed, function()
        callback()
    end)
end

function PANEL:EndAnimation()
    for x = 1, 10 do
        for y = 1, 10 do
            local object = self.list[x][y]
            object.white = false
        end
    end

    if IsValid(self.logo) then
        self.logo:SizeTo(0, 0, 0.2)
        self.logo:AlphaTo(0, 1)
    end

    self:StartAnimation(0, function()
        self:Remove()

        local main = MonoPad:GetUI()

        if IsValid(main) then
            main.isLoading = false
        end
    end)
end

function PANEL:Paint(w, h)
    asterionlib.DrawRender(function()
        surface.SetDrawColor(255, 255, 255)
        surface.DrawRect(0, 0, w, h - 40)
    end, function()
        for x = 1, 10 do
            for y = 1, 10 do
                local object = self.list[x][y]

                object:Think()
                object:Draw()
            end
        end
    end)
end

vgui.Register("MonoPad:Loading", PANEL, "Panel")