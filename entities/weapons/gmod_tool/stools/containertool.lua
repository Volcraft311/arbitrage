AddCSLuaFile()

TOOL.Name = "Container Tool"
TOOL.Category = "Asterion Tools"
TOOL.Information = {
    {name = "left", stage = 0},
    {name = "right", stage = 0}
}

TOOL.ClientConVar.name = "Название"
TOOL.ClientConVar.w = 4
TOOL.ClientConVar.h = 4

if CLIENT then
    language.Add("tool.containertool.name", "Container Tool")
    language.Add("tool.containertool.desc", "Позволяет превращать из сущностей - контейнер")
    language.Add("tool.containertool.left", "Нажмите левую кнопку мышки чтобы поставить контейнер.")
    language.Add("tool.containertool.right", "Нажмите правую кнопку мышки чтобы удалить контейнер.")
end

function TOOL:LeftClick()
    if CLIENT then return true end

    local client = self:GetOwner()

    local data = Container:GetToolData(client)
    if !data then return end

    local message = Container:LeftClick(data)

    if message then
        client:ChatPrint(message)
    end
end

function TOOL:RightClick()
    if CLIENT then return true end

    local client = self:GetOwner()

    local data = Container:GetToolData(client)
    if !data then return end

    local message = Container:RightClick(data)

    if message then
        client:ChatPrint(message)
    end
end

function TOOL.BuildCPanel(CPanel)
    local l = "containertool_"

    CPanel:AddControl("Header",{
        Description = "Данный инструмент поможет вам создавать контейнеры из пропов."
    })

    CPanel:AddControl("TextBox", {
        Label = "Название контейнера",
        Command = l .. "name"
    })

    CPanel:AddControl("Slider", {
        Label = "Размер в длину",
        Command = l .. "w",
        Min = 1,
        Max = 10
    })

    CPanel:AddControl("Slider", {
        Label = "Размер в ширину",
        Command = l .. "h",
        Min = 1,
        Max = 10
    })

    local ResetButton = vgui.Create("DButton")
    ResetButton:SetText("Сбросить настройки")
    ResetButton.DoClick = function()
        RunConsoleCommand(l .. "name", "Название")
        RunConsoleCommand(l .. "w", 4)
        RunConsoleCommand(l .. "h", 4)
    end
    CPanel:AddPanel(ResetButton)
end