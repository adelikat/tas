-- Starts on the overworld at the 1st frame BEFORE the one that pressing right starts moving right
-- at the farthest left square from the save, to maximize possible 2nd rng values
-- goes through and end the chapter
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _isEncounter()
    return c.ReadEGroup1Type() ~= 0xFF
end

local function _walkOneSquareRight()
    c.PushRight()
    c.RandomFor(14)
    c.WaitFor(1)
    return not _isEncounter()
end

local function _walkToCave()
    for i = 0, 4, 1 do
        local result = _walkOneSquareRight()
        if not result then
            return false
        end
    end

    c.WaitFor(2)
    c.UntilNextInputFrame()

    return true
end

local function _leaveCave()
    c.PushUp()
    c.RandomFor(11)
    c.WaitFor(1)
    c.PushFor('Up', 3)

    c.RandomFor(12)
    c.WaitFor(1)
    c.PushFor('Right', 3)
    c.RndUntilX('Right', 10)
    c.RandomFor(12)
    c.WaitFor(1)
    c.PushFor('Up', 3)

    c.RndUntilY('Up', 6)
    c.RandomFor(12)
    c.WaitFor(1)
    c.PushFor('Right', 3)

    c.RndUntilX('Right', 19)
    c.RandomFor(12)
    c.WaitFor(1)
    c.PushFor('Up', 3)
    c.RandomFor(12)
    c.WaitFor(1)
    c.PushFor('Right', 3)

    c.RndUntilX('Right', 31)
    c.RandomFor(12)
    c.WaitFor(1)
    c.PushFor('Up', 3)
    c.RndWalkingFor('Up', 65)

    c.UntilNextInputFrame()

    return true
end

local function _toChp4()
    c.RandomFor(2) -- Magic frame
    c.UntilNextInputFrame()

    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame() -- The End of Chapter 3

    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(350)
    c.UntilNextInputFrame() 

    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.RandomFor(2) -- Magic Frame
    c.UntilNextInputFrame()

    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushA() -- Yes
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.WaitFor(1)
    c.RndAtLeastOne() -- Chapter 4 The Sisters of Monbaraba
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.RandomFor(2) -- Magic Frame
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

local function _do()
    local result = c.Best(_walkToCave, 9)
    if result > 0 then 
        result = c.Best(_leaveCave, 9) 
        if result > 0 then
            result = c.Best(_toChp4, 4)
            if result > 0 then
                return true
            end
        end
    end

    return false
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)

    --local result = c.Cap(_walkToCave, 10)
    --local result = c.Cap(_leaveCave, 10)
    --local result = c.Cap(_toChp4, 10)
    local result = c.Best(_do, 9)
    if result > 0 then 
        c.Done()
    end
end

c.Finish()



