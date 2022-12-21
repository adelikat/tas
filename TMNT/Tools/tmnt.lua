local turtleXAddr = 0x0480
local turtleYAddr = 0x0460

local weaponXAddr = 0x0481
local weaponYAddr = 0x0461
while true do
	turtleX = memory.readbyte(turtleXAddr)
	turtleY = memory.readbyte(turtleYAddr)
	gui.drawBox(turtleX, turtleY, turtleX + 10, turtleY + 10, "blue")

	weaponX = memory.readbyte(weaponXAddr)
	weaponY = memory.readbyte(weaponYAddr)
	gui.drawBox(weaponX, weaponY, weaponX + 10, weaponY + 10, "green")
	emu.frameadvance();
end