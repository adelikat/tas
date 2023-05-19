--Starts at the first frame of menuing after the last Saro miss ('nimbly')
--Assumes Saro has low enough HP that Ragnar can defeat him with a regular attack (14-18 HP)

local c = require("DW4-ManipCore")
c.InitSession()
c.maxDelay = 70
c.reportFrequency = 1000
local level = 8
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

-- Starts from the magic frame before the level
local function _manipLevel(level, origStats)
    local delay = 0
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
	   delay = c.DelayUpTo(c.maxDelay)
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
		c.Save(string.format('aaChp1Lv%s-Vit-Skip-ButOtherStats-FrameCount-%s', level, emu.framecount()))
		return false
	end

    if strSkip then
        c.Log('Jackpot!!! No stats in level ')
        c.Save(string.format('aaLv%sStatSkip-FrameCount-%s', level, emu.framecount()))
        c.Done()
    else
        local rng1 = c.ReadRng1()
        local rng2 = c.ReadRng2()
        c.Log(string.format('Lv %s manipulated, FrameCount: %s', level, emu.framecount()))
        c.Save(string.format('aaChp1Lv%s-FrameCount-%s-Rng2-%s-Rng1-%s', level, emu.framecount(), rng2, rng1))
    end

    c.Log('Found with delay: ' .. delay)
    return true
end

--There is an extra magic frame for lv 5
function _level5Setup()
    c.RandomFor(2)
    c.WaitFor(160)
    c.UntilNextInputFrame()
end

c.Save(100)
while not c.done do
	c.Load(100)
    if level == 5 then
        _level5Setup()
    end
    randomDelay = GetRandomSet(c.maxDelay, 5)
	local result = _manipLevel(level, _getStats())
	
	c.Increment()
end

c.Finish()
