local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 50

fromPreviousLv = true
previousLvDelay = 245


function _readStr()
	return c.Read(c.Addr.AlenaStr)
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
	found = false
	ostr = _readStr()
	oint = _readInt()
	omhp = _readMHP()

	if fromPreviousLv then
		delay = delay + c.DelayUpTo(c.maxDelay - delay)
		c.RndAorB()
		c.WaitFor(previousLvDelay)
	end

	int = _readInt()
	mhp = _readMHP()

	if oint ~= int and omhp ~= mhp then
		c.Log('Got unwanted stat increases, bailing', true)
		bail = true
	else
		bail = false
	end

	-- Magic frame
	c.RandomFor(1)
		if fromPreviousLv and emu.islagged() then
			c.Log('Lagged at lv up', true)
			bail = true
		end

	if not bail then
		c.UntilNextMenu()

		str = _readStr()
		
		strInc = str - ostr;
		c.Debug('strInc: ' .. strInc .. ' delay: ' .. delay)
		if strInc == 3 then
			c.LogProgress('Found Str 3 delay: ' .. delay, true)
			c.Save(9)
			c.Save(99)
			c.maxDelay = delay - 1
			found = true
		end
	end

	if found and delay == 0 then
		c.done = true
		c.Done()
	else
		c.Increment()
	end
end

c.Finish()


