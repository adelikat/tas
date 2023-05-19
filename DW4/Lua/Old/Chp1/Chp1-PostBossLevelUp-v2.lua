--Starts at the first frame of menuing after the last Saro miss ('nimbly')
--Assumes Saro has low enough HP that Ragnar can defeat him with a regular attack (14-18 HP)

local c = require("DW4-ManipCore")
c.InitSession()
c.maxDelay = 100
c.reportFrequency = 100
local delay = 0

local _ragLvAddr = 0x60BA
local _ragStrAddr = 0x60BB
local _ragAgAddr = 0x60BC
local _ragVitAddr = 0x60BD
local _ragLuckAddr = 0x60BF
local _ragIntAddr = 0x60BE

local function _bail(msg)
	c.Debug(msg)
	c.Increment()
	return false
end

local function _ragnarLevel()
	return c.Read(_ragLvAddr)
end

local function _ragnarStr()
	return c.Read(_ragStrAddr)
end

local function _ragnarAgility()
	return c.Read(_ragAgAddr)
end

local function _ragnarVitality()
	return c.Read(_ragVitAddr)
end

local function _ragnarLuck()
	return c.Read(_ragLuckAddr)
end

local function _ragnarInt()
	return c.Read(_ragIntAddr)
end

local function _manipLv2()
	local origStr = _ragnarStr()
	local origAgility = _ragnarAgility()
	local origVitality = _ragnarVitality()
	local origLuck = _ragnarLuck()
	local origInt = _ragnarInt()

	c.Debug('Ragnar Str: ' .. origStr)
	c.Debug('Ragnar Agility: ' .. origAgility)
	c.Debug('Ragnar Vitality: ' .. origVitality)
	c.Debug('Ragnar Luck: ' .. origLuck)
	c.Debug('Ragnar Int: ' .. origInt)

	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.RndAtLeastOne()
	c.RandomFor(10)
	c.RandomFor(5)
	c.UntilNextInputFrame()
	c.WaitFor(2)

	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.RndAtLeastOne() -- Ragnar Attacks
	c.RandomFor(2)
	c.WaitFor(5)

	if c.ReadE1Hp() ~= 0 then
		return _bail('Failed to do enough damange to Saro')
	end

	c.WaitFor(40)
	c.UntilNextInputFrame()
	c.WaitFor(2)

	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.RndAtLeastOne() -- x Dmg to Saro's Shadow
	c.RandomFor(1)
	c.WaitFor(18)
	c.UntilNextInputFrame()
	c.WaitFor(2)

	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.RndAtLeastOne() -- Saro's Shadow was defeated
	c.RandomFor(21)
	c.WaitFor(280)

	if _ragnarLevel() ~= 2 then
		return _bail('Failed to get to level 2')
	end
	
	c.UntilNextInputFrame()
	
	c.RandomFor(1) -- Magic frame
	c.WaitFor(6)

	if _ragnarStr() == origStr then
		c.Log('Jackpot!!! Lv 2 - Manipulated no str, not known to be possible')
		c.Done()
	end

	c.UntilNextInputFrame()

	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.RndAorB() -- Ragnar's Level goes up
	c.WaitFor(41)

	if _ragnarAgility() > origAgility then
		return _bail('Lv 2 - Got agility increase, bailing')
	end

	c.WaitFor(6) -- Seems it takes a bit longer after not getting a stat, if so, less beneficial than it seems to skip one, still worth it

	if _ragnarVitality() > origVitality then
		return _bail('Lv 2 - Got vitality, bailing')
	end
	
	if _ragnarLuck() > origLuck or _ragnarInt() > origInt then
		c.Log('Lv 2 Vitality skip delay: ' .. delay)
		c.Save('Chp1Lv2-Vit-Skip-ButOtherStats-Delay-' .. delay)
		return false
	end

	c.Log('Lv 2 manipulated, delay: ' .. delay)
	c.Save('Chp1Lv2-Delay-' .. delay)
	return true
end

local function _manipLv3()
	local origStr = _ragnarStr()
	local origAgility = _ragnarAgility()
	local origVitality = _ragnarVitality()
	local origLuck = _ragnarLuck()
	local origInt = _ragnarInt()

	c.Debug('Ragnar Str: ' .. origStr)
	c.Debug('Ragnar Agility: ' .. origAgility)
	c.Debug('Ragnar Vitality: ' .. origVitality)
	c.Debug('Ragnar Luck: ' .. origLuck)
	c.Debug('Ragnar Int: ' .. origInt)

	c.WaitFor(163)
	c.UntilNextInputFrame()

	c.RndAtLeastOne() -- Magic Frame

	c.WaitFor(6)

	if _ragnarStr() == origStr then
		c.Log('Jackpot!!! Lv 3 - Manipulated no str, not known to be possible')
		c.Done()
	end

	c.UntilNextInputFrame()

	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.RndAorB() -- Ragnar's Level goes up
	c.WaitFor(41)

	if _ragnarAgility() > origAgility then
		return _bail('Lv 3 - Got agility increase, bailing')
	end

	if _ragnarVitality() > origVitality then
		return _bail('Lv 3 - Got vitality, bailing')
	end

	if _ragnarLuck() > origLuck or _ragnarInt() > origInt then
		c.Log('Lv 3 Vitality skip delay: ' .. delay)
		c.Save('Chp1Lv3-Vit-Skip-ButOtherStats-Delay-' .. delay)
		return false
	end

	c.maxDelay = delay - 1
	c.Log('Lv 3 manipulated, delay: ' .. delay)
	c.Save('Chp1Lv3-Delay-' .. delay)
	return true
end

c.Load(0)
c.Save(100)
while not c.done do
	c.Load(100)
	delay = 0
	local result = _manipLv2()
	if result then
		result = _manipLv3()
		if result and delay < 0 then
			c.Done()
			c.Save(9)
		end
	end

	c.Increment()
end

c.Finish()
