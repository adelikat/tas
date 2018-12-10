-----------------
-- Settings
-----------------

-------------------------
local c = require("DW4-ManipCore");

c.InitSession();
c.reportFrequency = 100;
c.maxDelay = 400;

_ragMaxHPAddr = 0x60C1;
delay = 0;
while not c.done do
	savestate.loadslot(0);
	delay = 0;
	omaxhp = memory.readbyte(_ragMaxHPAddr);

	delay = delay + c.DelayUpTo(c.maxDelay - delay);
	c.RndAorB();

	c.WaitFor(42);
	delay = delay + c.DelayUpTo(c.maxDelay - delay);
	c.RndAorB();
	c.WaitFor(10);

	maxhp = memory.readbyte(_ragMaxHPAddr);
	gain = maxhp - omaxhp;
	if (gain == 0) then
		console.log('Jackpot!!!! attempt: ' .. c.attempts);
		savestate.saveslot(9);
		c.done = true;
	end
	c.Increment(' hp+: ' .. gain);
end

c.Finish();
savestate.saveslot(9);


