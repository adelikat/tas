-- Starts at the last lag frame when going through the transition
-- before the stairs to the room with the gunpowder jar
-- manipulates getting the jar, and an optimal encounter
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _path11()
    local result = c.WalkUp()
    if not result then return false end
    result = c.WalkLeft(3)

    return true
end

local function _path22()
    local result = c.WalkLeft(3)
    if not result then return false end
    result = c.WalkUp()
    return true
end

local function _path1()
    local result = c.WalkDown()
    if not result then return false end
    result = c.WalkRight(3)
    if not result then return false end
    c.WaitFor(2)
    c.UntilNextInputFrame()
    
    return true
end

local function _path2()
    local result = c.WalkRight(3)
    if not result then return false end
    result = c.WalkDown()
    if not result then return false end
    c.WaitFor(2)
    c.UntilNextInputFrame()
end

local function _do()
    local result = c.WalkRight(3)
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()

    return true
end

local function _do2()
    local result
    if c.GenerateRndBool() then
        result = _path11()
    else
        result = _path22()
    end
    if not result then return false end
  
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.Search()

    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.RndAorB()
    c.WaitFor(120)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    
    c.RndAtLeastOne()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.RandomFor(14)
    c.WaitFor(1)
    local result
    if c.GenerateRndBool() then
        result = _path1()
    else
        result = _path2()
    end

    if not result then return false end

    if c.ReadEGroup1Type() == 0xFF then
        return c.Bail('Did not get encounter')
    end

    if c.ReadEGroup2Type() ~= 0xFF then
        return c.Bail('Got 2nd enemy group')
    end    

    c.Log('Encounter found')
    c.Save(string.format('DeathWarp2Encounter-%s-fr-%s-rng2-%s', c.ReadEGroup1Type(), emu.framecount(), c.ReadRng2()))
    return false
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
    local result = c.Best(_do, 8)
    if result > 0 then
        result = c.Cap(_do2, 1000)
        if result then
            c.Done()
        else
            c.Log('No best result')
        end
    end    
end

c.Finish()
