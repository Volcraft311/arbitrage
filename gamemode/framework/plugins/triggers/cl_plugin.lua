
local angle_nil = Angle(0,0,0)
local vector_nil = Vector(0,0,0)

PLUGIN.draw_triggers = false
PLUGIN.selected_trigger = 1


function PLUGIN:NewTrigger(hitpos)
    netstream.Start("Trigger:New",hitpos)
end

function PLUGIN:GetTriggers()
    return GetNetVar("Trigger:triggers")
end

function PLUGIN:ChangePos(id, point, vector)
    netstream.Start("Trigger:ChangePos",id, point, vector)
end




function PLUGIN:Select(id)
    Trigger.selected_trigger = id
end
function PLUGIN:GetSelected()
    return Trigger.selected_trigger
end

local function _DrawTriggers()
    local triggers = Trigger:GetTriggers() or {}
    for k,v in pairs(triggers) do
        render.DrawWireframeBox(vector_nil, angle_nil, v[1], v[2], color_green)
    end
end


function PLUGIN:PostDrawTranslucentRenderables()
    if Trigger.draw_triggers then
        _DrawTriggers()
    end
end