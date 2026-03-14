-- This template lives at `.../Lua/.template.lua`.

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
    cursorX = memory.readbyte(0x00A5)
    cursorY = memory.readbyte(0x00A6)

    drawCursor(morePreviousCursorX, morePreviousCursorY, "black")
    drawCursor(previousCursorX, previousCursorY, "gray")
    drawCursor(cursorX, cursorY, "white")

	emu.frameadvance();
end
