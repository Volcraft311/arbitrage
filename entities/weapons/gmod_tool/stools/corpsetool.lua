AddCSLuaFile()

TOOL.Name = "Corpse Tool"
TOOL.Category = "Asterion Tools"
TOOL.Information = {
    {name = "left", stage = 0},
    {name = "right", stage = 0}
}

TOOL.ClientConVar.steamid = ""

if CLIENT then
    language.Add("tool.corpsetool.name", "Corpse Tool")
    language.Add("tool.corpsetool.desc", "Позволяет вам делать из Entity труп")
    language.Add("tool.corpsetool.left", "Нажмите левую кнопку мышки чтобы сделать из Entity труп")
    language.Add("tool.corpsetool.right", "Нажмите правую кнопку мышки чтобы удалить из Entity труп")
end

local l = "corpsetool_"
function TOOL:LeftClick()
    if CLIENT then return true end

    local client = self:GetOwner()
    local trace = client:GetEyeTrace()
    local entity = trace.Entity
    if !IsValid(entity) then return client:ChatPrint("Не валидное Entity!") end

    if !entity:IsCorpse() then
        local convar = GetConVar(l .. "steamid"):GetString()

        local steamid = true
        if convar and convar != "" then
            steamid = util.SteamIDFrom64(convar)
        end

        entity:SetCorpse(steamid)
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
        entity:SetCorpse(nil)
        client:ChatPrint("Вы успешно убрали из " .. tostring(entity) .. " труп.")
    else
        client:ChatPrint(tostring(entity) .. " не является трупом!")
    end
end

function TOOL.BuildCPanel(CPanel)
    CPanel:AddControl("Header",{
        Description = "Данный инструмент поможет вам превращать Entity в труп."
    })

    local PlayersDesc = vgui.Create("DLabel")
    PlayersDesc:SetText("Выберите игрока который является убийцей:")
    PlayersDesc:SetWrap(true)
    PlayersDesc:SetAutoStretchVertical(true)
    PlayersDesc:SetTextColor(Color(10,149,255))
    CPanel:AddPanel(PlayersDesc)

    local Combobox = vgui.Create("DComboBox")
    Combobox.OnSelect = function(_, index, value, data)
        RunConsoleCommand(l .. "steamid", data)
    end

    local function reload()
        RunConsoleCommand(l .. "steamid", "")

        Combobox:Clear()
        Combobox:AddChoice("Не указан", "", true)

        for k, v in ipairs(player.GetAll()) do
            Combobox:AddChoice(v:FullName(true), v:SteamID64())
        end
    end
    reload()

    local UpdateButton = vgui.Create("DButton")
    UpdateButton:SetText("Обновить список игроков")
    UpdateButton.DoClick = function()
        reload()
    end

    CPanel:AddPanel(UpdateButton)
    CPanel:AddPanel(Combobox)
end