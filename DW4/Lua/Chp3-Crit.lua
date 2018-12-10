-----------------
-- Settings
-----------------
maxDelay = 4; --Max amount of delay to use during delayable moments
reportFrequency = 1; -- How many attempts before it logs a result
-------------------------
local c = require("DW4-ManipCore");
c.InitSession();

while not c.done do
	savestate.loadslot(0);
	delay = 0;

	-- Loop
	--------------------------------------
	--Crit from From Enemy Appears, assumes you will go first not enemy
	delay = delay + c.DelayUpTo(maxDelay);
	c.RndAtLeastOne(); -- Enemy appears
	c.RandomFor(1);
	c.WaitFor(31);
	c.WaitFor(1);
	c.PushA(); -- Pick Attack
	c.RandomFor(1);
	c.WaitFor(3);
	delay = delay + c.DelayUpTo(maxDelay);
	c.PushA(); -- Pick Enemy
	c.RandomFor(22);
	c.WaitFor(11);
	c.PushA(); -- Attack
	c.WaitFor(24);	
	
	--------------------------------------
	c.attempts = c.attempts + 1
	--------------------------------------
	
	--Crit eval
	dmg = memory.readbyte(0x7361);
	if dmg >= 17 then c.done = true; end

	c.LogProgress(c.done, c.attempts, delay, 'dmg: ' .. dmg);
	
	--------------------------------------
end

c.Finish();


