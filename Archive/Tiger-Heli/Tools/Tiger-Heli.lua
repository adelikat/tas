while true do
	frame = emu.framecount();
	firstByte = memory.readbyte(0x0082);
	secondByte = memory.readbyte(0x0083);
	normalizedFirstByte = 239 - firstByte;
	normalizedSecondByte = (256 - secondByte) - 1;
	position = (normalizedSecondByte) * 240 + normalizedFirstByte
	
	minimum = 728;
	offset = 728;
	if frame >= 11527 and frame < 12248 then
		offset = offset + frame - 11527
	elseif frame >= 12248 then
		offset = 728 + 720
	end

	if frame >= 23768 and frame < 24488 then
		offset = offset + frame - 23768
	elseif frame >= 24488 then
		offset = 728 + 720 + 720
	end

	expected = 65535;
	if frame > minimum then
		expected = math.floor((frame - offset) / 3)
	end

	if frame > minimum and expected ~= position then
		gui.text(0, 196, 'LAG!!!!!!', 'red')
	end



	gui.text(0, 140, 'Position: ' .. position)
	gui.text(0, 168, 'Expected: ' .. expected)
	emu.frameadvance();
end