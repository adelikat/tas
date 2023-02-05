--Starts at Lv 6 magic frame

local c = require("DW4-ManipCore")

c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 5

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

function _level6_vit3()
	local origStats = _getStats()
	local targetVitality = origStats.Vitality + 3
    c.RandomFor(2)
    c.WaitFor(6)
    c.UntilNextInputFrame()
	c.RndAorB()
	c.RandomFor(1)
	c.WaitFor(47)
	c.UntilNextInputFrame()

	local currStats = _getStats()

	if currStats.Agility > origStats.Agility then
		return _bail('Got agility')
	end

	if origStats.Vitality == currStats.Vitality then
		c.Log('Jackpot!!! Vit skip')
		c.Save('Chp6-VitSkip')
		c.Save(9)
		c.Done()
	end

	if origStats.Vitality > targetVitality then
		_bail('Vitality too large')
	end

	return true
end

function _level6_postvit()
	local origStats = _getStats()
	c.RndAorB()
	c.RandomFor(1)
	c.WaitFor(49)
	c.UntilNextInputFrame()

	local currStats = _getStats()

	if currStats.Luck > origStats.Luck then
		return _bail('Got luck')
	end

	if currStats.Int > origStats.Int then
		return _bail('Got int')
	end

	local targetHp = origStats.MaxHp + 6
	if currStats.MaxHp > targetHp then
		return _bail('Got too much HP')
	end

	return true
end

c.Load(0)
c.Save(100)
while not c.done do
	c.Load(100)
	c.Cap(_level6_vit3, 100)
	c.Log('Got good vitality')
	c.Save(5)

	result = c.ProgressiveSearch(_level6_postvit, 250, 20)
	if result then
		c.Save(6)
		c.Done()
	else
		c.Log('Failed to find a successful result')
	end
	
end
	

c.Finish()



