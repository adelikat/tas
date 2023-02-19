-- Starts at the first frame to menu past
-- "Alena gets 16 Damage Points"
local c = require("DW4-ManipCore")

c.InitSession()
c.reportFrequency = 5000
c.maxDelay = 5

local function _transition()
    c.RndAtLeastOne()
    c.WaitFor(17)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- Alena passes away
    c.RandomFor(65)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- Alena's party is demolished
    c.RandomFor(32)
    c.WaitFor(47)
    c.UntilNextInputFrame()

    c.RndAorB() -- A voice is heard out of nowhere
    c.WaitFor(43)
    c.UntilNextInputFrame()

    c.RndAorB() -- Chosen Ones. It's not the time to give up
    c.WaitFor(47)
    c.UntilNextInputFrame()

    c.RndAorB() -- I shall revive you
    c.WaitFor(80)
    c.UntilNextInputFrame()

    return true
end

c.Load(0)
c.Save(100)
while not c.done do
	c.Load(100)
	c.Best(_transition, 100)
	c.Done()
end

c.Finish()

