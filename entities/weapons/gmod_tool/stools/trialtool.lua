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

if CLIENT then
    TOOL.Data = TOOL.Data or {}
    TOOL.ClientProps = TOOL.ClientProps or {}

    ---@param name string
    local function _save(name)
        Arbitrage.file.Write("trial_cfg/" .. name .. ".txt", "a")
    end

    concommand.Add("arb_save_trial_cfg", function(ply, cmd, args)
        _save(tostring(args[1]))
    end)


    function TOOL:Reload()
        if !IsFirstTimePredicted() then return false end

        LocalPlayer():ChatNotify("Добавлено место: " .. #Arbitrage.Trial.PlacesList)
        return true
    end
end

function TOOL.BuildCPanel(CPanel)
    local titleLabel = vgui.Create("DLabel")
	titleLabel:SetText("Настройка \"Классного Суда\"(CLASS TRIAL)")
    titleLabel:SetColor(color_black)
    titleLabel:SetContentAlignment(1)
    -- titleLabel:SetWrap(true)
    -- titleLabel:SetTall(30)

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
                Trigger:Load(fname)
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
		if !value then return end

	end

    CPanel:AddPanel(titleLabel)
    CPanel:AddPanel(saveButton)
    CPanel:AddPanel(placesLabel)
    CPanel:AddPanel(placesList)
end

function TOOL:DrawHUD()

end
