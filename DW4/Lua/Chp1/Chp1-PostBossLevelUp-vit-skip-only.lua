--Starts at the first frame of menuing after the last Saro miss ('nimbly')
--Assumes Saro has low enough HP that Ragnar can defeat him with a regular attack (14-18 HP)

local c = require("DW4-ManipCore")
c.InitSession()
c.maxDelay = 60
c.reportFrequency = 1000
local level = 4
local function _bail(msg)
	c.Debug(msg)
	c.Increment()
	return false
end

local randomDelay = {}
function GetRandomSet(maxSize, count)
    local payload = {}
    for i = 0, count - 1 do
       payload[i] = math.floor(math.random(0, maxSize) / count)
    end
  
    return payload
end
  
local function _delay(key)
    local delayAmt = randomDelay[key]
    c.WaitFor(delayAmt)
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
   _delay(0)
	c.RndAtLeastOne()
	c.RandomFor(10)
	c.WaitFor(10)
	c.UntilNextInputFrame()
	c.WaitFor(2)

	_delay(1)
	c.RndAtLeastOne() -- Ragnar Attacks
	c.RandomFor(2)
	c.WaitFor(5)

	if c.ReadE1Hp() ~= 0 then
		return _bail('Failed to do enough damange to Saro')
	end

	c.WaitFor(40)
	c.UntilNextInputFrame()
	c.WaitFor(2)

	_delay(2)
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
	   -- _delay(1)
	   x = c.DelayUpTo(c.maxDelay)
	   c.Debug('delaying: ' .. x)
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
		c.Log(string.format('Lv %s Vitality skip framecount: %s', level, emu.framecount()))
		c.Save(string.format('Chp1Lv%s-Vit-Skip-ButOtherStats-FrameCount-%s', level, emu.framecount()))
		return false
	end

    if strSkip then
        c.Log('Jackpot!!! No stats in level ')
        c.Save(string.format('Lv%sStatSkip-FrameCount-%s', level, emu.framecount()))
        c.Done()
    else
        local rng1 = c.ReadRng1()
        local rng2 = c.ReadRng2()
        c.Log(string.format('Lv %s manipulated, FrameCount: %s', level, emu.framecount()))
        c.Save(string.format('Chp1Lv%s-Rng1-%s-Rng2-%s-FrameCount-%s', level, rng1, rng2, emu.framecount()))
    end

    return true
end

local function _manipLv2()    
    local origStats = _getStats()

	_defeatSro()

	_delay(3)
	c.RndAtLeastOne() -- Saro's Shadow was defeated
	c.RandomFor(21)
	c.WaitFor(280)

	if _ragnarLevel() ~= 2 then
		return _bail('Failed to get to level 2')
	end
	
	c.UntilNextInputFrame()

	return _manipLevel(2, origStats)
end
--[[
local function _manipLv3()
    --Setup next magic frame
    c.WaitFor(155)
    c.UntilNextInputFrame()    
    return _manipLevel(3, _getStats())
end
]]
c.Save(100)
while not c.done do
	c.Load(100)
    randomDelay = GetRandomSet(c.maxDelay, 5)
	--local result = _manipLv2()
	local result = _manipLevel(level, _getStats())
	--if result then
        --delay = c.maxDelay - 1 
        --c.Log(string.format('Successfully manipulated lv %s, framecount: %s', level, emu.framecount()))
        --local rng1 = c.Read(0x0012)
       -- local rng2 = c.Read(0x0013)
       -- c.Save(string.format('Chp1Lv2-Delay-%s-Rng1-%s-Rng2-%s', delay, rng1, rng2))
        --if delay < 0 then
         --   c.Done()
          --  c.Save(9)
        --end
	--end

	c.Increment()
end

c.Finish()
