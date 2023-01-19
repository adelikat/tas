_magicFrameDelay = 9 --sometimes it is 8 or 9 randomly, sometimes only 9

local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 30

_ragHPAddr = 0x60B6
_ragStrAddr = 0x60BB
_ragAgAddr = 0x60BC
_ragLuckAddr = 0x60BF
_ragVitAddr = 0x60BD
_ragLvAddr = 0x60BA
_ragMaxHPAddr = 0x60C1
_ragIntAddr = 0x60BE

delay = 0
bestHP = 999
bestDelay = 999
while not c.done do
	found = false
	c.Load(0)
	delay = 0
	maxhp = 0
	ohp = c.Read(_ragHPAddr)
	oag = c.Read(_ragAgAddr)
	olu = c.Read(_ragLuckAddr)
	ovi = c.Read(_ragVitAddr)
	olv = c.Read(_ragLvAddr)
	oit = c.Read(_ragIntAddr)
	omaxhp = c.Read(_ragMaxHPAddr)
	--------------------------------------	
	bail = false

	c.RandomFor(1)
	c.WaitFor(_magicFrameDelay)
	c.RndAorB() -- Level goes up
		if (emu.islagged()) then
			bail = true
			c.Debug('Lagged at start, bailing attempt: ' .. c.attempts)
		end

	if (bail == false) then
		c.UntilNextMenu()
		delay = delay + c.DelayUpTo(c.maxDelay - delay)
		c.RndAorB() -- Str goes up

		--Jackpot check
		--Next stat will already be increased, jackpot is netiher ag or vit is next
		ag = c.Read(_ragAgAddr)
		vi = c.Read(_ragVitAddr)
		if (ag == oag and vi == ovi) then
			c.LogProgress('Jackpot!!! delay: ' .. delay, true)
			c.Save(9)
			c.Save(99)
			c.done = true
		elseif (ag == oag and vi > ovi) then
			c.Debug('No agility, continuing')
			c.UntilNextMenu()
			c.RndAorB()

			maxhp = c.Read(_ragMaxHPAddr)
			lu = c.Read(_ragLuckAddr)
			it = c.Read(_ragIntAddr)

			success = lu == olu
				and it == oit
				and (delay < bestDelay or (delay == bestDelay and maxhp < bestHP))

			if (success) then
				found = true
				c.LogProgress('Success delay: ' .. delay .. ' HP+: ' .. (maxhp - omaxhp), true)
				c.Save(9)
				bestHP = maxhp
				bestDelay = delay
				c.maxDelay = delay
			else
				c.Debug('Luck or int increase, bailing')
			end
		end
	end
	
	if (found == true and maxhp == omaxhp + 1) then
		c.done = true
	end

	c.Increment()
end

c.Finish()
savestate.saveslot(9)


