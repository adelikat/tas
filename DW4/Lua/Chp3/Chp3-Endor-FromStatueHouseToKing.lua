-- Starts at the last lag frame after leaving the house where you sell the status
-- Manipulates up to the king's chamberts
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 10000

local function _openDoor()
    c.PushDown()
    c.RndWalkingFor('Down', 13)
    c.WaitFor(1)
    c.PushFor('Left', 3)
    c.RndUntilX('Left', 37)
    c.RndWalkingFor('Up', 12)
    c.WaitFor(1)
    c.PushUp()
    c.RndUntilY('Up', 13)
    c.RndWalkingFor('Up', 12)
    c.WaitFor(1)
    c.PushFor('Left', 3)
    c.RndUntilX('Left', 24, 350)
    c.RndWalkingFor('Left', 12)
    c.WaitFor(1)
    c.PushFor('Up', 2)
    c.RndUntilY('Up', 10)
    c.WaitFor(1)
    c.PushA()
    c.RandomFor(10)
    c.UntilNextMenuY()
    c.UntilNextMenuY()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to status')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Unable to navigate to equip')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then
        return c.Bail('Unable to navigate to door')
    end
    c.PushA()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.RandomFor(10)
    c.PushFor('Up', 6)
    c.RndWalkingFor('Up', 16)

    c.UntilNextInputFrame()

    return true
end

local function _enterKingsChambers()
    c.PushLeft()
    c.RndWalkingFor('Left', 13)
    c.WaitFor(1)
    c.PushFor('Up', 3)
    c.RndWalkingFor('Up', 170)
    c.UntilNextInputFrame()
    return true
end

local function _do()
    local result = c.Best(_openDoor, 9)
    if result > 0 then
        result = c.Best(_enterKingsChambers, 9)
        return result > 0
    end
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
    result = c.Best(_do, 5)
    if result > 0 then
        c.Done()
    end
end

c.Finish()



