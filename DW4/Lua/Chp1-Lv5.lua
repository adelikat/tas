local c = require("DW4-ManipCore")

c.InitSession()
c.reportFrequency = 500
c.maxDelay = 0

_ragAgAddr = 0x60BC
_ragLuckAddr = 0x60BF
_ragVitAddr = 0x60BD
_ragLvAddr = 0x60BA
_ragMaxHPAddr = 0x60C1
_ragIntAddr = 0x60BE

_blinkerAddr = 0x0059

delay = 0

while not c.done do
	found = false
	savestate.loadslot(0)
	delay = 0
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
		--console.log('lag check')
		if (lag) then
			--console.log('lag! bailing')
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
			console.log('magic frame lag!')
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
			console.log('lagged, at magic frame')
		end
	c.UntilNextMenu()

	olv = memory.readbyte(_ragLvAddr)
	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.RndAorB() -- Level goes up
	c.UntilNextMenu()

		-- Jackpot check
		lv = memory.readbyte(_ragLvAddr)
		if (lv == olv + 1) then
			console.log('Jackpot!!! delay: ' .. delay)
			savestate.saveslot(9);
			c.maxDelay = delay - 1;
			found = true;
			--c.done = true -- If we find this, all bets are off, we didn't know about a jackpot this early in the frame search
		end

	--if (c.done == false) then
	--	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	--	c.RndAorB(); -- Next stat
	--	c.UntilNextMenu()

	--	lv = memory.readbyte(_ragLvAddr)
	--	if (lv == olv + 1) then
	--		console.log('Success delay: ' .. delay)
	--		c.maxDelay = delay - 1
	--		found = true
	--		savestate.saveslot(9);
	--	end
	--end

	if (found == true and c.maxDelay < 0) then
		c.done = true
	end
end
	c.Increment()

c.Finish()
savestate.saveslot(9)


