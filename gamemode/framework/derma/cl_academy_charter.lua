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

Arbitrage.DefaultCharter = [[Правило #1. Убийственная школьная жизнь абсолютных учеников не имеет даты завершения.
Правило #2. По истечению жизни путём убийства, проводится расследование и последующий классный суд. Участие в нём является обязательным для всех выживших учеников.
Правило #3. По истечению классного суда, ученикам необходимо выявить очерненного и сделать голос. Ученик с наибольшим количеством голосов будет казнён. 
Правило #4. Очерненный, сумевший совершить идеальное убийство и не быть выявленным по итогам классного суда, становится победителем. Победитель имеет право покинуть академию.
Правило #5. Если невиновные продолжают выявлять очерненного на классных судах, то игра продолжается до указанного организатором количества учеников.
Правило #6. Насилие против директора академии строго запрещено и карается преждевременной казнью.
Правило #7. Директор не имеет права вмешиваться в убийства.
Правило #8. Ночное время проходит в период с 22:00 по 8:00. В это время, доступ к определенным локациям может быть заблокирован.
Правило #9. Этап расследования начинается после того, как 3 выживших ученика находят тело убитого.
Правило #10. Ученики могут исследовать академию лишь с минимальными ограничениями.
Правило #11. Нарушители правил будут наказываться по всей строгости.
Правило #12. Если два разных убийства с двумя разными убийцами были совершены в одно время, запятнанным считается тот, чью жертву нашли первым.
Правило #13. Директор может вводить новые правила, а также изменять старые в любое время на своё усмотрение.]]

local PANEL = {}

function PANEL:Init()
    self:SetTitle("")
    self:SetPos(0, 0)
    self:SetSize(W(960 * 1.3), H(540 * 1.3))
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self:Center()
    self:ShowCloseButton(false)

    local close = self:Add("DButton")
    close:SetPos(self:GetWide() - H(70), 0)
    close:SetSize(H(70), H(30))
    close:SetText("")
    close.alpha = 40
    close.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 40)
        draw.SimpleText("X", "arb.Font_FuturaPTBook_7", w / 2, H(4), Color(255, 255, 255, _.alpha), TEXT_ALIGN_LEFT)
    end

    close.DoClick = function()
        self:AlphaTo(0, 0.2, 0, function()
            self:Remove()
        end)
    end

    Arbitrage.gui.academycharter = self

    self.charterPanel = self:Add("DTextEntry")
    self.charterPanel:SetValue(GetNetVar("arb.Charter", Arbitrage.DefaultCharter))
    self.charterPanel:SetMultiline(true)
    self.charterPanel:SetFont("arb.Font_FuturaPTBook_8")
    self.charterPanel:Dock(FILL)
    self.charterPanel:DockMargin(W(5), H(10), W(5), H(5))
    self.charterPanel:SetEditable(false)
end


function PANEL:Paint(w, h)
    surface.SetDrawColor(41, 22, 25)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(255, 61, 96, 165.75)
    surface.DrawOutlinedRect(0, 0, w, h, 2)

    surface.SetDrawColor(255, 61, 96, 165.75)
    surface.DrawOutlinedRect(0, 0, w, H(30), 2)

    surface.SetDrawColor(255, 61, 96, 20)
    surface.DrawRect(0, 0, w, H(30))

    draw.SimpleText("Устав академии", "arb.Font_FuturaPTDemi_8", W(10), H(3), color_white, TEXT_ALIGN_LEFT)
end

vgui.Register("arb.AcademyCharter", PANEL, "DFrame")