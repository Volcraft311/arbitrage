--- Wraps text so it does not pass a certain width. This function will try and break lines between words if it can,
-- otherwise it will break a word if it's too long.
-- @realm client
-- @string text Text to wrap
-- @number maxWidth Maximum allowed width in pixels
-- @string[opt="Font"] font Font to use for the text
function Arbitrage.WrapText(text, maxWidth, font)
	font = font or "ixChatFont"
	surface.SetFont(font)

	local words = string.Explode("%s", text, true)
	local lines = {}
	local line = ""
	local lineWidth = 0 -- luacheck: ignore 231

	-- we don't need to calculate wrapping if we're under the max width
	if (surface.GetTextSize(text) <= maxWidth) then
		return {text}
	end

	for i = 1, #words do
		local word = words[i]
		local wordWidth = surface.GetTextSize(word)

		-- this word is very long so we have to split it by character
		if (wordWidth > maxWidth) then
			local newWidth

			for i2 = 1, string.len(word) do
				local character = word[i2]
				newWidth = surface.GetTextSize(line .. character)

				-- if current line + next character is too wide, we'll shove the next character onto the next line
				if (newWidth > maxWidth) then
					lines[#lines + 1] = line
					line = ""
				end

				line = line .. character
			end

			lineWidth = newWidth
			continue
		end

		local newLine = line .. " " .. word
		local newWidth = surface.GetTextSize(newLine)

		if (newWidth > maxWidth) then
			-- adding this word will bring us over the max width
			lines[#lines + 1] = line

			line = word
			lineWidth = wordWidth
		else
			-- otherwise we tack on the new word and continue
			line = newLine
			lineWidth = newWidth
		end
	end

	if (line != "") then
		lines[#lines + 1] = line
	end

	return lines
end