--[[
        © AsterionStaff 2024.
        This script was created from the developers of the AsterionTeam.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/CtfS8r5W3M
        
        developer(s):
            Volcraft31

        ——— Chop your own wood and it will warm you twice.
]]--


AddCSLuaFile()
local file_name = {
    tool = "academy_triggertool",
    config = "academy_triggertool_configs",
    map = "academy_triggertool_configs/" .. game.GetMap()
}

file.CreateDir(file_name.config)
file.CreateDir(file_name.map)

TOOL.Name = "Trigger Tool" -- Название
TOOL.Category = "Asterion Tools" -- Категория
TOOL.Information = { -- Дополнительная информация
    {name = "left", stage = 0},
    {name = "right", stage = 0},
    {name = "reload", stage = 0},
}

local color_text = Color(255,255,255)
local color_text_background = Color(0,0,0,100)
local color_first_point = Color(0,0,255,150)
local color_second_point = Color(0,255,0,150)


local ActionType = ACTION_ENTER


-- Добавляем язык

if CLIENT then
    language.Add("tool.triggertool.name", "Trigger Tool")
    language.Add("tool.triggertool.desc", "Позволяет управлять триггерами")
    language.Add("tool.triggertool.left", "Устанавливает позицию первой точки.")
    language.Add("tool.triggertool.right", "Устанавливает позицию второй точки.")
    language.Add("tool.triggertool.reload", "Создаёт новый триггер.")

    function TOOL:Holster()
        Trigger.drawTriggers = false
    end
end
-- Левая кнопка мыши

function TOOL:Deploy()
    if CLIENT then
        Trigger.drawTriggers = true
    else
        Trigger:SyncAll()
    end
end


function TOOL:LeftClick(trace)
    if !IsFirstTimePredicted() then return false end
    if CLIENT then
        local id = Trigger.selectedID
        local vector = trace.HitPos
        local point = 1
        local trigger = Trigger:GetByID(id)
        if trigger == nil then return false end
        trigger:SetPoint(point, vector)
        netstream.Start("Trigger:SetPos",{id = id, point = point, vector = vector})
        Trigger.UpdateTriggerList()
        Trigger.drawTriggers = true
    end
end

-- Правая кнопка мыши
function TOOL:RightClick(trace)
    if !IsFirstTimePredicted() then return false end
    if CLIENT then
        local id = Trigger.selectedID
        local vector = trace.HitPos
        local point = 2
        local trigger = Trigger:GetByID(id)
        if trigger == nil then return false end
        trigger:SetPoint(point, vector)
        netstream.Start("Trigger:SetPos",{id = id, point = point, vector = vector})
        Trigger.UpdateTriggerList()
        Trigger.drawTriggers = true
    end
end

-- Перезарядка
function TOOL:Reload(trace)
    if !IsFirstTimePredicted() then return end
    if SERVER then
        Trigger:Create({points = {trace.HitPos,trace.HitPos + Vector(5,5,5)},type = 1})
        Trigger:SyncLast()
        Arbitrage.adminnotify:SendNotify("triggercreated", self:GetOwner():FullName(), Trigger:GetLast().name)
    else
        timer.Simple(0.1,function()
            Trigger.UpdateTriggerList()
            Trigger.selectedID = #Trigger.instances
        end)
        Trigger.drawTriggers = true
    end
    return true
end


function TOOL:DrawHUD()
    local triggers = Trigger.instances
    for k,v in pairs(triggers) do
        local vector = (v.points[1] + v.points[2]) / 2
        local vScreen = vector:ToScreen()
        draw.RoundedBox(1,vScreen.x - 20,vScreen.y - 20,40,40,color_text_background)
        draw.SimpleText(v.name,"Trebuchet24",vScreen.x,vScreen.y,color_text,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end

    -- Точки триггера
    local trigger = Trigger:GetSelected()
    if trigger == nil then return end
    local point1 = trigger.points[1]:ToScreen()
    local point2 = trigger.points[2]:ToScreen()
    draw.RoundedBox(1,point1.x - 10,point1.y - 10,20,20,color_first_point)
    draw.RoundedBox(1,point2.x - 10,point2.y - 10,20,20,color_second_point)

    draw.SimpleText("1","Trebuchet24",point1.x,point1.y,color_text,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    draw.SimpleText("2","Trebuchet24",point2.x,point2.y,color_text,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end



local trigger_actions = {
    {
        type = ACTION_ENTER,
        desc = "Событие при входе в триггер"
    },
    {
        type = ACTION_EXIT,
        desc = "Событие при выходе из триггера"
    }
}

function TOOL.BuildCPanel(CPanel)

    CPanel:AddControl("Header",{
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
                netstream.Start("Trigger:RemoveAll")

                for k2, v2 in ipairs(util.JSONToTable(file.Read(file_name.map .. "/" .. v, "DATA"))) do
                    netstream.Start("Trigger:CreateTrigger", {points = v2[2], name = v2[1], ActionList = v2[3]})
                end

                timer.Simple(0.5, function()
                    Trigger.UpdateTriggerList()
                end)
            end)
        end

        Menu:Open()
    end
    CPanel:AddPanel(saveButton)

    local text = vgui.Create("DLabel",CPanel)
    text:SetText("Список Триггеров")
    text:Dock(TOP)
    text:SetFont("arb.Font_FuturaPTBook_6")
    text:DockMargin(0, 0, 0, 10)
    text:SetTextColor(color_black)
    CPanel:AddPanel(text)

    local TriggerList = vgui.Create("DListView", CPanel)
    TriggerList:Dock(TOP)
    TriggerList:DockMargin(10, 5, 10, 20)
    TriggerList:AddColumn( "Trigger" )
    TriggerList:AddColumn( "Type" )
    TriggerList:SetTall(300)



    Trigger.TriggerList = TriggerList

    Trigger.UpdateTriggerList()


    TriggerList.OnRowSelected = function(panel, index, row)
        Trigger.selectedID = tonumber(row:GetValue(2))
        Trigger.UpdateActionLists()
    end

    TriggerList.OnRowRightClick = function(panel, index, row)
        local Menu = DermaMenu()
        local thisTrigger = Trigger:GetSelected()
        local EnterAct = Menu:AddSubMenu( "Добавить действие на вход")
        for k, v in pairs(Trigger.ActionTypes) do
            local _opt = EnterAct:AddOption(v.name,function()
                netstream.Start("Trigger:AddAction",{type = ACTION_ENTER, id = Trigger.selectedID,actionid = k, args = v.default})
                timer.Simple(0.1,function()
                    Trigger.UpdateActionLists()
                end)
            end)
            _opt:SetIcon(v.icon or "icon16/bug.png")
        end
        local ExitAct = Menu:AddSubMenu( "Добавить действие на выход")
        for k, v in pairs(Trigger.ActionTypes) do
            local _opt = ExitAct:AddOption(v.name,function()
                netstream.Start("Trigger:AddAction",{type = ACTION_EXIT, id = Trigger.selectedID,actionid = k, args = v.default})
                timer.Simple(0.1,function()
                    Trigger.UpdateActionLists()
                end)
            end)
            _opt:SetIcon(v.icon or "icon16/bug.png")

        end
        Menu:AddSpacer()

        Menu:AddOption( "Изменить имя", function()
            local str_arg = vgui.Create("DFrame")
            str_arg:SetSize(500, 100)
            str_arg:Center()
            str_arg:MakePopup()
            str_arg:SetTitle("Указать имя триггера")

            local str_button = vgui.Create("DButton",str_arg)
            str_button:SetText("Применить изменения")
            str_button:Dock(BOTTOM)
            str_button:SetWidth(20)


            local label = str_arg:Add("DTextEntry")
            label:Dock(TOP)
            label:SetText(thisTrigger.name)

            str_button.DoClick = function()
                thisTrigger.name = label:GetText()
                netstream.Start("Trigger:ChangeName",{id = thisTrigger.id,name = thisTrigger.name})
                str_arg:Remove()
            end
            timer.Simple(0.1,function()
                Trigger.UpdateActionLists()
            end)
        end)

        Menu:AddOption( "Удалить триггер", function()
            netstream.Start("Trigger:Remove",{id = Trigger.selectedID})
            timer.Simple(0.1,function()
                Trigger.UpdateActionLists()
            end)
        end)

        Menu:Open()
    end


    for k, v in pairs(trigger_actions) do
        local text = vgui.Create("DLabel",CPanel)
        text:SetText(v.desc)
        text:Dock(TOP)
        text:SetFont("arb.Font_FuturaPTBook_6")
        text:SetTextColor(color_black)
        CPanel:AddPanel(text)

        local _list = vgui.Create("DListView", CPanel)
        _list:Dock(TOP)
        _list:DockMargin(10, 20, 10, 40)
        _list:AddColumn( "Action" )
        _list:SetTall(300)
        _list.act_type = v.type

        _list.OnRowRightClick = function(panel, index, row)
            ActionType = panel.act_type
            local Menu = DermaMenu()
            Menu:AddOption( "Удалить Действие", function()
                netstream.Start("Trigger:RemoveAction",{type = ActionType, id = Trigger.selectedID,number = index})
                timer.Simple(0.1,function()
                    Trigger.UpdateActionLists()
                end)
            end)


            Menu:AddSpacer()
            -- Почему это сделано через if/else? Я позволю себе 30 секунд или одну минуту, маленькую историческую справку.
            -- Так вот. Для создания нового действия, ты указываешь, какие типы данных он принимает, 'args = {"string","string","number"}'
            -- И основываясь на опыте Селентера, когда я пытался изъебнуться, лишь бы впихнуть изменение цвета персонажа в текстовое окошко меню кастомных персонажей,
            -- Я и решил, что ГОРАЗДО легче продумать это заранее. А гороздить ебейшую кучу РАЗНЫХ интерфейсов - пустая трата времени.
            -- Потому тут и сделано подобное развлетвление, чтобы в случае, если тебе нужен прям особый интерфейс, ты без лишних проблем вписал elseif
            -- Можно было сделать как-то лучше? - Не знаю. Оно работает нормально - да. Потому, если тебя сюда привела подсветка синтаксиса Visual Studio Code, можешь слать его НАХУЙ
            local SubMenu = Menu:AddSubMenu( "Изменить Аргументы" )
            local thisTrigger = Trigger:GetSelected()
            local thisAction = Trigger:ActionByID(row.thisActionID)

            local icon

            for k, v in pairs(thisAction.args) do
                local trigger_args = thisTrigger.ActionList[ActionType][index].args
                local arg = SubMenu:AddOption(thisAction.args_desc[k], function()
                    local str_arg = vgui.Create("DFrame")
                    str_arg:SetSize(500, 100)
                    str_arg:Center()
                    str_arg:MakePopup()
                    str_arg:SetTitle("Указать Аргумент " .. k)

                    local str_button = vgui.Create("DButton",str_arg)
                    str_button:SetText("Применить изменения")
                    str_button:Dock(BOTTOM)
                    str_button:SetWidth(20)
                    if v == "string" then
                        local label = str_arg:Add("DTextEntry")
                        label:Dock(TOP)
                        label:SetText(trigger_args[k])

                        str_button.DoClick = function()
                            trigger_args[k] = label:GetText()
                            netstream.Start("Trigger:EditAction",{type = ActionType, id = Trigger.selectedID,number = index,args = trigger_args})
                            str_arg:Remove()
                        end

                    elseif v == "number" then
                        local label = str_arg:Add("DTextEntry")
                        label:Dock(TOP)
                        label:SetText(tostring(trigger_args[k]))

                        str_button.DoClick = function()
                            trigger_args[k] = tonumber(label:GetText())
                            netstream.Start("Trigger:EditAction",{type = ActionType, id = Trigger.selectedID,number = index,args = trigger_args})
                            str_arg:Remove()
                        end

                    elseif v == "bool" then
                        trigger_args[k] = tobool(!trigger_args[k])
                        netstream.Start("Trigger:EditAction",{type = ActionType, id = Trigger.selectedID,number = index,args = trigger_args})
                        str_arg:Remove()

                    elseif v == "color" then
                        local color = Color(0,0,0)
                        local label = str_arg:Add("DColorCombo")
                        str_arg:SetSize(500, 400)
                        str_arg:Center()
                        label:Dock(TOP)
                        label:SetColor(trigger_args[k])
                        function label:OnValueChanged( col )
                            color = col
                        end

                        str_button.DoClick = function()
                            trigger_args[k] = color
                            netstream.Start("Trigger:EditAction",{type = ActionType, id = Trigger.selectedID,number = index,args = trigger_args})
                            str_arg:Remove()
                        end

                    elseif v == "vector" then
                        local vector = trigger_args[k]
                        local answer = {}
                        str_arg:SetSize(300, 250)
                        str_arg:Center()
                        str_arg:DockMargin(0, 10, 0, 0)

                        for k2,i2 in ipairs({"x","y","z"}) do
                            local text = str_arg:Add("DLabel")
                            local label = str_arg:Add("DTextEntry")

                            text:SetText(i2:upper())
                            text:Dock(TOP)
                            label:SetText(vector[i2])
                            label:Dock(TOP)
                            answer[k2] = label
                        end
                        current_pos = str_arg:Add("DButton")
                        current_pos:SetText("Текущая позиция")
                        current_pos:Dock(BOTTOM)
                        current_pos:DockMargin(0, 10, 0, 10)
                        current_pos.DoClick = function()
                            local pos = LocalPlayer():GetPos()
                            for k2,v2 in pairs(answer) do
                                v2:SetText(pos[k2])
                            end
                        end

                        str_button.DoClick = function()
                            trigger_args[k] = Vector(answer[1]:GetText(),answer[2]:GetText(),answer[3]:GetText())
                            netstream.Start("Trigger:EditAction",{type = ActionType, id = Trigger.selectedID,number = index,args = trigger_args})
                            str_arg:Remove()
                        end
                    -- Тут (если очень захотеть) можно добавить новый тип данных.  
                    end

                end)
                if v == "bool" then
                    if trigger_args[k] == true then
                        icon = "accept"
                    else
                        icon = "cancel"
                    end
                elseif v == "string" then
                    icon = "text_replace"
                elseif v == "number" then
                    icon = "calendar_add"
                elseif v == "color" then
                    icon = "color_wheel"
                end
                arg:SetIcon("icon16/" .. (icon or "bug_add") .. ".png")
            end
            Menu:Open()
        end

        Trigger.ActionLists[v.type] = _list
    end
end
