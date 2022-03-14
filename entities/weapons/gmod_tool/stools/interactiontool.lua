AddCSLuaFile()

TOOL.Name = "Interaction Tool"
TOOL.Category = "Asterion Tools"
TOOL.Information = {
    {name = "left", stage = 0},
    {name = "right", stage = 0},
}

TOOL.ClientConVar.url = "https://i.imgur.com/4vyQ6Hl.png"

if CLIENT then
    language.Add("tool.interactiontool.name", "Interaction Tool")
    language.Add("tool.interactiontool.desc", "Позволяет устанавливать взаимодействие на пропы")
    language.Add("tool.interactiontool.left", "Нажмите левую кнопку мышки чтобы установить на проп взаимодействие.")
    language.Add("tool.interactiontool.right", "Нажмите правую кнопку мышки чтобы удалить с пропа взаимодействие.")
end

function TOOL:LeftClick()
    if CLIENT then return true end

    local client = self:GetOwner()

    local data = Interaction:GetToolData(client)
    if !data then return end

    local message = Interaction:LeftClick(data)

    if message then
        client:ChatPrint(message)
    end
end

function TOOL:RightClick()
    if CLIENT then return true end

    local client = self:GetOwner()

    local data = Interaction:GetToolData(client)
    if !data then return end

    local message = Interaction:RightClick(data)

    if message then
        client:ChatPrint(message)
    end
end

function TOOL.BuildCPanel(CPanel)
    local l = "interactiontool_"

    CPanel:AddControl("Header",{
        Description = "Данный инструмент позволит устанавливать взаимодействие с пропами."
    })

    CPanel:AddControl("TextBox", {
        Label = "URL ссылка",
        Command = "interactiontool_url"
    })

    local ResetButton = vgui.Create("DButton")
    ResetButton:SetText("Сбросить настройки")
    ResetButton.DoClick = function()
        RunConsoleCommand(l .. "url", "https://i.imgur.com/4vyQ6Hl.png")
    end
    CPanel:AddPanel(ResetButton)
end