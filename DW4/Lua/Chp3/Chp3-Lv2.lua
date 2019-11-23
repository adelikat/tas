local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 0

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
	c.UntilNextMenu()

	--Finds the half plate armor
	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.RndAtLeastOne()
	c.WaitFor(1)
	c.UntilNextInputFrame()
	
	c.Save(4)
	c.RandomFor(1)
	c.UntilNextInputFrame()

	c.Done()
end