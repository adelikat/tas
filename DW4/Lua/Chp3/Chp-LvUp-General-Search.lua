-- Starts from the first input frame to press A or B to get
-- the last stat of the previous level
-- Ensures only Str, Ag, Vit, and HP go up
-- Looks for 'Jackpot' scenarios of skipping one of these major stats
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
local minStr = 4
local minAg = 2
local minVit = 3
local minHp = 7

-- Lv2 gets extra menuing
local function _lv2()
    c.RndAorB()
    c.WaitFor(30)
    c.UntilNextInputFrame()

    c.RndAorB()
    c.WaitFor(20)
    c.UntilNextInputFrame()
end

local function _jackPot(stat)
    c.Log(string.format('Jackpot!! No %s', stat))
    c.Save(string.format('Jackpot-No%s-%s', stat, emu.framecount()))
    c.Done()
    return true
end

local function _magicFrame()
    local origStat = c.Read(c.Addr.TaloonStr)
    c.RandomFor(1)
    c.WaitFor(5)
	c.UntilNextInputFrame()

    local currStat = c.Read(c.Addr.TaloonStr)

    c.Debug('Gain: ' .. currStat - origStat)
    return currStat - origStat >= minStr
end

local function _str()    
	c.RndAorB()
	c.WaitFor(200)
	c.UntilNextInputFrame()	

    c.Debug('Trying with delay: ' .. delay)

	return c.Cap(_magicFrame, 20)
end

local function _ag()
    local origAg = c.Read(c.Addr.TaloonAg)
    c.Debug('Orig Ag: ' .. origAg)
    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()

    local currAg = c.Read(c.Addr.TaloonAg)
    if currAg == orgAg then
        return _jackPot('ag')
    end

    c.Debug('Ag gain: ' .. currAg - origAg)
    return currAg - origAg >= minAg
end

local function _vit()
    local origVit = c.Read(c.Addr.TaloonVit)
    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()

    local currVit = c.Read(c.Addr.TaloonVit)
    if currVit == origVit then
        return _jackPot('vit')
    end

    c.Debug('Vit gain: ' .. currVit - origVit)
    return currVit - origVit >= minVit
end

local function _hp()
    c.Debug('Hp attempt, frame: ' .. emu.framecount())

    local origInt = c.Read(c.Addr.TaloonInt)
    local origLuck = c.Read(c.Addr.TaloonLuck)
    local origHp = c.Read(c.Addr.TaloonMaxHP)

    c.RndAorB()
    c.WaitFor(10)
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
    c.Debug('Hp gain: ' .. currHp - origHp)
    if currHp == origHp then
        return _jackPot('HP')
    end
    return currHp - origHp >= minHp
end

local function _do()
    local result = c.ProgressiveSearch(_str, 10, 50, true)
    if not result then
        return false
    end

    c.Log('Str found')
    result = c.ProgressiveSearch(_ag, 20, 50, true)
    if not result then
        return false
    end

    c.Log('Ag found')
    result = c.ProgressiveSearch(_vit, 20, 50, true)
    if not result then
        return false
    end

    c.Log('Vitality found')    
    result = c.ProgressiveSearch(_hp, 20, 100, true)
    if not result then
        return false
    end

    c.Log('-----')
    c.Log('Level up Found')
    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
   -- _lv2()
	local result = c.Best(_do, 0)
    if result then
        c.Done()
    end
end

c.Finish()
