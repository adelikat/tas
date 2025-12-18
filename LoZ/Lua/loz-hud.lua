function screenScrollHelper()
    facingRight = 1
    facingLeft = 2
    facingDown = 4
    facingUp = 8
    direction = memory.readbyte(0x0098)
    x = memory.readbyte(0x0070)
    y = memory.readbyte(0x0084)
    color = 'white'
    if (direction == facingLeft and x == 5)
        or (direction == facingRight and x == 235) then
        color = 'green'
    end

    if direction == facingLeft then
        gui.drawLine(x, y - 8, x, y + 16, color)
    elseif direction == facingRight then
        gui.drawLine(x + 12, y - 8, x + 12, y + 16, color)
    elseif direction == facingUp then
        gui.drawLine(x, y - 8, x + 16, y - 8)
    elseif direction == facingDown then
        gui.drawLine(x, y + 8, x + 16, y + 8)
    end
end

while true do
	screenScrollHelper();

	emu.frameadvance();
end
