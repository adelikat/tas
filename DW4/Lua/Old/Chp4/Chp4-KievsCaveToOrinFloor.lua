-- Starts at the last lag frame after leaving Monbaraba to the overworld
-- Manipulates entering the cave west of Kievs
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000



local function _floor1()
    local result = c.WalkMap({
        { ['Down'] = 2 },
        { ['Right'] = 2 }
    })

    if not result then return false end

    result = c.Best(c.WalkRightToCaveTransition, 10)
    if result == 0 then return false end

    result = c.WalkMap({
        { ['Right'] = 2 },
        { ['Up'] = 9 },
        { ['Left'] = 10 },
        { ['Up'] = 2 },
        { ['Left'] = 7 },
        { ['Up'] = 11 }
      })
    if not result then return false end

    result = c.Best(c.WalkUpToCaveTransition, 12)
    if result == 0 then return false end
    c.WalkUp(5)

    c.PushA()
    c.WaitFor(2)
    c.UntilNextMenuY()
    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.Search()
    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.WaitFor(2)
    c.RndAtLeastOne() -- Close dialog
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)

    c.WalkDown(5)

    result = c.Best(c.WalkDownToCaveTransition, 12)
    if result == 0 then return false end

    result = c.WalkMap({
        { ['Down'] = 2 },
        { ['Right'] = 7 },
        { ['Up'] = 4 },
        { ['Right'] = 8 },
        { ['Up'] = 6 }
    })

    result = c.Best(c.WalkUpToCaveTransition, 12)
    if result == 0 then return false end

    result = c.WalkMap({
        { ['Right'] = 1 },
        { ['Up'] = 4 }
    })

    result = c.Best(c.WalkUpToCaveTransition, 12)
    if result == 0 then return false end

    return true
end

local function _floor2()
    local result = c.WalkDown(5)
    if not result then return false end

    result = c.Best(c.WalkDownToCaveTransition, 10)
    if result == 0 then return false end

    result = c.WalkMap({
        { ['Down'] = 5 },
        { ['Left'] = 8 },
        { ['Up'] = 2 },
        { ['Left'] = 5 },
        { ['Down'] = 1 },
        { ['Left'] = 2 },
    })

    result = c.Best(c.WalkLeftToCaveTransition, 12)
    if result == 0 then return false end
    result = c.WalkLeft(4)

    result = c.Best(c.WalkLeftToCaveTransition, 12)
    if result == 0 then return false end

    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)

    local result = c.Best(_floor1, 15)
    if result > 0 then
        result = c.Best(_floor2, 15)
        if result > 0 then
            c.Done()
        end
    else
        c.Log('No best result')
    end
end

c.Finish()
