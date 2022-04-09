AddCSLuaFile()

TOOL.Name = "Corpse Tool"
TOOL.Category = "Asterion Tools"
TOOL.Information = {
    {name = "left", stage = 0},
    {name = "right", stage = 0}
}

if CLIENT then
    language.Add("tool.corpsetool.name", "Corpse Tool")
    language.Add("tool.corpsetool.desc", "Позволяет вам делать из Entity труп")
    language.Add("tool.corpsetool.left", "Нажмите левую кнопку мышки чтобы сделать из Entity труп")
    language.Add("tool.corpsetool.right", "Нажмите правую кнопку мышки чтобы удалить из Entity труп")
end

function TOOL:LeftClick()
    if CLIENT then return true end

    local client = self:GetOwner()
    local trace = client:GetEyeTrace()
    local entity = trace.Entity
    if !IsValid(entity) then return client:ChatPrint("Не валидное Entity!") end

    if !entity:IsCorpse() then
        entity:SetCorpse(true)
        client:ChatPrint("Вы успешно сделали из " .. tostring(entity) .. " труп.")
    else
        client:ChatPrint(tostring(entity) .. " уже является трупом!")
    end
end

function TOOL:RightClick()
    if CLIENT then return true end

    local client = self:GetOwner()
    local trace = client:GetEyeTrace()
    local entity = trace.Entity
    if !IsValid(entity) then return client:ChatPrint("Не валидное Entity!") end

    if entity:IsCorpse() then
        entity:SetCorpse(false)
        client:ChatPrint("Вы успешно убрали из " .. tostring(entity) .. " труп.")
    else
        client:ChatPrint(tostring(entity) .. " не является трупом!")
    end
end