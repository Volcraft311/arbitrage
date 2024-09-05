--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


local matBG = Material("danganronpa/note/bg.png")
local matYellow = Material("danganronpa/note/yellow.png")
local matRed = Material("danganronpa/note/red.png")
local size = 0.6

local h_colors = {
    aliceblue            = Color(240, 248, 255),
    antiquewhite         = Color(250, 235, 215),
    aqua                 = Color(0, 255, 255),
    aquamarine           = Color(127, 255, 212),
    azure                = Color(240, 255, 255),
    beige                = Color(245, 245, 220),
    bisque               = Color(255, 228, 196),
    black                = Color(0, 0, 0),
    blanchedalmond       = Color(255, 235, 205),
    blue                 = Color(0, 0, 255),
    blueviolet           = Color(138, 43, 226),
    brown                = Color(165, 42, 42),
    burlywood            = Color(222, 184, 135),
    cadetblue            = Color(95, 158, 160),
    chartreuse           = Color(127, 255, 0),
    chocolate            = Color(210, 105, 30),
    coral                = Color(255, 127, 80),
    cornflowerblue       = Color(100, 149, 237),
    cornsilk             = Color(255, 248, 220),
    crimson              = Color(220, 20, 60),
    cyan                 = Color(0, 255, 255),
    darkblue             = Color(0, 0, 139),
    darkcyan             = Color(0, 139, 139),
    darkgoldenrod        = Color(184, 134, 11),
    darkgray             = Color(169, 169, 169),
    darkgreen            = Color(0, 100, 0),
    darkgrey             = Color(169, 169, 169),
    darkkhaki            = Color(189, 183, 107),
    darkmagenta          = Color(139, 0, 139),
    darkolivegreen       = Color(85, 107, 47),
    darkorange           = Color(255, 140, 0),
    darkorchid           = Color(153, 50, 204),
    darkred              = Color(139, 0, 0),
    darksalmon           = Color(233, 150, 122),
    darkseagreen         = Color(143, 188, 143),
    darkslateblue        = Color(72, 61, 139),
    darkslategray        = Color(47, 79, 79),
    darkslategrey        = Color(47, 79, 79),
    darkturquoise        = Color(0, 206, 209),
    darkviolet           = Color(148, 0, 211),
    deeppink             = Color(255, 20, 147),
    deepskyblue          = Color(0, 191, 255),
    dimgray              = Color(105, 105, 105),
    dimgrey              = Color(105, 105, 105),
    dodgerblue           = Color(30, 144, 255),
    firebrick            = Color(178, 34, 34),
    floralwhite          = Color(255, 250, 240),
    forestgreen          = Color(34, 139, 34),
    fuchsia              = Color(255, 0, 255),
    gainsboro            = Color(220, 220, 220),
    ghostwhite           = Color(248, 248, 255),
    gold                 = Color(255, 215, 0),
    goldenrod            = Color(218, 165, 32),
    gray                 = Color(128, 128, 128),
    green                = Color(0, 128, 0),
    greenyellow          = Color(173, 255, 47),
    grey                 = Color(128, 128, 128),
    honeydew             = Color(240, 255, 240),
    hotpink              = Color(255, 105, 180),
    indianred            = Color(205, 92, 92),
    indigo               = Color(75, 0, 130),
    ivory                = Color(255, 255, 240),
    khaki                = Color(240, 230, 140),
    lavender             = Color(230, 230, 250),
    lavenderblush        = Color(255, 240, 245),
    lawngreen            = Color(124, 252, 0),
    lemonchiffon         = Color(255, 250, 205),
    lightblue            = Color(173, 216, 230),
    lightcoral           = Color(240, 128, 128),
    lightcyan            = Color(224, 255, 255),
    lightgoldenrodyellow = Color(250, 250, 210),
    lightgray            = Color(211, 211, 211),
    lightgreen           = Color(144, 238, 144),
    lightgrey            = Color(211, 211, 211),
    lightpink            = Color(255, 182, 193),
    lightsalmon          = Color(255, 160, 122),
    lightseagreen        = Color(32, 178, 170),
    lightskyblue         = Color(135, 206, 250),
    lightslategray       = Color(119, 136, 153),
    lightslategrey       = Color(119, 136, 153),
    lightsteelblue       = Color(176, 196, 222),
    lightyellow          = Color(255, 255, 224),
    lime                 = Color(0, 255, 0),
    limegreen            = Color(50, 205, 50),
    linen                = Color(250, 240, 230),
    magenta              = Color(255, 0, 255),
    maroon               = Color(128, 0, 0),
    mediumaquamarine     = Color(102, 205, 170),
    mediumblue           = Color(0, 0, 205),
    mediumorchid         = Color(186, 85, 211),
    mediumpurple         = Color(147, 112, 219),
    mediumseagreen       = Color(60, 179, 113),
    mediumslateblue      = Color(123, 104, 238),
    mediumspringgreen    = Color(0, 250, 154),
    mediumturquoise      = Color(72, 209, 204),
    mediumvioletred      = Color(199, 21, 133),
    midnightblue         = Color(25, 25, 112),
    mintcream            = Color(245, 255, 250),
    mistyrose            = Color(255, 228, 225),
    moccasin             = Color(255, 228, 181),
    navajowhite          = Color(255, 222, 173),
    navy                 = Color(0, 0, 128),
    oldlace              = Color(253, 245, 230),
    olive                = Color(128, 128, 0),
    olivedrab            = Color(107, 142, 35),
    orange               = Color(255, 165, 0),
    orangered            = Color(255, 69, 0),
    orchid               = Color(218, 112, 214),
    palegoldenrod        = Color(238, 232, 170),
    palegreen            = Color(152, 251, 152),
    paleturquoise        = Color(175, 238, 238),
    palevioletred        = Color(219, 112, 147),
    papayawhip           = Color(255, 239, 213),
    peachpuff            = Color(255, 218, 185),
    peru                 = Color(205, 133, 63),
    pink                 = Color(255, 192, 203),
    plum                 = Color(221, 160, 221),
    powderblue           = Color(176, 224, 230),
    purple               = Color(128, 0, 128),
    red                  = Color(255, 0, 0),
    rosybrown            = Color(188, 143, 143),
    royalblue            = Color(65, 105, 225),
    saddlebrown          = Color(139, 69, 19),
    salmon               = Color(250, 128, 114),
    sandybrown           = Color(244, 164, 96),
    seagreen             = Color(46, 139, 87),
    seashell             = Color(255, 245, 238),
    sienna               = Color(160, 82, 45),
    silver               = Color(192, 192, 192),
    skyblue              = Color(135, 206, 235),
    slateblue            = Color(106, 90, 205),
    slategray            = Color(112, 128, 144),
    slategrey            = Color(112, 128, 144),
    snow                 = Color(255, 250, 250),
    springgreen          = Color(0, 255, 127),
    steelblue            = Color(70, 130, 180),
    tan                  = Color(210, 180, 140),
    teal                 = Color(0, 128, 128),
    thistle              = Color(216, 191, 216),
    tomato               = Color(255, 99, 71),
    turquoise            = Color(64, 224, 208),
    violet               = Color(238, 130, 238),
    wheat                = Color(245, 222, 179),
    white                = Color(255, 255, 255),
    whitesmoke           = Color(245, 245, 245),
    yellow               = Color(255, 255, 0),
    yellowgreen          = Color(154, 205, 50)
}

local htmlColors = ""
for k, v in pairs(h_colors) do
    htmlColors = htmlColors .. string.format("%s {color: rgb(%s, %s, %s)}\n", k, v.r, v.g, v.b)
    htmlColors = htmlColors .. string.format("b_%s {background-color: rgb(%s, %s, %s)}\n", k, v.r, v.g, v.b)
end


local htmlSize = ""
for i = 1, 100 do
    htmlSize = htmlSize .. string.format("s_%s {font-size: %spx}\n", i, i)
end


local h_fonts = {
    {Times_New_Roman = "'Times New Roman', Times, serif"},
    {Georgia = "Georgia, serif"},
    {Arial = "Arial, Helvetica, sans-serif"},
    {Arial_Black = "'Arial Black', Gadget, sans-serif"},
    {Tahoma = "Tahoma, Geneva, sans-serif"},
    {Verdana = "Verdana, Geneva, sans-serif"},
    {Trebuchet_MS = "'Trebuchet MS', Helvetica, sans-serif"},
    {Lucida_Sans_Unicode = "'Lucida Sans Unicode', 'Lucida Grande', sans-serif"},
    {Impact = "Impact, Charcoal, sans-serif"},
    {Comic_Sans_MS = "'Comic Sans MS', cursive, sans-serif"},
    {Courier_New = "'Courier New', Courier, monospace"},
    {Lucida_Console = "'Lucida Console', Monaco, monospace"}
}

local htmlFonts = ""
for k, v in ipairs(h_fonts) do
    for k2, v2 in pairs(v) do
        htmlFonts = htmlFonts .. string.format("%s {font-family: %s}\n", k2, v2)
    end
end


local htmlBlockTags = {
    "a",
    "area",
    "audio",
    "canvas",
    "button",
    "iframe",
    "input",
    "noscript",
    "object",
    "wbr",
    "video",
    "var",
    "track",
    "time",
    "textarea",
    "template",
    "summary",
    "script",
    "progress",
    "picture",
    "output",
    "meta",
    "map",
    "main",
    "link",
    "html",
    "body",
    "head",
    "form",
    "embed",
    "dialog",
    "datalist",
    "data",
    "base"
}

local function GetHTMLCode(data, w, h)
    local array = string.Explode("\n", data)

    for k, v in ipairs(array) do
        array[k] = "<p>" .. v .. "</p>"
    end

    local text = table.concat(array, "<br>")
    text = text:gsub("\n", "")

    for k, v in ipairs(htmlBlockTags) do
        text = text:gsub("<" .. v .. ">", " ")
        text = text:gsub("<" .. v .. " ", " ")
        text = text:gsub("</" .. v .. ">", " ")
    end

    text = text:gsub("<img>(.-)</img>", function(a)
        a = a:gsub("<img>", "")
        a = a:gsub("</img>", "")

        return [[<img alt="" src="]] .. a .. [["/>]]
    end)

    for k, v in ipairs({"right", "left", "center"}) do
        text = text:gsub("<" .. v .. ">(.-)</" .. v .. ">", function(a)
            a = a:gsub("<" .. v .. ">", "")
            a = a:gsub("</" .. v .. ">", "")

            return [[<div align="]] .. v .. [["><p>]] .. a .. [[</p></div>]]
        end)
    end

    return [[
        <!DOCTYPE html>
        <html content="text/html>
            <head>
                <meta charset="utf-8">

                <style>
                    html {
                        margin: 0;
                        padding: 0;
                        background-color: rgba(0, 0, 0, 0.01);
                    }

                    body {
                        background-color: rgb(239, 239, 239);
                        margin: 0;
                        padding: 0;
                    }

                    p {
                        font-family: Verdana, sans-serif;
                        font-size: 14px;

                        margin: 0;
                        padding: 0;
                        border: 0;

                        overflow-wrap: break-word;
                        overflow: hidden;
                        word-wrap: break-word;
                    }

                    img {
                        max-width: ]] .. w .. [[px;
                    }

                    center {
                        font-family: Verdana, sans-serif;
                        font-size: 14px;
                        text-align: center;
                    }

                    left {
                        font-family: Verdana, sans-serif;
                        font-size: 14px;
                        text-align: left;
                    }

                    right {
                        font-family: Verdana, sans-serif;
                        font-size: 14px;
                        text-align: right;
                    }

                    *::-webkit-scrollbar {
                        width: 16px;
                    }

                    *::-webkit-scrollbar-track {
                        border-radius: 8px;
                    }

                    *::-webkit-scrollbar-thumb {
                        height: 56px;
                        border-radius: 8px;
                        border: 4px solid transparent;
                        background-clip: content-box;
                        background-color: #888;
                    }

                    *::-webkit-scrollbar-thumb:hover {
                        background-color: #555;
                    }

                    ]] .. htmlSize .. [[
                    ]] .. htmlColors .. [[
                    ]] .. htmlFonts .. [[
                </style>
            </head>

            <body>
                <p>]] .. text .. [[</p>
            </body>
        </html>
    ]]
end

local actionList = {
    {
        {
            name = "❖ Сохранить данную страницу",
            onRun = function(data, panel)
                netstream.Start("ItemBase:NoteAction", "SAVE_PAGE", data.itemID, data.page, panel.note.title:GetValue(), panel.note.text:GetValue())
            end
        },
        {
            name = "√ Создать новую страницу",
            onCanRun = function(data, panel)
                return data.pages < NOTE_MAX_PAGES
            end,
            onRun = function(data, panel)
                netstream.Start("ItemBase:NoteAction", "CREATE_PAGE", data.itemID, data.page)
            end
        },
        {
            name = "⌦ Удалить последнюю страницу",
            onCanRun = function(data, panel)
                return data.pages > 1
            end,
            onRun = function(data, panel)
                netstream.Start("ItemBase:NoteAction", "DELETE_PAGE", data.itemID, data.page)
            end
        },
        {
            name = "☑ Добавить нового владельца",
            onCanRun = function(data, panel)
                return table.Count(panel.data.editors) < NOTE_MAX_EDITORS
            end,
            onRun = function(data, panel)
                local strPanel = Derma_StringRequest("Добавить нового Владельца", "Введите SteamID человека, которому вы хотите выдать полный доступ к своему блокноту.", "", function(text)
                    if !text then return end
                    if !string.find(text, "STEAM_") then return end

                    panel:AddEditorPanel(text)
                    netstream.Start("ItemBase:NoteAction", "ADD_EDITOR", data.itemID, text)
                end, nil, "Добавить", "Закрыть меню")
                strPanel.startTime = SysTime()

                strPanel.Paint = function(_, w, h)
                    Derma_DrawBackgroundBlur(_, _.startTime)

                    surface.SetDrawColor(235, 235, 235)
                    surface.SetMaterial(matYellow)
                    surface.DrawTexturedRect(0, 0, w, h)

                    surface.SetDrawColor(0, 0, 0, 185)
                    surface.DrawOutlinedRect(0, 0, w, h, 2)
                end

                strPanel:GetChildren()[4]:SetTextColor(Color(0, 0, 0, 200))
                strPanel:GetChildren()[5]:GetChildren()[1]:SetTextColor(Color(0, 0, 0, 185))
            end
        },
        {
            name = "✉ Перейти в режим чтение",
            onCanRun = function(data, panel)
                return table.Count(panel.data.editors) < NOTE_MAX_EDITORS
            end,
            onRun = function(data, panel)
                netstream.Start("ItemBase:NoteAction", "READ_PAGE", data.itemID, data.page)
            end
        },
        {
            name = "Ø Разрешить/Запретить поднимать",
            onRun = function(data, panel)
                netstream.Start("ItemBase:NoteAction", "CHANGE_TAKE", data.itemID)
            end
        },
        {
            name = "✉ Просмотр страницы",
            onRun = function(data, panel)
                if IsValid(panel.view) then
                    panel.view:Remove()
                end

                panel.view = vgui.Create("DFrame")
                panel.view:SetTitle("Просмотр страницы")
                panel.view:SetSize(panel.note.text:GetSize())
                panel.view:MakePopup()
                panel.view:Center()

                panel.view.html = panel.view:Add("DHTML")
                panel.view.html.Paint = function() end
                panel.view.html:Dock(FILL)
                panel.view.html:SetHTML(GetHTMLCode(panel.note.text:GetValue(), panel.note.text:GetWide(), panel.note.text:GetTall()))
            end
        },
        {
            name = "✉ Редактор HTML страницы",
            onRun = function(data, panel)
                if IsValid(panel.site) then
                    panel.site:Remove()
                end

                panel.site = vgui.Create("DFrame")
                panel.site:SetTitle("Редактор HTML страницы")
                panel.site:SetSize(ScrW() * 0.5, ScrH() * 0.5)
                panel.site:MakePopup()
                panel.site:Center()

                panel.site.html = panel.site:Add("DHTML")
                panel.site.html.Paint = function() end
                panel.site.html:Dock(FILL)
                panel.site.html:OpenURL("https://be1.ru/html-redaktor-online/")
            end
        },
    },
    {
        {
            name = "→ Следующая страница",
            onCanRun = function(data, panel)
                local nextPage = data.page + 1

                return data.pages >= nextPage
            end,
            onRun = function(data, panel)
                netstream.Start("ItemBase:NoteAction", "CHANGE_PAGE", data.itemID, data.page + 1, data.edit)
            end
        },
        {
            name = "← Предыдущая страница",
            onCanRun = function(data, panel)
                local previousPage = data.page - 1

                return previousPage > 0
            end,
            onRun = function(data, panel)
                netstream.Start("ItemBase:NoteAction", "CHANGE_PAGE", data.itemID, data.page - 1, data.edit)
            end
        },
        {
            name = "x Закрыть блокнот",
            onRun = function(data, panel)
                panel:Remove()
            end
        }
    }
}

local editorColor = {}
for k, v in pairs(h_colors) do
    editorColor[#editorColor + 1] = {
        name = k,
        insert = {"<" .. k .. ">", "</" .. k .. ">"},
        onPanel = function(panel)
            panel:SetTextColor(v)
        end
    }
end

local editorBColor = {}
for k, v in pairs(h_colors) do
    editorBColor[#editorBColor + 1] = {
        name = k,
        insert = {"<b_" .. k .. ">", "</b_" .. k .. ">"},
        onPanel = function(panel)
            panel.Paint = function(_, w, h)
                surface.SetDrawColor(v)
                surface.DrawRect(0, 0, w, h)
            end
        end
    }
end

local editorFont = {}
for k, v in ipairs(h_fonts) do
    for k2 in pairs(v) do
        editorFont[#editorFont + 1] = {
            name = k2,
            insert = {"<" .. k2 .. ">", "</" .. k2 .. ">"}
        }
    end
end

local editorSize = {}
for i = 1, 100 do
    editorSize[#editorSize + 1] = {
        name = i,
        insert = {"<s_" .. i .. ">", "</s_" .. i .. ">"}
    }
end

local h_indentation = {
    ["Маленький отсуп"] = "&nbsp;",
    ["Средний отступ"] = "&ensp;",
    ["Большой отступ"] = "&emsp;",
    ["Отступ вниз"] = "<br>"
}

local editorIndentation = {}
for k, v in pairs(h_indentation) do
    editorIndentation[#editorIndentation + 1] = {
        name = k,
        insert = {v, ""}
    }
end

local editorList = {
    {
        name = "Полужирный",
        insert = {"<b>", "</b>"}
    },
    {
        name = "Курсив",
        insert = {"<i>", "</i>"}
    },
    {
        name = "Подчеркнутый",
        insert = {"<u>", "</u>"}
    },
    {
        name = "Зачеркнутый",
        insert = {"<s>", "</s>"}
    },
    {
        name = "Отступ",
        data = editorIndentation
    },
    {
        name = "Картинка",
        insert = {"<img>", "</img>"}
    },
    {
        name = "Цвет шрифта",
        data = editorColor
    },
    {
        name = "Цвет выделения",
        data = editorBColor
    },
    {
        name = "Шрифты",
        data = editorFont
    },
    {
        name = "Размер шрифта",
        data = editorSize
    },
    {
        name = "Выравнивание",
        data = {
            {
                name = "Лево",
                insert = {"<left>", "</left>"}
            },
            {
                name = "Право",
                insert = {"<right>", "</right>"}
            },
            {
                name = "Центр",
                insert = {"<center>", "</center>"}
            }
        }
    }
}


local function GetFont(data)
    return "arb.Font_FuturaPTDemi_"
end

local PANEL = {}

function PANEL:Init()
    self:SetSize(W(1083 * size), H(1448 * size))
    self:SetAlpha(255)

    self.main = self:Add("Panel")
    self.main:Dock(FILL)
    self.main:DockMargin(W(85), H(20), W(30), H(20))

    local titlePanel = self.main:Add("Panel")
    titlePanel:Dock(TOP)
    titlePanel:SetTall(H(60))
    titlePanel.Paint = function(_, w, h)
        draw.DrawText("Страница №" .. (self.data.page or 1), GetFont(self.data.font) .. 7, w, -2, Color(100, 100, 100), TEXT_ALIGN_RIGHT)

        surface.SetDrawColor(159, 159, 159)
        surface.DrawRect(w * 0.1, h - 2, w - (w * 0.1) * 2, 2)
    end

    self.title = titlePanel:Add("DTextEntry")
    self.title:Dock(FILL)
    self.title:SetDisabled(true)
    self.title:SetTextColor(Color(60, 60, 60))
    self.title:SetPaintBackground(false)

    self.bottomPanel = self.main:Add("DHorizontalScroller")
    self.bottomPanel:SetOverlap(-4)
    self.bottomPanel:Dock(BOTTOM)
    self.bottomPanel:SetTall(H(60))
    self.bottomPanel.Paint = function(_, w, h)
        surface.SetDrawColor(159, 159, 159)
        surface.DrawRect(w * 0.1, 0, w - (w * 0.1) * 2, 2)
    end

    self.centerPanel = self.main:Add("Panel")
    self.centerPanel:Dock(FILL)
    self.centerPanel:DockMargin(0, H(20), 0, H(20))
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(matBG)
    surface.DrawTexturedRect(0, 0, w, h)
end

function PANEL:SetData(data, bEdit)
    self.data = data

    self.title:SetValue(data.title)
    self.title:SetFont(GetFont(data.font) .. 14)

    if IsValid(self.text) then self.text:Remove() end

    if bEdit then
        self.text = self.centerPanel:Add("DTextEntry")
        self.text:Dock(FILL)
        self.text:SetDisabled(true)
        self.text:SetVerticalScrollbarEnabled(true)
        self.text:SetMultiline(true)
        self.text:SetTextColor(Color(60, 60, 60))
        self.text:SetPaintBackground(false)

        self.text:SetValue(data.text)
        self.text:SetFont(GetFont(data.font) .. 7)

        self.text.OnChange = function(this)
            local panel = self:GetParent().view

            if IsValid(panel) and IsValid(panel.html) then
                local value = this:GetValue()

                panel.html:SetHTML(GetHTMLCode(value, this:GetWide(), this:GetTall()))
            end
        end

        if !self.initEditor then
            self.initEditor = true

            for k, v in ipairs(editorList) do
                local button = self.bottomPanel:Add("DButton")
                button:SetText(v.name)
                button:Dock(LEFT)
                button:DockMargin(0, H(20), 0, H(5))
                button:SizeToContents()
                button.DoClick = function()
                    local panel = self.text

                    local function insert(info)
                        if !IsValid(panel) then return end

                        local pos = panel:GetCaretPos()
                        local text = panel:GetValue()

                        local left_string = utf8.sub(text, 0, pos)
                        local right_string = utf8.sub(text, pos + 1, utf8.len(text))

                        local new_text = left_string
                        for k2, v2 in ipairs(info.insert) do
                            new_text = new_text .. v2
                        end
                        new_text = new_text .. right_string

                        local shift = (info.insert and utf8.len(info.insert[1])) or 0

                        panel:SetText(new_text)
                        panel:RequestFocus()
                        panel:SetCaretPos(pos + shift)
                    end

                    if v.insert then
                        insert(v)
                    else
                        local Menu = DermaMenu(false, self)
                        Menu.panels = {}

                        for k2, v2 in ipairs(v.data) do
                            local option = Menu:AddOption(v2.name, function()
                                insert(v2)

                                self.text:OnChange()
                            end)

                            if v2.onPanel then
                                v2.onPanel(option)
                            end

                            Menu.panels[#Menu.panels + 1] = option
                        end

                        Menu:Open()
                    end
                end

                self.bottomPanel:AddPanel(button)
            end
        end
    else
        self.text = self.centerPanel:Add("DHTML")
        self.text.Paint = function() end

        self.text:Dock(FILL)

        self.text.PerformLayout = function(this, w, h)
            this:SetHTML(GetHTMLCode(data.text, w, h))
        end
    end
end

vgui.Register("arb.Note", PANEL, "EditablePanel")




local PANEL = {}

function PANEL:Init()
    self:SetTitle("")
    self:ShowCloseButton(false)
    self:SetSize(W(1683 * size), H(1448 * size))
    self:Center()
    self:MakePopup()

    self.attachment = self:Add("Panel")
    self.attachment:SetWide(W(610 * size))
    self.attachment:Dock(RIGHT)
    self.attachment:DockMargin(0, H(30), 0, H(30))

    local yellowPanel = self.attachment:Add("Panel")
    yellowPanel:SetSize(0, self:GetTall() * 0.65)
    yellowPanel.Paint = function(_, w, h)
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(matYellow)
        surface.DrawTexturedRect(0, 0, w, h)

        surface.SetDrawColor(0, 0, 0, 70)
        surface.DrawRect(0, 0, 10, h)
    end

    self.yellowPanel2 = yellowPanel

    self.yellowPanel = yellowPanel:Add("DScrollPanel")
    self.yellowPanel:Dock(FILL)

    self.infoPanel = yellowPanel:Add("Panel")
    self.infoPanel:SetTall(H(100))
    self.infoPanel:Dock(BOTTOM)
    self.infoPanel.Paint = function(_, w, h)
        draw.DrawText("Количество владельцев: " .. table.Count(self.data.editors) .. "/" .. NOTE_MAX_EDITORS, GetFont(self.data.font) .. 7, 25, H(3), Color(0, 0, 0, 155), TEXT_ALIGN_LEFT)
        draw.DrawText("Количество страниц: " .. self.data.pages .. "/" .. NOTE_MAX_PAGES, GetFont(self.data.font) .. 7, 25, H(23), Color(0, 0, 0, 155), TEXT_ALIGN_LEFT)
        draw.DrawText("Размер заголовка: " .. utf8.len(self.note.title:GetValue()) .. "/" .. NOTE_SIZE_TITLE, GetFont(self.data.font) .. 7, 25, H(43), Color(0, 0, 0, 155), TEXT_ALIGN_LEFT)
        draw.DrawText("Размер текста: " .. utf8.len(self.note.text:GetValue()) .. "/" .. NOTE_SIZE_TEXT, GetFont(self.data.font) .. 7, 25, H(63), Color(0, 0, 0, 155), TEXT_ALIGN_LEFT)
    end

    self.editorsPanel = yellowPanel:Add("DPanelList")
    self.editorsPanel:SetTall(H(140))
    self.editorsPanel:EnableVerticalScrollbar()
    self.editorsPanel:DockMargin(15, 0, 5, 5)
    self.editorsPanel:Dock(BOTTOM)
    self.editorsPanel.panels = {}
    self.editorsPanel.Paint = function(_, w, h)
        surface.SetDrawColor(0, 0, 0, 185)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    do
        local bar = self.yellowPanel:GetVBar()
        bar.Paint = function(_, w, h)
            surface.SetDrawColor(0, 0, 0, 100)
            surface.DrawRect(w * 0.2, bar.btnUp:GetTall(), w - w * 0.4, h - bar.btnUp:GetTall() * 2)
        end

        bar.btnUp.Paint = zero
        bar.btnDown.Paint = zero

        bar.btnGrip.Paint = function(_, w, h)
            surface.SetDrawColor(255, 255, 255, 100)
            surface.DrawRect(w * 0.2, 0, w - w * 0.4, h)
        end
    end

    self.redPanel = self.attachment:Add("DScrollPanel")
    self.redPanel:SetY(self:GetTall() * 0.65)
    self.redPanel:SetSize(0, self:GetTall() - self:GetTall() * 0.65 - H(60))
    self.redPanel.Paint = function(_, w, h)
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(matRed)
        surface.DrawTexturedRect(0, 0, w, h)

        surface.SetDrawColor(0, 0, 0, 100)

        if IsValid(self.yellowPanel) then
            surface.DrawRect(0, 0, w, 5)
            surface.DrawRect(0, 5, 10, h - 5)
        else
            surface.DrawRect(0, 0, 10, h)
        end

        draw.DrawText("Количество страниц: " .. self.data.pages, GetFont(self.data.font) .. 7, 25, h - H(25), Color(0, 0, 0, 155), TEXT_ALIGN_LEFT)
    end

    do
        local bar = self.redPanel:GetVBar()
        bar.Paint = function(_, w, h)
            surface.SetDrawColor(0, 0, 0, 100)
            surface.DrawRect(w * 0.2, bar.btnUp:GetTall(), w - w * 0.4, h - bar.btnUp:GetTall() * 2)
        end

        bar.btnUp.Paint = zero
        bar.btnDown.Paint = zero

        bar.btnGrip.Paint = function(_, w, h)
            surface.SetDrawColor(255, 255, 255, 100)
            surface.DrawRect(w * 0.2, 0, w - w * 0.4, h)
        end
    end

    if IsValid(yellowPanel) then
        yellowPanel:SizeTo(self.attachment:GetWide(), yellowPanel:GetTall(), 0.5)
    end

    timer.Simple(0.3, function()
        if IsValid(self.redPanel) then
            self.redPanel:SizeTo(self.attachment:GetWide() * 0.8, self.redPanel:GetTall(), 0.5)
        end
    end)

    self.note = self:Add("arb.Note")

    Arbitrage.gui.note = self
end

function PANEL:AddEditorPanel(steamid)
    local panel = self.editorsPanel:Add("DCheckBoxLabel")
    panel:SetText(steamid)
    panel:SetFont(GetFont(self.data.font) .. 7)
    panel:Dock(TOP)
    panel:DockMargin(20, 0, 0, 0)
    panel:SetValue(true)
    panel:SetTextColor(Color(0, 0, 0, 185))
    panel.OnChange = function(_, value)
        if value then return end

        if LocalPlayer():SteamID() == steamid then
            return panel:SetValue(true)
        end

        netstream.Start("ItemBase:NoteAction", "REMOVE_EDITOR", self.data.itemID, steamid)
        panel:Remove()
    end

    self.editorsPanel:AddItem(panel)
    self.panels[#self.panels + 1] = panel

    return panel
end

function PANEL:SetData(data, bEdit)
    self.data = data

    self.note:SetData(data, bEdit)

    if !bEdit then
        self.yellowPanel2:Remove()
    else
        self.note.title:SetDisabled(false)
        self.note.text:SetDisabled(false)
    end

    for k, v in pairs(self.panels or {}) do
        if IsValid(v) then
            v:Remove()
        end
    end

    self.panels = {}

    if IsValid(self.editorsPanel) then
        for k, v in pairs(data.editors) do
            self:AddEditorPanel(k)
        end
    end

    for i = 1, 2 do
        if i == 1 and !bEdit then continue end

        for k, v in pairs(actionList[i]) do
            local selectPanel = i == 1 and self.yellowPanel or self.redPanel

            local panel = selectPanel:Add("DButton")
            panel:SetText("")
            panel:SetTall(H(30))
            panel:Dock(TOP)
            panel.alpha = 185
            panel.width = 0
            panel.onCan = true
            panel.Paint = function(_, w, h)
                _.alpha = Lerp(FrameTime() * 10, _.alpha, (_:IsHovered() and _.onCan) and 230 or 185)

                draw.DrawText(v.name, GetFont(self.data.font) .. 7, 25, H(3), _.onCan and Color(0, 0, 0, _.alpha) or Color(255, 0, 0, _.alpha), TEXT_ALIGN_LEFT)

                surface.SetFont(GetFont(self.data.font) .. 7)
                local width = surface.GetTextSize(v.name)
                _.width = Lerp(FrameTime() * 5, _.width, (_:IsHovered() and _.onCan) and width or 0)

                surface.SetDrawColor(0, 0, 0, _.alpha)
                surface.DrawRect(25, h - 5, _.width, 1)
            end

            if v.onCanRun then
                panel.onCan = v.onCanRun(self.data, self)
            end

            panel.DoClick = function()
                if !panel.onCan then return end

                if v.onRun then
                    v.onRun(self.data, self)
                end
            end

            self.panels[#self.panels + 1] = panel
        end
    end
end

function PANEL:OnRemove()
    if IsValid(self.view) then
        self.view:Remove()
    end

    if IsValid(self.site) then
        self.site:Remove()
    end
end

function PANEL:Paint()
end

vgui.Register("ItemBase:OpenNote", PANEL, "DFrame")

concommand.Add("arb_close_notemenu", function(client, command, arguments)
    if IsValid(Arbitrage.gui.note) then
        Arbitrage.gui.note:Remove()
    end
end)