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


local BASE = ItemBase.GetBase()

BASE.name = "База Патронов"
BASE.description = ""
BASE.category = "Патроны"
BASE.ammoClass = "pistol"
BASE.ammoAmount = 10

BASE.creationExample = {
    {
        variable = "category",
        title = "Категория",
        default = "Патроны"
    },
    {
        variable = "ammoClass",
        title = "Тип патронов",
        default = "pistol"
    },
    {
        variable = "ammoAmount",
        title = "Количество патронов",
        default = 10
    }
}

function BASE:GetDescription()
    local amount = tonumber(self:GetData("amount", self.ammoAmount))

    return self.description .. " Количество патрон: " .. amount .. "."
end

BASE:AddAction("Использовать", {
    OnRun = function(item)
    	local client = item.player
        local ammoClass = item.ammoClass
        local ammoAmount = tonumber(item:GetData("amount", item.ammoAmount))

        client:GiveAmmo(ammoAmount, ammoClass)
    end,
    OnCanRun = function(item)
        return true
    end
})

ItemBase:RegisterBase("base_ammo", BASE)