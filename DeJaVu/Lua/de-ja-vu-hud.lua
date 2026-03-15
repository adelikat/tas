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

    -- draw pointers to the coordinatese the cursor will land on from each angle

    -- from right
    gui.drawLine(119, 80, 135, 100, "gray")
    gui.drawLine(119, 80, 135, 60, "gray")
    gui.drawPixel(119, 80, "black")

    -- from bottom
    gui.drawLine(71, 128, 87, 144, "gray")
    gui.drawLine(71, 128, 55, 144, "gray")
    gui.drawPixel(71, 128, "black")

    -- from top
    gui.drawLine(71, 32, 87, 16, "gray")
    gui.drawLine(71, 32, 55, 16, "gray")
    gui.drawPixel(71, 32, "black")


	emu.frameadvance();
end
