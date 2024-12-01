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

TOOL.Name = "ClientSide Area Tool" -- Название
TOOL.Category = "Asterion Tools" -- Категория
TOOL.Information = { -- Дополнительная информация
    {name = "left", stage = 0},
    {name = "right", stage = 0},
    {name = "reload", stage = 0},
}

local color_text = Color(255,255,255)
local color_text_background = Color(0,0,0,100)
local color_first_point = Color(0,0,200,150)
local color_second_point = Color(0,200,0,150)

-- Добавляем язык

if CLIENT then
    language.Add("tool.clientsidearea.name", "ClientSide Area Tool")
    language.Add("tool.clientsidearea.desc", "Allows you to turn ordinary objects into Client Side Props")
    language.Add("tool.clientsidearea.left", "Click the left mouse button to turn the server object into a client prop.")
    language.Add("tool.clientsidearea.right", "Return client prop to server prop.")
    language.Add("tool.clientsidearea.reload", "Right click to delete client prop.")

    -- Левая кнопка мыши
    function TOOL:LeftClick(trace)
        if !IsFirstTimePredicted() then return false end
        Trigger:ChangePos(Trigger:GetSelected(),1,trace.HitPos)
        print("lefts")
    end

    -- Правая кнопка мыши
    function TOOL:RightClick(trace)
        if !IsFirstTimePredicted() then return false end
        Trigger:ChangePos(Trigger:GetSelected(),2,trace.HitPos)
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

        -- -- Точки зоны
        -- local area = csp.GetChoisedArea()
        -- if area == nil then return end
        -- local point1 = area:GetPoint(1):ToScreen()
        -- local point2 = area:GetPoint(2):ToScreen()
        -- draw.RoundedBox(1,point1.x - 10,point1.y - 10,20,20,color_first_point)
        -- draw.RoundedBox(1,point2.x - 10,point2.y - 10,20,20,color_second_point)

        -- draw.SimpleText("1","Trebuchet24",point1.x,point1.y,color_text,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        -- draw.SimpleText("2","Trebuchet24",point2.x,point2.y,color_text,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
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




-- if CLIENT then
--     local l = "clientsideprops_"

--     
--         

--         local drawProps = vgui.Create("DCheckBoxLabel")
--         drawProps:SetText("Draw Props")
--         drawProps:SetConVar(l .. "drawcsprops")
--         drawProps:SetValue(GetConVar(l .. "drawcsprops"):GetBool())
--         drawProps:SetTextColor(Color(0, 0, 0))
--         CPanel:AddPanel(drawProps)

--         local drawZones = vgui.Create("DCheckBoxLabel")
--         drawZones:SetText("Draw Zones")
--         drawZones:SetConVar(l .. "drawzones")
--         drawZones:SetValue(GetConVar(l .. "drawzones"):GetBool())
--         drawZones:SetTextColor(Color(0, 0, 0))
--         CPanel:AddPanel(drawZones)

--         local appPropsListLabel = vgui.Create("DLabel")
--         appPropsListLabel:SetText("List Props:")
--         appPropsListLabel:SetDark(true)
--         CPanel:AddPanel(appPropsListLabel)

--         local appPropsList = vgui.Create("DListView")
--         appPropsList:SetTall(400)
--         appPropsList:SetMultiSelect(false)
--         appPropsList:AddColumn("ID")
--         appPropsList:AddColumn("Model")
--         appPropsList:AddColumn("Position")
--         appPropsList.OnRowSelected = function(this, index, pnl)
--             local Menu = DermaMenu()

--             Menu:AddOption("Teleport", function()
--                 local idx = pnl:GetColumnText(1)

--                 net.Start("csp.prop:Teleport")
--                     net.WriteUInt(idx, 16)
--                 net.SendToServer()
--             end):SetIcon("icon16/control_play_blue.png")

--             Menu:AddOption("Dump to Console", function()
--                 local idx = pnl:GetColumnText(1)

--                 local prop = csp.prop.instances[idx]
--                 if prop then
--                     prop:Dump()
--                 end
--             end):SetIcon("icon16/page_red.png")

--             Menu:AddOption("Return", function()
--                 local idx = pnl:GetColumnText(1)

--                 net.Start("csp.prop:Return")
--                     net.WriteUInt(idx, 16)
--                 net.SendToServer()
--             end):SetIcon("icon16/arrow_rotate_clockwise.png")

--             Menu:AddOption("Remove", function()
--                 local idx = pnl:GetColumnText(1)

--                 net.Start("csp.prop:Remove")
--                     net.WriteUInt(idx, 16)
--                 net.SendToServer()
--             end):SetIcon("icon16/delete.png")

--             Menu:Open()
--         end
--         CPanel:AddPanel(appPropsList)
--         csp.ui.appPropsList = appPropsList

--         local appZonesListLabel = vgui.Create("DLabel")
--         appZonesListLabel:SetText("List Zones:")
--         appZonesListLabel:SetDark(true)
--         CPanel:AddPanel(appZonesListLabel)

--         local appZonesList = vgui.Create("DListView")
--         appZonesList:SetTall(100)
--         appZonesList:SetMultiSelect(false)
--         appZonesList:AddColumn("ID")
--         appZonesList.OnRowSelected = function(this, index, pnl)
--             local Menu = DermaMenu()

--             Menu:AddOption("Teleport", function()
--                 local idx = pnl:GetColumnText(1)

--                 net.Start("csp.zone:Teleport")
--                     net.WriteUInt(idx, 16)
--                 net.SendToServer()
--             end):SetIcon("icon16/control_play_blue.png")

--             Menu:Open()
--         end
--         CPanel:AddPanel(appZonesList)
--         csp.ui.appZonesList = appZonesList

--         csp.UpdateAppList()

--         local updateButton = vgui.Create("DButton")
--         updateButton:SetText("Update ClientSide Props in Menu")
--         updateButton.DoClick = function()
--             csp.UpdateAppList()
--         end
--         CPanel:AddPanel(updateButton)
--     end

-- end