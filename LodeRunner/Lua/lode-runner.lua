--TODO: detect enemy is in ground, only show spawn circle during that time
-- use dig timers to try to predict where an enemy will land ahead of time, instead of cycling it
-- use spawn timer to create a lag counter
local function toSignedByte(b)
    if b > 127 then
        return b - 256
    else
        return b
    end
end

local function getEnemy(n)
    local i = n - 1;

    local colors = {
        [0] = 'magenta',
        [1] = 'purple',
        [2] = 'red',
    }

    local enemy = {
        index = i,
        levelX = memory.readbyte(0x0661 + i),
        levelY = memory.readbyte(0x0669 + i),
        timer = toSignedByte(memory.readbyte(0x0671 + i)),
        xTileOffset = memory.readbyte(0x0679 + i),
        yTileOffset = memory.readbyte(0x0681 + i),
        color = colors[i] or 'magenta'
    }

    return enemy
end

local function drawEnemy(e)
    local camX = memory.readbyte(0x0004)
    local x = (((e.levelX) * 16) - camX) + 14 + e.xTileOffset
    x = math.min(255, x)
    local x = math.max(-14, x)

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
end

local function drawSpawnPrediction(num)
    local i = num - 1;
    local digCounter = memory.readbyte(0x06E0 + i)
    if digCounter == 0 then
        return
    end
    local spawnTimer = memory.readbyte(0x0053)

    local camX = memory.readbyte(0x0004)
    local prediction = (spawnTimer + digCounter) % 32
    gui.drawText(10, 12, spawnTimer, 'red')
    gui.drawText(10, 0, digCounter, 'brown')

end

while true do
    drawEnemy(getEnemy(1))
    drawEnemy(getEnemy(2))
    drawEnemy(getEnemy(3))
    drawSpawnPrediction(1)
	emu.frameadvance();
end
