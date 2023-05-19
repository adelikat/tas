-----------------
-- Settings
-----------------
maxDelay = 27; --Max amount of delay to use during delayable moments
targetStat = 19;
wait = 220;
statAddr = 0x60D9;
reportFrequency = 1;
-------------------------
local c = require("DW4-ManipCore");
c.InitSession();

while not c.done do
	savestate.loadslot(0);
	delay = 0;
	--------------------------------------
	-- Loop
	--------------------------------------
	delay = delay + c.DelayUpTo(maxDelay);
	c.PushAorB(); -- Advance previous stat
	c.RandomFor(wait);
	c.WaitFor(10);

	c.attempts = c.attempts + 1;

	--------------------------------------
	-- Eval
	--------------------------------------

	amt = memory.readbyte(statAddr);

	if amt >= targetStat then
		c.done = true;
	end

	LogProgress(c.done, c.attempts, delay, 'amt: ' .. amt);

	--------------------------------------
end

console.log('Success!');
client.pause();


