-----------------
-- Settings
-----------------
reportFrequency = 1 -- How many attempts before it logs a result

prewalkingframes = 210
 prewalkingdir = 'P1 Right'
frames = 0
-------------------------
local c = require("DW4-ManipCore")
c.InitSession()
origBattleFlag = memory.readbyte(0x008B)
while not c.done do
	savestate.loadslot(0)

	--Pre-walking
	delay = 0
	c.Push(prewalkingdir)
	for i = 0, prewalkingframes, 1 do
		c.RndWalking(prewalkingdir)
	end

	--Wait
	c.WaitFor(0)

	direction =  c.RndDirectionButton()

	for i = 0, 1, 1 do
		c.Push(direction)
	end
	direction = 'P1 Right'

	for i = 0, frames, 1 do
		battleFlag = memory.readbyte(0x008B)
		if battleFlag ~= origBattleFlag then
			console.log("battle found")
			break
		end
		c.RndWalking(direction)
	end

	c.WaitFor(45)

	-- Eval
	c.attempts = c.attempts + 1
	--------------------------------------
	battleFlag = memory.readbyte(0x008B)
    eg1Type = memory.readbyte(0x6E45)
    eg2Type = memory.readbyte(0x6E46)
	eg1Count = memory.readbyte(0x6E49)
	e1HP = memory.readbyte(0x727E)

	if eg1Type ~= 0xFF and eg2Type == 0xFF
		and (eg1Type == 0x0C)
	    --and eg1Count >= 3
	    --and eg1Type == 0x16
		then
		c.done = true
	end

	if eg1Type ~= 0xFF then
		c.LogProgress('eg1: ' .. c.Etypes[eg1Type] .. ' eg2: ' .. c.Etypes[eg2Type] .. ' eg1Count: ' .. eg1Count)
		else if c.attempts % 100 == 0 then
			console.log("Attempts: " .. c.attempts)
		end
	end
	--------------------------------------
end

c.Finish()


