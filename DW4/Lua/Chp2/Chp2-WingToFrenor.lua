-- Starts at last lag frame after the shrine appears
local c = require("DW4-ManipCore")

c.InitSession()
c.reportFrequency = 5000
c.maxDelay = 5

local function _wing()
    c.RandomFor(1) -- Magic frame
    c.WaitFor(64)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- I wish you a safe journey
    c.WaitFor(2)
    c.UntilNextInputFrame()

    c.PushA() -- Bring up menu
    c.WaitFor(11)
    c.UntilNextInputFrame()

    if c.ReadMenuPosY() ~= 16 then
        return c.Bail('Failed to bring up menu')        
    end

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Failed to navigate to status')
    end

    c.PushRight()
    if c.ReadMenuPosY() ~= 33 then
        return c.Bail('Failed to navigate to item')
    end

    c.PushA() -- Pick Item
    c.WaitFor(13)
    c.UntilNextInputFrame()

    c.PushA() -- Pick Alena
    c.WaitFor(8)
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Failed to navigate to Wing')
    end
    c.PushA()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushA() -- Use
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Failed to navigate to Tempe')
    end

    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Failed to navigate to Frenor')
    end
    c.PushA()
    c.RandomFor(1)
    c.WaitFor(220)
    c.UntilNextInputFrame()

    return true
end

c.Load(0)
c.Save(100)
while not c.done do
	c.Load(100)
	c.Best(_wing, 50)
	c.Done()
end

c.Finish()

