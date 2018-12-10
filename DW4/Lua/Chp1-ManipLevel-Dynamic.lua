local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 50

function ReadLevel()
	return c.Read(0x60BA)
end

while not c.done do
	found = false
	c.Load(0)
	delay = 0

	c.RandomFor(1)
	c.UntilNextMenu()

	olv = ReadLevel()
	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.RndAorB() -- Level goes up
	c.UntilNextMenu()

	-- Jackpot check
	lv = ReadLevel()
	if (lv == olv + 1) then
		c.LogProgress('Jackpot!!! delay: ' .. delay, true)
		c.Save(9)
		c.maxDelay = delay - 1
		found = true
		c.done = true -- If we find this, all bets are off, we didn't know about a jackpot this early in the frame search
	end

	if (c.done == false) then
		delay = delay + c.DelayUpTo(c.maxDelay - delay)
		c.RndAorB() -- Next stat
		c.UntilNextMenu()

		lv = ReadLevel()
		if (lv == olv + 2) then --turned off, put back to 1 to turn on
			c.LogProgress('Success delay: ' .. delay, true)
			c.maxDelay = delay - 1
			found = true
			c.Save(9)
		end
	end

	if (found == true and c.maxDelay < 1) then
		c.done = true
	end

	c.Increment()
end

c.Finish()


