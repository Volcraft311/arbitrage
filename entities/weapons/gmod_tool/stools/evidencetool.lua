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


file.CreateDir("academy_evidencetool_configs")

AddCSLuaFile()

TOOL.Name = "Evidence Tool"
TOOL.Category = "Asterion Tools"
TOOL.Information = {
    {name = "left", stage = 0},
    {name = "right", stage = 0},
    {name = "reload"},
}

TOOL.ClientConVar.name = "Название улики"
EvidenceDescription = EvidenceDescription or "Описание улики"
EvidenceFactionData = EvidenceFactionData or {}
TOOL.ClientConVar.r = 255
TOOL.ClientConVar.g = 255
TOOL.ClientConVar.b = 255
TOOL.ClientConVar.alpha = 255
TOOL.ClientConVar.icon = 1
TOOL.ClientConVar.ribbon = 1

if CLIENT then
    language.Add("tool.evidencetool.name", "Evidence Tool")
    language.Add("tool.evidencetool.desc", "Позволяет вам расставлять улики по карте")
    language.Add("tool.evidencetool.left", "Нажмите левую кнопку мышки чтобы поставить обычную улику.")
    language.Add("tool.evidencetool.right", "Нажмите правую кнопку мышки чтобы прикрепить улику к Entity.")
    language.Add("tool.evidencetool.reload", "Нажмите Перезарядку чтобы удалить улику.")
end

function TOOL:LeftClick()
    if CLIENT then return true end

    local client = self:GetOwner()

    local data = Evidence:GetToolData(client)
    if !data then return end

    local message = Evidence:LeftClick(data)

    if message then
        client:ChatNotify(message)
    end
end

function TOOL:RightClick()
    if CLIENT then return true end

    local client = self:GetOwner()

    local data = Evidence:GetToolData(client)
    if !data then return end

    local message = Evidence:RightClick(data)

    if message then
        client:ChatNotify(message)
    end
end

function TOOL:Reload()
    if CLIENT then return true end

    local client = self:GetOwner()

    local data = Evidence:GetToolData(client)
    if !data then return end

    local message = Evidence:Reload(data)

    if message then
        client:ChatNotify(message)
    end
end

local l = "evidencetool_"
local function GetConVars()
    local vars = {
        name = GetConVar(l .. "name"):GetString(),
        r = GetConVar(l .. "r"):GetInt(),
        g = GetConVar(l .. "g"):GetInt(),
        b = GetConVar(l .. "b"):GetInt(),
        alpha = GetConVar(l .. "alpha"):GetInt(),
        icon = GetConVar(l .. "icon"):GetInt(),
        ribbon = GetConVar(l .. "ribbon"):GetInt(),
    }

    vars.EvidenceDescription = EvidenceDescription

    return vars
end

local select_config = nil
local function CreateConfigPanel(parent)
    local panel = vgui.Create("Panel")
    panel:SetTall(18)

    local combobox = panel:Add("DComboBox")
    combobox:Dock(FILL)
    combobox:DockMargin(0, 0, 5, 0)
    combobox.list = {}
    combobox.OnSelect = function(this, _, _, data)
        select_config = data

        local info = util.JSONToTable(file.Read("academy_evidencetool_configs/" .. data, "DATA"))

        for id, value in pairs(info) do
            if id != "EvidenceDescription" then
                RunConsoleCommand(l .. id, value)
            else
                EvidenceDescription = value

                local dtextentry = Evidence.dtextentry
                if IsValid(dtextentry) then
                    dtextentry:SetValue(value)
                    dtextentry:OnChange()
                end
            end            
        end
    end

    local function updateComboBox()
        select_config = nil
        combobox:Clear()

        local files, _ = file.Find("academy_evidencetool_configs/*.txt", "DATA")
        for k, v in ipairs(files) do
            combobox:AddChoice(v:gsub(".txt", ""), v)
        end
    end

    updateComboBox()

    local removebutton = panel:Add("DImageButton")
    removebutton:SetIcon("icon16/delete.png")
    removebutton:Dock(RIGHT)
    removebutton:DockMargin(5, 0, 0, 0)
    removebutton.DoClick = function()
        if !select_config then return end

        local Menu = DermaMenu()
            Menu:AddOption("Удалить данный конфиг", function()
                file.Delete("academy_evidencetool_configs/" .. select_config)
                chat.AddText("Конфиг " .. select_config .. " успешно был удален!")
                updateComboBox()

                select_config = nil
            end)
        Menu:Open()
    end

    local addbutton = panel:Add("DImageButton")
    addbutton:SetIcon("icon16/add.png")
    addbutton:Dock(RIGHT)
    addbutton.DoClick = function()
        Derma_StringRequest("Сохранить конфигурацию", "Введите название документа в который сохраниться конфигурация из Editor-а", "", function(text)
            local data = util.TableToJSON(GetConVars())

            file.Write("academy_evidencetool_configs/" .. text .. ".txt", data)
            chat.AddText("Ваш конфиг успешно был сохранен в файл: " .. text .. ".txt")
            updateComboBox()
        end)
    end

    panel.PerformLayout = function(_, w, h)
        addbutton:SetWide(h)
        removebutton:SetWide(h)
    end

    parent:AddPanel(panel)
end

function TOOL.BuildCPanel(CPanel)
    CPanel:AddControl("Header",{
        Description = "Данный инструмент поможет вам создавать улики на карте которые смогут собирать игроки."
    })

    CreateConfigPanel(CPanel)

    CPanel:AddControl("TextBox", {
        Label = "Название улики",
        Command = "evidencetool_name"
    })

    local lableDesc = vgui.Create("DLabel")
    lableDesc:SetText("Описание улики")
    lableDesc:SetTextColor(color_black)
    CPanel:AddPanel(lableDesc)

    local dtextentryDesc = vgui.Create("DTextEntry")
    dtextentryDesc:SetValue(EvidenceDescription)
    dtextentryDesc:SetTall(100)
    dtextentryDesc:SetVerticalScrollbarEnabled(true)
    dtextentryDesc:SetMultiline(true)
    dtextentryDesc.OnChange = function(_)
        local data = _:GetValue()

        EvidenceDescription = data
        netstream.Start("Evidence:SetDescription", EvidenceDescription)
    end

    CPanel:AddPanel(dtextentryDesc)
    Evidence.dtextentry = dtextentryDesc

    CPanel:AddControl("Slider", {
        Label = "Видимость улики",
        Command = l .. "alpha",
        Min = 0,
        Max = 255
    })

    CPanel:AddControl("Color", {
        Label = "Цвет улики",
        Red = l .. "r",
        Green = l .. "g",
        Blue = l .. "b"
    })

    local evidenceScrollPanel = vgui.Create("DScrollPanel")
    evidenceScrollPanel:DockMargin(W(5), H(5), W(5), H(5))
    evidenceScrollPanel:SetTall(200)
    evidenceScrollPanel.Paint = function(_, w, h)
        surface.SetDrawColor(0, 0, 0)
        surface.DrawOutlinedRect(0, 0, w, h)
    end
    CPanel:AddPanel(evidenceScrollPanel)

    local ListIcons = evidenceScrollPanel:Add("DIconLayout")
    ListIcons:Dock(FILL)
    ListIcons:SetSpaceY(5)
    ListIcons:SetSpaceX(5)

    for k, v in ipairs(Evidence.icons) do
        local mat = Material(v)

        local ListItem = ListIcons:Add("DButton")
        ListItem:SetText("")
        ListItem:SetSize(W(60), H(60))
        ListItem.alpha = 0
        ListItem.index = k
        ListItem.Paint = function(_, w, h)
            local convar = GetConVar(l .. "icon"):GetInt()

            _.alpha = Lerp(FrameTime() * 10, _.alpha, (_:IsHovered() or _.index == convar) and 200 or 0)

            surface.SetDrawColor(255, 61, 96, _.alpha)
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(mat)
            surface.DrawTexturedRect(5, 5, w - 10, h - 10)

            surface.SetDrawColor(255, 61, 96, 150)
            surface.DrawOutlinedRect(0, 0, w, h, 1)
        end

        ListItem.DoClick = function()
            RunConsoleCommand(l .. "icon", k)
        end
    end

    local ribbonScrollPanel = vgui.Create("DScrollPanel")
    ribbonScrollPanel:DockMargin(W(5), H(5), W(5), H(5))
    ribbonScrollPanel:SetTall(130)
    ribbonScrollPanel.Paint = function(_, w, h)
        surface.SetDrawColor(0, 0, 0)
        surface.DrawOutlinedRect(0, 0, w, h)
    end
    CPanel:AddPanel(ribbonScrollPanel)

    local ListRibbons = ribbonScrollPanel:Add("DIconLayout")
    ListRibbons:Dock(FILL)
    ListRibbons:SetSpaceY(5)
    ListRibbons:SetSpaceX(5)

    for k, v in ipairs(Evidence.ribbons) do
        local mat = Material(v[1])

        local ListItem = ListRibbons:Add("DButton")
        ListItem:SetTooltip(v[2])
        ListItem:SetText("")
        ListItem:SetSize(W(60), H(60))
        ListItem.alpha = 0
        ListItem.index = k
        ListItem.Paint = function(_, w, h)
            local convar = GetConVar(l .. "ribbon"):GetInt()

            _.alpha = Lerp(FrameTime() * 10, _.alpha, (_:IsHovered() or _.index == convar) and 200 or 0)

            surface.SetDrawColor(255, 61, 96, _.alpha)
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(mat)
            surface.DrawTexturedRect(5, 5, w - 10, h - 10)

            surface.SetDrawColor(255, 61, 96, 150)
            surface.DrawOutlinedRect(0, 0, w, h, 1)
        end

        ListItem.DoClick = function()
            RunConsoleCommand(l .. "ribbon", k)
        end
    end

    local factionScrollPanel = vgui.Create("DScrollPanel")
    factionScrollPanel:DockMargin(W(5), H(5), W(5), H(5))
    factionScrollPanel:SetTall(130)
    factionScrollPanel.list = {}
    factionScrollPanel.Paint = function(_, w, h)
        surface.SetDrawColor(0, 0, 0)
        surface.DrawOutlinedRect(0, 0, w, h)
    end
    CPanel:AddPanel(factionScrollPanel)

    local function createButton()
        factionScrollPanel.list = {}
        EvidenceFactionData = {}
        factionScrollPanel:Clear()

        netstream.Start("Evidence:SetFactionData", {})

        for k, v in ipairs(player.GetAll()) do
            local id = v:Team()
            local faction = Character.team:GetByID(id)

            if faction and !factionScrollPanel.list[id] then
                local checkbox = factionScrollPanel:Add("DCheckBoxLabel")
                checkbox:SetTextColor(Color(0, 0, 0))
                checkbox:Dock(TOP)
                checkbox:SetText(faction:GetName())
                checkbox:SetValue(false)
                checkbox:SizeToContents()
                checkbox.OnChange = function(_, val)
                    if val then
                        EvidenceFactionData[id] = true
                    else
                        EvidenceFactionData[id] = nil
                    end

                    netstream.Start("Evidence:SetFactionData", EvidenceFactionData)
                end

                factionScrollPanel.list[id] = checkbox
            end
        end

        local factionInfoReloadButton = factionScrollPanel:Add("DButton")
        factionInfoReloadButton:SetText("Обновить список персонажей")
        factionInfoReloadButton:Dock(TOP)
        factionInfoReloadButton.DoClick = function()
            createButton()
        end
    end

    createButton()

    local ResetButton = vgui.Create("DButton")
    ResetButton:SetText("Сбросить настройки")
    ResetButton.DoClick = function()
        RunConsoleCommand(l .. "name", "Название улики")
        EvidenceDescription = "Описание улики"
        dtextentryDesc:SetValue(EvidenceDescription)
        RunConsoleCommand(l .. "r", 255)
        RunConsoleCommand(l .. "g", 255)
        RunConsoleCommand(l .. "b", 255)
        RunConsoleCommand(l .. "alpha", 255)
        RunConsoleCommand(l .. "icon", 1)
        RunConsoleCommand(l .. "ribbon", 1)
    end
    CPanel:AddPanel(ResetButton)
end