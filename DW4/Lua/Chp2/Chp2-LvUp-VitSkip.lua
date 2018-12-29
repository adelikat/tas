-- Starts at the magic frame at the start of a level up
-- Manipulates at least 2 str
-- Checks for ag 0 but otherwise does not care
-- Gets a vit = 0

local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 10000
c.maxDelay = 70
local delay = 0
_manipStr = false
_strTarget = 2


function _readLv()
	return c.Read(c.Addr.AlenaLv)
end

function _readStr()
	return c.Read(c.Addr.AlenaStr)
end

function _readAg()
	return c.Read(c.Addr.AlenaAg)
end

function _readVit()
	return c.Read(c.Addr.AlenaVit)
end

function _str()
	local strFound = false
	ostr = _readStr()
	c.Save(20)

	while not strFound do
		c.Load(20)

		c.RandomFor(1)
		c.UntilNextMenu()
		str = _readStr()
		strInc = str - ostr
		if strInc >= _strTarget then
			c.Debug('Str found')
			strFound = true
			c.Save(5)
			c.Save(21)
		else
			c.Increment('str: ' .. strInc)
		end
		
		c.Increment()
	end
end

function _noVit()
	c.Save(21)

	local cur = 0
	local cap = c.maxDelay * 20

	local vitResult = -1
	ovit = _readVit()
	oag = _readAg()
	while cur <= cap do
		c.Load(21)
		delay = 0

		-- Alena's Level goes up
		delay = delay + c.DelayUpTo(c.maxDelay - delay)
		c.Debug('delay before Ag: ' .. delay)
		c.RndAorB()
		c.WaitFor(2) -- Ensure menu isn't already on 248
		c.UntilNextMenu()
		ag = _readAg()

		-- Strength goes up 2 points!
		delay = delay + c.DelayUpTo(c.maxDelay - delay)
		c.Debug('delay before Vit: ' .. delay)
		c.RndAorB()
		c.WaitFor(2) -- Ensure menu isn't already on 248
		c.UntilNextMenu()

		vit = _readVit()
		agInc = ag - oag
		vitInc = vit - ovit

		if vitInc == 0 then
			if agInc == 0 then
				c.LogProgress('------', true)
				c.LogProgress('Jackpot!!! delay ' .. delay, true)
				cur = cap;
				c.Save(9)
				c.Save(900 + delay)
				c.Done()
			else
				c.LogProgress('Vit 0!!!! delay: ' .. delay, true)
				c.maxDelay = delay - 1
				c.Save(6)
				c.Save(800 + delay)
			end

			if delay == 0 then
				cur = cap
			end
		end

		c.Increment()
		cur = cur + 1
	end

	return vitResult
end
while not c.done do
	c.Load(0)
	delay = 0
	if _manipStr then
		_str()
	end

	local vitResult = _noVit()
	if vitResult == 0 then
		c.Done()
	else
		c.LogProgress('Failed to manip no vit, continuing', true)
	end

	c.Increment()
end

c.Finish()


