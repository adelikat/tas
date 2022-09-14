objectStart = 0x528;
yOffset = 0x28A;
xOffset = 0x270;
hpOffset = 0x23C;

types = {}; 

types[129] = '' --Player Ship
types[130] = '' --Player Ship B button Projectile
types[131] = '' --Player A button Projectile
types[132] = '' --Box
types[133] = '' --Box
types[134] = 'ChpBx'
types[135] = '' --Some enemy
types[164] = '' --Giza
types[136] = '' --Some enemy
types[138] = '' --Blue Rock
types[140] = '' --Some enemy
types[141] = '' --Some enemy
types[142] = '' --Some enemy
types[144] = '' --Some enemy
types[146] = '' --Some enemy
types[149] = '' --Almond
types[150] = '' --Some enemy
types[155] = '' --Effine
types[157] = 'Eff' --Effine
types[158] = '' --Heart left half
types[159] = '' --Heart right half
types[163] = '' --Explosion effect
types[165] = '' --Bullet
types[166] = '' --Bullet
types[169] = '' --Bullet
types[172] = '' --Rock
types[174] = '' --Some enemy
types[184] = '' --Missile
types[185] = '' --Double missile
types[186] = '' --Triple missile
types[187] = '' --Missile
types[189] = 'Sart'
types[190] = 'RoundFace'
types[191] = 'Chip'
types[198] = 'Icon'
types[200] = 'Eraser'
types[202] = 'T' --Turret
types[210] = 'Upgrd'
types[217] = 'Bubble'

function typeLookUp(type)
	lookUp = types[type];
	if lookUp ~= nill then
		return lookUp;
	end

	return type;
end

while true do
	gui.clearGraphics();
	for i=0,25,1 do
		type = memory.readbyte(objectStart + i);
		hp = memory.readbyte(objectStart + hpOffset + i);

		if type > 0 then
			--console.log('y addr: ' .. string.format("%x", startHPAddr + i + yOffset))
			y = memory.readbyte(objectStart + i + yOffset);
			x = memory.readbyte(objectStart + i + xOffset);
			--gui.drawText(i * 16, 32, y)
			--gui.drawLine(0, y, 256, y)
			--gui.drawLine(x, 0, x, 256)
			typeText = typeLookUp(type)
			if (typeText ~= '') then
				gui.drawBox(x-16, y-8, x, y+8, 'green')
				gui.drawText(x-16, y+8, typeLookUp(type))

				if hp > 0 then
					gui.drawText(x-16, y-24, 'hp:' .. hp)
				end
			end			
		end
	end

	hp = 0;
	x = 0;
	y = 0;
	i = 0;
	emu.frameadvance();
end

