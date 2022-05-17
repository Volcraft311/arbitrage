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
PLUGIN.cache = {}
PLUGIN.caching = PLUGIN.caching or false

local function isImage(data)
    data = tostring(data)

    if data then
        return string.find(data, ".png") or string.find(data, ".jpg")
    end

    return false
end

local function CacheTable(data)
    if !data then return end

    if istable(data) then
        for k, v in pairs(data) do
            CacheTable(k)
            CacheTable(v)
        end
    elseif isstring(data) and isImage(data) then
        PLUGIN.cache[#PLUGIN.cache + 1] = data
    end
end

function PLUGIN:CacheMat(data, num, max_num)
    if !SETTINGS.options.Get("enable_autocache") then return end

    Material(data)

    data = data .. "  [" .. num .. "/" .. max_num .. "]"

    surface.SetFont("arb.Font_FuturaPTBook_7")
    local width, _ = surface.GetTextSize(data)

    self.text = data
    self.w = width
end

function PLUGIN:StartCaching(data)
    if #data <= 0 then return end
    if self.caching then return end

    self.caching = true
    local colddown = 0.25 -- 0.25

    for i, element in SortedPairs(data) do
        timer.Simple(colddown * i, function()
            self:CacheMat(element, i, #data)
        end)
    end

    timer.Simple(colddown * #data + 3, function()
        self.caching = false
    end)
end

function PLUGIN:EndSaving()
    local data = table.Copy(PLUGIN.cache)
    PLUGIN.cache = {}

    for k, v in pairs(data) do
        if Arbitrage.cachedMaterials[v] then
            data[k] = nil
        end
    end

    local data2 = {}
    for k, v in pairs(data) do
        data2[#data2 + 1] = v
    end

    self:StartCaching(data)
end

function PLUGIN:StartSaving()
    if !SETTINGS.options.Get("enable_autocache") then return end

    -- Кешируем все картинки у всех персонажей
    do
        local data = Arbitrage.teams.data

        CacheTable(data)
    end


    -- картинки всех улик
    do
        local data = Evidence.icons

        CacheTable(data)
    end


    -- остальное
    do
        local path = "danganronpa/"

        CacheTable(path .. "hud/health.png")
        CacheTable(path .. "hud/hunger.png")
        CacheTable(path .. "hud/sleep.png")
        CacheTable(path .. "hud/thirst.png")


        CacheTable(path .. "law/big_bullet.png")
        CacheTable(path .. "law/big_bullet_blur.png")
        CacheTable(path .. "law/bullet.png")
        CacheTable(path .. "law/bullet_l.png")
        CacheTable(path .. "law/circle.png")
        CacheTable(path .. "law/circle_b.png")
        CacheTable(path .. "law/cylinder.png")
        CacheTable(path .. "law/interface.png")
        CacheTable(path .. "law/start.png")

        CacheTable(path .. "law/nsb/1.png")
        CacheTable(path .. "law/nsb/1_l.png")
        CacheTable(path .. "law/nsb/2.png")
        CacheTable(path .. "law/nsb/2_l.png")
        CacheTable(path .. "law/nsb/3.png")
        CacheTable(path .. "law/nsb/3_l.png")
        CacheTable(path .. "law/nsb/4.png")
        CacheTable(path .. "law/nsb/4_l.png")
        CacheTable(path .. "law/nsb/5.png")
        CacheTable(path .. "law/nsb/5_l.png")

        CacheTable(path .. "law/table/active.png")
        CacheTable(path .. "law/table/base.png")
        CacheTable(path .. "law/table/disable.png")

        CacheTable(path .. "law/table/base.png")
        CacheTable(path .. "law/table/base_s.png")
        CacheTable(path .. "law/table/time_ff.png")


        CacheTable(path .. "note/bg.png")
        CacheTable(path .. "note/red.png")
        CacheTable(path .. "note/yellow.png")


        CacheTable(path .. "note/connect_1.png")
        CacheTable(path .. "note/connect_2.png")
        CacheTable(path .. "note/connect_3.png")
        CacheTable(path .. "note/connect_4.png")
        CacheTable(path .. "note/connect_5.png")


        CacheTable(path .. "selector/first.png")
        CacheTable(path .. "selector/key.png")


        CacheTable(path .. "splashscreen/bg.png")
        CacheTable(path .. "splashscreen/vignette.png")


        CacheTable(path .. "ui/back.png")
        CacheTable(path .. "ui/bg.png")
        CacheTable(path .. "ui/bg_glassshards.png")
        CacheTable(path .. "ui/bg_light.png")
        CacheTable(path .. "ui/circle.png")
        CacheTable(path .. "ui/content_mini.png")
        CacheTable(path .. "ui/delete.png")
        CacheTable(path .. "ui/discord.png")
        CacheTable(path .. "ui/discord_mini.png")
        CacheTable(path .. "ui/evidence.png")
        CacheTable(path .. "ui/logo.png")
        CacheTable(path .. "ui/settings.png")
        CacheTable(path .. "ui/socialization.png")
        CacheTable(path .. "ui/tell.png")
        CacheTable(path .. "ui/vk_mini.png")
        CacheTable(path .. "ui/warning.png")
        CacheTable(path .. "ui/wiki_mini.png")
    end

    self:EndSaving()
end

local settings_mat = Material("danganronpa/ui/settings.png")
function PLUGIN:HUDPaint()
    if !self.caching then return end
    if !SETTINGS.options.Get("enable_autocache") then return end

    local padding = W(5)
    local es = W(5)

    local text = self.text or "materials/error.png"
    local w = W(140) + (self.w or W(310))
    local h = H(30)
    local alpha = 160 + (math.sin(CurTime() * 3) * 127.5)

    surface.SetDrawColor(27, 10, 13, 204)
    surface.DrawRect(padding, padding, w, h)

    surface.SetDrawColor(255, 61, 96, 165.75)
    surface.DrawOutlinedRect(padding, padding, w, h, 2)

    surface.SetDrawColor(255, 255, 255, alpha)
    surface.SetMaterial(settings_mat)
    surface.DrawTexturedRectRotated(padding + h / 2 + es, padding + h / 2, h - es * 2, h - es * 2, CurTime() % 360 * 50)

    draw.SimpleText("Загружаем: " .. text, "arb.Font_FuturaPTBook_7", padding * 3 + h, padding + H(4), Color(255, 220, 228, alpha), TEXT_ALIGN_LEFT)
    draw.DrawText("Внимание! Ваш клиент заранее кэширует ассеты используемые на сервере во благо избежений микро-фризов во время игры.\nИгра может подвисать во время загрузки...", "arb.Font_FuturaPTBook_5", padding, padding + h + H(1), Color(255, 220, 228, 255), TEXT_ALIGN_LEFT)
    draw.SimpleText("Отключить авто-кэширование можно в настройках режима", "arb.Font_FuturaPTBook_5", padding, padding + h + H(31), Color(255, 220, 228, 30), TEXT_ALIGN_LEFT)
end

function Arbitrage.StartCaching()
    PLUGIN:StartSaving()
end