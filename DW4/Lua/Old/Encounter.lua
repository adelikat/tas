local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1 -- How many attempts before it logs a result
c.maxDelay = 0
local direction = 'Right'
frames = 130
-------------------------

local origBattleFlag = c.ReadBattle()

c.Load(0)
c.Save(100)
while not c.done do
	c.Load(100)
	--delay = delay + c.DelayUpTo(c.maxDelay - delay)
	--c.WaitFor(delay)

	--direction =  c.RndDirectionButton()

	--for i = 0, 1, 1 do
	--	c.Push(direction)
	--end
	--direction = 'P1 Right'

	for i = 0, frames, 1 do
		battleFlag = c.ReadBattle()
		if battleFlag ~= origBattleFlag then
			c.Debug("battle found")
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
		and (eg1Type == 0x5C)
	    and eg1Count == 1
	    --and eg1Type == 0x16
		then
		--hp = c.Read(0xC27E)
		--console.log('slime found hp: ' .. hp)
		--if (hp == 4) then
			c.Done()
		--end
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


