--Starts at the magic frame after level ups
--Manipulates the new day begins
local c = require("DW4-ManipCore")

c.InitSession()
c.reportFrequency = 1000

local function _village()
    c.RandomFor(1)
    c.WaitFor(94)
    c.UntilNextInputFrame()
    c.RndAorB()
    c.WaitFor(20)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.RndAorB()
    c.WaitFor(75)
    c.UntilNextInputFrame()

    return true
end

c.Load(0)
c.Save(100)
while not c.done do
	c.Load(100)
	c.Best(_village, 50)
    c.Done()
end

c.Finish()


