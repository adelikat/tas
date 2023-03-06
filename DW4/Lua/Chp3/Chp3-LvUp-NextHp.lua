-- Starts from the first input frame to press A or B
-- after Taloon's level goes up
-- Manipulates a minimum of 2 agility then
-- Ensures only Str, Ag, Vit, and HP go up
-- Looks for 'Jackpot' scenarios of skipping HP
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 29
local vitDelay = 5
local minAg = 2
local minHpValue = 8
local hpDelay = 20

local bestVit = 0
local bestVitDelay = vitDelay

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

local function _vit()
    local origStat = c.Read(c.Addr.TaloonVit)
    local delay = c.DelayUpToForLevels(bestVitDelay)
	c.RndAorB()
    c.WaitFor(30)
	c.UntilNextInputFrame()

    local currStat = c.Read(c.Addr.TaloonVit)
    local gain = currStat - origStat
    c.Debug('Gain: ' .. gain)    
    if gain > bestVit then
        bestVit = gain
        c.Log(string.format('New Best Vit: %s delay: ', gain, delay))
        c.Save(string.format('Vit%s-%s', gain, delay))
    elseif delay < bestVitDelay then
        bestVitDelay = delay
        c.Log(string.format('New Best Vit: %s delay: ', gain, delay))
        c.Save(string.format('Vit%s-%s', gain, delay))
    end
    return gain >= 5
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
    c.Debug('Hp gain: ' .. gain)
    if gain >= minHpValue then
        return true
    else
        c.Log(string.format('Got int and luck skip, gain %s, delay %s', gain, delay))
        c.Save(string.format('Hp%s-delay-%s', gain, delay))
    end

    return false
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
    local result = true
    if minAg > 0 then
        result = c.ProgressiveSearchForLevels(_ag, 20)
    end
    local hpCap = 100
	local result = c.Cap(_vit, 100)
    if result then
        c.Log('Got 5 vit, expanding hp delay')
        hpDelay = hpDelay + 10
        hpCal = 200
    end

    result = c.ProgressiveSearchForLevels(_hp, hpCap)
    if result then
        c.Done()
    else
        c.Log('Failed to get stat')
    end
end

c.Finish()
