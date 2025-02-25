--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


local PLUGIN = PLUGIN

file.CreateDir("academy_editor_configs")

Editor.clientside = Editor.clientside or {}
Editor.mat = Material("models/debug/debugwhite")

function Editor:Initialize()
    asterionlib.data:Delete("editor_pos")
end

function Editor:ShutDown()
    asterionlib.data:Delete("editor_pos")
end

function Editor:On()
    local client = LocalPlayer()

    client:SetEditing(true)
end

function Editor:Off()
    local client = LocalPlayer()

    client:SetEditing(false)
    self:ClearClientProps()
end

function Editor:PlayerBindPress(client, bind, bPressed)
    if !client:IsEditing() then return end

    if (bind:find("invnext") or bind:find("invprev")) and bPressed then
        return true
    elseif bind:find("attack2") and bPressed then
        vgui.Create("Editor:MenuDelete")
        return true
    elseif bind:find("attack") and bPressed then
        vgui.Create("Editor:MenuAdd")
        return true
    elseif bind:find("reload") and bPressed then
        return true
    end
end

function Editor:DrawInfo(text, vec, ang, color, idx, model, chams)
    if !vec then return end

    local textPos = vec + Vector(0, 0, 10)
    local data2D = textPos:ToScreen()
    if !data2D.visible then return end

    draw.SimpleText(text, "arb.Font_FuturaPTBook_5", data2D.x, data2D.y, color, TEXT_ALIGN_CENTER)

    if idx then
        local entity = self.clientside[idx]

        if !IsValid(entity) then
            entity = ents.CreateClientProp(model or "models/editor/air_node.mdl")
            entity:Spawn()

            local phys = entity:GetPhysicsObject()
            if phys and phys:IsValid() then
                phys:EnableMotion(false)
            end
        end

        entity:SetModel(model or "models/editor/air_node.mdl")
        entity:SetPos(vec or Vector(0, 0, 0))
        entity:SetAngles(ang or Angle(0, 0, 0))

        if chams then
            cam.Start3D(EyePos(), EyeAngles())
                render.SuppressEngineLighting(true)
                render.MaterialOverride(self.mat)
                render.SetColorModulation(color.r / 255, color.g / 255, color.b / 255)
                    entity:DrawModel()
                render.MaterialOverride()
                render.SuppressEngineLighting(false)
            cam.End3D()
        end

        self.clientside[idx] = entity
    end
end

function Editor:ClearClientProps()
    for k, v in pairs(Editor.clientside) do
    	if IsValid(v) then
    		v:Remove()
            Editor.clientside[k] = nil
    	end
    end
end

function Editor:HUDPaint()
    local client = LocalPlayer()
    if !client:IsEditing() then return end

    draw.SimpleText(L("#editor_editmode"), "arb.Font_FuturaPTDemi_10", ScrW() / 2, H(10), Color(255, 255, 255, 50), TEXT_ALIGN_CENTER)

    do
        for k, v in pairs(Arbitrage.placesList or {}) do
            local color = k == 0 and Color(255, 0, 0) or Color(255, 171, 0)
            local pos, ang = v[1], v[2]

            self:DrawInfo(L("#editor_place") .. " " .. k, pos, ang, color, "placesList_" .. k, "models/editor/spot.mdl", true)
        end
    end

    do
        for k, v in pairs(Arbitrage.camPosPlaces or {}) do
            local color = k == 0 and Color(255, 0, 0) or Color(255, 171, 0)

            self:DrawInfo(L("#editor_camera") .. " " .. k, v, nil, color, "camPosPlaces_" .. k, "models/editor/air_node_hint.mdl")
        end
    end

    do
        for k, v in pairs(Arbitrage.spawnList or {}) do
            self:DrawInfo(L("#editor_spawn") .. " " .. k, v, nil, Color(49, 139, 240), "spawnList_" .. k, "models/editor/axis_helper.mdl", true)
        end
    end

    do
        for k, v in pairs(Arbitrage.lobbyList or {}) do
            self:DrawInfo(L("#editor_lobby") .. " " .. k, v, nil, Color(145, 240, 49), "lobbyList_" .. k, "models/editor/axis_helper.mdl", true)
        end
    end

    self:DrawInfo(L("#editor_endpoint_camera"), Arbitrage.camPosEnd, nil, Color(0, 255, 0), "camPosEnd", "models/editor/air_node_hint.mdl")
    self:DrawInfo(L("#editor_startpoint_camera"), Arbitrage.camPos and Arbitrage.camPos[1], Arbitrage.camPos and Arbitrage.camPos[2], Color(171, 57, 193), "camPos", "models/editor/cone_helper.mdl", true)

    Hints:AddKeyDraw("#hintsdraw_remove_points", {MOUSE_RIGHT})
    Hints:AddKeyDraw("#hintsdraw_change_points", {MOUSE_LEFT})
end

netstream.Hook("Editor:SetEditor", function(data)
    if data then
        Editor:On()
    else
        Editor:Off()
    end
end)

netstream.Hook("Editor:SetVariables", function(data)
    Editor.stored = data

    if CLIENT then
        asterionlib.data:Set("editor_pos", data)
    end

    Arbitrage:ReplaceVariables()
end)