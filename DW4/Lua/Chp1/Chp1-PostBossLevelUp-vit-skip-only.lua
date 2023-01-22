--Starts at the first frame of menuing after the last Saro miss ('nimbly')
--Assumes Saro has low enough HP that Ragnar can defeat him with a regular attack (14-18 HP)

local c = require("DW4-ManipCore")
c.InitSession()
c.maxDelay = 0
c.reportFrequency = 1000
local delay = 0

local function _bail(msg)
	c.Debug(msg)
	c.Increment()
	return false
end

local function _delay()
    delay = delay + c.DelayUpTo(c.maxDelay - delay)
end

local function _ragnarLevel()
    local _ragLvAddr = 0x60BA
	return c.Read(_ragLvAddr)
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

local function _defeatSro()
   _delay()
	c.RndAtLeastOne()
	c.RandomFor(10)
	c.RandomFor(5)
	c.UntilNextInputFrame()
	c.WaitFor(2)

	_delay()
	c.RndAtLeastOne() -- Ragnar Attacks
	c.RandomFor(2)
	c.WaitFor(5)

	if c.ReadE1Hp() ~= 0 then
		return _bail('Failed to do enough damange to Saro')
	end

	c.WaitFor(40)
	c.UntilNextInputFrame()
	c.WaitFor(2)

	_delay()
	c.RndAtLeastOne() -- x Dmg to Saro's Shadow
	c.RandomFor(1)
	c.WaitFor(18)
	c.UntilNextInputFrame()
	c.WaitFor(2)

    return true
end

-- Starts from the magic frame before the level
local function _manipLevel(level, origStats)
    c.RandomFor(1)
    c.WaitFor(6)
    local strSkip = false
    local newStats = _getStats()
	if newStats.Strength == origStats.Strength then
		c.Log(string.format('Lv %s - Manipulated no str! (continuing)', level))
		strSkip = true
	end

    if not strSkip then
        c.UntilNextInputFrame()
	    _delay()
	    c.RndAorB() -- Ragnar's Level goes up
    end
	
	c.WaitFor(49)
    newStats = _getStats()

    if newStats.Agility > origStats.Agility then
		return _bail(string.format('Lv %s - Got agility increase, bailing', level))
	end

    if newStats.Vitality > origStats.Vitality then
	 	return _bail(string.format('Lv %s - Got vitality, bailing', level))
	end
	
	if newStats.Luck > origStats.Luck or newStats.Int > origStats.Int then
		c.Log(string.format('Lv %s Vitality skip delay: %s', level, delay))
		c.Save(string.format('Chp1Lv2-Vit-Skip-ButOtherStats-Delay-%s', delay))
		return false
	end

    if strSkip then
        c.Log('Jackpot!!! No stats in level ')
        c.Save(string.format('Lv%sStatSkip-Delay-%s', level, delay))
        c.Done()
    else
        local rng1 = c.ReadRng1()
        local rng2 = c.ReadRng2()
        c.Log(string.format('Lv %s manipulated, delay: %s', level, delay))
        c.Save(string.format('Chp1Lv%s-Rng1-%s-Rng2-%s-Delay-%s', level, rng1, rng2, delay))
    end

    return true
end

local function _manipLv2()    
    local origStats = _getStats()

	_defeatSro()

	_delay()
	c.RndAtLeastOne() -- Saro's Shadow was defeated
	c.RandomFor(21)
	c.WaitFor(280)

	if _ragnarLevel() ~= 2 then
		return _bail('Failed to get to level 2')
	end
	
	c.UntilNextInputFrame()

	return _manipLevel(2, origStats)
end

local function _manipLv3()
    --Setup next magic frame
    c.WaitFor(155)
    c.UntilNextInputFrame()    
    return _manipLevel(3, _getStats())
end

c.Save(100)
while not c.done do
    _pokeRng()
	c.Load(100)
	delay = 0

	local result = _manipLv2()
	if result then       
        c.Log(string.format('Successfully manipulated lv 2, delay: %s', level, delay))
        local rng1 = c.Read(0x0012)
        local rng2 = c.Read(0x0013)
        c.Save(string.format('Chp1Lv2-Delay-%s-Rng1-%s-Rng-2%s', delay, rng1, rng2))
        --if delay < 0 then
         --   c.Done()
          --  c.Save(9)
        --end
	end

	c.Increment()
end

c.Finish()
