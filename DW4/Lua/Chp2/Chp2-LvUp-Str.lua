local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 50

fromPreviousLv = true
previousLvDelay = 218


function _readStr()
	return c.Read(c.Addr.AlenaStr)
end

while not c.done do
	c.Load(0)
	delay = 0
	found = false
	ostr = _readStr()
	if fromPreviousLv then
		delay = delay + c.DelayUpTo(c.maxDelay - delay)
		c.RndAorB()
		c.WaitFor(previousLvDelay)
	end

	-- Magic frame
	bail = false
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


