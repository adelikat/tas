--Starts from the first frame to advance the menu after
-- the last stat from the previous level
local c = require("DW4-ManipCore")

c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 15

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

local function _lv3()
    local origStr = _str()
    local origAg = _ag()
    local origVit = _vit()
    local origInt = _int()
    local origLuck = _luck()

    c.DelayUpTo(c.maxDelay)
    c.RndAorB() -- Agiliy goes up x points
    c.RandomFor(1)
    c.WaitFor(200)
    c.UntilNextInputFrame()

    c.RandomFor(1) -- Magic frame
    c.WaitFor(7)
    c.UntilNextInputFrame()

    local currStr = _str()
    if currStr - origStr < 2 then
        return _bail('Not enough str')
    end

    c.RndAorB() -- Alena level goes up
    c.RandomFor(1)
    c.WaitFor(46)

    local currAg = _ag()
    if currAg - origAg < 1 then
        return _bail('Not enough agility')
    end

    c.UntilNextInputFrame() -- Strength goes up
    c.DelayUpTo(c.maxDelay)
    c.RndAorB()
    c.RandomFor(1)
    c.WaitFor(46)

    local currVit = _vit()
    if currVit > origVit then
        return _bail('Got vitality')
    end

    c.Log('Skipped vitality!')
    c.Save('Lv3-VitSkip-Rng2-' .. c.ReadRng2() .. '-Rng1-' .. c.ReadRng1() .. '-' .. emu.framecount())

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
	local result = c.Cap(_lv3, 1000)
    if result then
        c.Done()
    end
    
	c.Increment()
end

c.Finish()


