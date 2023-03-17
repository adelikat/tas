-- Starts at the first frame to dismiss the "x damage points" dialog
-- that kills off Mara, manipulates into Keeleon
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _deathWarp()
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne() -- Mara passes away
    c.RandomFor(30)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne()
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

    return true
end

local function _wingToKeeleon()
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne()
    c.WaitFor(5)
    c.UntilNextInputFrame()

    c.PushA() -- Bring up menu
    c.UntilNextMenuY()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to status')
    end
    c.PushRight()
    if c.ReadMenuPosY() ~= 33 then
        return c.Bail('Unable to navigate to item')
    end
    c.PushA()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushA() -- Pick Mara
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Gunpowder Jar')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Unable to navigate to Wing')
    end
    c.PushA() -- Pick Wing    
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushA() -- Use
    c.WaitFor(4)
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Keeleon')
    end
    c.PushA()
    c.RandomFor(1)
    c.WaitFor(100)
    c.UntilNextInputFrame()

    return true
end

local function _enterKeeleon()
    c.RandomFor(14)
    c.WaitFor(1)
    c.PushUp()
    c.RandomFor(20)
    c.WaitFor(30)
    c.UntilNextInputFrame()
    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
    local result = c.Best(_deathWarp, 20)
    if result > 0 then        
        result = c.Best(_wingToKeeleon, 20)
        if result > 0 then
            result = c.Best(_enterKeeleon, 50)
            if result > 0 then
                c.Done()
            end
        end        
    end
end

c.Finish()
