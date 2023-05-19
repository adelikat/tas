--Starts at Ragnar walking up to the castle door in Burland
--Coordinates: X 18, Y 23

local c = require("DW4-ManipCore")

c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 0

local _rngSets = {}
_rngSets[1] = {}
_rngSets[2] = {}
_rngSets[3] = {}
local function _addRng(set)
	local rng1 = c.ReadRng1()
	local rng2 = c.ReadRng2()

	local rng = (rng2 * 256) + rng1
	if _rngSets[set][rng] ~= nil then
		c.Log(string.format('Already found RNG set:  rng1 %s rng2 %s', rng1, rng2))
		return false
	end

	_rngSets[set][rng] = rng
	c.Save(string.format('aaaChp1-StartLv5-%s-Rng2-%s-Rng1-%s', emu.framecount(), rng1, rng2))
	return true
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

local function _bail(msg)
	c.Debug(msg)
	c.Increment()
	return false
end


local function _enterCastle()
	c.RndWalkingFor('Up', 195)
	c.PushA() -- Open menu
	c.WaitFor(19)
	c.UntilNextInputFrame()
	c.PushDown() -- Down to Status
	if c.ReadMenuPosY() ~= 17 then
		c.Debug('Lag at menu')
		return false
	end
	c.WaitFor(1)
	c.PushDown() -- Down to Equip
	if c.ReadMenuPosY() ~= 18 then
		c.Debug('Lag at menu')
		return false
	end
	c.WaitFor(1)
	c.PushDown() -- Down to Door
	if c.ReadMenuPosY() ~= 19 then
		c.Debug('Lag at menu')
		return false
	end
	c.PushA()
	c.WaitFor(105)
	c.UntilNextInputFrame()
	c.PushFor('Up', 16)
	c.RndWalkingFor('Up', 16)
	c.WaitFor(60)
	c.UntilNextInputFrame()
	return true
end

function _walkToKing()
	c.PushFor('Right', 1)
	c.PushFor('Up', 17)
	c.RndWalkingFor('Up', 150)
	c.WaitFor(100)
	c.UntilNextInputFrame()

	c.RndAorB() -- Ragnar Welcome back
	c.RandomFor(1)
	c.WaitFor(40)
	c.UntilNextInputFrame()

	c.RndAorB() -- I'm truly impressed with your accomplishment
	c.RandomFor(1)
	c.WaitFor(49)
	c.UntilNextInputFrame()

	c.RndAorB() -- I'm proud of having a solider like you
	c.RandomFor(1)
	c.WaitFor(72)
	c.UntilNextInputFrame()

	c.RndAorB() -- I will give you a reward
	c.RandomFor(1)
	c.WaitFor(50)
	c.UntilNextInputFrame()

	c.RndAorB() -- What? You want to go on a journey?
	c.RandomFor(1)
	c.WaitFor(20)
	c.UntilNextInputFrame()

	c.RndAorB() -- Ragnar ....
	c.RandomFor(1)
	c.WaitFor(90)
	c.UntilNextInputFrame()

	c.RndAorB() -- You intend to find and protect the hero
	c.RandomFor(1)
	c.WaitFor(58)
	c.UntilNextInputFrame()

	c.RndAorB() -- I see.. You'll have my full support
	c.RandomFor(1)
	c.WaitFor(75)
	c.UntilNextInputFrame()

	c.RndAorB() -- Ragnar, this is a farewell gift from me
	c.RandomFor(1)
	c.WaitFor(9)
	c.UntilNextInputFrame()

	c.RandomFor(2) -- Magic frame
	c.WaitFor(10)
	c.UntilNextInputFrame()
	c.WaitFor(1)
	c.RndAtLeastOne() -- Start XP counter
	c.WaitFor(295)
	c.UntilNextInputFrame()
	c.WaitFor(1)

	c.RndAtLeastOne() -- close dialog
	c.RandomFor(1)
	c.WaitFor(8)
	c.UntilNextInputFrame() -- Until magic frame

	return true
end

--There is an extra magic frame for lv 5
function _level5Setup()
    c.RandomFor(2)
    c.WaitFor(160)
    c.UntilNextInputFrame()
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
		c.Save(string.format('aaaChp1Lv%s-Vit-Skip-ButOtherStats-FrameCount-%s', level, emu.framecount()))
		return false
	end

    if strSkip then
        c.Log('Jackpot!!! No stats in level ')
        c.Save(string.format('aaaLv%sStatSkip-FrameCount-%s', level, emu.framecount()))
        c.Done()
    else
        local rng1 = c.ReadRng1()
        local rng2 = c.ReadRng2()
        c.Log(string.format('Lv %s manipulated, FrameCount: %s', level, emu.framecount()))
        c.Save(string.format('aaaChp1Lv%s-FrameCount-%s-Rng2-%s-Rng1-%s', level, emu.framecount(), rng2, rng1))
    end

    return true
end

local function _manipLevel5()
	c.maxDelay = 30
	_level5Setup()
	local origStats = _getStats()
	return _manipLevel(5, _getStats())
end

local function _manipLevel6()
	c.maxDelay = 50
	c.WaitFor(130)
	c.UntilNextInputFrame()
	c.Save(6)
	return _manipLevel(6, _getStats())
end

c.Load(0)
c.Save(100)
while not c.done do
	c.Load(100)
	local result = c.Best(_enterCastle, 3)
	if result then
		c.Save(4)
		result = c.Best(_walkToKing, 2)
		if result > 0 then
			rngResult = _addRng(1)
			if rngResult then
				c.Log('New RNG Seed, attempting Lv5')
				c.Save(4)				
				lv5Result = c.Cap(_manipLevel5, 2000)
				if lv5Result then
					rngResult = _addRng(2)
					if rngResult then
						c.Log('New RNG Seed, attempting Lv6')
						lv6Result = c.Cap(_manipLevel6, 2000)
						if lv6Result then
							c.Done()
						else
							c.Log('Unable to manip level 6')
						end
					end
				end
			else
				c.Log('RNG already foud')
			end			
		else
			c.Log('Unable to reach level ups')
		end		
	else
		c.Log('Unable to enter castle')
	end
	
end
	

c.Finish()



