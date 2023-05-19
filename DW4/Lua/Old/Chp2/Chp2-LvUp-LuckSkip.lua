-- Starts at the magic frame at the start of a level up
-- Manipulates at least 2 str
-- Checks for ag 0 but otherwise does not care
-- Gets a vit = 0

local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 10000
c.maxDelay = 48
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

function _readLuck()
	return c.Read(c.Addr.AlenaLuck)
end

function _readInt()
	return c.Read(c.Addr.AlenaInt)
end

function _readMHP()
	return c.Read(c.Addr.AlenaMaxHP)
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
	
	oag = _readAg()
	ovit = _readVit()
	oluck = _readLuck()
	oint = _readInt()
	omp = _readMHP()

	--Alena level goes up
	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.Debug('delay before Ag: ' .. delay)
	c.RndAorB()
	c.WaitFor(2) -- Ensure menu isn't already on 248
	c.UntilNextMenu()
	
	-- Alena str goes up
	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.Debug('delay After Ag: ' .. delay)
	c.RndAorB()
	c.WaitFor(2) -- Ensure menu isn't already on 248
	c.UntilNextMenu()

	-- (Probably) Alena ag goes up
	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.RndAorB()
	c.WaitFor(2) -- Ensure menu isn't already on 248
	c.UntilNextMenu()

	-- (Probably) Alena vit goes up
	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.RndAorB()
	c.WaitFor(2) -- Ensure menu isn't already on 248
	c.UntilNextMenu()

	ag = _readAg()
	vit = _readVit()
	luck = _readLuck()
	int = _readInt()
	mhp = _readMHP()

	anySkip = ag == oag or vit == ovit or oluck == luck

	found = false
	if int == oint and anySkip then
		found = true
		c.LogProgress('Skip!!! delay: .. ' .. delay, true)
		c.Save(9)
		c.Save(900 + delay)
		c.maxDelay = delay - 1
	end

	if found and delay == 0 then
		c.Done()
	end

	c.Increment()
end

c.Finish()


