-----------------
-- Settings
-----------------
_magicFrameDelay = 9; --sometimes it is 8 or 9 randomly, sometimes only 9
-------------------------
local c = require("DW4-ManipCore");

c.InitSession();
c.reportFrequency = 100;
c.maxDelay = 46;

_ragLuckAddr = 0x60BF;
_ragMaxHPAddr = 0x60C1;
_ragIntAddr = 0x60BE;

delay = 0;
bestHP = 999;
while not c.done do
	found = false;
	savestate.loadslot(0);
	delay = 0;
	olu = memory.readbyte(_ragLuckAddr);
	oit = memory.readbyte(_ragIntAddr);
	omaxhp = memory.readbyte(_ragMaxHPAddr);
	--------------------------------------	
	bail = false;

	delay = delay + c.DelayUpTo(c.maxDelay - delay);
	c.RndAorB(); -- Level goes up
	c.WaitFor(80);

	
	lu = memory.readbyte(_ragLuckAddr);
	it = memory.readbyte(_ragIntAddr);
	maxhp = memory.readbyte(_ragMaxHPAddr);
	hpInc = maxhp - omaxhp;
	if (lu == olu and it == oit) then
		if (delay < c.maxDelay) then
			console.log('delay is less than max ' .. delay .. ' ' .. c.maxDelay)
			found = true;
		elseif (hpInc < bestHP) then
			console.log('hpInc is less than bestHP ' .. hpInc .. ' ' .. bestHP)
			found = true;
		else
			found = false;
		end

		if (found == true) then
			console.log('Success!! .. delay: ' .. delay .. ' hp: ' .. hpInc);
			c.maxDelay = delay;
			bestHP = hpInc;
			savestate.saveslot(9);
		end
	end

	if (found == true and delay == 0 and bestHP <= 1) then
		c.done = true;
	end

	c.Increment(' bestHP: ' .. bestHP);
end

c.Finish();
savestate.saveslot(9);


