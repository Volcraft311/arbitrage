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

TOOL.Name = "Container Tool"
TOOL.Category = "Asterion Tools"
TOOL.Information = {
    {name = "left", stage = 0},
    {name = "reload"}
}

TOOL.ClientConVar.name = ""
ContainerDescription = ContainerDescription or ""
TOOL.ClientConVar.w = 4
TOOL.ClientConVar.h = 4
TOOL.ClientConVar.preset = ""

if CLIENT then
    language.Add("tool.containertool.name", "Container Tool")
    language.Add("tool.containertool.desc", "Позволяет превращать из сущностей - контейнер")
    language.Add("tool.containertool.left", "Нажмите левую кнопку мышки чтобы поставить контейнер.")
    language.Add("tool.containertool.reload", "Нажмите Перезарядка чтобы удалить контейнер.")
end

function TOOL:LeftClick()
    if CLIENT then return true end

    local client = self:GetOwner()

    local data = Container:GetToolData(client)
    if !data then return end

    local message = Container:LeftClick(data)

    if message then
        client:ChatNotify(message)
    end
end

function TOOL:Reload()
    if CLIENT then return true end

    local client = self:GetOwner()

    local data = Container:GetToolData(client)
    if !data then return end

    local message = Container:Reload(data)

    if message then
        client:ChatNotify(message)
    end
end

local ConVarsDefault = TOOL:BuildConVarList()
function TOOL.BuildCPanel(CPanel)
    local l = "containertool_"

    local function clear()
        RunConsoleCommand(l .. "preset", "")
        RunConsoleCommand(l .. "name", "")
        ContainerDescription = ""
        RunConsoleCommand(l .. "w", 4)
        RunConsoleCommand(l .. "h", 4)

        CPanel.labelTitle:SetText("")
        CPanel.textEntryDesc:SetValue("")
        CPanel.wSlider:SetValue(4)
        CPanel.hSlider:SetValue(4)
    end

    CPanel:AddControl("Header", {
        Description = "Данный инструмент поможет вам создавать контейнеры из пропов."
    })

    CPanel:AddControl("ComboBox", {
        MenuButton = 1,
        Folder = "containertool",
        Options = {
            ["#preset.default"] = ConVarsDefault
        },
        CVars = table.GetKeys(ConVarsDefault)
    })

    CPanel:AddControl("Label", {
        Text = "Выбор пресета",
        Description = "Выберите готовый набор предметов"
    })

    local presetPanel = vgui.Create("DPanel")
    presetPanel:SetTall(350)
    CPanel:AddPanel(presetPanel)

    local presetTree = vgui.Create("DTree", presetPanel)
    presetTree:Dock(FILL)
    presetTree:SetIndentSize(10)

    local categoryIcons = {
        ["medical"] = "icon16/heart.png",
        ["weapons"] = "icon16/gun.png",
        ["tools"] = "icon16/wrench.png",
        ["food"] = "icon16/cake.png",
        ["documents"] = "icon16/book.png",
        ["container"] = "icon16/box.png"
    }

    local noneNode = presetTree:AddNode("Без пресета")
    noneNode:SetIcon("icon16/package.png")
    noneNode.DoClick = function()
        RunConsoleCommand(l .. "preset", "")
        CPanel.labelTitle:SetText("")
        CPanel.textEntryDesc:SetValue("")
        CPanel.wSlider:SetValue(4)
        CPanel.hSlider:SetValue(4)
    end

    local categories = {
        ["medical"] = "Медицинские",
        ["weapons"] = "Оружие",
        ["tools"] = "Инструменты",
        ["food"] = "Еда",
        ["documents"] = "Документы",
        ["container"] = "Контейнеры"
    }

    local presetsByCategory = {}
    for presetName, presetData in pairs(Container.presets) do
        if !presetsByCategory[presetData.type] then
            presetsByCategory[presetData.type] = {}
        end
        presetsByCategory[presetData.type][presetName] = presetData
    end

    for categoryId, categoryName in SortedPairs(categories) do
        if presetsByCategory[categoryId] then
            local categoryNode = presetTree:AddNode(categoryName)
            categoryNode:SetIcon(categoryIcons[categoryId] or "icon16/folder.png")

            categoryNode.Label:SetTextColor(Color(0, 0, 0, 150))
            categoryNode.Label:SetTextStyleColor(Color(0, 0, 0, 150))
            categoryNode.Label.DoClick = function() end
            categoryNode.Label.DoDoubleClick = function() end
            categoryNode.Label.DoRightClick = function() end
            categoryNode.Label.DragHover = function() end

            for presetName, presetData in SortedPairsByMemberValue(presetsByCategory[categoryId], "name") do
                local presetNode = categoryNode:AddNode(presetData.name)
                presetNode:SetTooltip(presetData.description)
                presetNode:SetIcon("icon16/package.png")

                for _, item_preset in ipairs(presetData.items) do
                    local itemNode = nil

                    local item = ItemBase.list[item_preset.id]
                    if item then
                        itemNode = presetNode:AddNode(L(item.name))
                        itemNode:SetTooltip(L(item.description))

                        if string.isURL(item.icon) then
                            asterionlib.downloader:Image(item.icon, function(mat, path)
                                if !path then return end

                                itemNode.Icon:SetMaterial(mat)
                            end)
                        else
                            itemNode:SetIcon(item.icon)
                        end
                    else
                        itemNode = presetNode:AddNode("!!!ERROR " .. item_preset.id .. "!!!")
                    end

                    itemNode.Label:SetTextColor(Color(0, 0, 0, 150))
                    itemNode.Label:SetTextStyleColor(Color(0, 0, 0, 150))
                    itemNode.Label.DoClick = function() end
                    itemNode.Label.DoDoubleClick = function() end
                    itemNode.Label.DoRightClick = function() end
                    itemNode.Label.DragHover = function() end
                end

                presetNode.DoClick = function()
                    RunConsoleCommand(l .. "preset", presetName)
                    RunConsoleCommand(l .. "name", presetData.name)
                    RunConsoleCommand(l .. "w", presetData.size.w)
                    RunConsoleCommand(l .. "h", presetData.size.h)

                    ContainerDescription = presetData.description
                    netstream.Start("Container:SetDescription", ContainerDescription)

                    CPanel.labelTitle:SetText(presetData.name)
                    CPanel.textEntryDesc:SetValue(presetData.description)
                    CPanel.wSlider:SetValue(presetData.size.w)
                    CPanel.hSlider:SetValue(presetData.size.h)
                end
            end
        end
    end

    CPanel.labelTitle = CPanel:AddControl("TextBox", {
        Label = "Название",
        Command = l .. "name"
    })

    CPanel.lableDesc = vgui.Create("DLabel")
    CPanel.lableDesc:SetText("Описание")
    CPanel.lableDesc:SetTextColor(color_black)
    CPanel:AddPanel(CPanel.lableDesc)

    CPanel.textEntryDesc = vgui.Create("DTextEntry")
    CPanel.textEntryDesc:SetValue(ContainerDescription)
    CPanel.textEntryDesc:SetTall(100)
    CPanel.textEntryDesc:SetVerticalScrollbarEnabled(true)
    CPanel.textEntryDesc:SetMultiline(true)
    CPanel.textEntryDesc.OnChange = function(_)
        local data = _:GetValue()
        ContainerDescription = data
        netstream.Start("Container:SetDescription", ContainerDescription)
    end
    CPanel:AddPanel(CPanel.textEntryDesc)

    CPanel.wSlider = CPanel:AddControl("Slider", {
        Label = "Размер в длину",
        Command = l .. "w",
        Min = 1,
        Max = 10
    })

    CPanel.hSlider = CPanel:AddControl("Slider", {
        Label = "Размер в ширину",
        Command = l .. "h",
        Min = 1,
        Max = 10
    })

    function CPanel:UpdatePresetInfo(presetData)
        if presetData then
            self.labelTitle:SetText(presetData.name)
            self.textEntryDesc:SetValue(presetData.description)
            self.wSlider:SetValue(presetData.size.w)
            self.hSlider:SetValue(presetData.size.h)
        else
            clear()
        end
    end

    clear()
end