local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 10
c.maxDelay = 9

local delay = 0
function _searchAg()
	c.Save(4)
	c.Debug('Starting Ag search ')
	agDelay = delay
	while agDelay <= c.maxDelay do
		c.Load(4)
		c.Debug('Ag search ' .. agDelay)
		c.WaitFor(agDelay)
		c.PushA()
		c.WaitFor(2)
		c.UntilNextMenu()
		ag = c.Read(c.Addr.NextStat)
		if (ag >= 3) then
			c.maxDelay = agDelay - 1
			c.Save("Ag3_" .. agDelay)
			c.Save(5)
			c.LogProgress('Ag 3 found! delay: ' .. agDelay, true)
			return agDelay
		end

		agDelay = agDelay + 1
	end

	return -1
end

while not c.done do
	c.Load(0)
	delay = 0

	--treasure chest!
	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.RndAtLeastOne()
	c.UntilNextMenu()

	--Taloon opens the treasure chest!
	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.RndAtLeastOne()
	c.RandomFor(1)
	c.UntilNextMenu()

	--Finds the half plate armor
	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.RndAtLeastOne()
	c.RandomFor(250)
	c.UntilNextInputFrame()
	
	c.RandomFor(2)
	c.UntilNextInputFrame()

	str = c.Read(c.Addr.NextStat)
	if (str >= 3) then
		c.Debug('Str 3 found')
		c.Save('Chp3Lv2Str3')
		result = _searchAg()
		if result == 0 and delay == 0 then
			c.Save(9)
			c.Done()
		end
	else
		c.Increment('str: ' .. str)
	end
end

c.Finish()