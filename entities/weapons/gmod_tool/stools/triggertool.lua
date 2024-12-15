--[[
        © AsterionStaff 2024.
        This script was created from the developers of the AsterionTeam.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/CtfS8r5W3M
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


AddCSLuaFile()

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
        Trigger:GetByID(id):SetPoint(point, vector)
        netstream.Start("Trigger:SetPos",{id = id, point = point, vector = vector})
        Trigger.UpdateToolPanel()
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
        Trigger:GetByID(id):SetPoint(point, vector)
        netstream.Start("Trigger:SetPos",{id = id, point = point, vector = vector})
        Trigger.UpdateToolPanel()
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
            Trigger.UpdateToolPanel()
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

function TOOL.BuildCPanel(CPanel)

    CPanel:AddControl("Header",{
        Description = "Данный инструмент позволяет управлять триггерами."
    })

    local TriggerList = vgui.Create("DListView", CPanel)
    TriggerList:Dock(TOP)
    TriggerList:DockMargin(10, 20, 10, 40)
    TriggerList:AddColumn( "Trigger" )
    TriggerList:AddColumn( "Type" )
    TriggerList:SetTall(500)



    Trigger.TriggerList = TriggerList

    Trigger.UpdateToolPanel()


    local ActionList = vgui.Create("DListView", CPanel)
    ActionList:Dock(TOP)
    ActionList:DockMargin(10, 20, 10, 40)
    ActionList:AddColumn( "ActionID" )
    ActionList:AddColumn( "Action" )
    ActionList:AddColumn( "Args" )
    ActionList:SetTall(500)
    Trigger.ActionList = ActionList



    TriggerList.OnRowSelected = function(panel, index, row)
        Trigger.selectedID = tonumber(row:GetValue(2))
        Trigger.UpdateActionList()
    end

    TriggerList.OnRowRightClick = function(panel, index, row)
        local Menu = DermaMenu()
        local thisTrigger = Trigger:GetSelected()
        Menu:AddOption( "Добавить пустое действие на вход", function()
            netstream.Start("Trigger:AddEnterAction",{id = Trigger.selectedID,actionid = 1, args = {"say","/me test message"}})
            timer.Simple(0.1,function()
                Trigger.UpdateActionList()
            end)
        end)
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
                print(thisTrigger.name)
                netstream.Start("Trigger:ChangeName",{id = thisTrigger.id,name = thisTrigger.name})
                str_arg:Remove()
            end
            timer.Simple(0.1,function()
                Trigger.UpdateActionList()
            end)
        end)

        Menu:AddOption( "Удалить триггер", function()
            netstream.Start("Trigger:Remove",{id = Trigger.selectedID})
            timer.Simple(0.1,function()
                Trigger.UpdateActionList()
            end)
        end)

        Menu:Open()
    end

    ActionList.OnRowRightClick = function(panel, index, row)
        local Menu = DermaMenu()
        Menu:AddOption( "Удалить Действие", function()
            netstream.Start("Trigger:RemoveEnterAction",{id = Trigger.selectedID,number = index})
            timer.Simple(0.1,function()
                Trigger.UpdateActionList()
            end)
        end)


        Menu:AddSpacer()

        local SubMenu = Menu:AddSubMenu( "Изменить Аргументы" )
        local thisAction = Trigger:ActionByID(tonumber(row:GetValue(1)))
        local thisTrigger = Trigger:GetSelected()
        for k, v in pairs(thisAction.args) do
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
                    label:SetText(thisTrigger.EnterActionList[index].args[k])

                    str_button.DoClick = function()
                        thisTrigger.EnterActionList[index].args[k] = label:GetText()
                        netstream.Start("Trigger:EditEnterAction",{id = Trigger.selectedID,number = index,args = thisTrigger.EnterActionList[index].args})
                        str_arg:Remove()
                    end
                elseif v == "number" then
                    local label = str_arg:Add("DTextEntry")
                    label:Dock(TOP)
                    label:SetText(tostring(thisTrigger.EnterActionList[index].args[k]))

                    str_button.DoClick = function()
                        thisTrigger.EnterActionList[index].args[k] = tonumber(label:GetText())
                        netstream.Start("Trigger:EditEnterAction",{id = Trigger.selectedID,number = index,args = thisTrigger.EnterActionList[index].args})
                        str_arg:Remove()
                    end
                end
            end)
            arg:SetIcon( "icon16/group.png" )
        end
        Menu:Open()
    end
end
