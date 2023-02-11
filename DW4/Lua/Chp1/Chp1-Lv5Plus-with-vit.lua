--Starts at the first frame of menuing after the last Saro miss ('nimbly')
--Assumes Saro has low enough HP that Ragnar can defeat him with a regular attack (14-18 HP)

local c = require("DW4-ManipCore")
c.InitSession()
c.maxDelay = 2
c.reportFrequency = 1000
local delay = 0
local level = 7
local maxVitGain = 3
local maxHpGain = 4
local origStats
local function _bail(msg)
	c.Debug(msg)
	c.Increment()
	return false
end

local function _getStats()
    return {
        Strength = c.Read(0x60BB),
        Agility = c.Read(0x60BC),
        Vitality = c.Read(0x60BD),
        Luck = c.Read(0x60BF),
        Int = c.Read(0x60BE),
        MaxHp = c.Read(0x60C1)
    }
end

-- Starts from the frame before the previous level stat
local function _manipLevel()
    delay = delay + c.DelayUpTo(c.maxDelay - delay)
    c.RndAorB() -- Ragnar's Vitality goes up
    c.RandomFor(1)
    c.WaitFor(220)
    c.UntilNextInputFrame()

    c.RandomFor(1)
    c.WaitFor(6)

    local currStats = _getStats()
	if currStats.Strength == origStats.Strength then
		c.Log(string.format('Lv %s - Manipulated no str! This situation is not coded, bailing', level))
        c.Save(string.format('Lv %s - Str Skip - %s', level, emu.framecount()))
		return _bail('Skipped str, which is good but not smart enough to code this scenario')
	end
    
    c.UntilNextInputFrame()
	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.Debug('delaying: ' .. x)
	c.RndAorB() -- Ragnar's Level goes up
	c.WaitFor(44)
    c.UntilNextInputFrame()

    currStats = _getStats()
    
    if currStats.Agility > origStats.Agility then
        return _bail(string.format('Got agility, bailing %s %s', currStats.Agility, origStats.Agility))
    end

    if currStats.Vitality == origStats.Vitality then
        c.Log('Jackpot!! Got vitality skip')
        c.Save(string.format('aaaaLv%s-VitSkip-%s', level, emu.framecount()))
        c.Done()
    end

    targetVit = origStats.Vitality + maxVitGain
    if currStats.Vitality > targetVit then
        return _bail(string.format('Too much vitality: %s', currStats.Vitality ))
    end

    delay = delay + c.DelayUpTo(c.maxDelay - delay)
    c.RndAorB() -- Ragnar's Str goes up
    c.WaitFor(45)
    c.UntilNextInputFrame()

    currStats = _getStats()
    if currStats.Luck > origStats.Luck then
        c.Log('Got luck')
        return _bail('Got luck')
    end

    if currStats.Int > origStats.Int then
        c.Log('Got Int delay: ' .. delay)
        c.Save(4)
        return _bail('Got Int')
    end
    c.Save(5)
    c.Log('Got to HP!')
    targetHp = origStats.MaxHp + maxHpGain
    if currStats.MaxHp > targetHp then
        c.Log('Too much HP: ' .. currStats.MaxHp - origStats.MaxHp)
        return _bail('Too much HP: ' .. currStats.MaxHp - origStats.MaxHp)
    end

    return true
end

c.Save(100)
while not c.done do
	c.Load(100)
    origStats = _getStats()
    local result = c.ProgressiveSearch(_manipLevel, 30, 300)
    if result then
        c.Log(string.format('Success! Delay: %s', delay))
        c.Save(9)
        c.Done()
    else
        c.Log('Failed to find a result')
        c.Increment()
    end
end

c.Finish()
