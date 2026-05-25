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


AddCSLuaFile()

TOOL.Name = "Entities Info"
TOOL.Category = "Pump Tools"
TOOL.Information = {
    {name = "left", stage = 0},
    {name = "right", stage = 0}
}

if CLIENT then
    language.Add("tool.entitiesinfo.name", "Entities Info Tool")
    language.Add("tool.entitiesinfo.desc", "Позволяет находить объекты из списка дополнений")
    language.Add("tool.entitiesinfo.left", "Нажмите левую кнопку мыши, чтобы выбрать выделенные объекты.")
    language.Add("tool.entitiesinfo.reload", "Нажмите перезарядка, чтобы очистить список выделенных объектов")
end

local toolData = {
    foundAddons = {},
    addonEntities = {},
    currentOutline = {},
    categoryList = nil,
    panels = {}
}

local size = 500

local function getSelectedEntities()
    local trace = LocalPlayer():GetEyeTrace()
    local pos = trace.HitPos
    local vectorSize = Vector(size, size, size)

    return ents.FindInBox(pos - vectorSize, pos + vectorSize)
end

local function findAddonForModel(model)
    local addons = engine.GetAddons()
    for _, addon in ipairs(addons) do
        if !addon.mounted then continue end

        if file.Exists(model, addon.title) then
            return addon
        end
    end

    return nil
end

local function highlightEntities(entities)
    if #entities > 0 then
        toolData.currentOutline = entities
    else
        toolData.currentOutline = {}
    end
end

local function clear()
    for _, panel in ipairs(toolData.panels) do
        if IsValid(panel) then
            panel:Remove()
        end
    end

    toolData.panels = {}
end

local function createCategories()
    if !IsValid(toolData.categoryList) then return end

    clear()

    if toolData.addonEntities.other and #toolData.addonEntities.other > 0 then
        local DCollapsible = toolData.categoryList:Add("DCollapsibleCategory")
        DCollapsible:SetLabel("ОСТАЛЬНОЕ")
        DCollapsible:Dock(TOP)

        local DermaList = vgui.Create("DPanelList")
        DermaList:SetSpacing(5)
        DermaList:EnableHorizontal(false)
        DermaList:EnableVerticalScrollbar(true)
        DCollapsible:SetContents(DermaList)

        local highlightBtn = DCollapsible:Add("Количество объектов: " ..  #toolData.addonEntities.other)
        highlightBtn.DoClick = function()
            highlightEntities(toolData.addonEntities.other)
        end

        local categoryList = vgui.Create("DPanelList")
        categoryList:Dock(TOP)
        categoryList:EnableHorizontal(true)
        categoryList:SetAutoSize(true)
        categoryList:SetPadding(4)
        categoryList:SetSpacing(4)
        DermaList:AddItem(categoryList)

        for _, entity in ipairs(toolData.addonEntities.other) do
            local icon = vgui.Create("DModelPanel")
            icon:SetTooltip(entity:GetModel())
            icon:SetSize(35, 35)
            icon:SetModel(entity:GetModel())
            icon.PaintOver = function(this, w, h)
                surface.SetDrawColor(0, 0, 0)
                surface.DrawOutlinedRect(0, 0, w, h)
            end
            icon.DoClick = function()
                local Menu = DermaMenu()
                    local btnCopyModel = Menu:AddOption("Скопировать путь до модели", function()
                        SetClipboardText(entity:GetModel())
                    end)
                    btnCopyModel:SetIcon("icon16/page_copy.png")

                    local btnSelect = Menu:AddOption("Выделить объект", function()
                        highlightEntities({entity})
                    end)
                    btnSelect:SetIcon("icon16/contrast_low.png")
                Menu:Open()
            end

            local mn, mx = icon.Entity:GetRenderBounds()
            local size = 0
            size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
            size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
            size = math.max(size, math.abs(mn.z) + math.abs(mx.z))

            icon:SetFOV(45)
            icon:SetCamPos(Vector(size, size, size))
            icon:SetLookAt((mn + mx) * 0.5)

            categoryList:AddItem(icon)
        end

        toolData.panels[#toolData.panels + 1] = DCollapsible
    end

    local sortedAddons = {}
    for wsid, props in pairs(toolData.addonEntities) do
        if wsid != "other" then
            sortedAddons[#sortedAddons + 1] = {
                wsid = wsid,
                count = #props,
                title = toolData.foundAddons[wsid].addon.title,
                props = props
            }
        end
    end

    table.sort(sortedAddons, function(a, b) return a.count > b.count end)

    for _, addon in ipairs(sortedAddons) do
        local DCollapsible = toolData.categoryList:Add("DCollapsibleCategory")
        DCollapsible:SetLabel(addon.title)
        DCollapsible:Dock(TOP)

        local DermaList = vgui.Create("DPanelList")
        DermaList:SetSpacing(5)
        DermaList:EnableHorizontal(false)
        DermaList:EnableVerticalScrollbar(true)
        DCollapsible:SetContents(DermaList)

        local highlightBtn = DCollapsible:Add("Количество объектов: " ..  addon.count)
        highlightBtn.DoClick = function()
            highlightEntities(addon.props)
        end

        local categoryList = vgui.Create("DPanelList")
        categoryList:Dock(TOP)
        categoryList:EnableHorizontal(true)
        categoryList:SetAutoSize(true)
        categoryList:SetPadding(4)
        categoryList:SetSpacing(4)
        DermaList:AddItem(categoryList)

        for _, entity in ipairs(addon.props) do
            local icon = vgui.Create("DModelPanel")
            icon:SetTooltip(entity:GetModel())
            icon:SetSize(35, 35)
            icon:SetModel(entity:GetModel())
            icon.PaintOver = function(this, w, h)
                surface.SetDrawColor(0, 0, 0)
                surface.DrawOutlinedRect(0, 0, w, h)
            end
            icon.DoClick = function()
                local Menu = DermaMenu()
                    local btnCopyModel = Menu:AddOption("Скопировать путь до модели", function()
                        SetClipboardText(entity:GetModel())
                    end)
                    btnCopyModel:SetIcon("icon16/page_copy.png")

                    local btnSelect = Menu:AddOption("Выделить объект", function()
                        highlightEntities({entity})
                    end)
                    btnSelect:SetIcon("icon16/contrast_low.png")
                Menu:Open()
            end

            local mn, mx = icon.Entity:GetRenderBounds()
            local size = 0
            size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
            size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
            size = math.max(size, math.abs(mn.z) + math.abs(mx.z))

            icon:SetFOV(45)
            icon:SetCamPos(Vector(size, size, size))
            icon:SetLookAt((mn + mx) * 0.5)

            categoryList:AddItem(icon)
        end

        local workshopBtn = vgui.Create("DButton")
        workshopBtn:SetText("Открыть в Workshop")
        workshopBtn:Dock(TOP)
        workshopBtn.DoClick = function()
            gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=" .. addon.wsid)
        end
        DermaList:AddItem(workshopBtn)

        local openBtn = vgui.Create("DButton")
        openBtn:SetText("Открыть список всех объектов")
        openBtn:Dock(TOP)
        openBtn.DoClick = function()
            local frame = vgui.Create("DFrame")
            frame:SetSize(800, 600)
            frame:SetTitle("Просмотр объектов аддона: " .. addon.title)
            frame:Center()
            frame:MakePopup()

            local mainPanel = vgui.Create("DPanel", frame)
            mainPanel:Dock(FILL)
            mainPanel:DockPadding(5, 5, 5, 5)

            local searchPanel = vgui.Create("DPanel", mainPanel)
            searchPanel:Dock(TOP)
            searchPanel:SetTall(30)
            searchPanel:DockMargin(0, 0, 0, 5)
            searchPanel.Paint = function(self, w, h)
                draw.RoundedBox(4, 0, 0, w, h, Color(40, 40, 40))
            end

            local treePanel = vgui.Create("DPanel", mainPanel)
            treePanel:Dock(LEFT)
            treePanel:SetWide(300)
            treePanel:DockMargin(0, 0, 5, 0)

            local modelPanelContainer = vgui.Create("DPanel", mainPanel)
            modelPanelContainer:Dock(FILL)

            local dtree = vgui.Create("DTree", treePanel)
            dtree:Dock(FILL)

            local searchEntry = vgui.Create("DTextEntry", searchPanel)
            searchEntry:Dock(FILL)
            searchEntry:SetPlaceholderText("Поиск моделей...")

            local currentModelPanel = vgui.Create("DModelPanel", modelPanelContainer)
            currentModelPanel:Dock(FILL)
            currentModelPanel:SetFOV(45)
            currentModelPanel:SetCamPos(Vector(50, 50, 50))
            currentModelPanel:SetLookAt(Vector(0, 0, 0))

            local function CreateAdjustablePanel(parent)
                local panel = vgui.Create("DAdjustableModelPanel", parent)
                panel:Dock(FILL)
                panel:SetFOV(45)
                panel:SetCamPos(Vector(50, 50, 50))
                panel:SetLookAt(Vector(0, 0, 0))
                panel:SetVisible(false)
                return panel
            end

            local advModelPanel = CreateAdjustablePanel(modelPanelContainer)

            local originalTreeData = {}

            local function SaveNodeData(node, path)
                if !node.IsFolder then
                    table.insert(originalTreeData, {
                        name = node:GetText(),
                        path = node.modelPath,
                        fullPath = path .. "/" .. node:GetText()
                    })
                end

                for _, child in pairs(node:GetChildNodes()) do
                    SaveNodeData(child, path .. "/" .. node:GetText())
                end
            end

            local function BuildTree(filterText)
                dtree:Clear()

                local function ShouldInclude(item)
                    return filterText == "" or item.name:lower():find(filterText:lower(), 1, true)
                end

                local addedFolders = {}

                local function AddToTree(item)
                    local pathParts = string.Split(string.GetPathFromFilename(item.path), "/")
                    local currentParent = dtree

                    for i, part in ipairs(pathParts) do
                        if part != "" then
                            if !addedFolders[part] then
                                local folderNode = currentParent:AddNode(part)
                                folderNode:SetExpanded(true)
                                folderNode.Icon:SetImage("icon16/folder.png")
                                folderNode.IsFolder = true
                                addedFolders[part] = folderNode
                                currentParent = folderNode
                            else
                                currentParent = addedFolders[part]
                            end
                        end
                    end

                    local modelNode = currentParent:AddNode(item.name)
                    modelNode.Icon:SetImage("icon16/shape_square.png")
                    modelNode.modelPath = item.path

                    modelNode.DoRightClick = function()
                        local menu = DermaMenu()

                        menu:AddOption("Копировать путь", function()
                            SetClipboardText(modelNode.modelPath)
                        end):SetIcon("icon16/page_copy.png")

                        menu:AddOption("Заспавнить проп", function()
                            RunConsoleCommand("gm_spawn", modelNode.modelPath)
                        end):SetIcon("icon16/box.png")

                        menu:AddOption("Просмотр (обычный)", function()
                            modelNode:View()
                        end):SetIcon("icon16/eye.png")

                        menu:AddOption("Просмотр (продвинутый)", function()
                            currentModelPanel:SetVisible(false)
                            advModelPanel:SetVisible(true)
                            advModelPanel:SetModel(modelNode.modelPath)

                            local ent = advModelPanel.Entity
                            if IsValid(ent) then
                                local mins, maxs = ent:GetRenderBounds()
                                advModelPanel:SetCamPos(mins:Distance(maxs) * Vector(0.75, 0.75, 0.5))
                                advModelPanel:SetLookAt((mins + maxs) / 2)
                            end

                            advModelPanel.mx = 0
                            advModelPanel.my = 0
                            advModelPanel.aLookAngle = Angle(0, 0, 0)
                            advModelPanel:SetMovementScale(1)
                            advModelPanel.OrbitPoint = vector_origin
                            advModelPanel.OrbitDistance = (advModelPanel.OrbitPoint - advModelPanel.vCamPos):Length()
                            advModelPanel:SetFOV(70)
                            advModelPanel.LayoutEntity = function() return end
                        end):SetIcon("icon16/eye.png")

                        menu:Open()
                    end

                    modelNode.View = function()
                        currentModelPanel:SetVisible(true)
                        advModelPanel:SetVisible(false)
                        currentModelPanel:SetModel(modelNode.modelPath)

                        if IsValid(currentModelPanel.Entity) then
                            local mn, mx = currentModelPanel.Entity:GetRenderBounds()
                            local size = 0
                            size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
                            size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
                            size = math.max(size, math.abs(mn.z) + math.abs(mx.z))

                            currentModelPanel:SetFOV(45)
                            currentModelPanel:SetCamPos(Vector(size, size, size))
                            currentModelPanel:SetLookAt((mn + mx) * 0.5)
                        end
                    end

                    modelNode.DoClick = function(this)
                        this:View()
                    end
                end

                for _, item in ipairs(originalTreeData) do
                    if ShouldInclude(item) then
                        AddToTree(item)
                    end
                end
            end

            searchEntry.OnEnter = function(self)
                BuildTree(self:GetText())
            end

            searchEntry.OnChange = function(self)
                BuildTree(self:GetText())
            end

            local function InitializeTree()
                local function ProcessNode(path, parentNode)
                    local files, folders = file.Find(path .. "/*", addon.title)

                    for _, folder in ipairs(folders) do
                        local node = parentNode:AddNode(folder)
                        node:SetExpanded(true)
                        node.Icon:SetImage("icon16/folder.png")
                        node.IsFolder = true
                        node.Path = path .. "/" .. folder

                        ProcessNode(node.Path, node)
                    end

                    for _, file in ipairs(files) do
                        if string.EndsWith(file, ".mdl") then
                            local node = parentNode:AddNode(string.StripExtension(file))
                            node.Icon:SetImage("icon16/shape_square.png")
                            node.modelPath = path .. "/" .. file

                            table.insert(originalTreeData, {
                                name = string.StripExtension(file),
                                path = path .. "/" .. file,
                                fullPath = path .. "/" .. file
                            })

                            node.DoRightClick = function()
                                local menu = DermaMenu()

                                menu:AddOption("Копировать путь", function()
                                    SetClipboardText(node.modelPath)
                                end):SetIcon("icon16/page_copy.png")

                                menu:AddOption("Заспавнить проп", function()
                                    RunConsoleCommand("gm_spawn", node.modelPath)
                                end):SetIcon("icon16/box.png")

                                menu:AddOption("Просмотр (обычный)", function()
                                    node:View()
                                end):SetIcon("icon16/eye.png")

                                menu:AddOption("Просмотр (продвинутый)", function()
                                    currentModelPanel:SetVisible(false)
                                    advModelPanel:SetVisible(true)
                                    advModelPanel:SetModel(node.modelPath)

                                    local ent = advModelPanel.Entity
                                    if IsValid(ent) then
                                        local mn, mx = currentModelPanel.Entity:GetRenderBounds()
                                        local size = 0
                                        size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
                                        size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
                                        size = math.max(size, math.abs(mn.z) + math.abs(mx.z))

                                        advModelPanel:SetFOV(45)
                                        advModelPanel:SetCamPos(Vector(size, size, size))
                                        advModelPanel:SetLookAt((mn + mx) * 0.5)
                                    end

                                    advModelPanel.mx = 0
                                    advModelPanel.my = 0
                                    advModelPanel.aLookAngle = Angle(0, 0, 0)
                                    advModelPanel:SetMovementScale(1)
                                    advModelPanel.OrbitPoint = vector_origin
                                    advModelPanel.OrbitDistance = (advModelPanel.OrbitPoint - advModelPanel.vCamPos):Length()
                                    advModelPanel:SetFOV(70)
                                    advModelPanel.LayoutEntity = function() return end
                                end):SetIcon("icon16/eye.png")

                                menu:Open()
                            end

                            node.View = function()
                                currentModelPanel:SetVisible(true)
                                advModelPanel:SetVisible(false)
                                currentModelPanel:SetModel(node.modelPath)

                                if IsValid(currentModelPanel.Entity) then
                                    local mn, mx = currentModelPanel.Entity:GetRenderBounds()
                                    local size = 0
                                    size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
                                    size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
                                    size = math.max(size, math.abs(mn.z) + math.abs(mx.z))

                                    currentModelPanel:SetFOV(45)
                                    currentModelPanel:SetCamPos(Vector(size, size, size))
                                    currentModelPanel:SetLookAt((mn + mx) * 0.5)
                                end
                            end

                            node.DoClick = function(this)
                                this:View()
                            end
                        end
                    end
                end

                ProcessNode("models", dtree)
            end

            InitializeTree()
        end
        DermaList:AddItem(openBtn)

        toolData.panels[#toolData.panels + 1] = DCollapsible
    end
end

local function updateAddonData()
    toolData.foundAddons = {}
    toolData.addonEntities = {}
    highlightEntities({})

    local props = getSelectedEntities()
    if #props == 0 then return end

    for _, prop in ipairs(props) do
        local model = prop:GetModel()
        local addon = findAddonForModel(model)

        if addon then
            toolData.foundAddons[addon.wsid] = {
                addon = addon
            }

            toolData.addonEntities[addon.wsid] = toolData.addonEntities[addon.wsid] or {}
            toolData.addonEntities[addon.wsid][#toolData.addonEntities[addon.wsid] + 1] = prop
        else
            toolData.addonEntities.other = toolData.addonEntities.other or {}
            toolData.addonEntities.other[#toolData.addonEntities.other + 1] = prop
        end
    end

    createCategories()

    chat.AddText("Было выбранно " .. #props .. " объектов!")
end

function TOOL:Deploy()
    if CLIENT then
        local angle_zero = Angle(0, 0, 0)
        local box_color = Color(0, 255, 0)

        hook.Add("PostDrawTranslucentRenderables", "EntitiesInfo", function(bDepth, bSkybox)
            local trace = LocalPlayer():GetEyeTrace()
            local pos = trace.HitPos
            local vectorSize = Vector(size, size, size)

            render.DrawWireframeBox(pos, angle_zero, -vectorSize, vectorSize, box_color, true)

            local entitiesInBox = ents.FindInBox(pos - vectorSize, pos + vectorSize)
            local regularEntities = {}

            for _, entity in ipairs(entitiesInBox) do
                if !table.HasValue(toolData.currentOutline, entity) then
                    regularEntities[#regularEntities + 1] = entity
                end
            end

            if #regularEntities > 0 then
                outline.Add(regularEntities, Color(255, 255, 0), 0)
            end

            if #toolData.currentOutline > 0 then
                outline.Add(toolData.currentOutline, Color(255, 0, 0), 0)
            end
        end)
    end
end

function TOOL:Holster()
    if CLIENT then
        hook.Remove("PostDrawTranslucentRenderables", "EntitiesInfo")
    end
end

function TOOL:LeftClick()
    if SERVER then return true end

    updateAddonData()

    return true
end

function TOOL:Reload()
    if SERVER then return true end

    clear()

    toolData.foundAddons = {}
    toolData.addonEntities = {}

    highlightEntities({})

    return true
end

function TOOL.BuildCPanel(CPanel)
    CPanel:AddControl("Header", {
        Description = "Данный инструмент поможет вам узнать информацию о выделенных объектах."
    })

    local DermaNumSlider = vgui.Create("DNumSlider")
    DermaNumSlider:Dock(BOTTOM)
    DermaNumSlider:SetText("Размер выделения")
    DermaNumSlider:SetMin(5)
    DermaNumSlider:SetMax(1000)
    DermaNumSlider:SetValue(500)
    DermaNumSlider:SetDecimals(0)
    DermaNumSlider:SetDark(true)
    DermaNumSlider.OnValueChanged = function(this, value)
        size = value
    end
    CPanel:AddPanel(DermaNumSlider)

    toolData.categoryList = vgui.Create("DPanelList")
    toolData.categoryList:SetTall(1000)
    CPanel:AddPanel(toolData.categoryList)
end 