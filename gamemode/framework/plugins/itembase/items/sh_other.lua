--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru (not work)
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

do
    local ITEM = ItemBase.GetBase()

    ITEM.name = "Ключи"
    ITEM.description = "Ключи от комнаты: \"%s\""
    ITEM.model = "models/gibs/metal_gib4.mdl"
    ITEM.category = "Двери"

    function ITEM:GetDescription()
        local data = "Отсутствует"

        local faction = self:GetData("faction")
        if faction then
            local factionData = Arbitrage.teams.Get(faction)

            data = factionData and factionData.name or data
        end

        return Format(self.description, data)
    end

    ITEM:AddAction("Присвоить ключу фракцию", {
        OnRun = function(item)
            local client = item.player

            netstream.Start(client, "ItemBase:OpenCreateKeyMenu", item:GetID())
            return false
        end,
        OnCanRun = function(item)
            local client = item.player
            local data = item:GetData("faction")

            return client:IsAdmin() and !data
        end
    })

    ItemBase:RegisterItem("keys", ITEM)

    if CLIENT then
        netstream.Hook("ItemBase:OpenCreateKeyMenu", function(id)
            local parent = DermaMenu()

            for k, v in pairs(Arbitrage.teams.data) do
                local panel = parent:AddOption(v.name, function()
                    netstream.Start("ItemBase:CreateKey", id, k)
                end)

                panel:SetIcon(v.pixel)

                for k2, v2 in ipairs(panel:GetChildren()) do
                    if v2:GetName() == "DImage" and !string.find(v2:GetImage(), "icon16/") then
                        local size = parent:GetTall() * 1.5

                        v2:SetSize(size, size)
                    end
                end
            end

            parent:Open(ScrW() / 2, ScrH() / 2)
        end)
    else
        netstream.Hook("ItemBase:CreateKey", function(client, itemID, faction)
            if !client:IsAdmin() then return end

            local item = ItemBase.instances[itemID]
            if !item then return end

            local data = item:GetData("faction")
            if data then return end

            local factionData = Arbitrage.teams.Get(faction)
            if !factionData then return end

            item:SetData("faction", faction)
        end)
    end
end

do
    local ITEM = ItemBase.GetBase()

    ITEM.name = "Ключ ко всем дверям"
    ITEM.description = "Ключи от всех дверей"
    ITEM.model = "models/gibs/metal_gib4.mdl"
    ITEM.category = "Двери"

    ItemBase:RegisterItem("keys_all", ITEM)
end