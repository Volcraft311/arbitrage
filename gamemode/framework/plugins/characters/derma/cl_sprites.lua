local PANEL = {}

local size = 0.7
local _, data_characters = file.Find("materials/danganronpa/characters/*", "GAME")


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
    function char_tree:Update()
        self:Clear()
        for k, v in pairs(Character.emoji.instances) do
            if !v.isCreation then continue end
            local node = char_tree:AddNode(k, "icon16/group.png")
            node.id = k
        end
    end
    char_tree:Update()

    local emoji_tree = self:Add("DTree")
    emoji_tree:SetWidth(256)
    emoji_tree:Dock(LEFT)
    emoji_tree:DockMargin(32,32,0,32)


    function emoji_tree:Update(nodeid)
        nodeid = nodeid or self.stored_id
        if !nodeid then return end
        self.stored_id = nodeid
        self:Clear()
        local edata = Character.emoji.data[nodeid] -- чистое название файла/эмоции
        for k, categ in SortedPairs(edata) do
            local category = self:AddNode(k)
            category:Receiver("add-sprite", function(this, panels, dropped, _, x,y)
                if dropped then
                    local panel = panels[1]
                    local data = table.Copy(Character.emoji.data[nodeid])
                    table.insert(data[k], panel.id .. ".png")
                    netstream.Start("Character:CreationEditEmoji", nodeid, data)
                    timer.Simple(0.5,function()
                        self:Update()
                    end)
                end
            end)
            category:ExpandTo(true)
            category.name = k
            for i, v in SortedPairs(categ) do
                local node2 = category:AddNode(v, "icon16/image.png")
                node2.small_image = "danganronpa/characters/" .. nodeid .. "/emoji/" .. v
                node2.big_image = "danganronpa/characters/" .. nodeid .. "/emoji/" .. v:gsub(".png","_m.png")
                node2.name = v
                node2.category = k
            end
        end
    end

    function char_tree:DoRightClick(node)
        local Menu = DermaMenu()

        Menu:AddOption("Создать Категорию", function()
            local data = table.Copy(Character.emoji.data[node.id])
            Derma_StringRequest("Новая категория", "Введите название категории", "", function(text)
                data[text] = {}
                netstream.Start("Character:CreationEditEmoji", node.id, data)
                timer.Simple(0.5,function()
                    emoji_tree:Update()
                end)
            end, nil, "Добавить", "Отменить")
        end)
        Menu:AddOption("Удалить", function()
            netstream.Start("Character:CreationRemoveEmoji", node.id)
            timer.Simple(0.5,function()
                self:Update()
            end)
        end)
        Menu:Open()
    end

    local image_margin = self:Add("DPanel")
    image_margin:SetBackgroundColor(Color(100,100,100,100))
    image_margin:SetWidth(210)
    image_margin:Dock(RIGHT)

    local bimage = image_margin:Add("DImage")
    bimage:Dock(TOP)
    bimage:SetTall(280)

    local simage = image_margin:Add("DImage")
    simage:Dock(TOP)
    simage:SetTall(280)


    function emoji_tree:OnNodeSelected(node)
        if !node.category then return end
        simage:SetImage(node.small_image)
        bimage:SetImage(node.big_image)
    end

    function emoji_tree:DoRightClick(node)
        local Menu = DermaMenu()

        if !node.category then
            Menu:AddOption("Удалить", function()
                local data = table.Copy(Character.emoji.data[self.stored_id])
                print(data)
                data[node.name] = nil
                netstream.Start("Character:CreationEditEmoji", self.stored_id, data)
                timer.Simple(0.5,function()
                    self:Update()
                end)
            end)
        else
            Menu:AddOption("Удалить", function()
                local data = table.Copy(Character.emoji.data[self.stored_id])
                for i, v in ipairs(data[node.category]) do
                    if v == node.name then
                        table.remove(data[node.category], i)
                        break
                    end
                end
                netstream.Start("Character:CreationEditEmoji", self.stored_id, data)
                timer.Simple(0.5,function()
                    self:Update()
                end)
            end)
        end

        Menu:Open()
    end

    local files_tree = self:Add("DTree")

    files_tree:SetWidth(256)
    files_tree:Dock(RIGHT)
    files_tree:DockMargin(32,32,0,32)
    function files_tree:Update(char)
        char = isnumber(char) and data_characters[char] or char
        self:Clear()
        local path = "danganronpa/characters/" .. char .. "/emoji/"
        local sprites = file.Find("materials/" .. path .. "/*.png", "GAME")
        for j, v2 in ipairs(sprites) do
            if v2:sub(-6,-5) == "_m" then continue end
            local node2 = self:AddNode(v2, "icon16/image.png")
            node2.id = v2:gsub(".png","")
            node2.small_image = path .. node2.id .. "_m.png"
            node2.big_image = path .. node2.id .. ".png"
            node2:Droppable("add-sprite")


        end
    end

    function char_tree:OnNodeSelected(node)
        emoji_tree:Update(node.id)
        files_tree:Update(node.id)
    end

    function files_tree:OnNodeSelected(node)
        -- if !node.category then return end
        simage:SetImage(node.small_image)
        bimage:SetImage(node.big_image)
    end

    local newteambutton = self:Add("DButton")
    newteambutton:SetSize(100,30)
    newteambutton:SetPos(50,20)
    newteambutton:SetText("Новый")
    newteambutton.DoClick = function()
        Derma_StringRequest("Уникальный ID", "Введите уникальный ID персонажа", "", function(text)
            netstream.Start("Character:CreationRegisterEmoji", text, {})
            timer.Simple(0.5,function()
                char_tree:Update()
            end)
        end, nil, "Добавить", "Отменить")
    end
end



vgui.Register("SpritesMenu", PANEL, "DFrame")