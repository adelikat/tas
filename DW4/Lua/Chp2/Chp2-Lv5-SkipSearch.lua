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

	ag = _readAg()
	--if ag == oag then
	--	c.LogProgress('ag skipped!')
	--	c.Save(9)
	--	c.Save(800 + delay)
	--end

	-- (Probably) Alena ag goes up
	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.RndAorB()
	c.WaitFor(2) -- Ensure menu isn't already on 248
	c.UntilNextMenu()

	luck = _readLuck()
	int = _readInt()

	found = false
	if int == oint and luck == oluck and ag >= oag + 2 then
		found = true
		c.LogProgress('Luck Skip!!! delay: .. ' .. delay, true)
		c.Save(9)
		c.Save(900 + delay)
		c.maxDelay = delay - 1

		if ag == oag then
			c.LogProgress('Double skip!!! delay: ' .. delay, true)
			c.Done()
		end
	end

	if found and delay == 0 then
		c.Done()
	end

	c.Increment()
end

c.Finish()


