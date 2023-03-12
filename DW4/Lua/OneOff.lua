local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 10000
local stat = c.Addr.TaloonVit


local function _do()
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
	c.WaitFor(10)
	c.UntilNextInputFrame()

	c.PushUp()
	c.RandomFor(20)
	c.UntilNextInputFrame()
	
	return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
	local result = c.Best(_do, 100)	
	if result > 0 then
		c.Save(7)
		c.Done()
	end
end

c.Finish()



