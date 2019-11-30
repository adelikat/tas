local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 0

while not c.done do
	c.Load(0)
	c.RndWalkingFor('P1 Left', 172)
	c.PushDown()
	c.RndWalkingFor('P1 Down', 25)
	c.WaitFor(2)
	c.PushA()
	c.WaitFor(14)
	c.PushA()
	c.PushFor('P1 A', 60)
	c.WaitFor(36)
	c.PushA()
	c.WaitFor(51)
	c.PushA()
	c.WaitFor(13)

	offer = memory.read_u16_le(0x006F)
	c.Debug('offer1: ' .. offer)
	if offer >= 4600 then
		c.LogProgress('Full plate max offer! ' .. offer, true)
		c.Save(4)
		c.Done()
	end

	c.Increment()
end

c.Finish()