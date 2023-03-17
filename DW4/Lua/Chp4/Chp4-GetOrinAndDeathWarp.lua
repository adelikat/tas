-- Starts at the last lag frame after leaving Monbaraba to the overworld
-- Manipulates entering the cave west of Kievs
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _getOrin()
    local result = c.WalkRight(5)
    if result == 0 then return false end

    result = c.Best(c.WalkRightToCaveTransition, 10)
    if result == 0 then return false end

    result = c.WalkMap({
        { ['Right'] = 14 },
        { ['Down'] = 12  },
        { ['Left'] = 11 },
        { ['Down'] = 3 },
        { ['Left'] = 2 }
      })
    if not result then return false end

    c.PushDown()
    c.UntilNextMenuY()
    c.WaitFor(2)
    c.UntilNextInputFrame()

    c.PushA()
    c.RandomFor(10) -- Magic frame in here
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
    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    return true
end

-- Starts on the first frame possible to close the
-- dialog with Orin
local function _getEncounter()
    c.RndAtLeastOne()
    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.RandomFor(14)
    c.WaitFor(1)
    local direction = 'Right'
    if c.GenerateRndBool() then
        direction = 'Down'
    end
    c.PushFor(direction, 1)
    c.RandomFor(15)
    c.WaitFor(10)

    if not c.IsEncounter() then
        return c.Bail('Did not get encounter')
    end

    if c.ReadEGroup2Type() ~= 0xFF then
        return c.Bail('Got 2nd enemy group')
    end

    c.Log('Got Encounter')
    c.UntilNextInputFrame()
    c.Save(string.format('aaaEncounter-%s-fr-%s-RNG2-%s', c.ReadEGroup1Type(),  emu.framecount(), c.ReadRng2()))
    return false
end


c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)

    local result = c.Cap(_getOrin, 25)
    if result then
        result = c.Cap(_getEncounter, 500)
        if result then
            c.Done()
        end
    else
        c.Log('No best result')
    end
end

c.Finish()
