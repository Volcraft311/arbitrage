local PANEL = {}

function PANEL:Init()
    self:SetTitle("")
    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()
    self:SetDraggable(false)
    self:SetAlpha(0)
    self:AlphaTo(255, 2)
end

function PANEL:OpenURL(url)
    local html = self:Add("DHTML")
    html:Dock(FILL)

    html.PerformLayout = function(_, w, h)
        html:SetHTML([[
            <html>
                <head>
                    <meta charset="utf-8">
                    <style>
                        .wrap {
                            position: relative;
                            width: 100%;
                            height: 99%;

                            -webkit-touch-callout: none;
                            -webkit-user-select: none;
                            -khtml-user-select: none;
                            -moz-user-select: none;
                            -ms-user-select: none;
                            user-select: none;
                        }

                        img {
                            position: absolute;
                            top: 50%;
                            left: 50%;
                            max-width: ]] .. w * 0.7 .. [[px;
                            max-height: ]] .. h * 0.7 .. [[px;

                            -webkit-touch-callout: none;
                            -webkit-user-select: none;
                            -khtml-user-select: none;
                            -moz-user-select: none;
                            -ms-user-select: none;
                            user-select: none;
                        }
                    </style>
                </head>

                <body>
                    <div class="wrap">
                        <img id="image" src="]] .. url .. [[" alt="">
                    </div>

                    <script>
                        window.onload = function() {
                            var obj = document.getElementById("image")

                            var width = ]] .. w / 2 .. [[ - obj.width / 2
                            var height = ]] .. h / 2 .. [[ - obj.height / 2

                            obj.style.left = width
                            obj.style.top = height
                        }
                    </script>
                </body>
            </html>
        ]])
    end
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 120)
    surface.DrawRect(0, 0, w, h)

    Arbitrage.DrawBlur(self, 5)
end

vgui.Register("arb.InteractionMenu", PANEL, "DFrame")