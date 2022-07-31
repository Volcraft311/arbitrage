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
    local amount = tonumber(self.ammoAmount)

    return self.description .. ". Количество: " .. amount .. "."
end

BASE:AddAction("Использовать", {
    OnRun = function(item)
    	local client = item.player
        local ammoClass = item.ammoClass
        local ammoAmount = tonumber(item.ammoAmount)

        for k, v in ipairs(client:GetWeapons()) do
        	local ammoType = v:GetPrimaryAmmoType()
        	if !ammoType then continue end

        	local ammoName = game.GetAmmoName(ammoType)
        	if !ammoName then continue end

        	if ammoName:lower() == ammoClass:lower() then
        		client:GiveAmmo(ammoAmount, ammoClass)

        		return
        	end
        end

        Arbitrage.commands.Notify(client, "У вас нету оружия к которому подходят данные патроны!")

        return false
    end,
    OnCanRun = function(item)
        return true
    end
})

ItemBase:RegisterBase("base_ammo", BASE)