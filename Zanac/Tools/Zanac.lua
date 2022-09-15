types = {}; 
types[129] = '' --Player Ship
types[130] = '' --Player Ship B button Projectile
types[131] = '' --Player A button Projectile
types[132] = '' --Box
types[133] = '' --Box
types[134] = 'ChpBx'
types[135] = '' --Some enemy
types[136] = '' --Some enemy
types[137] = '' --Some enemy
types[138] = '' --Blue Rock
types[140] = '' --Some enemy
types[141] = '' --Some enemy
types[142] = '' --Some enemy
types[143] = '' --Missile shooter enemy
types[144] = '' --Some enemy
types[145] = '' --Some enemy
types[146] = '' --Some enemy
types[148] = '' --Bullet
types[149] = '' --Almond
types[150] = '' --Some enemy
types[151] = '' --Some enemy
types[153] = '' --Red Enemy that eats bullets
types[154] = '' --Effine
types[155] = '' --Effine
types[156] = '' --Effine
types[157] = 'Glitch Eff' --Effine, this one triggers area 12 fairy glitch
types[158] = '' --Heart left half
types[159] = '' --Heart right half
types[160] = '' --Yellow heart left half
types[161] = '' --Yellow heart right half
types[162] = '' --Some enemy
types[163] = '' --Explosion effect
types[164] = '' --Some enemy
types[165] = '' --Bullet
types[166] = '' --Bullet
types[169] = '' --Bullet
types[172] = '' --Rock
types[174] = '' --Some enemy
types[175] = '' --Some enemy
types[176] = 'Capital'
types[177] = 'Capital'
types[178] = 'Capital'
types[179] = 'Capital'
types[180] = 'Capital'
types[181] = 'Happy Face'
types[182] = '--FAIRY ICON--'
types[183] = 'Fairy'
types[184] = '' --Missile
types[185] = '' --Double missile
types[186] = '' --Triple missile
types[187] = '' --Missile
types[189] = '' --Sart
types[190] = 'RoundFace'
types[191] = 'Chip'
types[193] = '' --Enemy that shoots bullets
types[194] = '' --Pink enemy that shoots missles
types[195] = '' --Enemy that turns yed and chases you
types[198] = '' --Eraser Icon
types[199] = '--Warp Eraser--'
types[200] = 'Eraser'
types[209] = '--Warp Eraser--'
types[201] = 'T' --Boss Required Turret Type
types[202] = 'T' --Boss Required Turret Type
types[203] = 'T' --Boss Required Turret Type
types[204] = 'T' --Boss Required Turret Type
types[205] = 'T' --Boss Required Turret Type
types[206] = 'T' --Boss Required Turret Type
types[208] = 'T' --Boss Required Turret Type
types[210] = 'Upgrd' --Icon that releases a weapon upgrade
types[211] = '' --Weapon upgrade
types[212] = '' -- Non-boss turret
types[213] = '' -- Non-boss turret
types[214] = '' --Non-required boss turret type
types[215] = '' -- Non-required boss turret type
types[216] = '' --Non-required turret, passive
types[217] = 'Bubble'

objectStart = 0x528;
yOffset = 0x28A;
xOffset = 0x270;
hpOffset = 0x23C;

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

