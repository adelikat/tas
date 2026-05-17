local function getEnemy(num)
    local i = num - 1
    return {
        hp = memory.readbyte(0x0405 + i),
        x = memory.readbyte(0x03E2 + i),
        y = memory.readbyte(0x03E7 + i)
    }
end

local function drawEnemy(e)
    if (e.hp >= 250) then
        return
    end

    local playerY = memory.readbyte(0x03E5)

    local color = 'white'
    if math.abs(e.y - playerY) < 2 then
        color = 'green'
    end
    gui.drawString(e.x, e.y, e.hp)
    gui.drawLine(e.x - 10, e.y, e.x + 20, e.y, color)
end

local function drawPlayer()
    local hp = memory.readbyte(0x00DA)
    gui.drawString(72, 191, hp)

    local x = memory.readbyte(0x3E0)
    local y = memory.readbyte(0x03E5)

    gui.drawLine(x - 10, y, x + 20, y)
end

while true do
	drawPlayer()
    drawEnemy(getEnemy(1))
    drawEnemy(getEnemy(2))
    drawEnemy(getEnemy(3))

	emu.frameadvance();
end
