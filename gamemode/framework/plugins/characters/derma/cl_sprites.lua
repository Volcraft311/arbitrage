local PANEL = {}

local size = 0.7
function PANEL:Init()
	if IsValid(Arbitrage.gui.spritesmenu) then
		Arbitrage.gui.spritesmenu:Remove()
	end

    self:SetTitle("")
	self:SetSize(W(1920) * size, H(1080) * size)
	self:MakePopup()
	self:Center()
	self:SetAlpha(0)
	self:AlphaTo(255, 0.1)
	self:ShowCloseButton(true)

    local char_tree = self:Add("DTree")
    char_tree:SetWidth(256)
    char_tree:Dock(LEFT)
    for k, v in pairs(Character.emoji.instances) do
        char_tree:AddNode(k)
    end
end



vgui.Register("SpritesMenu", PANEL, "DFrame")