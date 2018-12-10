local c = require("DW4-ManipCore")

c.InitSession()
c.reportFrequency = 100
c.maxDelay = 5
best = 999999

function _readHp()
	return c.Read(0x60C1)
end

function _readAg()
	return c.Read(0x60BC)
end

function _readLuck()
	return c.Read(0x60BF)
end

function _readInt()
	return c.Read(0x60BE)
end

function _readLv()
	return c.Read(0x60BA)
end

while not c.done do
	c.Load(0)
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
	c.RndAorB() --next stat
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
			c.LogProgress(' Found HP: ' .. hpInc, true)
			c.Save(9)
			c.Save(99)
		end

	end

	c.Increment()
end

c.Finish()


