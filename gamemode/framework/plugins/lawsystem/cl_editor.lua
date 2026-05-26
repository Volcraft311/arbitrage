---@type TrialPlugin
local PLUGIN = PLUGIN


PLUGIN.CSProps = PLUGIN.CSProps or {}
PLUGIN.CSProps.PlacesList = PLUGIN.CSProps.PlacesList or {}
PLUGIN.CSProps.CamerasList = PLUGIN.CSProps.CamerasList or {}


PLUGIN.SelectedPlaceID = PLUGIN.SelectedPlaceID or 1

function PLUGIN.ShowPlacesModels()
    PLUGIN.HidePlacesModels()

    local places = PLUGIN.GetPlaces()
    for i, place in ipairs(places) do
        local ent = ClientsideModel("models/editor/spot.mdl")
        ent:SetPos(place.pos)
        ent:SetAngles(place.ang)
        PLUGIN.CSProps.PlacesList[i] = ent
    end

    local cameras = PLUGIN.GetCameras()

    for i, camera in pairs(cameras) do
        local ent = ClientsideModel("models/editor/camera.mdl")
        ent:SetPos(camera.pos)
        ent:SetAngles(camera.ang)
        print(camera.pos, camera.ang)
        PLUGIN.CSProps.CamerasList[i] = ent
    end
end


function PLUGIN.HidePlacesModels()
    local props = PLUGIN.CSProps.PlacesList
    for _, v in pairs(props) do
        if IsValid(v) then
            v:Remove()
        end
    end

    for _, v in pairs(PLUGIN.CSProps.CamerasList) do
        if IsValid(v) then
            v:Remove()
        end
    end
    PLUGIN.CSProps = {
        PlacesList = {},
        CamerasList = {}
    }
end
