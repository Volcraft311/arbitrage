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


file.CreateDir("academy_doordistribution_configs")
file.CreateDir("academy_doordistribution_configs/" .. game.GetMap())

AddCSLuaFile()

TOOL.Name = "Door Distribution Tool"
TOOL.Category = "Asterion Tools"
TOOL.Information = {
    {name = "left", stage = 0},
    {name = "right", stage = 0},
    {name = "reload"}
}

TOOL.ClientConVar.drawprivatestored = 1
TOOL.ClientConVar.drawselectedstored = 1
TOOL.ClientConVar.maximumcharacters = 1

local AppList1 = nil
local AppList2 = nil
local MapCreationStored = {}
local SelectedStored = {}

local function updateAppList()
    if IsValid(AppList1) then
        AppList1:Clear()

        for k, v in pairs(SelectedStored) do
            AppList1:AddLine(tostring(Entity(k)), k, v[1], v[2])
        end
    end

    if IsValid(AppList2) then
        AppList2:Clear()

        for k, v in pairs(Arbitrage.plugin.list.doors.DoorsData) do
            AppList2:AddLine(tostring(Entity(v.idx)), k, table.Count(v.list))
        end
    end
end

if CLIENT then
    language.Add("tool.doordistributiontool.name", "Door Distribution Tool")
    language.Add("tool.doordistributiontool.desc", "Позволяет вам добавлять двери для авто-распределения")
    language.Add("tool.doordistributiontool.left", "Нажмите левую кнопку мышки чтобы добавить дверь в список")
    language.Add("tool.doordistributiontool.right", "Нажмите правую кнопку мышки чтобы удалить дверь из списка")
    language.Add("tool.doordistributiontool.reload", "Нажмите Перезарядку чтобы сбросить свойства двери")

    netstream.Hook("DoorDistribution:Receive", function(data)
        MapCreationStored = data
        updateAppList()
    end)

    netstream.Hook("DoorDistribution:Add", function(idx, creationID, maxCharacters)
        SelectedStored[idx] = {creationID, maxCharacters}
        updateAppList()
    end)

    netstream.Hook("DoorDistribution:Remove", function(idx)
        SelectedStored[idx] = nil
        updateAppList()
    end)

    netstream.Hook("DoorDistribution:Sync", function(data)
        SelectedStored = data
        updateAppList()
    end)

    netstream.Hook("DoorDistribution:Update", function()
        timer.Simple(0.5, function()
            updateAppList()
        end)
    end)
else
    local function get(client)
        local data = {}
        for k, v in ipairs(ents.GetAll()) do
            local id = v:MapCreationID()

            if id != -1 and IsValid(v) and v:IsDoor() then
                data[v:EntIndex()] = id
            end
        end

        netstream.Heavy(client, "DoorDistribution:Receive", data)
    end

    netstream.Hook("DoorDistribution:Get", function(client)
        if !client:IsAdmin() then return end

        get(client)
    end)

    netstream.Hook("DoorDistribution:Distribute", function(client, array)
        if !client:IsAdmin() then return end

        local players = {}
        for k, v in pairs(Arbitrage.players) do
            if IsPlaying(k) and !IsHost(k) then
                players[#players + 1] = v.faction
            end
        end

        local doors = Arbitrage.plugin.list.doors
        local db = doors.DoorsData
        db = doors.DoorsData or {}

        for k, v in ipairs(array) do
            local id, maxCharacters = v[1], v[2]

            local entity = ents.GetMapCreatedEntity(id)
            if !IsValid(entity) then continue end

            db[id] = db[id] or {}
            db[id].list = db[id].list or {}
            db[id].idx = entity:EntIndex()

            local list = {}
            for i = 1, maxCharacters do
                local faction = players[1]
                if !faction then break end

                list[#list + 1] = faction
                db[id].list[faction] = true

                table.remove(players, 1)
            end

            entity:SetNetVar("arb.image", list)

            entity:Fire("close")
            entity:Fire("lock")
            entity:SetNWBool("Locked", true)
            entity:SetNWBool("disableHack", true)
        end

        for k, v in pairs(db) do
            if table.Count(v.list) <= 0 then
                db[k] = nil
            end
        end

        doors.DoorsData = db
        netstream.Start(nil, "arb.DoorGetData", doors.DoorsData)
    end)

    netstream.Hook("DoorDistribution:Teleport", function(client, id)
        if !client:IsAdmin() then return end

        local entity = ents.GetMapCreatedEntity(id)
        if !IsValid(entity) then return end

        client:SetPos(entity:GetPos())
    end)

    local arrayList = {asterion_hopespeak_prerelease = {1373, 1608, 2749, 2770, 2288, 2496, 2696, 2386, 2078, 2739, 2081, 2116, 1260, 2315, 2057, 2374}}
    local function sync(client)
        local array = arrayList[game.GetMap()]
        if !array then return end

        local data = {}

        for _, v in ipairs(array) do
            local entity = ents.GetMapCreatedEntity(v)
            if !IsValid(entity) then continue end

            data[entity:EntIndex()] = {v, 1}
        end

        netstream.Start(client, "DoorDistribution:Sync", data)
    end

    hook.Add("PlayerInitialSpawnForRealz", "DoorDistribution:Hook", function(client)
        sync(client)
        get(client)
    end)

    hook.Add("PostCleanupMap", "DoorDistribution:Hook", function()
        sync(nil)
        get(nil)
    end)
end

local l = "doordistributiontool_"
function TOOL:LeftClick()
    if CLIENT then return true end

    local client = self:GetOwner()
    local trace = client:GetEyeTrace()
    local entity = trace.Entity
    if !IsValid(entity) then return client:ChatNotify("Не валидное Entity!") end

    local id = entity:MapCreationID()
    if id == -1 then return client:ChatNotify("Данный объект не создан миром!") end

    if !entity:IsDoor() then return client:ChatNotify("Данный объект не является дверью!") end

    local convar = tonumber(client:GetTool():GetClientInfo("maximumcharacters")) or 1
    netstream.Start(client, "DoorDistribution:Add", entity:EntIndex(), id, convar)
end

function TOOL:RightClick()
    if CLIENT then return true end

    local client = self:GetOwner()
    local trace = client:GetEyeTrace()
    local entity = trace.Entity
    if !IsValid(entity) then return client:ChatNotify("Не валидное Entity!") end

    netstream.Start(client, "DoorDistribution:Remove", entity:EntIndex())
end

function TOOL:Reload()
    if CLIENT then return true end

    local client = self:GetOwner()
    local trace = client:GetEyeTrace()
    local entity = trace.Entity
    if !IsValid(entity) then return client:ChatNotify("Не валидное Entity!") end

    netstream.Start(client, "DoorDistribution:Update")

    entity:SetNetVar("arb.image", nil)
    entity:Fire("unlock")
    entity:SetNWBool("Locked", false)
    entity:SetNWBool("disableHack", false)

    local doors = Arbitrage.plugin.list.doors
    local id = entity:MapCreationID()
    local db = doors.DoorsData or {}
    if db[id] then
        db[id] = nil

        netstream.Start(nil, "arb.DoorGetData", doors.DoorsData)
    end
end

function TOOL.BuildCPanel(CPanel)
    CPanel:AddControl("Header",{
        Description = "Данный инструмент поможет создавать конфигурации с выбранными дверьми и сразу распределять их между игроками."
    })

    local saveButton = vgui.Create("DButton")
    saveButton:SetText("Конфигурации")
    saveButton:Dock(BOTTOM)
    saveButton.DoClick = function()
        local Menu = DermaMenu()
        Menu:AddOption("Сохранить список", function()
            Derma_StringRequest("Сохранить цветокор", "Введите название документа в который вы хотите сохранить цветокор", "", function(text)
                local data = {}
                for k, v in pairs(SelectedStored) do
                    data[#data + 1] = v
                end

                file.Write("academy_doordistribution_configs/" .. game.GetMap() .. "/" .. text .. ".txt", util.TableToJSON(data))
            end, nil, "Сохранить", "Отменить")
        end):SetIcon("icon16/add.png")

        local Child, Parent = Menu:AddSubMenu("Загрузить список")
        Parent:SetIcon("icon16/arrow_down.png")

        local files = file.Find("academy_doordistribution_configs/" .. game.GetMap() .. "/*", "DATA")
        for k, v in ipairs(files) do
            Child:AddOption(v, function()
                SelectedStored = {}
                updateAppList()

                MapCreationStored = {}
                netstream.Start("DoorDistribution:Get")

                timer.Simple(0.5, function()
                    local info = {}
                    for k2, v2 in pairs(MapCreationStored) do
                        info[v2] = k2
                    end

                    local data = {}
                    for _, v2 in ipairs(util.JSONToTable(file.Read("academy_doordistribution_configs/" .. game.GetMap() .. "/" .. v, "DATA"))) do
                        local idx = info[v2[1]]
                        if !idx then continue end

                        data[idx] = v2
                    end

                    SelectedStored = data
                    updateAppList()
                end)
            end)
        end

        Menu:Open()
    end
    CPanel:AddPanel(saveButton)

    local PrivateCheckbox = vgui.Create("DCheckBoxLabel")
    PrivateCheckbox:SetText("Отображать настроенные двери")
    PrivateCheckbox:SetConVar(l .. "drawprivatestored")
    PrivateCheckbox:SetValue(GetConVar(l .. "drawprivatestored"):GetBool())
    PrivateCheckbox:SetTextColor(Color(0, 0, 0))
    CPanel:AddPanel(PrivateCheckbox)

    local SelectedCheckbox = vgui.Create("DCheckBoxLabel")
    SelectedCheckbox:SetText("Отображать выбранные двери")
    SelectedCheckbox:SetConVar(l .. "drawselectedstored")
    SelectedCheckbox:SetValue(GetConVar(l .. "drawselectedstored"):GetBool())
    SelectedCheckbox:SetTextColor(Color(0, 0, 0))
    CPanel:AddPanel(SelectedCheckbox)

    local MaxSlider = vgui.Create("DNumSlider")
    MaxSlider:SetText("Максимум персонажей")
    MaxSlider:SetDark(true)
    MaxSlider:SetMin(1)
    MaxSlider:SetMax(30)
    MaxSlider:SetDecimals(0)
    MaxSlider:SetConVar(l .. "maximumcharacters")
    CPanel:AddPanel(MaxSlider)

    local ClearButton = vgui.Create("DButton")
    ClearButton:SetText("Очистить список выбранных объектов")
    ClearButton.DoClick = function()
        SelectedStored = {}

        updateAppList()
    end
    CPanel:AddPanel(ClearButton)

    local AppList2Label = vgui.Create("DLabel")
    AppList2Label:SetText("Список настроенных дверей:")
    AppList2Label:SetDark(true)
    CPanel:AddPanel(AppList2Label)

    AppList2 = vgui.Create("DListView")
    AppList2:SetTall(150)
    AppList2:SetMultiSelect(false)
    AppList2:AddColumn("Объект")
    AppList2:AddColumn("ID Создания")
    AppList2:AddColumn("Записано игроков")
    AppList2.OnRowSelected = function(this, index, pnl)
        local Menu = DermaMenu()
        Menu:AddOption("Телепортироваться", function()
            local idx = pnl:GetColumnText(2)
            netstream.Start("DoorDistribution:Teleport", idx)

            updateAppList()
        end):SetIcon("icon16/control_play_blue.png")

        Menu:Open()
    end
    CPanel:AddPanel(AppList2)

    local AppList1Label = vgui.Create("DLabel")
    AppList1Label:SetText("Список выбранных дверей:")
    AppList1Label:SetDark(true)
    CPanel:AddPanel(AppList1Label)

    AppList1 = vgui.Create("DListView")
    AppList1:SetTall(250)
    AppList1:SetMultiSelect(false)
    AppList1:AddColumn("Объект")
    AppList1:AddColumn("ID Объекта")
    AppList1:AddColumn("ID Создания")
    AppList1:AddColumn("Максимум мест")
    AppList1.OnRowSelected = function(this, index, pnl)
        local Menu = DermaMenu()
        Menu:AddOption("Удалить", function()
            local idx = pnl:GetColumnText(2)
            SelectedStored[idx] = nil

            updateAppList()
        end):SetIcon("icon16/delete.png")

        Menu:Open()
    end
    CPanel:AddPanel(AppList1)
    updateAppList()

    local UpdateButton = vgui.Create("DButton")
    UpdateButton:SetText("Обновить список (если не обновился)")
    UpdateButton.DoClick = function()
        updateAppList()
    end
    CPanel:AddPanel(UpdateButton)

    local DistributeButton = vgui.Create("DButton")
    DistributeButton:SetText("Распределить двери")
    DistributeButton.DoClick = function()
        local data = {}
        for k, v in pairs(SelectedStored) do
            data[#data + 1] = v
        end

        netstream.Start("DoorDistribution:Distribute", data)

        timer.Simple(0.5, function()
            updateAppList()
        end)
    end
    CPanel:AddPanel(DistributeButton)
end

-- :)
if CLIENT then
    local isAllowDraw = false
    timer.Create("DoorDistribution:Update", 2, 0, function()
        isAllowDraw = false
    end)

    function TOOL:DrawHUD()
        isAllowDraw = true

        local showSelectedStored = GetConVar(l .. "drawselectedstored"):GetBool()

        if showSelectedStored then
            for k, v in pairs(SelectedStored) do
                local entity = Entity(k)
                if !IsValid(entity) then continue end

                local pos = entity:GetPos()
                local point = pos + entity:OBBCenter()

                local data2D = point:ToScreen()
                if !data2D.visible then continue end

                local x, y = data2D.x, data2D.y

                local info = k .. " [" .. entity:GetClass() .. "] (" .. v[2] .. ")"
                draw.SimpleText(info, "Default", x, y, color_green, TEXT_ALIGN_CENTER)
            end
        end
    end

    hook.Add("PostDrawOpaqueRenderables", "DoorDistribution:Hook", function()
        if !isAllowDraw then return end

        local showPrivateCreation = GetConVar(l .. "drawprivatestored"):GetBool()
        local showSelectedStored = GetConVar(l .. "drawselectedstored"):GetBool()

        if showPrivateCreation then
            for k, v in pairs(Arbitrage.plugin.list.doors.DoorsData or {}) do
                local entity = Entity(v.idx)
                if !IsValid(entity) then continue end

                local isSel = SelectedStored[v.idx]
                if showSelectedStored and isSel then continue end

                local mins, maxs = entity:GetRenderBounds()
                render.DrawWireframeBox(entity:GetPos(), entity:GetAngles(), mins, maxs, color_blue)
            end
        end

        if showSelectedStored then
            for k, v in pairs(SelectedStored) do
                local entity = Entity(k)
                if !IsValid(entity) then continue end

                local mins, maxs = entity:GetRenderBounds()
                render.DrawWireframeBox(entity:GetPos(), entity:GetAngles(), mins, maxs, color_green)
            end
        end
    end)
end