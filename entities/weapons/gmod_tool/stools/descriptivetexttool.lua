--[[
        © AsterionStaff 2023.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


AddCSLuaFile()

TOOL.Name = "Descriptive Text Tool"
TOOL.Category = "Asterion Tools"
TOOL.Information = {
    {name = "left", stage = 0},
    {name = "right", stage = 0},
    {name = "reload"},
}

DescriptiveTextDescription = DescriptiveTextDescription or "Ваш текст"

if CLIENT then
    language.Add("tool.descriptivetexttool.name", "Descriptive Text Tool")
    language.Add("tool.descriptivetexttool.desc", "Позволяет вам создавать текст в мире")
    language.Add("tool.descriptivetexttool.left", "Нажмите левую кнопку мышки чтобы поставить текст.")
    language.Add("tool.descriptivetexttool.right", "Нажмите правую кнопку мышки чтобы прикрепить текст к Entity.")
    language.Add("tool.descriptivetexttool.reload", "Нажмите Перезарядку чтобы удалить текст.")
end

function TOOL:LeftClick()
    if CLIENT then return true end

    local client = self:GetOwner()
    local pos = client:GetEyeTrace().HitPos

    local entity = ents.Create("gmod_button")
    entity:SetModel("models/hunter/blocks/cube025x025x025.mdl")
    entity:SetPos(pos)
    entity:SetSolid(SOLID_VPHYSICS)
    entity:SetMoveType(MOVETYPE_VPHYSICS)
    entity:DrawShadow(false)
    entity:SetNoDraw(true)
    entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    entity:Spawn()

    local data = client.DescriptiveTextDescription or "Ваш текст"
    entity:SetNetVar("DescriptiveText", data)

    client:ChatNotify("Вы успешно установили свой текст в мире.")
end

function TOOL:RightClick()
    if CLIENT then return true end

    local client = self:GetOwner()

    local entity = client:GetEyeTrace().Entity
    if IsValid(entity) then
        local data = client.DescriptiveTextDescription or "Ваш текст"
        entity:SetNetVar("DescriptiveText", data)

        client:ChatNotify("Вы успешно прикрепили свой текст к объекту " .. tostring(entity) .. ".")

        if entity:IsPlayer() then
            entity:ChatNotify("Администратор прикрепил к вам текст: \"" .. data .. "\"!")
        end
    end
end

function TOOL:Reload()
    if CLIENT then return true end

    local client = self:GetOwner()
    local entity = client:GetEyeTrace().Entity

    if IsValid(entity) and entity:GetNetVar("DescriptiveText") then
        entity:SetNetVar("DescriptiveText", nil)
        client:ChatNotify("Вы успешно открепили свой текст от объекта.")

        if entity:GetModel() == "models/hunter/blocks/cube025x025x025.mdl" then
            entity:Remove()
        end

        if entity:IsPlayer() then
            entity:ChatNotify("Администратор убрал с вас текст!")
        end
    end
end

function TOOL.BuildCPanel(CPanel)
    CPanel:AddControl("Header",{
        Description = "Данный инструмент поможет вам создавать текст на карте."
    })

    local lableDesc = vgui.Create("DLabel")
    lableDesc:SetText("Ваш текст")
    lableDesc:SetTextColor(color_black)
    CPanel:AddPanel(lableDesc)

    local dtextentryDesc = vgui.Create("DTextEntry")
    dtextentryDesc:SetValue(DescriptiveTextDescription)
    dtextentryDesc:SetTall(500)
    dtextentryDesc:SetVerticalScrollbarEnabled(true)
    dtextentryDesc:SetMultiline(true)
    dtextentryDesc.OnChange = function(_)
        local data = _:GetValue()

        DescriptiveTextDescription = data
        netstream.Start("DescriptiveText:SetDescription", DescriptiveTextDescription)
    end
    CPanel:AddPanel(dtextentryDesc)
end