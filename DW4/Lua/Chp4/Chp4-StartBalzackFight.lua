--Starts at the first frame to push left after walking up 1 square into Balzack's chambers
--Manipulates until the magic frame, with ideal HP
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

    c.Log('Balzack HP: ' .. c.ReadE1Hp())
	
	return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
	local result = c.Best(_do, 100)	
	if result > 0 then
		c.Done()
	else
		c.Log('Nothing found')
	end
end

c.Finish()



