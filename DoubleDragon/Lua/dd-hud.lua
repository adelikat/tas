local function getEnemy(n)
    local i = n - 1

    local enemy = {
        num = n,
        hp = memory.readbyte(0x03B5 + i),
        levelX = (memory.readbyte(0x005B + i)) + (memory.readbyte(0x0063 + i) * 255),
        levelY = 224 - memory.readbyte(0x0073 + i),
        dmgTimer = memory.readbyte(0x03C9 + i),
    }

    return enemy
end

local function getCameraX()
    return (memory.readbyte(0x00DB)) + (memory.readbyte(0x00DC) * 255)
end

local function getCameraY()
    return (memory.readbyte(0x00DD)) + (memory.readbyte(0x00DE) * 255)
end

local function drawEnemy(e)
    local color = 'gray';
    if e.num == 2 then
        color = 'white'
    elseif e.num == 0 then
        color = 'green'
    end

    camX = getCameraX()
    camY = getCameraY()
    local x = e.levelX - camX
    local y = e.levelY
    gui.drawRectangle(x - 8, y - 32, 16, 40, color)
    gui.drawText(x - 8, y + 8, e.hp, color)
    if e.dmgTimer > 0 then
        gui.drawText(x + 12, y + 8, e.dmgTimer, 'red')
    end
end

while true do
    drawEnemy(getEnemy(0)) -- Bimmy
    drawEnemy(getEnemy(1))
    drawEnemy(getEnemy(2))

    camX = getCameraX()
    camY = getCameraY()
    gui.drawText(0, 100, camX)
    gui.drawText(0, 112, camY)


	emu.frameadvance();
end
