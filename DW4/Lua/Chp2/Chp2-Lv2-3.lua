local c = require("DW4-ManipCore")

c.InitSession()
c.reportFrequency = 100
c.maxDelay = 0

local wing = 0x56

function _readDrop()
	return c.Read(0x01D6) --This seems to indicate the drop among other things, drop is always wing even when one isn't given??
	--return c.Read(c.Addr.Drop)
end

function _readSlot1()
	return c.Read(c.Addr.AlenaSlot2)
end

function _readLv()
	return c.Read(c.Addr.AlenaLv)
end

function _readStr()
	return c.Read(c.Addr.AlenaStr)
end

function _getDrop()
	c.Save(20)
	local dropFound = false
	while not dropFound do
		c.Load(20)
		c.RndAtLeastOne() -- Alena attacks
		c.RandomFor(1)
		c.WaitFor(19)

		c.RndAtLeastOne() -- Alena critical
		c.RandomFor(1)
		c.WaitFor(46)

		c.RndAtLeastOne() -- 13 Dmg
		c.RandomFor(1)
		c.WaitFor(22)

		c.RndAtLeastOne() -- Defeated
		c.RandomFor(101)
		c.WaitFor(70)
		drop = _readDrop()
		c.Debug('drop: ' .. drop)
		if _readDrop() == wing then
			c.Log('Wing Drop Found!', true)
			dropFound = true
			c.UntilNextMenu()
			c.Save(4)
			c.Save("Chp2DropFound")
		end
	end
end

function _lv1()
	c.Save(21)
	local cur = 0
	local cap = 3000
	local lv1Done = false
	ostr = _readStr()
	while cur <= cap do
		c.Load(21)
		c.RndAorB()
		c.UntilNextMenu()
		c.RndAorB()
		c.UntilNextMenu()

		c.RndAorB()
		c.WaitFor(212)
		c.WaitFor(39)

		olv = _readLv()
		c.RandomFor(1) -- Magic frame
		bail = false
		if emu.islagged() then
			c.Debug('Lagged at Lv 2 Up, aborting')
			bail = true
		end
		if not bail then
			c.UntilNextMenu()
			c.RndAorB()
			c.UntilNextMenu()
			lv = _readLv()
			if lv == olv + 1 then
				c.Log('Jackpot!! Lv 2 no stats')
				c.Done()
				c.Save(9)
				c.Save("Chp2Lv2Jackpot")
				cur = cap
				lv1Done = true
			else
				str = _readStr()
				if str - ostr == 3 then
					c.Debug("Str found")
					-- Continue to manip more things
					c.RndAorB()
					c.UntilNextMenu()
					lv = _readLv()
					if lv == olv + 1 then
						c.Log('Lv 1 Manipulated!', true)
						cur = cap
						lv1Done = true
						c.Save(9)
						c.Save("Chp2Lv2Done")
					end
				end
			end
		end
		cur = cur + 1
	end

	c.Save(5)
	return lv1Done
end

while not c.done do
	c.Load(0)
	_getDrop()
	lv1Result = _lv1()
	if lvResult then
		c.Done()
	else
		c.Log('Failed to manip level 1, continuing', true)
	end

	c.Increment()
end

c.Finish()


