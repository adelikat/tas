-- This template lives at `.../Lua/.template.lua`.
local enemyTypes = {
    [0x01] = 'Pink Shy Guy',
    [0x02] = 'Tweeter',
    [0x03] = 'Rec Shy Guy',
    [0x04] = 'Porcupine',
    [0x05] = 'Walking Snifit',
    [0x06] = 'Jumping Snifit',
    [0x07] = 'Pink Walk and Jump Snifit',
    [0x08] = '',
    [0x09] = 'Bob Omb',
    [0x0A] = '',
    [0x0B] = '',
    [0x0C]= '',
    [0x0D] = 'Ninji Running',
    [0x0E] = 'Ninji Standing',
    [0x0F] = 'Beezo',
    [0x10] = '',
    [0x13] = 'Trouter',
    [0x14] = 'Hooper',
    [0x17] = 'Phanto',

}

local eColors = {
    [1] = 'white',
    [2] = '#cccccc',
    [3] = '#aaaaaa',
    [4] = '#888888',
    [5] = '#555555',
}

local cameraX

local function readGlobals()
    cameraX = memory.readbyte(0x00FD)
end

local function getEnemy(n)
    local x = memory.readbyte(0x002d - n + 1)
    local y = memory.readbyte(0x0037 - n + 1)
    local type = enemyTypes[memory.readbyte(0x0094 - n + 1)]
    local loaded = memory.readbyte(0x0055 - n + 1)
    local enemy = {
        slot = n,
        x = x - cameraX,
        y = y,
        status = loaded,
        type = type ~= nil and type or 'unknown',
    }

    function enemy:isActive()
        return self.status > 0
    end

    return enemy
end

local function drawEBox(enemy)
    if (enemy:isActive()) then
        gui.drawBox(enemy.x, enemy.y - 8, enemy.x + 16, enemy.y + 8, eColors[enemy.slot])

        for i = 0, enemy.slot - 1 do
            gui.drawPixel(enemy.x + (i * 2) + 2, enemy.y - 8, 'black')
        end
    end
end

local function toSignedByte(b)
    if b > 127 then
        return b - 256
    else
        return b
    end
end

local function toLeftNibble(b)
    return string.sub(string.format("%01X", b), 1, 1)
end

local function toPositionStr(b1, b2, bsub, speed)
    return (b1 + (toSignedByte(b2) * 256)) .. '.' .. toLeftNibble(bsub) .. ' ' .. toSignedByte(speed)
end

while true do
    readGlobals()
	local e1 = getEnemy(1)
    local e2 = getEnemy(2)
    local e3 = getEnemy(3)
    local e4 = getEnemy(4)
    local e5 = getEnemy(5)
    drawEBox(e1)
    drawEBox(e2)
    drawEBox(e3)
    drawEBox(e4)
    drawEBox(e5)

    local levelX1st = memory.readbyte(0x0028)
    local levelX2nd = memory.readbyte(0x0014)
    local xSubpixel = memory.readbyte(0x0407)
    local xSpeed = memory.readbyte(0x003C)
    gui.text(0, 68, 'X: ' .. toPositionStr(levelX1st, levelX2nd, xSubpixel, xSpeed))

    local levelY1st = memory.readbyte(0x0032)
    local levelY2nd = memory.readbyte(0x001E)
    local ySubpixel = memory.readbyte(0x0411)
    local ySpeed = memory.readbyte(0x0046)
    gui.text(0, 88, 'Y: ' .. toPositionStr(levelY1st, levelY2nd, ySubpixel, ySpeed))

	emu.frameadvance();
end
