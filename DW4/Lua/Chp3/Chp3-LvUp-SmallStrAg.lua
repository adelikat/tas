-- Starts from the first input frame to press A or B
-- after Taloon's level goes up
-- Manipulates a minmum str, that is not the max possible
-- Similar for Agility
-- Uses the assumption that Str, Ag is easy to manipulate
-- To emphasize getting more HP
-- Looks for 'Jackpot' scenarios of skipping HP
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 29
local minStr = 4
local minAg = 2
local minVit = 1
local idealHp = 12

local function _magicFrame()
    local origStat = c.Read(c.Addr.TaloonStr)
    c.RandomFor(1)
    c.WaitFor(5)
	c.UntilNextInputFrame()

    local currStat = c.Read(c.Addr.TaloonStr)

    c.Debug('Str Gain: ' .. currStat - origStat)
    c.Debug('Need to get: ' .. minStr)
    return currStat - origStat >= minStr
end

local function _str()    
	c.RndAorB()
	c.WaitFor(200)
	c.UntilNextInputFrame()	
	return c.Cap(_magicFrame, 20)
end

local function _ag()
    local origStat = c.Read(c.Addr.TaloonAg)
    c.RndAorB()
    c.WaitFor(30)
	c.UntilNextInputFrame()

    local currStat = c.Read(c.Addr.TaloonAg)
    local gain = currStat - origStat
    c.Debug('Ag Gain: ' .. gain)
    if gain == 0 then
        c.Log('Jackpot!! No agility')
        c.Save('AgSkip-'..emu.framecount())
    end

    return currStat - origStat >= minAg
end

local function _failLowManip(stat)
    c.Log('---- :(')
    c.Log(string.format('Unable to manipulate an easy stat: %s', stat))
    return false
end

local function _vit()
    local origStat = c.Read(c.Addr.TaloonVit)
    c.RndAorB()
    c.WaitFor(30)
	c.UntilNextInputFrame()

    local currStat = c.Read(c.Addr.TaloonVit)
    local gain = currStat - origStat
    c.Debug('Vit Gain: ' .. gain)
    if gain == 0 then
        c.Log('Jackpot!! No vitality')
        c.Save('VitSkip-'..emu.framecount())
    end

    return currStat - origStat >= minVit
end

local function _hp()
    local origInt = c.Read(c.Addr.TaloonInt)
    local origLuck = c.Read(c.Addr.TaloonLuck)
    local origHp = c.Read(c.Addr.TaloonMaxHP)

    c.RndAorB()
    c.WaitFor(20)
    c.UntilNextInputFrame()

    local currLuck = c.Read(c.Addr.TaloonLuck)
    if currLuck > origLuck then
        return c.Bail('Got luck')
    end

    local currInt = c.Read(c.Addr.TaloonInt)
    if currInt > origInt then
        return c.Bail('Got int')
    end     

    local currHp = c.Read(c.Addr.TaloonMaxHP)
    local gain = currHp - origHp

    if gain == 0 then
        c.Log('------')
        c.Log('Jackpot, 0 HP')
        c.Save(string.format('HpSkip-frame-%s', emu.framecount()))
        return true
    end
    c.Debug('Hp gain: ' .. gain)
    if gain >= idealHp then
        return true
    else
        c.Log(string.format('Got int and luck skip, gain %s, frame %s', gain, emu.framecount()))
        c.Save(string.format('Hp%s-frame-%s', gain, emu.framecount()))
    end

    return false
end


local function _do()
    -- local result = c.ProgressiveSearchForLevels(_str, 10)
    -- if not result then
    --     return _failLowManip('str')
    -- end

    result = c.ProgressiveSearchForLevels(_ag, 15)
    if not result then
        return _failLowManip('agility')
    end

    result = c.ProgressiveSearchForLevels(_vit, 1)
    if not result then
        return _failLowManip('vitality')
    end

    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
    --local result = c.Cap(_do, 100)
    local result = c.ProgressiveSearchForLevels(_hp, 30)
    if result then
        c.Done()
    else
        c.Log('Failed to get level')
    end
end

c.Finish()
