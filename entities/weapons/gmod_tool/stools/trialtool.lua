--[[
    Made by Volcraft311 for Max Pump
]] --

--- ЛКМ - Двигать последнюю
--- R - Создать новый


AddCSLuaFile()

TOOL.Name = "Trial Tool"
TOOL.Category = "Pump Tools"
TOOL.Information = {
    {
        name = "left",
        stage = 0
    },
    {
        name = "right",
        stage = 0
    },
    {
        name = "reload",
        stage = 0
    }
}

local Trial = Arbitrage.Trial

if CLIENT then
    do -- Конфиги
        ---@param name string
        local function _save(name)
            Arbitrage.file.Write("trial_cfg/" .. name .. ".txt", util.TableToJSON({ Places = Trial.GetPlaces() }))
            LocalPlayer():ChatNotify("Конфиг " .. name .. ".txt сохранён!")
        end

        local function _load(name)
            local data = Arbitrage.file.Read("trial_cfg/" .. name)
            if ! data then return LocalPlayer():ChatNotify("Конфиг " .. name .. ". не найден!") end
            netstream.Start("Arbitrage_Trial_LoadConfig", util.JSONToTable(data))
        end

        concommand.Add("arb_save_trial_cfg", function(ply, cmd, args)
            _save(tostring(args[1]))
        end)

        concommand.Add("arb_load_trial_cfg", function(ply, cmd, args)
            _load(tostring(args[1]))
        end)
    end

    function TOOL:Holster()
        Trial.HidePlacesModels()
    end

    function TOOL:Deploy()
        hook.Run("Arbitrage_Trial_Updated")
    end

    function TOOL:LeftClick(tr)
        if ! IsFirstTimePredicted() then return false end
        local placeID = Trial.SelectedPlaceID
        if placeID <= 0 then return end

        local dir = (self:GetOwner():GetPos() - tr.HitPos):Angle()
        dir.p = 0
        dir.r = 0
        local pos = Vector(tr.HitPos.x, tr.HitPos.y, LocalPlayer():EyePos().z)
        netstream.Start("Arbitrage_Trial_SetPlace", placeID, pos, dir)
        return LocalPlayer():IsAdmin()
    end

    function TOOL:RightClick()
        if ! IsFirstTimePredicted() then return false end

        netstream.Start("Arbitrage_Trial_SetCamera", Trial.SelectedPlaceID, LocalPlayer():EyePos(),
            LocalPlayer():EyeAngles())
        return LocalPlayer():IsAdmin()
    end

    -- local function drawing(client, mat)
    -- local spriteSize = 1.5 * GetNetVar("arb.SpritesSize", 1)
    -- local spriteW = 45 * spriteSize
    -- local spriteH = 75 * spriteSize
    -- local spriteShift = spriteW * 0.5

    --     do
    --         local ang = Angle(0, client:EyeAngles()[2] + 90, 90)
    --         local pos = client:GetPos() + Vector(0, 0, spriteH) + client:EyeAngles():Right() * spriteShift

    --         cam.Start3D2D(pos, ang, 1)
    --         surface.SetDrawColor(255, 255, 255)
    --         surface.SetMaterial(mat)
    --         surface.DrawTexturedRect(0, 0, spriteW, spriteH)
    --         cam.End3D2D()
    --     end

    --     do
    --         local ang = Angle(0, client:EyeAngles()[2] - 90, 90)
    --         local pos = client:GetPos() + Vector(0, 0, spriteH) + client:EyeAngles():Right() * -spriteShift

    --         cam.Start3D2D(pos, ang, 1)
    --         surface.SetDrawColor(0, 0, 0)
    --         surface.SetMaterial(mat)
    --         surface.DrawTexturedRectUV(0, 0, spriteW, spriteH, 1, 0, 0, 1)
    --         cam.End3D2D()
    --     end
    -- end

    local function draw_3d_sprite()
        local place = Trial.GetPlaces()[Trial.SelectedPlaceID]
        local character = LocalPlayer():GetCharacter()
        if ! character then return end
        local uniqueID = character:GetUniqueID()
        local emoji = Character.emoji:GetByUniqueID(uniqueID)
        if ! emoji then return end
        local mat = Material(emoji:GetByIndex(1))
        -- print(mat)
        local spriteSize = 1.5 * GetNetVar("arb.SpritesSize", 1)
        local spriteW = 45 * spriteSize
        local spriteH = 75 * spriteSize
        local spriteShift = spriteW * 0.5

        local pos = place.pos
        local ang = place.ang + Angle(0, 90, 90)

        cam.Start3D2D(pos, ang, 1)
            surface.SetMaterial(mat)
            surface.SetDrawColor(255, 255, 255, 200)
            surface.DrawTexturedRect(-spriteShift, -spriteH/2, spriteW, spriteH)
        cam.End3D2D()
    end


    hook("PostDrawTranslucentRenderables", function()
        draw_3d_sprite()
    end)

    local vector_offset = Vector(0, 0, 10)
    local color_bg = Color(0, 0, 0, 250)
    local color_bg_unselected = Color(0, 0, 0, 50)
    local color_text = Color(200, 200, 200, 255)

    function TOOL:DrawHUD()
        local places = Trial.GetPlaces()
        for i, v in ipairs(places) do
            local textPos = v.pos + vector_offset
            local data2D = textPos:ToScreen()
            local color = i == Trial.SelectedPlaceID and color_white or color_text
            if ! data2D.visible then continue end

            draw.RoundedBox(8, data2D.x - 50, data2D.y, 100, 30, i == Trial.SelectedPlaceID and color_bg or color_bg_unselected)
            draw.SimpleText("М :" .. i, "arb.Font_FuturaPTBook_10", data2D.x, data2D.y, color, TEXT_ALIGN_CENTER)
        end
    end


    function TOOL.BuildCPanel(CPanel)
        local titleLabel = vgui.Create("DLabel")
        titleLabel:SetText("Настройка \"Классного Суда\"(CLASS TRIAL)")
        titleLabel:SetColor(color_black)
        titleLabel:SetContentAlignment(1)

        local saveButton = vgui.Create("DButton")
        saveButton:SetText("Сохранения")
        saveButton:Dock(BOTTOM)
        saveButton.DoClick = function()
            local Menu = DermaMenu()

            Menu:AddOption("Сохранить в конфиг", function()
                Derma_StringRequest("Сохранить конфиг", "Название конфига?", tostring(os.date("%c")), function(text)
                    RunConsoleCommand("arb_save_trial_cfg", text)
                end, nil, "Сохранить", "Отменить")
            end):SetIcon("icon16/add.png")

            local SubMenu, SubMenuOption = Menu:AddSubMenu("Загрузить список")
            local files = Arbitrage.file.Find("trial_cfg/*")
            for _, fname in ipairs(files) do
                SubMenu:AddOption(fname, function()
                    RunConsoleCommand("arb_load_trial_cfg", fname)
                end)
            end
            SubMenuOption:SetIcon("icon16/arrow_down.png")

            Menu:Open()
        end

        local placesLabel = vgui.Create("DLabel")
        placesLabel:SetText("Список Мест")
        placesLabel:SetColor(color_black)
        placesLabel:SetContentAlignment(1)

        local placesList = vgui.Create("DListView")
        placesList:AddColumn("Номер")
        placesList:SetTall(130)
        placesList.OnRowSelected = function(panel, index, row)
            local value = tonumber(row:GetValue(1))
            if ! value then return end
            Trial.SelectedPlaceID = value
        end

        hook("Arbitrage_Trial_Updated", function()
            placesList:Clear()
            local places = Trial.GetPlaces()
            for i, _ in ipairs(places) do
                local a = placesList:AddLine(tostring(i))
                if i == Trial.SelectedPlaceID then
                    a:SetSelected(true)
                end
            end
        end)

        CPanel:AddPanel(titleLabel)
        CPanel:AddPanel(saveButton)
        CPanel:AddPanel(placesLabel)
        CPanel:AddPanel(placesList)

        hook.Run("Arbitrage_Trial_Updated")
    end

    hook("Arbitrage_Trial_Updated", "TrialTool_DrawModels", function()
        Trial.ShowPlacesModels()
    end)


    netstream.Hook("Arbitrage_Trial_Updated", function(bResetSelection)
        hook.Run("Arbitrage_Trial_Updated")
        if bResetSelection then
            Trial.SelectedPlaceID = #Trial.GetPlaces()
        end
    end)
else
    ---@param tr TraceResult
    function TOOL:Reload(tr)
        if ! IsFirstTimePredicted() then return false end
        local dir = (self:GetOwner():GetPos() - tr.HitPos):Angle()
        dir.p = 0
        dir.r = 0
        local placeNumber = Trial.AddPlace({ pos = tr.HitPos, ang = dir })
        netstream.Start(self:GetOwner(), "Arbitrage_Trial_Updated", true)

        self:GetOwner():ChatNotify("Добавлено место: " .. placeNumber)
        return true
    end

    netstream.Hook("Arbitrage_Trial_LoadConfig", function(client, data)
        if ! IsValid(client) and ! client:IsAdmin() then return end
        Trial.SetPlaces(data.Places or {})
        netstream.Start(client, "Arbitrage_Trial_Updated")
    end)

    netstream.Hook("Arbitrage_Trial_SetPlace", function(client, id, pos, ang)
        if ! IsValid(client) and ! client:IsAdmin() then return end
        Trial.SetPlace(id, { pos = pos, ang = ang })
        netstream.Start(client, "Arbitrage_Trial_Updated")
    end)

    netstream.Hook("Arbitrage_Trial_SetCamera", function(client, id, pos, ang)
        if ! IsValid(client) and ! client:IsAdmin() then return end
        Trial.SetCamera(id, { pos = pos, ang = ang })
        netstream.Start(client, "Arbitrage_Trial_Updated")
        client:ChatNotify("Камера для места " .. id .. " установлена!")
    end)
end


