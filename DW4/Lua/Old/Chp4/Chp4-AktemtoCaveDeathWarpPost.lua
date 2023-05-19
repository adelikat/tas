-- Starts at the first frame to clear the dialog 'terrific blow'
-- Of the final attack that will wipe out the party
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 5

local function _do()
    c.RndAtLeastOne()
    c.WaitFor(30)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- 18 dmg points
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- Nara passes away
    c.RandomFor(30)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- Demolished
    c.RandomFor(20)
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

    -- c.RndAtLeastOne()
    -- c.WaitFor(10)
    -- c.UntilNextInputFrame()
    -- c.WaitFor(2)

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
        c.Log('No best result')
    end
end

c.Finish()
