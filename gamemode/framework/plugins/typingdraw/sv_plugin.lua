--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


function TypingDraw:SetTypingText(client, target, data, color)
    netstream.Start(client, "TypingDraw:SetTypingText", target, data, color)
end

function TypingDraw:SendSphere(radius, client, data, color)
    for k, v in ipairs(player.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * radius)) do
        TypingDraw:SetTypingText(v, client, data, color)
    end
end