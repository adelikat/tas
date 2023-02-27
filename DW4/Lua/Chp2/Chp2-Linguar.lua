-- Starts at the magic frame before the fight
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 0

_miss = 98
_hpAddr = c.Addr.AlenaHP
_bestDelay = 999

function _getMiss()
	c.Save(30)
	found = false
	local missDelay = 0
	while not found and missDelay < _bestDelay do
		c.Load(30)
		c.WaitFor(missDelay)
		c.Debug('Attempt delay: ' .. missDelay)
		c.PushA()
		c.WaitFor(24)
		battle = c.ReadBattle()
		dmg = c.ReadDmg()
		if battle == _miss then
			c.LogProgress('Miss found, delay: ' .. missDelay, true)
			found = true
			c.Save(4)
			_bestDelay = missDelay
		else
			missDelay = missDelay + 1;
		end
	end

	if not found then
		c.LogProgress('Failed to find miss', true)
		return -1
	end
	return missDelay
end

while not c.done do
	c.Load(0)
	c.RandomFor(1)
	c.WaitFor(14)
	c.RndAtLeastOne()
	c.WaitFor(208)
	c.RandomFor(1)
	bail = false
	if not emu.islagged() then
		c.Debug('Lagged before Attack menu')
		bail = true
	end

	if not bail then
		c.RandomFor(7)
		c.WaitFor(3)
		c.PushA()
		c.RandomFor(1)
		c.WaitFor(8)
		c.PushA()
		c.RandomFor(1)
		bail = false
		if not c.ReadMenuPosY() == 31 then
			c.Debug('Lagged picking Linguar')
			bail = true
		end

		if not bail then
			c.RandomFor(40)
			c.WaitFor(2)
			if c.ReadTurn() == 4 and c.ReadBattle() == 76 then
				c.LogProgress('Attack manipulated', true)
				c.Save(3)
				result = _getMiss()
				if result == 0 then
					c.LogProgress('Found', true)
					c.Done()
				end
			end
		end
	end
end

c.Finish()
