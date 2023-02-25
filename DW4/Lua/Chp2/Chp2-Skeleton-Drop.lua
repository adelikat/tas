-- Starts at first frame to end "terrific blow" dialog at the end of round 2
-- Manipulates an Iron Claw drop
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 1
local delay = 0
local function _getDrop()
    delay = c.DelayUpTo(c.maxDelay - delay)
    c.RndAtLeastOne()
    c.WaitFor(43)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    delay = c.DelayUpTo(c.maxDelay - delay)
    c.RndAtLeastOne() -- 21 Damage points to Skeleton
    c.WaitFor(18)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    --delay = c.DelayUpTo(c.maxDelay - delay)
    c.RndAtLeastOne()  -- Skeleton was defeated
    c.RandomFor(100)
    c.WaitFor(70)
    c.PushFor('A', 300)

    return c.Read(0x60E9) == 3
end

c.Load(0)
c.Save(100)
while not c.done do
    c.Load(100)
	local result = _getDrop()
    if result then
        c.Save(5)
        c.Done()
    end

	c.Increment()
end

c.Finish()
