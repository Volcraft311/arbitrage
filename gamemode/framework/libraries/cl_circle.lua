function draw.CircleCustom(x, y, w, h, ang, color, x0, y0)
    for i = 0, ang do
        local c = math.cos(math.rad(i))
        local s = math.sin(math.rad(i))
        local newx = y0 * s - x0 * c
        local newy = y0 * c + x0 * s

        draw.NoTexture()
        surface.SetDrawColor(color)
        surface.DrawTexturedRectRotated(x + newx, y + newy, w, h, i)
    end
end