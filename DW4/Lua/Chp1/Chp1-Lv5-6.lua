local c = require("DW4-ManipCore")

c.InitSession()
c.reportFrequency = 500
c.maxDelay = 60

_ragAgAddr = 0x60BC
_ragLuckAddr = 0x60BF
_ragVitAddr = 0x60BD
_ragLvAddr = 0x60BA
_ragMaxHPAddr = 0x60C1
_ragIntAddr = 0x60BE

_blinkerAddr = 0x0059

function _readLv()
	return c.Read(_ragLvAddr)
end

function _jackPot2()
	c.Save(200)
	local jp2found = false
	local cur = 0
	local cap = 4000
	c.LogProgress('Attempting Jackpot 2', true)
	while cur < cap do
		c.Load(200)
		delay = 0

		c.RandomFor(1)
		c.UntilNextMenu()

		olv = _readLv()
		delay = delay + c.DelayUpTo(c.maxDelay - delay)
		c.RndAorB() -- Level goes up
		c.UntilNextMenu()

		lv = _readLv()
		if lv == olv + 1 then
			c.LogProgress('----------------', true)
			c.LogProgress('Jackpot 2!!! delay: ' .. delay, true)
			c.Save(9)
			c.Save(99)
			c.Save(1000 + delay)
			c.maxDelay = delay - 1
			if c.maxDelay < 0 then
				cur = cap
			end
			jp2found = true
		end

		cur = cur + 1
		c.Increment()
	end

	if jp2found == true then
		c.LogProgress('Jackpot 2 found', true)
		return true
	end

	c.LogProgress('Jackpot 2 attempt failed', true)
	return false
end

c.Save(100)
while not c.done do
	local found = false
	c.Load(100)
	--------------------------------------
	c.RndWalkingFor('Up', 198)
	c.WaitFor(3)
	c.PushA()
	c.WaitFor(15)

	--Door
	c.PushDown(); c.WaitFor(1)
	c.PushDown(); c.WaitFor(1)
	c.PushDown(); c.PushA()
	c.WaitFor(30)
	c.PushFor('Up', 100)

	lag = true
	while (lag) do
	savestate.save("maniptemp")
		c.RndWalkingFor('Up', 8)
		c.WaitFor(8)
		c.PushFor('Down', 63) --Push a bad direction while it doesn't matter for easier debugging
		c.PushFor('Right', 11)

		lag = memory.readbyte(_blinkerAddr) == 30
		if (lag) then
			savestate.load('maniptemp')
		end
	end

	c.PushFor('Right', 11)
	c.PushFor('Up', 13)

	savestate.save('maniptemp')
	lag = true;
	while (lag) do
		--Start walking up
		c.RndWalkingFor('Up', 145)
		c.UntilNextMenu()

		--king's dialog
		c.RndAorB()
		c.UntilNextMenu()
		c.RndAorB()
		c.UntilNextMenu()
		c.RndAorB()
		c.UntilNextMenu()
		c.RndAorB()
		c.UntilNextMenu()
		c.RndAorB()
		c.UntilNextMenu()
		c.RndAorB()
		c.UntilNextMenu()
		c.RndAorB()
		c.UntilNextMenu()
		c.RndAorB()
		c.UntilNextMenu()
		c.RndAorB()

		--Magic frame before xp dialog
		c.WaitFor(12)
		c.RandomFor(1)
		lag = emu.islagged()
		if (emu.islagged()) then
			c.Debug('magic frame lag!')
			savestate.load('maniptemp')
		end
	end

	c.WaitFor(14)

	c.RndAtLeastOne() -- Exp == 100
	c.WaitFor(302)

	c.RndAtLeastOne() -- Exp == 3100
	c.WaitFor(11)
	c.RandomFor(1)
	c.WaitFor(170)

	c.RandomFor(1)
		--Santity check
		if (emu.islagged == false) then
			c.Debug('lagged, at magic frame')
		end
	c.UntilNextMenu()

	olv = _readLv()
	c.RndAorB() -- Level goes up
	c.UntilNextMenu()

	-- Jackpot check
	lv = _readLv()
	if (lv == olv + 1) then
		c.LogProgress('Jackpot 1!!!', true)
		c.Save(9)
		c.Save(99)
		found = true;
	end


	if (found == true) then
		jp2 = _jackPot2()
		if jp2 == true and c.maxDelay < 0 then
			c.Done()
		end
	end

	c.Increment()
end

c.Finish()



