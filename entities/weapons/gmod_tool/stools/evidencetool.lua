AddCSLuaFile()

TOOL.Name = "Evidence Tool"
TOOL.Category = "Asterion Tools"
TOOL.Information = {
    {name = "left", stage = 0},
    {name = "right", stage = 0},
    {name = "reload"},
}

TOOL.ClientConVar.name = "Название улики"
TOOL.ClientConVar.description = "Описание улики"
TOOL.ClientConVar.r = 255
TOOL.ClientConVar.g = 255
TOOL.ClientConVar.b = 255
TOOL.ClientConVar.alpha = 255
TOOL.ClientConVar.icon = 1

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
        client:ChatPrint(message)
    end
end

function TOOL:RightClick()
    if CLIENT then return true end

    local client = self:GetOwner()

    local data = Evidence:GetToolData(client)
    if !data then return end

    local message = Evidence:RightClick(data)

    if message then
        client:ChatPrint(message)
    end
end

function TOOL:Reload()
    if CLIENT then return true end

    local client = self:GetOwner()

    local data = Evidence:GetToolData(client)
    if !data then return end

    local message = Evidence:Reload(data)

    if message then
        client:ChatPrint(message)
    end
end

function TOOL.BuildCPanel(CPanel)
    local l = "evidencetool_"

    CPanel:AddControl("Header",{
        Description = "Данный инструмент поможет вам создавать улики на карте которые смогут собирать игроки."
    })

    CPanel:AddControl("TextBox", {
        Label = "Название улики",
        Command = "evidencetool_name"
    })

    CPanel:AddControl("TextBox", {
        Label = "Описание улики",
        Command = "evidencetool_description"
    })

    CPanel:AddControl("Slider", {
        Label = "Видимость улики",
        Command = l .. "alpha",
        Min = 0,
        Max = 255
    })

    CPanel:AddControl( "Color", {
        Label = "Цвет улики",
        Red = l .. "r",
        Green = l .. "g",
        Blue = l .. "b"
    })

    local cluePanel = vgui.Create("DScrollPanel")
    cluePanel:DockMargin(Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(5), Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(5))
    cluePanel:SetTall(200)
    cluePanel.Paint = function(_, w, h)
        surface.SetDrawColor(0, 0, 0)
        surface.DrawOutlinedRect(0, 0, w, h)
    end
    CPanel:AddPanel(cluePanel)

    local List = cluePanel:Add("DIconLayout")
    List:Dock(FILL)
    List:SetSpaceY(5)
    List:SetSpaceX(5)

    for k, v in pairs(Evidence.icons) do
        local mat = Arbitrage.GetMaterial(v)

        local ListItem = List:Add("DButton")
        ListItem:SetText("")
        ListItem:SetSize(Arbitrage.ResolutionW(60), Arbitrage.ResolutionH(60))
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

    local ResetButton = vgui.Create("DButton")
    ResetButton:SetText("Сбросить настройки")
    ResetButton.DoClick = function()
        RunConsoleCommand(l .. "name", "Название улики")
        RunConsoleCommand(l .. "description", "Описание улики")
        RunConsoleCommand(l .. "r", 255)
        RunConsoleCommand(l .. "g", 255)
        RunConsoleCommand(l .. "b", 255)
        RunConsoleCommand(l .. "alpha", 255)
        RunConsoleCommand(l .. "icon", 1)
    end
    CPanel:AddPanel(ResetButton)
end