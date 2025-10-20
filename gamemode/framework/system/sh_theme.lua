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
Arbitrage.theme.cached = Arbitrage.theme.cached or {}
Arbitrage.theme.default = "red"
Arbitrage.theme.convar = CreateClientConVar("arb_theme", Arbitrage.theme.default, true, true)

function Arbitrage.theme:Add(uniqueID, data)
    data.images = data.images or {}

    Arbitrage.theme.stored[uniqueID] = data
end

function Arbitrage.theme:Get(theme_id)
    return self.stored[theme_id]
end

function Arbitrage.theme:GetActive()
    local theme_id = self.convar:GetString()
    local theme = self:Get(theme_id)

    return theme or self:Get(self.default)
end

function Arbitrage.theme:ProcessMaterial(mat)
    if !mat then return end

    if string.isURL(mat) then
        if self.cached[mat] == nil then
            self.cached[mat] = false

            asterionlib.downloader:Image(mat, function(fetchMaterial)
                self.cached[mat] = fetchMaterial
            end)
        end

        if self.cached[mat] then
            return self.cached[mat]
        end
    else
        return Material(mat)
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

    Arbitrage.theme:Add("red", {
        name = "Asterion Academy",
        information = main_color,
        colors = {
            text_title = main_color,  --  текст заглавлений в тексте (главы в руководстве)
            text_category = white_color,  --  текст оглавления категорий
            text_primary = white_color, --  стандартный информационный текст в блоках. Описания, руководство, и т.д.
            text_secondary = white_color, --  второстепенный текст более технического характера (пока не знаю)
            text_tertriary = Color(143, 135, 137), --  третьестепенный текст вспомогательного характера. В основном, менее заметный текст еще более ограниченного назначения

            text_header = main_color, --  выбранная текстовая категория (верхний правый угол)
            text_button = white_color, --  текст размещенный на кнопках
            text_selected = white_color, --  текст для выбранных элементов (выбранная тема, настройка)
            text_unheader = white_color, --  невыбранная текстовая категория (верхний правый угол)
            text_unselected = Color(255, 242, 245, 25), --  текст для невыбранных элементов (тема не выбрана)
            text_locked = Color(64, 60, 61), --  текст для заблокированных элементов (плейсхолдер, блокировка)
            text_hover = Color(0, 0, 0), --  текст при наведении на него курсором

            player_title = white_color, -- цвет ника персонажа в главном меню

            vis_logos = main_color, --  логотип(-ы), иконки (лого, выбор языка, загрузка, иконки категорий)
            vis_titles = main_color, --  фон для плашек (внимание)
            vis_selection_line = main_color, --  выделение при выборе опций (длинная сквозная полоса)
            vis_selection_square = main_color, --  выделение при выборе элементов (глава, аддоны)
            vis_thumb = main_color, -- 
            vis_details_title = main_color, --  детализация (полосы)
            vis_details_main = main_color, -- детализация
            vis_category_selected = main_color, --  выделение выбранной категории (выбранная тема, настройка)
            vis_foreground = Color(255, 255, 255), --
            vis_background = Color(255, 255, 255), --
            vis_category_unselected = Color(255, 255, 255), -- 
            vis_scrollbar = Color(255, 242, 245, 15) --  область скроллбара
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

    Arbitrage.theme:Add("kirigiri", {
        name = "Danganronpa Kirigiri",
        information = main_color,
        colors = {
            text_title = main_color,
            text_category = white_color,
            text_primary = white_color,
            text_secondary = white_color,
            text_tertriary = Color(143, 135, 137),

            text_header = main_color,
            text_button = white_color,
            text_selected = white_color,
            text_unheader = white_color,
            text_unselected = Color(255, 242, 245, 25),
            text_locked = Color(64, 60, 61),
            text_hover = Color(0, 0, 0),

            player_title = white_color,

            vis_logos = main_color,
            vis_titles = main_color,
            vis_selection_line = main_color,
            vis_selection_square = main_color,
            vis_thumb = main_color,
            vis_details_title = main_color,
            vis_details_main = main_color,
            vis_category_selected = main_color,
            vis_foreground = Color(255, 255, 255),
            vis_background = Color(255, 255, 255),
            vis_category_unselected = Color(255, 255, 255),
            vis_scrollbar = Color(255, 242, 245, 15)
        },
        images = {
            primary_bg = "asterion/academy/ui/themes/kirigiri_background.png",
            primary_bg_active = "asterion/academy/ui/themes/kirigiri_background_active.png",
            primary_bg_character = "asterion/academy/ui/themes/kirigiri_background_character.png"
        }
    })
end