local function drawHealth()
    local hp = memory.readbyte(0x00DA)
    gui.drawString(72, 191, hp)
end

while true do
	drawHealth()
	emu.frameadvance();
end
