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

local startAddr = 0x421
local function getEnemy(n)
    local eStart = startAddr + ((n - 1) * 32)

    local enemy = {
        offset = eStart,
        type = memory.readbyte(eStart),
        hp = toSignedByte(memory.readbyte(eStart + 15)),
        x = memory.readbyte(eStart + 2),
        y = memory.readbyte(eStart + 4)
    }

    return enemy
end

local prevsKillCount = 0;
local wrapCount = 0;
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
        if e.hp >= 0 then
            anyDrawn = true
            gui.drawRectangle(e.x - 8, e.y - 16, 16, 16, color)
            if e.hp > 0 then
                gui.drawText(e.x, e.y, e.hp)
            end
        end
    end

    if anyDrawn == false then
        gui.clearGraphics()
    end



    local sKillCount = memory.readbyte(0x03FD);
    if sKillCount == 0 and prevsKillCount == 9 then
        wrapCount = wrapCount + 1
    end

    prevsKillCount = sKillCount

    gui.drawText(0,198, 'Kill count: ' .. sKillCount)
    gui.drawText(0,210, 'Kill count wrap: ' .. wrapCount)

	emu.frameadvance();
end

