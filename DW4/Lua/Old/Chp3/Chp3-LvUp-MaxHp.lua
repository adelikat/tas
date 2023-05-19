local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 8

fromPreviousLv = true
best = 0

function _readHp()
	return c.Read(0x60A3)
end

function _readLuck()
	return c.Read(0x60A1)
end

function _readInt()
	return c.Read(0x60A0)
end

function _readLv()
	return c.Read(0x609C)
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

	delay = 0
	olu = _readLuck()
	ohp = _readHp()
	olv = _readLv()
	oint = _readInt()
	--From Agility goes up 3 
	--points!

	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.RndAorB() --Str
	c.UntilNextMenu()
	
	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.RndAorB() --next stat
	c.UntilNextMenu()
	c.RndAorB() -- HP
	c.WaitFor(45)

	int = _readInt()
	lu = _readLuck()
	hp = _readHp()

	if (int == oint and lu == olu) then
		c.Save(5)
		c.Debug('Found no int no luck', true)
		hpInc = hp - ohp;
		c.Debug('hp: ' .. hp .. ' orig hp: ' .. ohp)
		c.Debug('Hp inc: ' .. hpInc)		
		if (hpInc > best) then
			c.Debug('new best: ' .. hpInc)
			c.Save(6)
			best = hpInc
			c.LogProgress(' New best HP: ' .. hpInc .. ' delay: ' .. delay, true)
			c.Save(9)
			c.Save(99)
			--if (delay < c.maxDelay) then
			--	c.maxDelay = delay
			--end
		end

	end 

	c.Increment()

end

c.Finish()


