local cursorX = nil
local cursorY = nil
local previousCursorX = nil
local previousCursorY = nil
local morePreviousCursorX = nil
local morePreviousCursorY = nil

local function drawCursor(x, y, color)
    if (x == nil or y == nil) then
        return
    end

    gui.drawRectangle(x - 4, y - 8, 8, 16, color)
    gui.drawPixel(x - 1, y - 8, "yellow")
end

while true do
    morePreviousCursorX = previousCursorX
    morePreviousCursorY = previousCursorY
    previousCursorX = cursorX
    previousCursorY = cursorY
    cursorX = memory.readbyte(0x0020)
    cursorY = memory.readbyte(0x0021)

    drawCursor(morePreviousCursorX, morePreviousCursorY, "black")
    drawCursor(previousCursorX, previousCursorY, "gray")
    drawCursor(cursorX, cursorY, "white")

     -- draw pointers to the coordinatees the cursor will land on from each angle

    -- from right
    gui.drawLine(116, 77, 135, 100, "gray")
    gui.drawLine(116, 77, 135, 60, "gray")
    gui.drawPixel(119, 80, "black")

    -- from bottom
    gui.drawLine(72, 115, 87, 144, "gray")
    gui.drawLine(72, 115, 55, 144, "gray")
    gui.drawPixel(72, 115, "black")

	emu.frameadvance();
end
