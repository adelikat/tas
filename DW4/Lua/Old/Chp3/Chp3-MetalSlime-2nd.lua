-- Starts on the magic frame before the 2nd metal slime encounter
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 30

_hpAddr = 0x6098
_attackReadyAddr = 0x735F --Will be one when cursor is ready after metal slime attacks
function _findCritical()
	c.Load(3)
	delay = 0
	found = false
	while not found and delay < c.maxDelay do
		c.Load(3)
		c.Debug('attempting delay: ' .. delay)
		c.WaitFor(delay)
		c.RndAtLeastOne()
		c.WaitFor(30)
		dmg = c.ReadDmg()
		if dmg >= 3 then
			c.Save(5)
			c.Save(50)
			c.Save('MetalCritical' .. delay)
			c.LogProgress('Critical! delay: ' .. delay, true)
			c.maxDelay = delay - 1
			found = true			
			return delay == 0
		end
		delay = delay + 1
	end

	return false
end

c.Load(0)
c.Save(100)
while not c.done do
	c.Load(100)
	delay = 0
	c.RndAtLeastOne()
	c.WaitFor(14)
	c.RndAtLeastOne()
	
	c.RandomFor(23)
	c.WaitFor(2)
	
	c.PushA()
	if (emu.islagged()) then
		c.Debug('Attempt: ' .. c.attempts .. ' lagged before press attack')
	else
		c.WaitFor(4)
		c.PushA()
		if (emu.islagged()) then
			c.Debug('Attempt: ' .. c.attempts .. ' lagged before pick slime')
		else
			c.RandomFor(32)
			c.WaitFor(2)

			turn = c.ReadTurn()
			battle = c.ReadBattle()
			noLag = c.Read(_attackReadyAddr) == 1 --Note that this will actually happen 1 frame early so this isn't a great check
			if (turn == 0 and battle == 76 and noLag) then
				c.LogProgress('Taloon goes first', true)
				c.Save(3)
				result = _findCritical()
				if result then
					c.Save(9)
					c.Save(99)
					c.Done()
				else
					c.Debug('Did not find critical')
				end				
			end
		end
	end
	c.Increment()
end

c.Finish()
