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


AddCSLuaFile()

TOOL.Name = "Interaction Tool"
TOOL.Category = "Pump Tools"
TOOL.Information = {
    {name = "left", stage = 0},
    {name = "right", stage = 0},
}

local PROPERTIES_PANEL = nil
local STANDART_IMAGE = "https://i.imgur.com/4vyQ6Hl.png"
local STANDART_SOUND = "https://cdn.discordapp.com/attachments/933053600102514710/933094002784346253/DELORENZY_-_NEED_FOR_SPEED.mp3"

if CLIENT then
    language.Add("tool.interactiontool.name", "Interaction Tool")
    language.Add("tool.interactiontool.desc", "Позволяет устанавливать взаимодействие на пропы")
    language.Add("tool.interactiontool.left", "Нажмите левую кнопку мышки чтобы установить на проп взаимодействие.")
    language.Add("tool.interactiontool.right", "Нажмите правую кнопку мышки чтобы удалить с пропа взаимодействие.")
end

function TOOL:LeftClick()
    if SERVER then return true end

    local propertiesPanel = PROPERTIES_PANEL
    if !IsValid(propertiesPanel) then return end

    if !self.cd or CurTime() >= self.cd then
        self.cd = CurTime() + 0.2

        local client = LocalPlayer()
        local data = {}
        local panels = propertiesPanel.panels

        for k, v in ipairs(panels) do
            for k2, v2 in ipairs(v) do
                data[k] = data[k] or {}
                data[k][k2] = v2.value
            end

            if data[k][3] == 0 then
                data[k] = nil
            end

            if data[k] and data[k][3] then
                data[k][3] = nil
            end
        end

        local newdata = {}
        for k, v in pairs(data) do
            newdata[#newdata + 1] = data[k]
        end

        local toolInfo = Interaction:GetToolData(client)
        local entity = toolInfo.entity
        if !IsValid(entity) then return client:ChatNotify("#notify_not_valid_entity") end

        netstream.Start("Interaction:LeftClick", newdata, entity)
    end

    return true
end

function TOOL:RightClick()
    if CLIENT then return true end

    local client = self:GetOwner()

    local data = Interaction:GetToolData(client)
    if !data then return end

    local message = Interaction:RightClick(data)

    if message then
        client:ChatNotify(message)
    end
end

local function CreateInteraction(propertiesPanel, isFill)
    local id = #propertiesPanel.panels + 1
    local title = "Страница #" .. id

    local RowImage = propertiesPanel:CreateRow(title, "URL Картинки")
    RowImage:Setup("Generic")
    RowImage.value = isFill and STANDART_IMAGE or ""
    RowImage:SetValue(RowImage.value)
    RowImage.DataChanged = function(self, data)
        self.value = data
    end

    local RowSound = propertiesPanel:CreateRow(title, "URL Музыки")
    RowSound:Setup("Generic")
    RowSound.value = isFill and STANDART_SOUND or ""
    RowSound:SetValue(RowSound.value)
    RowSound.DataChanged = function(self, data)
        self.value = data
    end

    local RowBool = propertiesPanel:CreateRow(title, "Отображать")
    RowBool:Setup("Boolean")
    RowBool.value = 1
    RowBool:SetValue(true)
    RowBool.DataChanged = function(self, data)
        self.value = data
    end

    propertiesPanel.panels[id] = {
        RowImage,
        RowSound,
        RowBool
    }
end

local function GeneratePanels(CPanel)
    local linksProperties = vgui.Create("DProperties")
    linksProperties:SetTall(400)
    linksProperties.panels = {}
    CPanel:AddPanel(linksProperties)

    CreateInteraction(linksProperties, true)

    local PropertiesButton = vgui.Create("DButton")
    PropertiesButton:SetText("Добавить новую страницу")
    PropertiesButton.DoClick = function()
        CreateInteraction(linksProperties)
    end
    CPanel:AddPanel(PropertiesButton)

    local ResetButton = vgui.Create("DButton")
    ResetButton:SetText("Сбросить настройки")
    ResetButton.DoClick = function()
        local data = {
            CPanel.linksProperties,
            CPanel.PropertiesButton,
            CPanel.ResetButton
        }

        for k, v in ipairs(data) do
            if IsValid(v) then
                v:Remove()
            end
        end

        GeneratePanels(CPanel)
    end
    CPanel:AddPanel(ResetButton)


    CPanel.linksProperties = linksProperties
    CPanel.PropertiesButton = PropertiesButton
    CPanel.ResetButton = ResetButton

    PROPERTIES_PANEL = linksProperties
end

function TOOL.BuildCPanel(CPanel)
    CPanel:AddControl("Header",{
        Description = "Данный инструмент позволит устанавливать взаимодействие с пропами."
    })

    local linksLabel = vgui.Create("DLabel")
    linksLabel:SetText("Информация")
    linksLabel:SetTextColor(color_black)
    CPanel:AddPanel(linksLabel)

    GeneratePanels(CPanel)
end