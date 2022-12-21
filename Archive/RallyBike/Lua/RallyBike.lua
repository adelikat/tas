while true do
	gasraw = memory.readbyte(0x0358);
	gas = bit.band(gasraw, 0xF);
	gui.text(100, 140, "Test")
	gui.text(100, 160, gas)
	emu.frameadvance();
end