-- enemy map
-- 1 - enemy type
-- 2 - enemy palette
-- 3 - x
-- 5 - y
-- a - timer
-- row 2 0 - hp

local function toSignedByte(b)
    if b > 127 then
        return b - 256
    else
        return b
    end
end

local function toHex(b)
    return string.format("%02X", b)
end

local startAddr = 0x421
local function getEnemy(n)
    local eStart = startAddr + ((n - 1) * 32)

    local enemy = {
        offset = eStart,
        type = memory.readbyte(eStart),
        hp = toSignedByte(memory.readbyte(eStart + 15)),
        x = memory.readbyte(eStart + 2),
        y = memory.readbyte(eStart + 4),
        loaded = memory.readbyte(eStart + 1)
    }

    return enemy
end

while true do
	-- Code here will run once when the script is loaded, then after each emulated frame.
    local isLag = emu.islagged()
    local anyDrawn = isLag
    local color = 'white'
    if (isLag) then
        color = 'red'
        gui.drawRectangle(0, 0, 255, 223, 'red')
        gui.drawRectangle(8, 8, 239, 207, 'red')
    end


    for i = 1, 10 do
        local e = getEnemy(i)
        if e.hp >= 0 and e.loaded > 0 then
            anyDrawn = true
            gui.drawRectangle(e.x - 8, e.y - 16, 16, 16, color)
            gui.drawText(e.x, e.y, e.hp + 1)
        end
    end

    if anyDrawn == false then
        gui.clearGraphics()
    end

	emu.frameadvance();
end

