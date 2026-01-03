dofile('loz-core.lua')

local function drawGridlines()
    color = '#92eb34'
    --vertical
    for i = 0, 30, 1 do
        gui.drawLine(8 + (i * 8), 64, 8 + (i * 8), 216, color)
    end
    --horizontal
    for i = 0, 19, 1 do
        gui.drawLine(8, 64 + (i * 8), 248, 64 + (i * 8), color)
    end
end

local function moneyMakingHud()
    if c.GameMode() ~= c.GameModes.Cave then
       return
    end

    left = memory.readbyte(0x0448)
    middle = memory.readbyte(0x0449)
    right = memory.readbyte(0x044A)
    if left == 0 then
        return
    end

    gui.drawText(80, 176, moneyMakingDisplay(left), moneyMakingColor(left))
    gui.drawText(112, 176, moneyMakingDisplay(middle), moneyMakingColor(middle))
    gui.drawText(144, 176, moneyMakingDisplay(right), moneyMakingColor(right))
end

while true do
    drawGridlines()
	emu.frameadvance();
end
