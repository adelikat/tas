-- Starts at first frame to end 'Skeleton has a treasure chest' message
-- Manipulates Lv 5 stats
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
local targetStrGain = 3
local firstDelay = 0
local function _readStr()
	return c.Read(c.Addr.AlenaStr)
end

local function _readAg()
    return c.Read(c.Addr.AlenaAg)
end

local function _readVit()
	return c.Read(c.Addr.AlenaVit)
end

local function _readInt()
    return c.Read(c.Addr.AlenaInt)
end

local function _readLuck()
    return c.Read(c.Addr.AlenaLuck)
end

local function _str()
    local origStr = _readStr()
    firstDelay = c.DelayUpTo(6)
    c.RndAorB() -- Skeleton has a treasure chest
    c.WaitFor(38)
    c.UntilNextInputFrame()
    
    c.RndAorB() -- Alena opens the treasure chest
    c.WaitFor(45)
    c.UntilNextInputFrame()

    c.RndAorB() -- Finds the Iron Claw
    c.WaitFor(240)
    c.UntilNextInputFrame()

    c.RandomFor(1) -- Magic frame
    c.WaitFor(9)

    local currStr = _readStr()
    if currStr - origStr < targetStrGain then
        return c.Bail('Not enough str: ' .. (currStr - origStr))
    end

    c.UntilNextInputFrame()

    return true
end

local function _remainingStats()
    local origInt = _readInt()
    local origLuck = _readLuck()
    c.DelayUpTo(5)
    
    c.RndAorB() -- Got str, will get ag
    c.WaitFor(49)
    c.UntilNextInputFrame()

    -- Ag is not skippable but it is irrelevant how much we get
    c.RndAorB() -- Got Ag, will get vitality
    c.WaitFor(49)
    c.UntilNextInputFrame()

    -- Amount of vitality is not relevant either
    c.RndAorB()
    c.WaitFor(50)

    local currInt = _readInt()
    if currInt > origInt then
        return c.Bail('Got Int')
    end

    local currLuck = _readLuck()
    if currLuck > origLuck then
        return c.Bail('Got luck')
    end

    return true
end

c.Load(0)
c.Save(100)
while not c.done do
    c.Load(100)    
	local result = c.Cap(_str, 200)
    if c.AddToRngCache() then
        if result then
            result = c.ProgressiveSearch(_remainingStats, 25, 12 - firstDelay)    
            if result then
                c.Done()
            else
                c.Log('Unable to skip int and luck')    
            end
            
        else
            c.Log('Unable to get str')
        end
    else
        c.Log('Rng already exists')
    end

	c.Increment()
end

c.Finish()
