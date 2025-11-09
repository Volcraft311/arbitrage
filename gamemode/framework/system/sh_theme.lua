--[[
        © AsterionStaff 2025.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


Arbitrage.theme = Arbitrage.library.Add("theme")
Arbitrage.theme.stored = Arbitrage.theme.stored or {}
Arbitrage.theme.default = "red"
Arbitrage.theme.convar = CreateClientConVar("arb_theme", Arbitrage.theme.default, true, true)

function Arbitrage.theme:Add(uniqueID, data)
    data.images = data.images or {}
    data.colors = data.colors or {}
    data.default = {images = {}, colors = {}}

    data.uniqueID = uniqueID

    -- colors
    for key, value in pairs(data.colors) do
        data.default.colors[key] = Color(value.r or 255, value.g or 255, value.b or 255, value.a or 255)
    end

    -- images
    for key, value in pairs(data.images) do
        data.default.images[key] = value
    end

    Arbitrage.theme.stored[uniqueID] = data
end

function Arbitrage.theme:Get(theme_id)
    return self.stored[theme_id]
end

function Arbitrage.theme:GetActive()
    if Arbitrage.OnGamemasterTheme() then
        local theme = self:Get("gamemaster")

        if theme then
            return theme
        end
    end

    local theme_id = self.convar:GetString()
    local theme = self:Get(theme_id) or self:Get(self.default)

    return theme
end

function Arbitrage.theme:LoadThemeParameters(theme_id, data)
    local theme = self:Get(theme_id)
    if !theme then return end

    data.colors = data.colors or {}
    data.images = data.images or {}

    -- Инициализируем все установленные цвета
    for key, value in pairs(data.colors) do
        theme.colors[key] = Color(value.r or 255, value.g or 255, value.b or 255, theme.default.colors[key].a)
    end

    -- Инициализируем все установленные картинки
    for key, value in pairs(data.images) do
        theme.images[key] = value
    end
end

function Arbitrage.theme:GetInformation()
    local theme = Arbitrage.theme:GetActive()
    local color = theme.information

    return Color(color.r, color.g, color.b, color.a)
end

function Arbitrage.theme:GetTextTitle()
    local theme = Arbitrage.theme:GetActive()
    local color = theme.colors.text_title

    return Color(color.r, color.g, color.b, color.a)
end

function Arbitrage.theme:GetTextCategory()
    local theme = Arbitrage.theme:GetActive()
    local color = theme.colors.text_category

    return Color(color.r, color.g, color.b, color.a)
end

function Arbitrage.theme:GetTextPrimary()
    local theme = Arbitrage.theme:GetActive()
    local color = theme.colors.text_primary

    return Color(color.r, color.g, color.b, color.a)
end

function Arbitrage.theme:GetTextSecondary()
    local theme = Arbitrage.theme:GetActive()
    local color = theme.colors.text_secondary

    return Color(color.r, color.g, color.b, color.a)
end

function Arbitrage.theme:GetTextTertriary()
    local theme = Arbitrage.theme:GetActive()
    local color = theme.colors.text_tertriary

    return Color(color.r, color.g, color.b, color.a)
end

function Arbitrage.theme:GetTextButton()
    local theme = Arbitrage.theme:GetActive()
    local color = theme.colors.text_button

    return Color(color.r, color.g, color.b, color.a)
end

function Arbitrage.theme:GetTextHover()
    local theme = Arbitrage.theme:GetActive()
    local color = theme.colors.text_hover

    return Color(color.r, color.g, color.b, color.a)
end

function Arbitrage.theme:GetTextAttention()
    local theme = Arbitrage.theme:GetActive()
    local color = theme.colors.text_attention

    return Color(color.r, color.g, color.b, color.a)
end

function Arbitrage.theme:GetTextSelected()
    local theme = Arbitrage.theme:GetActive()
    local color = theme.colors.text_selected

    return Color(color.r, color.g, color.b, color.a)
end

function Arbitrage.theme:GetTextUnSelected()
    local theme = Arbitrage.theme:GetActive()
    local color = theme.colors.text_unselected

    return Color(color.r, color.g, color.b, color.a)
end

function Arbitrage.theme:GetTextHeader()
    local theme = Arbitrage.theme:GetActive()
    local color = theme.colors.text_header

    return Color(color.r, color.g, color.b, color.a)
end

function Arbitrage.theme:GetTextUnHeader()
    local theme = Arbitrage.theme:GetActive()
    local color = theme.colors.text_unheader

    return Color(color.r, color.g, color.b, color.a)
end

function Arbitrage.theme:GetTextLocked()
    local theme = Arbitrage.theme:GetActive()
    local color = theme.colors.text_locked

    return Color(color.r, color.g, color.b, color.a)
end

function Arbitrage.theme:GetPlayerTitle()
    local theme = Arbitrage.theme:GetActive()
    local color = theme.colors.player_title

    return Color(color.r, color.g, color.b, color.a)
end

function Arbitrage.theme:GetVisLogos()
    local theme = Arbitrage.theme:GetActive()
    local color = theme.colors.vis_logos

    return Color(color.r, color.g, color.b, color.a)
end

function Arbitrage.theme:GetVisTitles()
    local theme = Arbitrage.theme:GetActive()
    local color = theme.colors.vis_titles

    return Color(color.r, color.g, color.b, color.a)
end

function Arbitrage.theme:GetVisSelectionLine()
    local theme = Arbitrage.theme:GetActive()
    local color = theme.colors.vis_selection_line

    return Color(color.r, color.g, color.b, color.a)
end

function Arbitrage.theme:GetVisSelectionSquare()
    local theme = Arbitrage.theme:GetActive()
    local color = theme.colors.vis_selection_square

    return Color(color.r, color.g, color.b, color.a)
end

function Arbitrage.theme:GetVisThumb()
    local theme = Arbitrage.theme:GetActive()
    local color = theme.colors.vis_thumb

    return Color(color.r, color.g, color.b, color.a)
end

function Arbitrage.theme:GetVisDetailsTitle()
    local theme = Arbitrage.theme:GetActive()
    local color = theme.colors.vis_details_title

    return Color(color.r, color.g, color.b, color.a)
end

function Arbitrage.theme:GetVisDetailsMain()
    local theme = Arbitrage.theme:GetActive()
    local color = theme.colors.vis_details_main

    return Color(color.r, color.g, color.b, color.a)
end

function Arbitrage.theme:GetVisCategorySelected()
    local theme = Arbitrage.theme:GetActive()
    local color = theme.colors.vis_category_selected

    return Color(color.r, color.g, color.b, color.a)
end

function Arbitrage.theme:GetVisCategoryUnselected()
    local theme = Arbitrage.theme:GetActive()
    local color = theme.colors.vis_category_unselected

    return Color(color.r, color.g, color.b, color.a)
end

function Arbitrage.theme:GetVisScrollbar()
    local theme = Arbitrage.theme:GetActive()
    local color = theme.colors.vis_scrollbar

    return Color(color.r, color.g, color.b, color.a)
end

function Arbitrage.theme:GetVisButtonBackground()
    local theme = Arbitrage.theme:GetActive()
    local color = theme.colors.vis_button_background

    return Color(color.r, color.g, color.b, color.a)
end

function Arbitrage.theme:GetVisButtonSelected()
    local theme = Arbitrage.theme:GetActive()
    local color = theme.colors.vis_button_selected

    return Color(color.r, color.g, color.b, color.a)
end

function Arbitrage.theme:GetVisButtonUnselected()
    local theme = Arbitrage.theme:GetActive()
    local color = theme.colors.vis_button_unselected

    return Color(color.r, color.g, color.b, color.a)
end

function Arbitrage.theme:GetVisBackground()
    local theme = Arbitrage.theme:GetActive()
    local color = theme.colors.vis_background

    return Color(color.r, color.g, color.b, color.a)
end

function Arbitrage.theme:GetVisForeground()
    local theme = Arbitrage.theme:GetActive()
    local color = theme.colors.vis_foreground

    return Color(color.r, color.g, color.b, color.a)
end

function Arbitrage.theme:GetVisMount()
    local theme = Arbitrage.theme:GetActive()
    local color = theme.colors.vis_mount

    return Color(color.r, color.g, color.b, color.a)
end

function Arbitrage.theme:GetVisLogoSelect()
    local theme = Arbitrage.theme:GetActive()
    local color = theme.colors.vis_logo_select

    return Color(color.r, color.g, color.b, color.a)
end

function Arbitrage.theme:GetPrimaryBackground()
    local theme = Arbitrage.theme:GetActive()

    local mat = Arbitrage.theme:ProcessMaterial(theme.images.primary_bg)
    if mat then
        return mat
    end
end

function Arbitrage.theme:GetPrimaryBackgroundActive()
    local theme = Arbitrage.theme:GetActive()

    local mat = Arbitrage.theme:ProcessMaterial(theme.images.primary_bg_active)
    if mat then
        return mat
    end
end

function Arbitrage.theme:GetPrimaryBackgroundCharacter()
    local theme = Arbitrage.theme:GetActive()

    local mat = Arbitrage.theme:ProcessMaterial(theme.images.primary_bg_character)
    if mat then
        return mat
    end
end

function Arbitrage.theme:GetPrimaryBackgroundParallaxPrimary()
    local theme = Arbitrage.theme:GetActive()

    local mat = Arbitrage.theme:ProcessMaterial(theme.images.primary_bg_parallax_p)
    if mat then
        return mat
    end
end

function Arbitrage.theme:GetPrimaryBackgroundParallaxSecondary()
    local theme = Arbitrage.theme:GetActive()

    local mat = Arbitrage.theme:ProcessMaterial(theme.images.primary_bg_parallax_s)
    if mat then
        return mat
    end
end

-- Основная тема красного цвета
do
    local main_color = Color(217, 26, 44) -- ЭТО (218, 19, 40) НЕ В ГМОДЕ
    local white_color = Color(255, 242, 245)
    local black_color = Color(0, 0, 0)

    Arbitrage.theme:Add("red", {
        name = "Asterion Academy",
        information = main_color,
        colors = {
            text_title = main_color,  --  текст заглавлений в тексте (главы в руководстве)
            text_category = main_color,  --  текст оглавления категорий
            text_primary = white_color, --  стандартный информационный текст в блоках. Описания, руководство, и т.д.
            text_secondary = white_color, --  второстепенный текст более технического характера (пока не знаю)
            text_tertriary = Color(143, 135, 137), --  третьестепенный текст вспомогательного характера. В основном, менее заметный текст еще более ограниченного назначения

            text_header = main_color, --  выбранная текстовая категория (верхний правый угол)
            text_button = white_color, --  текст размещенный на кнопках
            text_selected = white_color, --  текст для выбранных элементов (выбранная тема, настройка)
            text_unheader = white_color, --  невыбранная текстовая категория (верхний правый угол)
            text_unselected = ColorAlpha(white_color, 25), --  текст для невыбранных элементов (тема не выбрана)
            text_locked = Color(64, 60, 61), --  текст для заблокированных элементов (плейсхолдер, блокировка)
            text_hover = black_color, --  текст при наведении на него курсором
            text_attention = black_color, -- текст предупреждения

            player_title = white_color, -- цвет ника персонажа в главном меню

            vis_logos = main_color, --  логотип(-ы), иконки (лого, выбор языка, загрузка, иконки категорий)
            vis_titles = main_color, --  фон для плашек (внимание)
            vis_selection_line = main_color, --  выделение при выборе опций (длинная сквозная полоса)
            vis_selection_square = main_color, --  выделение при выборе элементов (глава, аддоны)
            vis_thumb = main_color, -- ползунок в скроллбаре
            vis_details_title = main_color, --  детализация (полосы)
            vis_details_main = main_color, -- детализация
            vis_category_selected = main_color, --  выделение выбранной категории (выбранная тема, настройка)
            vis_category_unselected = Color(255, 255, 255), -- не выбранная категория
            vis_scrollbar = Color(255, 242, 245, 15), --  область скроллбара
            vis_button_background = Color(0, 0, 0, 50),
            vis_button_selected = main_color,
            vis_button_unselected = ColorAlpha(main_color, 50),
            vis_background = black_color,
            vis_foreground = main_color,
            vis_mount = ColorAlpha(black_color, 200),
            vis_logo_select = white_color
        },
        images = {
            primary_bg = "asterion/academy/ui/themes/red_background.png",
            primary_bg_active = "asterion/academy/ui/themes/red_background_active.png",
            primary_bg_character = "asterion/academy/ui/themes/red_background_character.png",
            primary_bg_parallax_p = "asterion/academy/ui/themes/red_background_parallax_p.png",
            primary_bg_parallax_s = "asterion/academy/ui/themes/red_background_parallax_s.png"
        }
    })
end

-- Тема Kirigiri
do
    local main_color = Color(255, 211, 116)
    local white_color = Color(255, 242, 245)
    local black_color = Color(0, 0, 0)

    Arbitrage.theme:Add("kirigiri", {
        name = "Danganronpa Kirigiri",
        information = main_color,
        colors = {
            text_title = main_color,
            text_category = main_color,
            text_primary = white_color,
            text_secondary = white_color,
            text_tertriary = Color(143, 135, 137),

            text_header = main_color,
            text_button = white_color,
            text_selected = white_color,
            text_unheader = white_color,
            text_unselected = ColorAlpha(white_color, 25),
            text_locked = Color(64, 60, 61),
            text_hover = black_color,
            text_attention = black_color,

            player_title = white_color,

            vis_logos = main_color,
            vis_titles = main_color,
            vis_selection_line = main_color,
            vis_selection_square = main_color,
            vis_thumb = main_color,
            vis_details_title = main_color,
            vis_details_main = main_color,
            vis_category_selected = main_color,
            vis_category_unselected = Color(255, 255, 255),
            vis_scrollbar = Color(255, 242, 245, 15),
            vis_button_background = Color(0, 0, 0, 50),
            vis_button_selected = main_color,
            vis_button_unselected = ColorAlpha(main_color, 50),
            vis_background = black_color,
            vis_foreground = main_color,
            vis_mount = ColorAlpha(black_color, 200),
            vis_logo_select = white_color
        },
        images = {
            primary_bg = "asterion/academy/ui/themes/kirigiri_background.png",
            primary_bg_active = "asterion/academy/ui/themes/kirigiri_background_active.png",
            primary_bg_character = "asterion/academy/ui/themes/kirigiri_background_character.png",
            primary_bg_parallax_p = "",
            primary_bg_parallax_s = ""
        }
    })
end

-- ГМская тема
do
    local main_color = Color(255, 255, 255)
    local white_color = Color(255, 255, 255)
    local black_color = Color(0, 0, 0)

    Arbitrage.theme:Add("gamemaster", {
        name = "Игровой Мастер",
        information = main_color,
        colors = {
            text_title = main_color,
            text_category = main_color,
            text_primary = white_color,
            text_secondary = white_color,
            text_tertriary = Color(143, 135, 137),

            text_header = main_color,
            text_button = white_color,
            text_selected = white_color,
            text_unheader = white_color,
            text_unselected = ColorAlpha(white_color, 25),
            text_locked = Color(64, 60, 61),
            text_hover = black_color,
            text_attention = black_color,

            player_title = white_color,

            vis_logos = main_color,
            vis_titles = main_color,
            vis_selection_line = main_color,
            vis_selection_square = main_color,
            vis_thumb = main_color,
            vis_details_title = main_color,
            vis_details_main = main_color,
            vis_category_selected = main_color,
            vis_category_unselected = Color(255, 255, 255),
            vis_scrollbar = Color(255, 242, 245, 15),
            vis_button_background = Color(0, 0, 0, 50),
            vis_button_selected = main_color,
            vis_button_unselected = ColorAlpha(main_color, 50),
            vis_background = black_color,
            vis_foreground = main_color,
            vis_mount = ColorAlpha(black_color, 200),
            vis_logo_select = white_color
        },
        images = {
            primary_bg = "asterion/academy/ui/themes/example_background.png",
            primary_bg_active = "asterion/academy/ui/themes/example_background_active.png",
            primary_bg_character = "",
            primary_bg_parallax_p = "",
            primary_bg_parallax_s = "asterion/academy/ui/themes/example_background_parallax_p.png"
        },
        onInitialized = function(this)
        end,
        onEdit = function(this, key, value)
            local uniqueID = this.uniqueID

            if CLIENT then
                netstream.Start("Theme:EditParamTheme", uniqueID, key, value)
            else
                Arbitrage.theme.custom[uniqueID] = Arbitrage.theme.custom[uniqueID] or {colors = {}, images = {}}

                if isstring(value) then
                    Arbitrage.theme.custom[uniqueID].images[key] = value
                elseif istable(value) then
                    local color = Color(value.r or 255, value.g or 255, value.b or 255, this.default.colors[key].a)

                    Arbitrage.theme.custom[uniqueID].colors[key] = color
                end

                netstream.Start(nil, "Theme:EditParamTheme", uniqueID, key, value)
            end
        end,
        onCanEdit = function(this, client)
            if !Arbitrage.OnGamemasterTheme() then return false end

            return client:IsAdmin()
        end,
        onCanSelect = function(this)
            return false
        end
    })
end

-- Пользовательская тема
do
    local main_color = Color(255, 255, 255)
    local white_color = Color(255, 255, 255)
    local black_color = Color(0, 0, 0)

    Arbitrage.theme:Add("user", {
        name = "Ваша тема",
        information = main_color,
        colors = {
            text_title = main_color,
            text_category = main_color,
            text_primary = white_color,
            text_secondary = white_color,
            text_tertriary = Color(143, 135, 137),

            text_header = main_color,
            text_button = white_color,
            text_selected = white_color,
            text_unheader = white_color,
            text_unselected = ColorAlpha(white_color, 25),
            text_locked = Color(64, 60, 61),
            text_hover = black_color,
            text_attention = black_color,

            player_title = white_color,

            vis_logos = main_color,
            vis_titles = main_color,
            vis_selection_line = main_color,
            vis_selection_square = main_color,
            vis_thumb = main_color,
            vis_details_title = main_color,
            vis_details_main = main_color,
            vis_category_selected = main_color,
            vis_category_unselected = Color(255, 255, 255),
            vis_scrollbar = Color(255, 242, 245, 15),
            vis_button_background = Color(0, 0, 0, 50),
            vis_button_selected = main_color,
            vis_button_unselected = ColorAlpha(main_color, 50),
            vis_background = black_color,
            vis_foreground = main_color,
            vis_mount = ColorAlpha(black_color, 200),
            vis_logo_select = white_color
        },
        images = {
            primary_bg = "asterion/academy/ui/themes/example_background.png",
            primary_bg_active = "asterion/academy/ui/themes/example_background_active.png",
            primary_bg_character = "",
            primary_bg_parallax_p = "",
            primary_bg_parallax_s = "asterion/academy/ui/themes/example_background_parallax_p.png"
        },
        onInitialized = function(this)
            local data = asterionlib.data:Get("theme_user", {})

            Arbitrage.theme:LoadThemeParameters(this.uniqueID, data)
        end,
        onEdit = function(this, key, value)
            if CLIENT then
                local data = asterionlib.data:Get("theme_user", {})

                data.colors = data.colors or {}
                data.images = data.images or {}

                if isstring(value) then
                    data.images[key] = value
                    this.images[key] = value
                elseif istable(value) then
                    local color = Color(value.r or 255, value.g or 255, value.b or 255, this.default.colors[key].a)

                    data.colors[key] = color
                    this.colors[key] = color
                end

                asterionlib.data:Set("theme_user", data)
            end
        end,
        onCanEdit = function(this, client)
            return true
        end
    })
end