dofile('lode-runner-core.lua')

local function toCoordsStr(obj)
    local x = '' .. obj.levelX .. '.' .. obj.xTileOffset
    local y = '' .. obj.levelY .. '.' .. obj.yTileOffset
    return string.format('(%s,%s)', string.format('%.3f', obj.xPos()), string.format('%.3f', obj.yPos()))
end

local function drawEnemy(e)
    local camX = memory.readbyte(0x0004)
    -- todo - use XcoordToScreen
    local x = (((e.levelX) * 16) - camX) + 14 + e.xTileOffset
    x = math.min(255, x)
    local x = math.max(-14, x)

    -- todo - use YcoordToScreen
    y = ((e.levelY - 1) * 16) + 8 + e.yTileOffset

    gui.drawRectangle(x, y, 15, 15, e.color)

    if e.timer < 0 then -- signed negative means it is a gold timere
        gui.drawRectangle(x + 1, y + 1, 13, 13, 'gold')
        drawX = math.max(0, math.min(x, 242))
        gui.drawText(drawX, y + 16, 0 - e.timer, 'gold')
    end

    if e.timer > 0 and e.timer < 126 then -- signed positive is pit timer, unlesss 126-127 which is for spawning at top
        gui.drawText(x, y, e.timer, e.color)
    end

    local coordText = toCoordsStr(e); -- string.format("(%d,%d)", e.levelX, e.levelY)
    gui.text(0 + (e.index * 200), 8, coordText, e.color, 'bottomleft')
end

local function drawSpawnPrediction(num)
    local i = num - 1;
    local digCounter = memory.readbyte(0x06E0 + i)
    if digCounter == 0 then
        return
    end
    local digX = memory.readbyte(0x06A0 + i)
    local digY = memory.readbyte(0x06C0 + i)

    local spawnTimer = memory.readbyte(0x0053)

    local colors = {
        [0] = '#D2B48C',
        [1] = '#A67B5B',
        [2] = '#7B4F2C',
        [3] = '#4B2E1A',
    }

    local camX = memory.readbyte(0x0004)
    local prediction = (spawnTimer + digCounter) % 32
    local x = c.XcoordToScreen(prediction)
    local y = c.YcoordToScreen(1)
    local color = colors[i] or '#4B2E1A';
    gui.drawEllipse(x + 2, y, 15, 15, color)
    gui.drawRectangle(c.XcoordToScreen(digX), c.YcoordToScreen(digY), 15, 15, color)
end



function drawPlayer()
    local color = 'red'
    if c.Player().isAlive then
        color = '#4240FE'
    end
    gui.text(5, 0, toCoordsStr(c.Player()), color, 'topright')
end

function drawGameSpeed()
    if c.GameMode() == 1 then
        return
    end

    gui.drawText(80, 75, 'Game Speed ' .. c.GameSpeed(), 'white')
end

function drawLevel()
    gui.text(8, 8, 'Level ' .. c.CurrentLevel(), 'white', 'bottomright')
end

function drawYNumbers()
    gui.drawText(1, 10, '1')
    gui.drawText(1, 42, '3')
    gui.drawText(1, 74, '5')
    gui.drawText(1, 106, '7')
    gui.drawText(1, 138, '9')
    gui.drawText(1, 170, '11')
end

while true do
    gui.clearGraphics()
    if c.GameMode() == 1 then
        drawEnemy(c.Enemy(1))
        drawEnemy(c.Enemy(2))
        drawEnemy(c.Enemy(3))
        drawSpawnPrediction(1)
        drawSpawnPrediction(2)
        drawSpawnPrediction(3)
        drawSpawnPrediction(4)
        drawPlayer()
        drawLevel()
        drawYNumbers()
    else
        drawGameSpeed()
    end

	emu.frameadvance();
end
