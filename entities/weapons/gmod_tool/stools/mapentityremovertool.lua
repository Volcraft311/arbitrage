--[[
        © AsterionStaff 2023.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


file.CreateDir("academy_mapentityremover_configs")
file.CreateDir("academy_mapentityremover_configs/" .. game.GetMap())

AddCSLuaFile()

TOOL.Name = "Map Entity Remover Tool"
TOOL.Category = "Asterion Tools"
TOOL.Information = {
    {name = "left", stage = 0},
    {name = "reload"}
}

TOOL.ClientConVar.drawmapcreationstored = 1
TOOL.ClientConVar.drawselectedstored = 1

local AppList = nil
local MapCreationStored = {}
local SelectedStored = {}

local function updateAppList()
    AppList:Clear()

    for k, v in pairs(SelectedStored) do
        AppList:AddLine(tostring(Entity(k)), k, v)
    end
end

if CLIENT then
    language.Add("tool.mapentityremovertool.name", "Map Entity Remover Tool")
    language.Add("tool.mapentityremovertool.desc", "Позволяет вам удалять выбранные объекты с карты")
    language.Add("tool.mapentityremovertool.left", "Нажмите левую кнопку мышки чтобы добавить объект в список")
    language.Add("tool.mapentityremovertool.reload", "Нажмите Перезарядку чтобы удалить объект из списка")

    netstream.Hook("MapEntityRemover:Receive", function(data)
        MapCreationStored = data
    end)

    netstream.Hook("MapEntityRemover:Add", function(idx, creationID)
        SelectedStored[idx] = creationID
        updateAppList()
    end)

    netstream.Hook("MapEntityRemover:Remove", function(idx)
        SelectedStored[idx] = nil
        updateAppList()
    end)
else
    netstream.Hook("MapEntityRemover:Get", function(client)
        if !client:IsAdmin() then return end

        local data = {}
        for k, v in ipairs(ents.GetAll()) do
            local id = v:MapCreationID()

            if id != -1 and IsValid(v) then
                data[v:EntIndex()] = id
            end
        end

        netstream.Heavy(client, "MapEntityRemover:Receive", data)
    end)

    netstream.Hook("MapEntityRemover:Remove", function(client, data)
        if !client:IsAdmin() then return end

        for k, v in ipairs(data) do
            local entity = ents.GetMapCreatedEntity(v)
            if !IsValid(entity) then continue end

            entity:Remove()
        end
    end)

    netstream.Hook("MapEntityRemover:Add", function(client, idx)
        if !client:IsAdmin() then return end

        idx = tonumber(idx)
        if !idx then return end

        local entity = Entity(idx)
        if !IsValid(entity) then return end

        local id = entity:MapCreationID()
        if id == -1 then return end

        netstream.Start(client, "MapEntityRemover:Add", idx, id)
    end)
end

local l = "mapentityremovertool_"
function TOOL:LeftClick()
    if CLIENT then return true end

    local client = self:GetOwner()
    local trace = client:GetEyeTrace()
    local entity = trace.Entity
    if !IsValid(entity) then return client:ChatNotify("Не валидное Entity!") end

    local id = entity:MapCreationID()
    if id == -1 then return client:ChatNotify("Данный объект не создан миром!") end

    netstream.Start(client, "MapEntityRemover:Add", entity:EntIndex(), id)
end

function TOOL:Reload()
    if CLIENT then return true end

    local client = self:GetOwner()
    local trace = client:GetEyeTrace()
    local entity = trace.Entity
    if !IsValid(entity) then return client:ChatNotify("Не валидное Entity!") end

    netstream.Start(client, "MapEntityRemover:Remove", entity:EntIndex())
end

function TOOL.BuildCPanel(CPanel)
    CPanel:AddControl("Header",{
        Description = "Данный инструмент поможет создавать конфигурации с выбранными объектами и сразу удалять их из карты."
    })

    local saveButton = vgui.Create("DButton")
    saveButton:SetText("Конфигурации")
    saveButton:Dock(BOTTOM)
    saveButton.DoClick = function()
        local Menu = DermaMenu()
        Menu:AddOption("Сохранить список", function()
            Derma_StringRequest("Сохранить цветокор", "Введите название документа в который вы хотите сохранить цветокор", "", function(text)
                file.Write("academy_mapentityremover_configs/" .. game.GetMap() .. "/" .. text .. ".txt", util.TableToJSON(SelectedStored))
            end, nil, "Сохранить", "Отменить")
        end):SetIcon("icon16/add.png")

        local Child, Parent = Menu:AddSubMenu("Загрузить список")
        Parent:SetIcon("icon16/arrow_down.png")

        local files = file.Find("academy_mapentityremover_configs/" .. game.GetMap() .. "/*", "DATA")
        for k, v in ipairs(files) do
            Child:AddOption(v, function()
                local data = util.JSONToTable(file.Read("academy_mapentityremover_configs/" .. game.GetMap() .. "/" .. v, "DATA"))

                SelectedStored = data
                updateAppList()
            end)
        end

        Menu:Open()
    end
    CPanel:AddPanel(saveButton)

    local MapCreationCheckbox = vgui.Create("DCheckBoxLabel")
    MapCreationCheckbox:SetText("Отображать объекты которые можно удалить")
    MapCreationCheckbox:SetConVar(l .. "drawmapcreationstored")
    MapCreationCheckbox:SetValue(GetConVar(l .. "drawmapcreationstored"):GetBool())
    MapCreationCheckbox:SetTextColor(Color(0, 0, 0))
    CPanel:AddPanel(MapCreationCheckbox)

    local SelectedCheckbox = vgui.Create("DCheckBoxLabel")
    SelectedCheckbox:SetText("Отображать выбранные объекты")
    SelectedCheckbox:SetConVar(l .. "drawselectedstored")
    SelectedCheckbox:SetValue(GetConVar(l .. "drawselectedstored"):GetBool())
    SelectedCheckbox:SetTextColor(Color(0, 0, 0))
    CPanel:AddPanel(SelectedCheckbox)

    local ClearButton = vgui.Create("DButton")
    ClearButton:SetText("Очистить список выбранных объектов")
    ClearButton.DoClick = function()
        SelectedStored = {}

        updateAppList()
    end
    CPanel:AddPanel(ClearButton)

    AppList = vgui.Create("DListView")
    AppList:SetTall(500)
    AppList:SetMultiSelect(false)
    AppList:AddColumn("Объект")
    AppList:AddColumn("ID Объекта")
    AppList:AddColumn("ID Создания")
    AppList.OnRowSelected = function(this, index, pnl)
        local Menu = DermaMenu()
        Menu:AddOption("Удалить", function()
            local idx = pnl:GetColumnText(2)
            SelectedStored[idx] = nil

            updateAppList()
        end):SetIcon("icon16/delete.png")

        Menu:Open()
    end
    CPanel:AddPanel(AppList)
    updateAppList()

    local AddButton = vgui.Create("DButton")
    AddButton:SetText("Добавить объект по ID")
    AddButton.DoClick = function()
        Derma_StringRequest("Добавить объект в список", "Введите номер объекта который вы хотите добавить в список", "", function(text)
            netstream.Start("MapEntityRemover:Add", text)
        end, nil, "Сохранить", "Отменить")
    end
    CPanel:AddPanel(AddButton)

    local UpdateButton = vgui.Create("DButton")
    UpdateButton:SetText("Обновить список объектов на карте")
    UpdateButton.DoClick = function()
        MapCreationStored = {}
        netstream.Start("MapEntityRemover:Get")

        timer.Simple(0.5, function()
            updateAppList()
        end)
    end
    CPanel:AddPanel(UpdateButton)

    local RemoverButton = vgui.Create("DButton")
    RemoverButton:SetText("Удалить выбранные объекты")
    RemoverButton.DoClick = function()
        local data = {}
        for k, v in pairs(SelectedStored) do
            data[#data + 1] = v
        end

        netstream.Start("MapEntityRemover:Remove", data)

        timer.Simple(0.5, function()
            updateAppList()
        end)
    end
    CPanel:AddPanel(RemoverButton)
end

local function get(id, eyePos, checkDist)
    local entity = Entity(id)
    if !IsValid(entity) then return end

    local pos = entity:GetPos()
    local point = pos + entity:OBBCenter()

    if checkDist then
        local dist = point:DistToSqr(eyePos)
        if dist > 3000000 then return end
    end

    local data2D = point:ToScreen()
    if !data2D.visible then return end

    local x, y = data2D.x, data2D.y

    local info = id .. " [" .. entity:GetClass() .. "]"
    return entity, x, y, info
end

function TOOL:DrawHUD()
    local eyePos = EyePos()

    local showMapCreation = GetConVar(l .. "drawmapcreationstored"):GetBool()
    local showSelectedStored = GetConVar(l .. "drawselectedstored"):GetBool()

    if showMapCreation then
        for k, v in pairs(MapCreationStored) do
            local isSel = SelectedStored[k]
            if showSelectedStored and isSel then continue end

            local entity, x, y, info = get(k, eyePos, true)
            if !entity then continue end

            draw.SimpleText(info, "Default", x, y, isSel and color_red or color_white, TEXT_ALIGN_CENTER)
        end
    end

    if showSelectedStored then
        for k, v in pairs(SelectedStored) do
            local entity, x, y, info = get(k, eyePos)
            if !entity then continue end

            draw.SimpleText(info, "Default", x, y, color_red, TEXT_ALIGN_CENTER)
        end
    end
end