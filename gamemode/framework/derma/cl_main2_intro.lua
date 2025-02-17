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


local PANEL = {}

local description = [[
    Спасибо, что принимаете участие в раннем доступе Asterion Academy. Работа над 
    сервером продолжается, но уже сейчас вы можете оценить нашу разработку. 
    Именно благодаря вам, мы можем оперативно исправлять ошибки и улучшать 
    геймплей основываясь на ваших отзывах и предложениях.

    О всех найденных багах и ошибках просьба сообщайть в отдельный канал
    #bugs-report нашего официального Discord сообщества сервера.
]]

function PANEL:Init()
    local parent = self:GetParent()

    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self:SetSize(ScrW(), ScrH())

    local warning = self:Add("DPanel")
    warning:SetSize(W(720), H(282))
    warning:SetPos(ScrW() / 2 - W(720) / 2, H(340))
    warning.Paint = function(_, w, h)
        surface.SetDrawColor(15, 5, 6, 204)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(99, 17, 32)
        surface.DrawOutlinedRect(0, 0, w, h, 2)

        surface.SetDrawColor(255, 41, 80)
        surface.DrawRect(0, 0, w, H(56))

        draw.SimpleText("#menu_welcome_title", "arb.Font_FuturaPTDemi_12", w / 2, H(10), Color(15, 5, 6), TEXT_ALIGN_CENTER)
        draw.DrawText(description, "arb.Font_FuturaPTBook_8", w / 2, H(75), Color(255, 234, 238), TEXT_ALIGN_CENTER)
    end

    local continueButton = self:Add("DButton")
    continueButton:SetText("")
    continueButton:SetPos(ScrW() / 2 - W(276) / 2, H(682))
    continueButton:SetSize(W(276), H(52))
    continueButton.Paint = function(panel, w, h)
        parent:DesignButton(panel, "#menu_welcome_continue", w, h)
    end
    continueButton.DoClick = function()
        self:AlphaTo(0, 0.3, 0, function()
            self:Remove()
            parent:Menu()
        end)
    end
end

function PANEL:Paint() end

vgui.Register("arb.MainRemake:Intro", PANEL, "EditablePanel")