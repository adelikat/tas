local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 1

fromPreviousLv = true
best = 999999

function _readHp()
	return c.Read(c.Addr.AlenaHp)
end

function _readAg()
	return c.Read(c.Addr.AlenaAg)
end

function _readLuck()
	return c.Read(c.Addr.AlenaLuck)
end

function _readInt()
	return c.Read(c.Addr.AlenaInt)
end

function _readLv()
	return c.Read(0x60BA)
end

function _nextInputFrame()
	c.Save(600)

	while emu.islagged() == true do
		c.Save(600)
		c.WaitFor(1)
	end

	c.Load(600)
end

while not c.done do
	c.Load(0)

	if (fromPreviousLv) then
		c.RndAorB()
		c.WaitFor(220)
		_nextInputFrame()
	end

	local delay = 0
	oag = _readAg()
	olu = _readLuck()
	ohp = _readHp()
	olv = _readLv()
	oint = _readInt()
	c.RandomFor(1)
	c.UntilNextMenu()

	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.RndAorB() --Level up
	c.UntilNextMenu()

	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.RndAorB() --Str
	c.UntilNextMenu()
	
	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.RndAorB() --AG probably
	c.UntilNextMenu()

	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.RndAorB() --Luck hopefully

	c.UntilNextMenu()
	c.RndAorB() -- HP
	c.WaitFor(45)

	ag = _readAg()
	int = _readInt()
	lu = _readLuck()
	hp = _readHp()

	if (ag == oag and int == oint and lu == olu) then
		c.LogProgress('Found', true)
		hpInc = hp - ohp;
		if (hpInc < best) then
			best = hpInc
			c.LogProgress(' Found HP: ' .. hpInc .. ' delay: ' .. delay, true)
			c.Save(9)
			c.Save(99)
			if (delay < c.maxDelay) then
				c.maxDelay = delay
			end
		end

	end 

	c.Increment()

end

c.Finish()


