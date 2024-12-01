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
    language.Add("tool.clientsidearea.name", "Trigger Tool")
    language.Add("tool.clientsidearea.desc", "Позволяет управлять триггерами")
    language.Add("tool.clientsidearea.left", "Устанавливает позицию первой точки.")
    language.Add("tool.clientsidearea.right", "Устанавливает позицию второй точки.")
    language.Add("tool.clientsidearea.reload", "Создаёт новый триггер.")

    -- Левая кнопка мыши
    function TOOL:LeftClick(trace)
        if !IsFirstTimePredicted() then return false end
        Trigger:ChangePos(Trigger:GetSelectedId(),1,trace.HitPos)
    end

    -- Правая кнопка мыши
    function TOOL:RightClick(trace)
        if !IsFirstTimePredicted() then return false end
        Trigger:ChangePos(Trigger:GetSelectedId(),2,trace.HitPos)
    end

    -- Перезарядка
    function TOOL:Reload(trace)
        if !IsFirstTimePredicted() then return end
        Trigger:NewTrigger(trace.HitPos)
        Trigger:Select(#Trigger:GetTriggers() + 1)
        return true
    end

    function TOOL:Deploy()
        Trigger.draw_triggers = true
    end
    function TOOL:Holster()
        Trigger.draw_triggers = false
    end

    function TOOL:DrawHUD()
        local triggers = Trigger:GetTriggers()
        for k,v in pairs(triggers) do
            -- Если передавать через NetVar таблицы, он не сохраняет текстовые индексы, я ебал
            local vector = (v[1] + v[2])/2
            local vScreen = vector:ToScreen()
            draw.RoundedBox(1,vScreen.x - 20,vScreen.y - 20,40,40,color_text_background)
            draw.SimpleText(k,"Trebuchet24",vScreen.x,vScreen.y,color_text,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end

        -- Точки триггера
        local area = Trigger:GetSelected()
        if area == nil then return end
        local point1 = area[1]:ToScreen()
        local point2 = area[2]:ToScreen()
        draw.RoundedBox(1,point1.x - 10,point1.y - 10,20,20,color_first_point)
        draw.RoundedBox(1,point2.x - 10,point2.y - 10,20,20,color_second_point)

        draw.SimpleText("1","Trebuchet24",point1.x,point1.y,color_text,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        draw.SimpleText("2","Trebuchet24",point2.x,point2.y,color_text,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end

    function TOOL.BuildCPanel(CPanel)
        -- CPanel:AddControl("Header",{
        --     Description = "This tool allows you to easily convert server-side to client-side objects. This can increase the performance of your server."
        -- })

        -- local arealist = vgui.Create("DListView")
        -- arealist:AddColumn("Name")
        -- arealist:SetSize(100,200)
        -- arealist.OnRowSelected = function(panel,rowIndex)
        --     csp.SetChoisedArea(rowIndex)
        -- end
        -- CPanel:AddPanel(arealist)

        -- csp.ui.arealist = arealist
        -- csp.UpdateAppList()
    end
end