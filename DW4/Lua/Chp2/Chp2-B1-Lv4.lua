--Starts from the first frame to advance the menu after
-- the last stat from the previous level
local c = require("DW4-ManipCore")

c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 15

local origInt
local origLuck

local function _bail(msg)
	c.Debug(msg)
	c.Increment()
	return false
end

local function _str()
    return c.Read(c.Addr.AlenaStr)
end

local function _ag()
    return c.Read(c.Addr.AlenaAg)
end

local function _vit()
    return c.Read(c.Addr.AlenaVit)
end

local function _int()
    return c.Read(c.Addr.AlenaInt)
end

local function _luck()
    return c.Read(c.Addr.AlenaLuck)
end

local function _strAndVit()
    local origStr = _str()
    local origAg = _ag()
    local origVit = _vit()

    c.DelayUpTo(5)
    c.RndAorB() -- Agiliy goes up x points
    c.RandomFor(1)
    c.WaitFor(198)
    c.UntilNextInputFrame()

    c.RandomFor(1) -- Magic frame
    c.WaitFor(7)
    c.UntilNextInputFrame()

    local currStr = _str()
    if currStr - origStr < 3 then
        return _bail('Not enough str')
    end

    c.RndAorB() -- Alena level goes up
    c.RandomFor(1)
    c.WaitFor(46)

    local currAg = _ag()

    if currAg == origAg then
        c.Log('Jackpot!! Agility skip')
        c.Save('Lv4-AgSkip-Rng2-' .. c.ReadRng2() .. '-Rng1-' .. c.ReadRng1() .. '-' .. emu.framecount())
        return true
    end

    c.UntilNextInputFrame() -- Strength goes up
    c.DelayUpTo(c.maxDelay)
    c.RndAorB()
    c.RandomFor(1)
    c.WaitFor(46)

    local currVit = _vit()

    if currVit == origVit then
        c.Log('Jackpot!! Vit skip')
        c.Save('Lv4-VitSkip-Rng2-' .. c.ReadRng2() .. '-Rng1-' .. c.ReadRng1() .. '-' .. emu.framecount())
    end

    local targetVit = origVit + 3
    if currVit > targetVit then
        return _bail('Got too much vitality')
    end
    c.UntilNextInputFrame()
    c.Save('Lv4-Str-Vit-2-Rng2-' .. c.ReadRng2() .. '-Rng1-' .. c.ReadRng1() .. '-' .. emu.framecount())

    return true
end

local function _luckAndIntSkip()
    c.RndAorB()
    c.RandomFor(1)
    c.WaitFor(40)
    c.UntilNextInputFrame()
    
    local currInt = _int()
    if currInt > origInt then
        return _bail('Got int')
    end

    local currLuck = _luck()
    if currLuck > origLuck then
        return _bail('Got luck')
    end

    return true
end

c.Load(0)
c.Save(100)
while not c.done do
	c.Load(100)
    origInt = _int()
    origLuck = _luck()
	local result = c.Cap(_strAndVit, 100)
    if result then
        c.Log('Got Vit and Str, searching for Luck and Int Skip')        
        result = c.ProgressiveSearch(_luckAndIntSkip, 5, 25)
        if result then
            local framecount = emu.framecount()
            c.Log('Found! ' .. framecount)
            c.Save('Lv4Done-' .. framecount)
        else
            c.Log('Failed to find Luck and Int')
        end
    end
    
	c.Increment()
end

c.Finish()


