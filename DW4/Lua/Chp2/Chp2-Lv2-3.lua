local c = require("DW4-ManipCore")

c.InitSession()
c.reportFrequency = 100
c.maxDelay = 19
local delay = 0
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

function _readVit()
	return c.Read(c.Addr.AlenaVit)
end

function _getDrop()
	c.Save(20)
	local dropFound = false
	local maxDelay = 5
	delay = 0
	while not dropFound do
		c.Load(20)
		c.RndAtLeastOne() -- Alena attacks
		c.RandomFor(1)
		c.WaitFor(19)

		delay = delay + c.DelayUpTo(maxDelay - delay)
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
		if _readDrop() == wing then
			c.LogProgress('Wing Drop Found! delay: ' .. delay .. ' Rng2: ' .. c.ReadRng2(), true)
			dropFound = true
			c.UntilNextMenu()
			c.Save(4)
			c.Save("Chp2DropFound")
		end
	end
end

function _str3()
	
	local delay = 0
	local cur = 0
	local cap = 300
	local str3Done = false
	ostr = _readStr()

	c.RndAorB()
	c.UntilNextMenu()
	c.RndAorB()
	c.UntilNextMenu()

	c.RndAorB()
	c.WaitFor(212)
	c.WaitFor(39)
	c.Save(21)
	olv = _readLv()
	
	while cur <= cap do
		c.Load(21)
		
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
			str = _readStr()
			if str - ostr == 3 then
				c.LogProgress("Str Manipulated", true)
				str3Done = true
				cur = cap
				c.Save(5)
			end
		end
		cur = cur + 1
		c.Increment()
	end

	return str3Done
end

function _noVit()
	c.Save(22)
	local cur = 0
	local cap = c.maxDelay * 20
	local vitDone = -1
	ovit = _readVit()
	while cur <= cap do
		c.Load(22)
		delay = delay + c.DelayUpTo(c.maxDelay - delay)
		c.RndAorB()
		c.WaitFor(5) --Hack, sometimes the menu value is already on the next value
		c.UntilNextMenu()
		vit = _readVit()
		if vit == ovit then
			vitDone = delay
			c.LogProgress('Vit 0!!!! delay: ' .. delay, true)
			c.maxDelay = delay - 1
			c.Save(6)
			c.Save("Chp2Lv2")			
			if delay == 0 then
				cur = cap
			end
		end
		c.Increment()
		cur = cur + 1
	end

	
	return vitDone
end

function _lv1()
	c.Save(21)
	local delay = 0
	local cur = 0
	local cap = 1000
	local lv1Done = false
	ostr = _readStr()
	while cur <= cap do
		c.Load(21)
		delay = delay + c.DelayUpTo(c.maxDelay - delay)
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
			delay = delay + c.DelayUpTo(c.maxDelay - delay)
			c.RndAorB()
			c.UntilNextMenu()
			lv = _readLv()
			c.Debug('Check no stats')
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
					c.Debug("Str 3 found")
					-- Continue to manip more things
					delay = delay + c.DelayUpTo(c.maxDelay - delay)
					c.RndAorB()
					c.UntilNextMenu()
					lv = _readLv()
					c.Debug('Check 2 stat')
					if lv == olv + 1 then
						c.Log('Lv 1 Manipulated!', true)
						cur = cap
						lv1Done = true
						c.done = true
						c.Save(9)
						c.Save("Chp2Lv2Done")
					else
						delay = delay + c.DelayUpTo(c.maxDelay - delay)
						c.RndAorB()
						c.UntilNextMenu()
						lv = _readLv()
						if lv == olv + 1 then
							c.Log('Lv 1 3-stat found delay: ' .. delay, true)
							c.Save(9)
							c.Save("Chp2Lv2TripleStat")
							cur = cap
							c.done = true
						end
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
	str3Result = _str3()
	if str3Result then
		vitResult = _noVit()
		if vitResult == 0 then
			c.Done()
		else
			c.LogProgress('Failed to manip no vit, continuing', true)
		end
	else
		c.LogProgress('Failed to manip str 3, continuing', true)
	end

	c.Increment()
end

c.Finish()


