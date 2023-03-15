-- Starts at the last lag frame before the opening dance scene starts
-- Manipulates leaving Monbaraba to the overworld
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _toMorning()
    c.RandomFor(650)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.RandomFor(280)
    c.UntilNextInputFrame()

    c.RndAorB() -- Dialog with Nara
    c.WaitFor(10)
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

    c.WaitFor(1)
    c.RndAtLeastOne() -- Close dialog
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.RandomFor(100)
    c.UntilNextInputFrame()

    c.RndAorB() -- Dialog with Boss
    c.WaitFor(10)
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

    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(30)
    c.UntilNextInputFrame()

    c.RandomFor(1) -- Input frame
    c.WaitFor(5)
    c.UntilNextInputFrame()

    return true
end

local function _leaveMonbaraba()
    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.PushA() -- Bring up menu
    c.UntilNextMenuY()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Failed to navigate to status')
    end
    c.PushRight()
    if c.ReadMenuPosY() ~= 33 then
        return c.Bail('Failed to navigate to item')
    end
    c.PushDown()
    if c.ReadMenuPosY() ~= 34 then
        return c.Bail('Failed to navigate to tactics')
    end
    c.PushA()
    c.RandomForLevels(2)
    c.UntilNextInputFrame()

    c.PushA()
    c.RandomForLevels(2)
    c.UntilNextInputFrame()

    c.PushA()
    c.RandomForLevels(2)
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Failed to navigate to Mara')
    end
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushA() -- Pick Mara
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.RandomForLevels(2)
    c.UntilNextInputFrame()
    c.RandomForLevels(2)
    c.UntilNextInputFrame()

    c.PushA() -- Pick Nara
    c.WaitFor(2)
    c.UntilNextInputFrame()

    c.RandomForLevels(2)
    c.UntilNextInputFrame()

    c.WaitFor(2)
    c.RndAtLeastOne()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.RandomFor(30)
    c.PushFor('Right', 2)
    c.RndUntilX('Right', 31)

    c.RandomFor(13)
    c.WaitFor(1)

    c.PushDown('Down', 3)
    c.RandomFor(13)

    c.UntilNextMenuY()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Failed to navigate to status')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Failed to navigate to equip')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then
        return c.Bail('Failed to navigate to down')
    end
    c.PushA()
    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.RandomFor(13)
    c.PushFor('Down', 3)

    c.RndUntilY('Down', 6)
    c.RandomFor(12)
    c.WaitFor(1)
    c.PushFor('Left', 3)
    c.RandomFor(12)
    c.WaitFor(1)
    c.PushFor('Down', 3)
    c.RndUntilY('Down', 8)
    c.RandomFor(12)
    c.WaitFor(1)
    c.PushFor('Left', 3)
    c.RndUntilX('Left', 28)
    c.RandomFor(12)
    c.WaitFor(1)
    c.PushFor('Down', 3)
    c.RndUntilY('Down', 10)
    c.RandomFor(12)
    c.WaitFor(1)
    c.PushFor('Right', 3)

    local result = c.RndUntilX('Right', 33, 90)
    if not result then
        c.Bail('NPC got in the way')
    end

    c.RndWalkingFor('Right', 40)
    c.UntilNextInputFrame()

    return true
end

local function _do()
    local result = c.Best(_toMorning, 5)
    if result > 0 then
        result = c.Best(_leaveMonbaraba, 19)
        if result then
            return true
        end
    end

    return false
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
