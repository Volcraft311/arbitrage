local PLUGIN = PLUGIN

ChatBox = PLUGIN 

PLUGIN.chat.history = PLUGIN.chat.history or {}

function PLUGIN:CreateChat()
    if IsValid(self.panel) then
        self.panel:Remove()
    end

    self.panel = vgui.Create("arbChatbox")
    self.panel:SetupTabs("")
    self.panel:SetupPosition("")
end

function PLUGIN:TabExists(id)
    if !IsValid(self.panel) then return false end

    return self.panel.tabs:GetTabs()[id] != nil
end

function PLUGIN:InitPostEntity()
    self:CreateChat()
end

function PLUGIN:PlayerBindPress(client, bind, pressed)
    bind = bind:lower()

    if bind:find("messagemode") and pressed then
        self.panel:SetActive(true)

        return true
    end
end

function PLUGIN:HUDShouldDraw(element)
    if element == "CHudChat" then
        return false
    end
end

function PLUGIN:OnScreenSizeChanged(oldWidth, oldHeight)
    self:CreateChat()
end

function PLUGIN:ChatText(index, name, text, messageType)
    if IsValid(self.panel) then
        self.panel:AddMessage(text)
    end
end

hook("StartChat", function()
    net.Start("arb.ChatIsTyping")
        net.WriteBool(true)
    net.SendToServer()
end)

hook("FinishChat", function()
    net.Start("arb.ChatIsTyping")
        net.WriteBool(false)
    net.SendToServer()
end)

chat.arbAddText = chat.arbAddText or chat.AddText

function chat.AddText(...)
    if (IsValid(PLUGIN.panel)) then
        PLUGIN.panel:AddMessage(...)
    end

    local text = {}

    for _, v in ipairs({...}) do
        if (istable(v) or isstring(v)) then
            text[#text + 1] = v
        elseif (isentity(v) and v:IsPlayer()) then
            text[#text + 1] = team.GetColor(v:Team())
            text[#text + 1] = v:Name()
        elseif (type(v) != "IMaterial") then
            text[#text + 1] = tostring(v)
        end
    end

    text[#text + 1] = "\n"
    MsgC(unpack(text))
end

concommand.Add("arb_chatbox_reload", function()
    PLUGIN:CreateChat()
end)