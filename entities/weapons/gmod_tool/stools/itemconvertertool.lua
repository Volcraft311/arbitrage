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

TOOL.Name = "Item Converter Tool"
TOOL.Category = "Asterion Tools"
TOOL.Information = {
    {name = "left", stage = 0},
    {name = "reload"}
}

TOOL.ClientConVar.base = ""

if CLIENT then
    language.Add("tool.itemconvertertool.name", "Item Converter Tool")
    language.Add("tool.itemconvertertool.desc", "Позволяет вам конвертировать пропы в предметы")
    language.Add("tool.itemconvertertool.left", "Нажмите левую кнопку мышки чтобы сделать из пропа предмет")
    language.Add("tool.itemconvertertool.reload", "Нажмите Перезарядку чтобы сделать из предмета проп")
end

local l = "itemconvertertool_"
function TOOL:LeftClick()
    if CLIENT then return true end

    local client = self:GetOwner()
    local trace = client:GetEyeTrace()
    local entity = trace.Entity
    if !IsValid(entity) then return client:ChatNotify("Не валидное Entity!") end

    if entity:GetClass() == "arb_item" then return client:ChatNotify("Данный объект уже является предметом!") end

    local base = "basic"
    local convar = tostring(client:GetTool():GetClientInfo("base"))
    if convar != "" or convar != " " or convar != "basic" then
        base = convar
    end

    local basic_item = nil
    local converter = ItemBase.converterBase[base]
    basic_item = converter and converter[2]

    if !basic_item then return end

    local pos, ang, model = entity:GetPos(), entity:GetAngles(), entity:GetModel()
    entity:Remove()

    local item, entity = ItemBase.CreateItemInWorld(basic_item, pos, ang)
    if !item then return end

    entity:SetModel(model)
    entity:PhysicsInit(SOLID_VPHYSICS)
    entity:SetSolid(SOLID_VPHYSICS)

    local physObj = entity:GetPhysicsObject()
    if !IsValid(physObj) then
        entity:PhysicsInitBox(invalidBoundsMin, invalidBoundsMax)
        entity:SetCollisionBounds(invalidBoundsMin, invalidBoundsMax)
    else
        physObj:EnableMotion(true)
        physObj:Wake()
    end

    item:SetData("m_model", model)
    item:SetData("m_category", "")
end

function TOOL:Reload()
    if CLIENT then return true end

    local client = self:GetOwner()
    local trace = client:GetEyeTrace()
    local entity = trace.Entity
    if !IsValid(entity) then return client:ChatNotify("Не валидное Entity!") end

    if entity:GetClass() != "arb_item" then return client:ChatNotify("Данный объект не является предметом!") end

    local pos, ang, model = entity:GetPos(), entity:GetAngles(), entity:GetModel()
    entity:Remove()

    local prop = ents.Create("prop_physics")
    prop:SetModel(model)
    prop:SetPos(pos)
    prop:SetAngles(ang)
    prop:Spawn()
end

function TOOL.BuildCPanel(CPanel)
    CPanel:AddControl("Header",{
        Description = "Данный инструмент поможет вам превращать Entity в предметы."
    })

    local BaseDesc = vgui.Create("DLabel")
    BaseDesc:SetText("Выберите базу предмета в которую вы хотите корвертировать предмет:")
    BaseDesc:SetWrap(true)
    BaseDesc:SetAutoStretchVertical(true)
    BaseDesc:SetTextColor(Color(10,149,255))
    CPanel:AddPanel(BaseDesc)

    local Combobox = vgui.Create("DComboBox")
    Combobox.OnSelect = function(_, index, value, data)
        RunConsoleCommand(l .. "base", data)
    end

    for k, v in pairs(ItemBase.converterBase) do
        Combobox:AddChoice(v[1], k, k == "basic")
    end

    CPanel:AddPanel(Combobox)
end