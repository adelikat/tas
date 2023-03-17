local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 30

local function _do()
	c.WalkLeft(6)
	c.WalkUp(3)
	c.UntilNextMenuY()
	c.UntilNextMenuY()
	c.WaitFor(3)
	c.UntilNextInputFrame()

	c.PushA() -- Talk
	c.RandomFor(2)
	c.UntilNextInputFrame()

	c.RndAorB()
	c.WaitFor(10)
	c.UntilNextInputFrame()
	c.RndAorB()
	c.WaitFor(10)
	c.UntilNextInputFrame()
	c.RndAorB()
	c.WaitFor(10)
	c.UntilNextInputFrame()
	c.RndAorB()
	c.WaitFor(10)
	c.UntilNextInputFrame()
	c.WaitFor(1)
	c.RndAtLeastOne()
	c.WaitFor(40)
	c.UntilNextInputFrame()

	c.Log('Saving 6')
	c.Save(6)
	
	return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
	local result = c.Cap(_do, 100)	
	if result then
		c.Done()
	else
		c.Log('Nothing found')
	end
end

c.Finish()



