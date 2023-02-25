local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100

local function _do()
	c.RndAorB()
	c.WaitFor(48)
	c.UntilNextInputFrame()
	c.WaitFor(1)
	c.RndAtLeastOne()
	c.WaitFor(90)
	c.UntilNextInputFrame()

	return true
end

c.Load(0)
c.Save(100)
while not c.done do	
	c.Load(100)
	c.Best(_do, 100)
	c.Done()
end

c.Finish()



