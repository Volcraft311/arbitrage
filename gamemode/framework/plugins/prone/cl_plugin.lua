function Prone:PlayerBindPress(client, bind, pressed)
	if client.IsProne and client:IsProne() and bind == "+jump" and pressed then
		netstream.Start("Prone:Handle")

		return true
	end
end

hook("KeyPressID", function(client, id, bIsVisibleGUI)
	if bIsVisibleGUI then return end
	if id != "prone" then return end
	if !prone then return end

	netstream.Start("Prone:Handle")
end)

function Prone:HUDPaint()
	local client = LocalPlayer()

	if client.IsProne and client:IsProne() then
		if !prone.CanExit(client) then return end

		Hints:AddKeyDraw("Встать на ноги", SETTINGS.binds.Get("prone"))
	end
end

local function canCalcView()
	return !FirstPerson.isAllow
end

hook.Add("prone.ShouldChangeCalcView", "Prone:ShouldChangeCalcView", function()
	if !canCalcView() then
		return false
	end
end)

hook.Add("prone.ShouldChangeCalcViewModelView", "Prone:ShouldChangeCalcViewModelView", function()
	if !canCalcView() then
		return false
	end
end)