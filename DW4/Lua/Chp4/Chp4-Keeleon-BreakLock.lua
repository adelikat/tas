-- Starts at the last lag frame entering Keeleon with Orin
-- Manipulates opening the door and entering
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _do()
    c.WalkMap({
        { ['Up'] = 1 },
        { ['Right'] = 6 },
        { ['Up'] = 6 }
    })
    c.UntilNextMenuY()
    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.Door()
    c.RndAorB() -- It's locked
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.RandomFor(14)
    c.WaitFor(1)
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
    local result = c.Best(_do, 20)
    if result > 0 then                
        c.Done()
    end
end

c.Finish()
