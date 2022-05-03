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

local PLUGIN = PLUGIN

function PLUGIN:CreateCategory(id, name)
    self.category[#self.category + 1] = {
        id = id,
        name = name
    }
end

function PLUGIN:AddBind(key, func)
    self.binds[key] = func
end

function PLUGIN:AddWeapon(class, id)
    self.weapons[class] = id
end

function PLUGIN:StandartCategory(data)
    self.standart = data
end

function PLUGIN:CreatePanel()
    if IsValid(self.panel) then
        self.panel:Remove()
    end

    local panel = vgui.Create("arb.WeaponSelector")

    return panel
end

function PLUGIN:AddIcon(class, icon)
    self.icons[class] = icon
end

PLUGIN:AddBind("invnext", function(panel, attempt)
    attempt = attempt or 0

    local activeWeapon = LocalPlayer():GetActiveWeapon()
    if !IsValid(activeWeapon) then return end
    if (activeWeapon:GetClass() == "weapon_physgun") and LocalPlayer():KeyDown(IN_ATTACK) then return true end
    if attempt >= 20 then return end

    panel.timeFocus = RealTime() + 5
    panel.select.y = panel.select.y + 1

    if IsValid(panel.panels[panel.select.x]) and panel.select.y > #panel.panels[panel.select.x]:GetChildren() - 1 then
        panel.select.x = panel.select.x + 1
        if IsValid(panel.panels[panel.select.x]) and #panel.panels[panel.select.x]:GetChildren() - 1 < 1 then
            return PLUGIN.binds["invnext"](panel, attempt + 1)
        end

        panel.select.y = 1
    end

    if panel.select.x > #panel.panels then
        panel.select.x = 1
        panel.select.y = 1
    end

    surface.PlaySound("common/talk.wav")
    return true
end)

PLUGIN:AddBind("invprev", function(panel, attempt)
    attempt = attempt or 0

    local activeWeapon = LocalPlayer():GetActiveWeapon()
    if !IsValid(activeWeapon) then return end
    if (activeWeapon:GetClass() == "weapon_physgun") and LocalPlayer():KeyDown(IN_ATTACK) then return true end
    if attempt >= 20 then return end

    panel.timeFocus = RealTime() + 5
    panel.select.y = panel.select.y - 1

    if panel.select.y < 1 then
        panel.select.x = panel.select.x - 1
        if panel.select.x < 1 then
            panel.select.x = #panel.panels
        end

        if IsValid(panel.panels[panel.select.x]) and #panel.panels[panel.select.x]:GetChildren() - 1 < 1 then
            return PLUGIN.binds["invprev"](panel, attempt + 1)
        end

        panel.select.y = #panel.panels[panel.select.x]:GetChildren() - 1
    end

    surface.PlaySound("common/talk.wav")
    return true
end)

PLUGIN:AddBind("+attack", function(panel)
    if !panel:IsFocus() then return end

    panel.timeFocus = RealTime()

    local x = panel.select.x
    local y = panel.select.y

    for k, v in pairs(panel.weaponsCategory) do
        if v.x == x and v.y == y then
            input.SelectWeapon(v.weapon)
            surface.PlaySound("ui/buttonclick.wav")
            return true
        end
    end
end)

for i = 1, 9 do
    PLUGIN:AddBind("slot" .. i, function(panel)
        if IsValid(Arbitrage.gui.fastSlots) then return true end

        panel.timeFocus = RealTime() + 5

        if IsValid(panel.panels[i]) then
            panel.select.x = i

            panel.select.y = panel.select.y + 1

            if panel.select.y > #panel.panels[panel.select.x]:GetChildren() - 1 then
                panel.select.y = 1
            end
        end

        surface.PlaySound("common/talk.wav")
        return true
    end)
end

PLUGIN:CreateCategory("main", "ОСНОВНОЕ")
PLUGIN:CreateCategory("weapons", "ОРУЖИЕ")
PLUGIN:CreateCategory("build", "СТРОИТЕЛЬСТВО")

PLUGIN:StandartCategory("weapons")

PLUGIN:AddWeapon("academy_first", "main")
PLUGIN:AddWeapon("academy_key", "main")

PLUGIN:AddWeapon("weapon_physgun", "build")
PLUGIN:AddWeapon("gmod_tool", "build")
PLUGIN:AddWeapon("gmod_camera", "main")

PLUGIN:AddIcon("academy_first", "danganronpa/selector/first.png")
PLUGIN:AddIcon("academy_key", "danganronpa/selector/key.png")



function PLUGIN:InitPostEntity()
    self:CreatePanel()
end

local function get_active_tool(ply, tool)
    local activeWep = ply:GetActiveWeapon()
    if !IsValid(activeWep) or activeWep:GetClass() ~= "gmod_tool" or activeWep.Mode ~= tool then return end

    return activeWep:GetToolObject(tool)
end

function PLUGIN:PlayerBindPress(client, bind, bPress)
    if !client:oldAlive() then return end
    if #client:GetWeapons() <= 0 then return end

    local weapon = client:GetActiveWeapon()
    if !IsValid(weapon) then return end

    local class = weapon:GetClass()

    if class == "gmod_tool" then
        local tool = client:GetTool() and client:GetTool().Name or nil

        if tool == "SubMaterial" then
            if !bPress then return end
            if bind == "invnext" then
                local submaterial = get_active_tool(client, "submaterial")
                if !submaterial then return end

                return submaterial:ScrollDown(client:GetEyeTraceNoCursor())
            elseif bind == "invprev" then
                local submaterial = get_active_tool(client, "submaterial")
                if !submaterial then return end

                return submaterial:ScrollUp(client:GetEyeTraceNoCursor())
            end

            return
        end
    end

    local panel = self.panel

    if self.binds[bind] and bPress then
        return self.binds[bind](panel)
    end
end