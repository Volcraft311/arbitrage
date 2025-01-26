--[[
        © AsterionStaff 2025.
        This script was created from the developers of the AsterionTeam.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/CtfS8r5W3M
        
        developer(s):
            Volcraft - https://steamcommunity.com/id/boobsgunner
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]
--
AddCSLuaFile()

local file_name = {
    tool = "academy_triggertool",
    config = "academy_triggertool_configs",
    map = "academy_triggertool_configs/" .. game.GetMap()
}

file.CreateDir(file_name.config)
file.CreateDir(file_name.map)

TOOL.Name = "Trigger Tool"
TOOL.Category = "Asterion Tools"
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

local color_text = Color(255, 255, 255)
local color_text_background = Color(0, 0, 0, 100)
local color_first_point = Color(0, 0, 255, 150)
local color_second_point = Color(0, 255, 0, 150)

local ActionType = ACTION_ENTER

if CLIENT then
    language.Add("tool.triggertool.name", "Trigger Tool")
    language.Add("tool.triggertool.desc", "Позволяет управлять триггерами")
    language.Add("tool.triggertool.left", "Устанавливает позицию первой точки.")
    language.Add("tool.triggertool.right", "Устанавливает позицию второй точки.")
    language.Add("tool.triggertool.reload", "Создаёт новый триггер.")

    function TOOL:Holster()
        Trigger.drawTriggers = false
    end

    function TOOL:Deploy()
        Trigger.drawTriggers = true
    end
end

function TOOL:LeftClick(trace)
    if !IsFirstTimePredicted() then return false end

    if CLIENT then
        local id = Trigger.selectedID
        local vector = trace.HitPos

        local trigger = Trigger:GetByID(id)
        if !trigger then return false end

        netstream.Start("Trigger:SetPos", id, 1, vector)

        Trigger:UpdateTriggerList()
    end

    return true
end

function TOOL:RightClick(trace)
    if !IsFirstTimePredicted() then return false end

    if CLIENT then
        local id = Trigger.selectedID
        local vector = trace.HitPos

        local trigger = Trigger:GetByID(id)
        if !trigger then return false end

        netstream.Start("Trigger:SetPos", id, 2, vector)

        Trigger:UpdateTriggerList()
    end

    return true
end

function TOOL:Reload(trace)
    if !IsFirstTimePredicted() then return false end

    if SERVER then
        local client = self:GetOwner()

        local trigger = Trigger:Create({
            points = {trace.HitPos, trace.HitPos + Vector(5, 5, 5)}
        })

        trigger:Sync()
        trigger:SelectTool(client)

        Arbitrage.adminnotify:SendNotify("triggercreated", client:FullName(), trigger.name)
    end

    return true
end

function TOOL:DrawHUD()

    for id, trigger in pairs(Trigger.instances) do
        local point = (trigger.points[1] + trigger.points[2]) / 2

        local data2D = point:ToScreen()
        if !data2D.visible then continue end


        draw.RoundedBox(1, data2D.x - 20, data2D.y - 20, 40, 40, color_text_background)
        draw.SimpleText(trigger.name .. "(" .. id .. ")", "Trebuchet24", data2D.x, data2D.y, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local trigger = Trigger:GetSelected()
    if trigger then
        local point1 = trigger.points[1]:ToScreen()
        if point1.visible then
            draw.RoundedBox(1, point1.x - 10, point1.y - 10, 20, 20, color_first_point)
            draw.SimpleText("1", "Trebuchet24", point1.x, point1.y, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        local point2 = trigger.points[2]:ToScreen()
        if point2.visible then
            draw.RoundedBox(1, point2.x - 10, point2.y - 10, 20, 20, color_second_point)
            draw.SimpleText("2", "Trebuchet24", point2.x, point2.y, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    -- debug
    --[[
    for k, v in ipairs(player.GetAll()) do
        local _, max = v:GetHull()

        local point = v:GetPos()
        point.z = point.z + max.z / 2

        local data2D = point:ToScreen()
        if !data2D.visible then continue end
        draw.RoundedBox(1, data2D.x - 10, data2D.y - 10, 20, 20, color_first_point)
    end
    ]]--
end

local trigger_actions = {
    [1] = {
        type = ACTION_ENTER,
        desc = "Событие при входе в триггер"
    },
    [2] = {
        type = ACTION_EXIT,
        desc = "Событие при выходе из триггера"
    },
    [3] = {
        type = ACTION_INTERACT,
        desc = "Событие при нажатии на триггер"
    }
}

function TOOL.BuildCPanel(CPanel)
    CPanel:AddControl("Header", {
        Description = "Данный инструмент позволяет управлять триггерами."
    })

    local saveButton = vgui.Create("DButton")
    saveButton:SetText("Сохранения")
    saveButton:Dock(BOTTOM)
    saveButton.DoClick = function()
        local Menu = DermaMenu()
        Menu:AddOption("Сохранить список", function()
            Derma_StringRequest("Сохранить Триггеры", "Введите название документа в который вы хотите сохранить триггеры", "", function(text)
                local data = {}
                for k, v in pairs(Trigger.instances) do
                    data[#data + 1] = {v.name, v.points, v.ActionList}
                end

                file.Write(file_name.map .. "/" .. text .. ".txt", util.TableToJSON(data))
            end, nil, "Сохранить", "Отменить")
        end):SetIcon("icon16/add.png")

        local Child, Parent = Menu:AddSubMenu("Загрузить список")
        Parent:SetIcon("icon16/arrow_down.png")
        local files = file.Find(file_name.map .. "/*", "DATA")
        for k, v in ipairs(files) do
            Child:AddOption(v, function()
                local data = util.JSONToTable(file.Read(file_name.map .. "/" .. v, "DATA"))

                netstream.Heavy("Trigger:LoadConfig", data)
            end)
        end

        Menu:Open()
    end
    CPanel:AddPanel(saveButton)

    local triggerLabel = vgui.Create("DLabel")
    triggerLabel:SetText("Список Триггеров")
    triggerLabel:Dock(TOP)
    triggerLabel:SetTextColor(color_black)
    CPanel:AddPanel(triggerLabel)

    local TriggerList = vgui.Create("DListView")
    TriggerList:Dock(TOP)
    TriggerList:AddColumn("Название")
    TriggerList:AddColumn("ID")
    TriggerList:SetTall(130)
    TriggerList.OnRowSelected = function(panel, index, row)
        local value = tonumber(row:GetValue(2))
        if !value then return end

        Trigger.selectedID = value
        Trigger:UpdateActionLists()
    end
    -- Меню триггеров
    TriggerList.OnRowRightClick = function(panel, index, row)
        local thisTrigger = Trigger:GetSelected()
        local isOneShot = thisTrigger:IsOneShot()

        local Menu = DermaMenu()

        Menu:AddOption("Изменить имя", function()
            local str_arg = vgui.Create("DFrame")
            str_arg:SetSize(500, 100)
            str_arg:Center()
            str_arg:MakePopup()
            str_arg:SetTitle("Указать имя триггера")

            local str_button = vgui.Create("DButton", str_arg)
            str_button:SetText("Применить изменения")
            str_button:Dock(BOTTOM)
            str_button:SetWidth(20)

            local label = str_arg:Add("DTextEntry")
            label:Dock(TOP)
            label:SetText(thisTrigger.name)
            str_button.DoClick = function()
                thisTrigger.name = label:GetText()

                netstream.Start("Trigger:ChangeName", thisTrigger.id, thisTrigger.name)

                str_arg:Remove()
            end
        end):SetIcon("icon16/page_edit.png")


        local bIsActive = thisTrigger:GetActive()
        Menu:AddOption(bIsActive and "Включён" or "Выключен", function()
            netstream.Start("Trigger:SetActive", Trigger.selectedID)
        end):SetIcon(bIsActive and "icon16/tick.png" or "icon16/cross.png")


        local _opt = Menu:AddOption(isOneShot and "Одноразовый" or "Многоразовый", function()
            netstream.Start("Trigger:SetOneShot", Trigger.selectedID, !isOneShot)
        end):SetIcon(isOneShot and "icon16/status_online.png" or "icon16/arrow_refresh_small.png")

        Menu:AddSpacer()

        local EnterAct, EnterActOption = Menu:AddSubMenu("Действие на вход")
        for k, v in pairs(Trigger.ActionTypes) do
            local _opt = EnterAct:AddOption(v.name, function()
                netstream.Start("Trigger:AddAction", Trigger.selectedID, {
                    type = ACTION_ENTER,
                    actionid = k,
                    args = v.default,
                    name = "Действие"
                })
            end)

            _opt:SetIcon(v.icon or "icon16/bug.png")
        end
        EnterActOption:SetIcon("icon16/script_code.png")

        local IntAct, IntActOption = Menu:AddSubMenu("Действие на нажатие")
        for k, v in pairs(Trigger.ActionTypes) do
            local _opt = IntAct:AddOption(v.name, function()
                netstream.Start("Trigger:AddAction", Trigger.selectedID, {
                    type = ACTION_INTERACT,
                    actionid = k,
                    args = v.default,
                    name = "Действие"
                })
            end)

            _opt:SetIcon(v.icon or "icon16/bug.png")
        end
        IntActOption:SetIcon("icon16/script_go.png")

        local ExitAct, ExitActOption = Menu:AddSubMenu("Действие на выход")
        for k, v in pairs(Trigger.ActionTypes) do
            local _opt = ExitAct:AddOption(v.name, function()
                netstream.Start("Trigger:AddAction", Trigger.selectedID, {
                    type = ACTION_EXIT,
                    actionid = k,
                    args = v.default,
                    name = "Действие"
                })
            end)

            _opt:SetIcon(v.icon or "icon16/bug.png")
        end
        ExitActOption:SetIcon("icon16/script_code_red.png")



        Menu:AddSpacer()

        local pos1ToPlayer = Menu:AddOption("Первую точку к игроку", function()
            netstream.Start("Trigger:SetPos", Trigger.selectedID, 1, LocalPlayer():GetPos())
        end)

        pos1ToPlayer:SetIcon("icon16/arrow_in.png")

        local pos2ToPlayer = Menu:AddOption("Вторую точку к игроку", function()
            netstream.Start("Trigger:SetPos", Trigger.selectedID, 2, LocalPlayer():GetPos())
        end)

        pos2ToPlayer:SetIcon("icon16/arrow_in.png")

        if isOneShot then
            Menu:AddSpacer()

            Menu:AddOption("Перезарядить", function()
                netstream.Start("Trigger:ReloadOneShot", Trigger.selectedID)
            end):SetIcon("icon16/arrow_refresh_small.png")

        end

        Menu:AddSpacer()

        Menu:AddOption("Удалить триггер", function()
            netstream.Start("Trigger:Remove", Trigger.selectedID)
        end):SetIcon("icon16/script_delete.png")

        Menu:Open()
    end
    Trigger.TriggerList = TriggerList
    Trigger:UpdateTriggerList()
    CPanel:AddPanel(TriggerList)

    for k, v in ipairs(trigger_actions) do
        local text = vgui.Create("DLabel")
        text:SetText(v.desc)
        text:Dock(TOP)
        text:SetTextColor(color_black)
        CPanel:AddPanel(text)

        local _list = vgui.Create("DListView")
        _list:Dock(TOP)
        _list:AddColumn("Действия")
        _list:AddColumn("Имя")
        _list:SetTall(200)
        _list.act_type = v.type
        _list.OnRowRightClick = function(panel, index, row)
            ActionType = panel.act_type

            -- Почему это сделано через if/else? Я позволю себе 30 секунд или одну минуту, маленькую историческую справку.
            -- Так вот. Для создания нового действия, ты указываешь, какие типы данных он принимает, 'args = {"string","string","number"}'
            -- И основываясь на опыте Селентера, когда я пытался изъебнуться, лишь бы впихнуть изменение цвета персонажа в текстовое окошко меню кастомных персонажей,
            -- Я и решил, что ГОРАЗДО легче продумать это заранее. А гороздить ебейшую кучу РАЗНЫХ интерфейсов - пустая трата времени.
            -- Потому тут и сделано подобное развлетвление, чтобы в случае, если тебе нужен прям особый интерфейс, ты без лишних проблем вписал elseif
            -- Можно было сделать как-то лучше? - Не знаю. Оно работает нормально - да. Потому, если тебя сюда привела подсветка синтаксиса Visual Studio Code, можешь слать его НАХУЙ

            local thisTrigger = Trigger:GetSelected()
            if !thisTrigger then return end

            local thisAction = Trigger:ActionByID(row.thisActionID)

            local Menu = DermaMenu()
            local SubMenu, SubMenuOption = Menu:AddSubMenu("Изменить Аргументы")
            local trigger_args = thisTrigger.ActionList[ActionType][index].args

            Menu:AddOption("Изменить имя", function()
                local str_arg = vgui.Create("DFrame")
                str_arg:SetSize(500, 100)
                str_arg:Center()
                str_arg:MakePopup()
                str_arg:SetTitle("Указать имя")

                local str_button = vgui.Create("DButton", str_arg)
                str_button:SetText("Применить изменения")
                str_button:Dock(BOTTOM)
                str_button:SetWidth(20)

                local label = str_arg:Add("DTextEntry")
                label:Dock(TOP)
                label:SetText(row.thisActionName)
                str_button.DoClick = function()
                    row.thisActionName = label:GetText()

                    netstream.Start("Trigger:EditAction", Trigger.selectedID, {
                        type = ActionType,
                        number = index,
                        args = trigger_args,
                        name = row.thisActionName
                    })

                    str_arg:Remove()
                end
            end):SetIcon("icon16/page_edit.png") 


            for k2, v2 in pairs(thisAction.args) do

                local arg = SubMenu:AddOption(thisAction.args_desc[k2] or "missing", function()
                    local str_arg = vgui.Create("DFrame")
                    str_arg:SetSize(500, 100)
                    str_arg:Center()
                    str_arg:MakePopup()
                    str_arg:SetTitle("Указать Аргумент " .. k2)

                    local str_button = vgui.Create("DButton", str_arg)
                    str_button:SetText("Применить изменения")
                    str_button:Dock(BOTTOM)
                    str_button:SetWidth(20)

                    if v2 == "string" then
                        local label = str_arg:Add("DTextEntry")
                        label:Dock(TOP)
                        label:SetText(trigger_args[k2])

                        str_button.DoClick = function()
                            trigger_args[k2] = label:GetText()

                            netstream.Start("Trigger:EditAction", Trigger.selectedID, {
                                type = ActionType,
                                number = index,
                                args = trigger_args,
                                name = row.thisActionName
                            })

                            str_arg:Remove()
                        end
                    elseif v2 == "number" then
                        local label = str_arg:Add("DTextEntry")
                        label:Dock(TOP)
                        label:SetText(tostring(trigger_args[k2]))

                        str_button.DoClick = function()
                            trigger_args[k2] = tonumber(label:GetText())

                            netstream.Start("Trigger:EditAction", Trigger.selectedID, {
                                type = ActionType,
                                number = index,
                                args = trigger_args,
                                name = row.thisActionName
                            })

                            str_arg:Remove()
                        end
                    elseif v2 == "bool" then
                        trigger_args[k2] = tobool(!trigger_args[k2])

                        netstream.Start("Trigger:EditAction", Trigger.selectedID, {
                            type = ActionType,
                            number = index,
                            args = trigger_args,
                            name = row.thisActionName
                        })

                        str_arg:Remove()
                    elseif v2 == "color" then
                        local color = Color(0, 0, 0)

                        str_arg:SetSize(500, 400)
                        str_arg:Center()

                        local label = str_arg:Add("DColorCombo")
                        label:Dock(TOP)
                        label:SetColor(trigger_args[k2])
                        label.OnValueChanged = function(this, col)
                            color = col
                        end

                        str_button.DoClick = function()
                            trigger_args[k2] = color

                            netstream.Start("Trigger:EditAction", Trigger.selectedID, {
                                type = ActionType,
                                number = index,
                                args = trigger_args,
                                name = row.thisActionName
                            })

                            str_arg:Remove()
                        end
                    elseif v2 == "vector" then
                        local vector = trigger_args[k2]
                        local answer = {}

                        str_arg:SetSize(300, 250)
                        str_arg:Center()

                        for k3, v3 in ipairs({"x", "y", "z"}) do
                            local text = str_arg:Add("DLabel")
                            text:SetText(v3:upper())
                            text:Dock(TOP)

                            local label = str_arg:Add("DTextEntry")
                            label:SetText(vector[v3])
                            label:Dock(TOP)

                            answer[k3] = label
                        end

                        local current_pos = str_arg:Add("DButton")
                        current_pos:SetText("Текущая позиция")
                        current_pos:Dock(BOTTOM)
                        current_pos.DoClick = function()
                            local pos = LocalPlayer():GetPos()

                            for k3, v3 in pairs(answer) do
                                v3:SetText(pos[k3])
                            end
                        end

                        str_button.DoClick = function()
                            local x = tonumber(answer[1]:GetText())
                            local y = tonumber(answer[2]:GetText())
                            local z = tonumber(answer[3]:GetText())

                            trigger_args[k2] = Vector(x, y, z)

                            netstream.Start("Trigger:EditAction", Trigger.selectedID, {
                                type = ActionType,
                                number = index,
                                args = trigger_args,
                                name = thisAction.name
                            })

                            str_arg:Remove()
                        end
                    end
                end)

                local icon = "bug_add"
                if v2 == "bool" then
                    if trigger_args[k2] == true then
                        icon = "accept"
                    else
                        icon = "cancel"
                    end
                elseif v2 == "string" then
                    icon = "text_replace"
                elseif v2 == "number" then
                    icon = "calendar_add"
                elseif v2 == "color" then
                    icon = "color_wheel"
                end

                arg:SetIcon("icon16/" .. icon .. ".png")
            end
            SubMenuOption:SetIcon("icon16/script_gear.png")

            Menu:AddSpacer()
            if index > 1 then
                Menu:AddOption("Перместить наверх", function()
                    netstream.Start("Trigger:MoveAction", Trigger.selectedID, {
                        type = ActionType,
                        number = index,
                        direction = -1 -- наверх
                    })
                end):SetIcon("icon16/arrow_up.png")
            end
            if index < #thisTrigger.ActionList[ActionType] then
                Menu:AddOption("Перместить вниз", function()
                    netstream.Start("Trigger:MoveAction", Trigger.selectedID, {
                        type = ActionType,
                        number = index,
                        direction = 1 -- вниз
                    })
                end):SetIcon("icon16/arrow_down.png")
            end

            Menu:AddOption("Удалить Действие", function()
                netstream.Start("Trigger:RemoveAction", Trigger.selectedID, {
                    type = ActionType,
                    number = index
                })
            end):SetIcon("icon16/application_delete.png")

            Menu:Open()
        end
        CPanel:AddPanel(_list)
        Trigger.ActionLists[v.type] = _list
    end

    local UpdateButton = vgui.Create("DButton")
    UpdateButton:SetText("Обновить список (если не обновился)")
    UpdateButton.DoClick = function()
        Trigger:UpdateActionLists()
        Trigger:UpdateTriggerList()
    end
    CPanel:AddPanel(UpdateButton)

    local removeButton = vgui.Create("DButton")
    removeButton:SetText("Удалить все триггеры")
    removeButton:Dock(BOTTOM)
    removeButton.DoClick = function()
        netstream.Start("Trigger:RemoveAll")
    end
    CPanel:AddPanel(removeButton)
end