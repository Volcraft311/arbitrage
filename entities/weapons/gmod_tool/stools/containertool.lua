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

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel(CPanel)
    local l = "containertool_"

    CPanel:AddControl("Header",{
        Description = "Данный инструмент поможет вам создавать контейнеры из пропов."
    })

    CPanel:AddControl("ComboBox", {MenuButton = 1, Folder = "containertool", Options = {["#preset.default"] = ConVarsDefault}, CVars = table.GetKeys(ConVarsDefault)})

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
end