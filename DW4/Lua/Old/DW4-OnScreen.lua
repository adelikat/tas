while true do
	rng1 = mainmemory.readbyte(0x12);
	rng2 = mainmemory.readbyte(0x13);
	gui.text(100, 100, 'hello')
	gui.text(0, 64, "RNG: " .. rng1);
	--gui.text(0, 76, "RNG: " .. rng2, nil, nil, 0);
	emu.frameadvance();
end 