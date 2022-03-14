--[[
        © Asterion Project 2021.
        This script was created from the developers of the AsterionTeam.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru
            Discord - https://discord.gg/Cz3EQJ7WrF
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

for i = 10, 50 do
	surface.CreateFont( "OpenSansLight_" .. i, {
		font = "Open Sans Light",
		size = i,
		weight = 400,
		extended = true,
		antialias = true,
		shadow = false,
	})
end

surface.CreateFont("ArcadeGenericFont", {
	font = "Roboto",
	size = 20,
	extended = true,
	weight = 1000
})

surface.CreateFont("ArcadeDescFont", {
	font = "Roboto",
	size = math.max(ScreenScale(6), 17),
	extended = true,
	shadow = true,
	weight = 500
})

surface.CreateFont( "arb.LawTableFont", {
	font = "Open Sans Light",
	extended = true,
	size = ScreenScale(16),
	weight = 300,
	italic = true,
})


local function fontIterator(array, count)
	local size = 0
	local idx = 1
	local max_idx = #array

	return function()
		if idx <= max_idx then
			size = size + 1

			if size > count then idx = idx + 1 size = 1 end

			if array[idx] then
				local el = array[idx]
				local name = el[3] or el[1]
				local data = el[2] or {}

				local fontName = "arb.Font_" .. name:gsub(" ", "") .. "_" .. size

				return {
					fontName, {
						font = name,
						size = ScreenScale(size),
						weight = data.weight or 400,
						extended = data.extended or true,
						antialias = data.antialias or true,
						shadow = data.shadow or false,
						italic = data.italic or false,
						blursize = data.blursize or nil
					}
				}
			end
		end
	end
end


ARBITRAGE_FONTS = {
	{"Futura PT Book"}, -- arb.Font_FuturaPTBook_25
	{"Futura PT Demi"}, -- arb.Font_FuturaPTDemi_25
	{"Futura PT Demi Italic"}, -- arb.Font_FuturaPTDemiItalic_25
	{"Futura PT Cond Medium"}, -- arb.Font_FuturaPTCondMedium_25
	{"Futura PT Cond Book Italic"}, -- arb.Font_FuturaPTCondBookItalic_25
	{"Futura PT Heavy"}, -- arb.Font_FuturaPTHeavy_25
	{"Open Sans Light"}, -- arb.Font_OpenSansLight_25
	{"Roboto"}, -- arb.Font_Roboto_25
	{"Baskerville WGL4 BT", {weight = 1000}}, -- arb.Font_BaskervilleWGL4BT_25

	-- Italic
	{"Futura PT Book", {italic = true}, "FuturaPTBookItalic"}, -- arb.Font_FuturaPTBookItalic_25
	{"Futura PT Demi", {italic = true, weight = 1500}, "FuturaPTDemiItalic"}, -- arb.Font_FuturaPTDemiItalic_25
	{"Nebula", {italic = true}}, -- arb.Font_Nebula_25

	-- Blur
	{"Futura PT Book", {extended = true, weight = 300, blursize = 5}, "FuturaPTBookBlur"}, -- arb.Font_FuturaPTBookBlur_25
	{"Futura PT Demi", {extended = true, weight = 300, blursize = 5}, "FuturaPTDemiBlur"}, -- arb.Font_FuturaPTDemiBlur_25
	{"Futura PT Book", {extended = true, weight = 300}, "FuturaPTBookBlurN"}, -- arb.Font_FuturaPTBookBlurN_25
	{"Futura PT Demi", {extended = true, weight = 300}, "FuturaPTDemiBlurN"}, -- arb.Font_FuturaPTDemiBlurN_25
}


local iterator = fontIterator(ARBITRAGE_FONTS, 50)

for n in iterator do
	surface.CreateFont(n[1], n[2])
end