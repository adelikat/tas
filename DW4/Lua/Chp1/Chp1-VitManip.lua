_magicFrameDelay = 9 --sometimes it is 8 or 9 randomly, sometimes only 9
-------------------------

local c = require("DW4-ManipCore")

c.InitSession()
c.reportFrequency = 1
c.maxDelay = 5

_ragAgAddr = 0x60BC
_ragVitAddr = 0x60BD

delay = 0
bestVi = 999
while not c.done do
	found = false
	savestate.loadslot(0)
	delay = 0
	oag = memory.readbyte(_ragAgAddr)
	ovi = memory.readbyte(_ragVitAddr)
	--------------------------------------	
	--c.RndAorB()
	--c.WaitFor(225)

	c.RandomFor(1);
	c.UntilNextMenu()
	delay = delay + c.DelayUpTo(c.maxDelay - delay)

	c.RndAorB() -- Level goes up
	c.UntilNextMenu()

	c.RndAorB() -- Str
	c.UntilNextMenu()

	ag = memory.readbyte(_ragAgAddr)
	vi = memory.readbyte(_ragVitAddr)
	viInc = vi - ovi
	if (ag == oag) then
		if (delay < c.maxDelay) then
			console.log('Success! vi: ' .. viInc .. ' delay: ' .. delay)
			c.Save(9)
			bestVi = viInc
			c.maxDelay = delay - 1
			found = true
		elseif (viInc < bestVi) then
			console.log('Success! vi: ' .. viInc .. ' delay: ' .. delay)
			c.Save(9)
			bestVi = viInc
			found = true
		end
	end

		
	if (found == true and vi == 0) then
		c.done = true;
	end

	c.Increment(' bestVi: ' .. bestVi);
end

c.Finish();
savestate.saveslot(9);


