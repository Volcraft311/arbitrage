local PANEL = {}

local size = 0.7
function PANEL:Init()
	if IsValid(Arbitrage.gui.spritesmenu) then
		Arbitrage.gui.spritesmenu:Remove()
	end
    Arbitrage.gui.spritesmenu = self
    self:SetTitle("")
	self:SetSize(W(1920) * size, H(1080) * size)
	self:MakePopup()
	self:Center()
	self:SetAlpha(0)
	self:AlphaTo(255, 0.1)
	self:ShowCloseButton(true)

    local char_tree = self:Add("DTree")
    char_tree:SetWidth(128)
    char_tree:Dock(LEFT)
    char_tree:DockMargin(32,32,0,32)
    for k, v in pairs(Character.emoji.instances) do
        local node = char_tree:AddNode(k, "icon16/group.png")
        node.id = k
    end

    local emoji_tree = self:Add("DTree")
    emoji_tree:SetWidth(192)
    emoji_tree:Dock(LEFT)
    emoji_tree:DockMargin(32,32,0,32)

    local image_margin = self:Add("DPanel")
    image_margin:SetBackgroundColor(Color(100,100,100,100))
    image_margin:SetWidth(200)
    image_margin:Dock(RIGHT)
    local image = image_margin:Add("DImage")
    image:Dock(TOP)
    image:SetTall(280)

    function char_tree:OnNodeSelected(node)
        emoji_tree:Clear()
        local emoji = Character.emoji:GetByUniqueID(node.id)
        local edata = emoji:GetData()["#classtrial_sprite_category_main"]

        local data = Character.emoji.data[node.id]["#classtrial_sprite_category_main"]
        if !data then return end
        for i, v in ipairs(data) do
            local node2 = emoji_tree:AddNode(v, "icon16/image.png")
            node2.image = tostring(edata.min[i])
        end
    end

    function emoji_tree:OnNodeSelected(node)
        image:SetImage(node.image)
    end
end



vgui.Register("SpritesMenu", PANEL, "DFrame")