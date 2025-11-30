-- This template lives at `.../Lua/.template.lua`.
while true do
	-- Code here will run once when the script is loaded, then after each emulated frame.
    local isLag = emu.islagged()
    if (isLag) then
        gui.drawRectangle(0, 0, 255, 223, 'red')
        gui.drawRectangle(4, 4, 247, 215, 'red')
    else
        gui.clearGraphics()
    end
	emu.frameadvance();
end
