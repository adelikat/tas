local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 300

_hpAddr = 0x6098
_attackReadyAddr = 0x735F --Will be one when cursor is ready after metal slime attacks
function _findMiss()
	c.Load(3)
	delay = 0
	found = false
	origHp = c.Read(_hpAddr)
	while not found and delay < c.maxDelay do
		c.Load(3)
		c.Debug('attempting delay: ' .. delay)
		c.WaitFor(delay)
		c.PushA()
		c.WaitFor(30)
		hp = c.Read(_hpAddr)
		if hp == origHp then
			c.Save(4)
			c.Save(40)
			c.Save('MetalMiss' .. delay)
			c.LogProgress('Miss! delay: ' .. delay, true)
			c.maxDelay = delay - 1
			found = true			
			return delay == 0
		end
		delay = delay + 1
	end

	return false
end

while not c.done do
	c.Load(0)
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
			if (turn == 4 and battle == 76 and noLag) then
				c.LogProgress('Metal slime attacks', true)
				c.Save(3)
				result = _findMiss()
				if result then
					c.Save(9)
					c.Save(99)
					c.Done()
				else
					c.Debug('Metal slime did not attack')
				end				
			end
		end
	end
	c.Increment()
end

c.Finish()
