local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 160

_ragLvAddr = 0x60BA

while not c.done do
	c.Load(0)
	local delay = 0
	olv = c.Read(_ragLvAddr)
	--------------------------------------	
	c.RndAtLeastOne() -- Ragnar attacks
	c.WaitFor(52)

	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.RndAtLeastOne() -- 18 damage
	c.WaitFor(23)

	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.RndAtLeastOne() -- Foes defeated
	c.RandomFor(30)
	c.WaitFor(295)

	c.RandomFor(1)
	c.WaitFor(8)

	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.PushAorB() -- Level goes up

	c.WaitFor(60)

	lv = c.Read(_ragLvAddr)

	found = false
	if (lv == olv + 2) then
		c.LogProgress('Jackpot!!! delay: ' .. delay, true)
		found = true
		c.maxDelay = delay - 1
		c.Save(9)
	else
		found = false
	end

	c.Increment()
	if (found == true and delay == 0) then
		c.done = true
	end

	c.LogProgress('rng2: ' .. c.ReadRng2() .. ' lv: ' .. lv)
end

c.Finish()


