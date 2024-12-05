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

    function TOOL:Deploy()
        Trigger.drawTriggers = true
    end
    function TOOL:Holster()
        Trigger.drawTriggers = false
    end
end
-- Левая кнопка мыши
function TOOL:LeftClick(trace)
    if !IsFirstTimePredicted() then return false end
    if CLIENT then
        local id = Trigger.selectedID
        local vector = trace.HitPos
        local point = 1
        Trigger:GetByID(id):SetPoint(point, vector)
        netstream.Start("Trigger:SetPos",{id = id, point = point, vector = vector})
        Trigger.UpdateToolPanel()
    end
    Trigger.drawTriggers = true
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
    end
    Trigger.drawTriggers = true
end

-- Перезарядка
function TOOL:Reload(trace)
    if !IsFirstTimePredicted() then return end
    if SERVER then
        Trigger:Create({points = {trace.HitPos,trace.HitPos + Vector(5,5,5)},type = 1})
        Trigger:SyncLast()
    else
        timer.Simple(0.1,function()
            Trigger.UpdateToolPanel()
            Trigger.selectedID = #Trigger.instances
        end)
    end
    Trigger.drawTriggers = true
    return true
end


function TOOL:DrawHUD()
    local triggers = Trigger.instances
    for k,v in pairs(triggers) do
        local vector = (v.points[1] + v.points[2])/2
        local vScreen = vector:ToScreen()
        draw.RoundedBox(1,vScreen.x - 20,vScreen.y - 20,40,40,color_text_background)
        draw.SimpleText(k,"Trebuchet24",vScreen.x,vScreen.y,color_text,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
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


    TriggerList.OnRowSelected = function(panel, index, row)
        Trigger.selectedID = tonumber(row:GetValue(2))
    end

    Trigger.TriggerList = TriggerList

    Trigger.UpdateToolPanel()
end
