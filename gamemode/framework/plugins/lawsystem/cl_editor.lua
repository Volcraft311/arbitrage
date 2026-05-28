---@type TrialPlugin
local PLUGIN = PLUGIN


PLUGIN.CSProps = PLUGIN.CSProps or {}
PLUGIN.CSProps.PlacesList = PLUGIN.CSProps.PlacesList or {}
PLUGIN.CSProps.CamerasList = PLUGIN.CSProps.CamerasList or {}
PLUGIN.CSProps.StartCamera = PLUGIN.CSProps.StartCamera or nil
PLUGIN.CSProps.EndPosCamera = PLUGIN.CSProps.EndPosCamera or nil

PLUGIN.SelectedPlaceID = PLUGIN.SelectedPlaceID or 1

local color_selected = Color(255, 255, 255, 255)
local color_unselected = Color(255, 171, 0, 150)

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
        ent:SetRenderMode(RENDERMODE_TRANSALPHA)
        ent:SetColor(i==PLUGIN.SelectedPlaceID and color_selected or color_unselected)

        PLUGIN.CSProps.CamerasList[i] = ent
    end

    local start_camera = PLUGIN.GetStartCamera()
    if start_camera and start_camera.pos then
        local ent = ClientsideModel("models/editor/cone_helper.mdl")
        ent:SetPos(start_camera.pos)
        ent:SetAngles(start_camera.ang)
        ent:SetRenderMode(RENDERMODE_TRANSALPHA)
        ent:SetColor(color_selected)

        PLUGIN.CSProps.StartCamera = ent
    end

    local end_camera = PLUGIN.GetEndPosCamera()
    if end_camera and end_camera != vector_zero then
        local ent = ClientsideModel("models/editor/axis_helper.mdl")
        ent:SetPos(end_camera)
        ent:SetRenderMode(RENDERMODE_TRANSALPHA)
        ent:SetColor(color_selected)
        PLUGIN.CSProps.EndPosCamera = ent
    end
    -- if cam then
    --     local ent = ClientsideModel("models/editor/camera.mdl")
    --     ent:SetPos(cam.pos)
    --     ent:SetAngles(cam.ang)
    --     PLUGIN.CSProps.CamerasList[PLUGIN.SelectedPlaceID] = ent
    -- end
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
    if IsValid(PLUGIN.CSProps.StartCamera) then
        PLUGIN.CSProps.StartCamera:Remove()
    end

    if IsValid(PLUGIN.CSProps.EndPosCamera) then
        PLUGIN.CSProps.EndPosCamera:Remove()
    end

    PLUGIN.CSProps = {
        PlacesList = {},
        CamerasList = {},
        StartCamera = nil,
        EndPosCamera = nil
    }
end
