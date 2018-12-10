-----------------
-- Settings
-----------------

odds = 128; --Max amount of delay to use during delayable moments
padding = 0;

reportFrequency = 100; -- How many attempts before it logs a result
-------------------------
local c = require("DW4-ManipCore");

c.InitSession();

origTaloonHP = memory.readbyte(0x6098);

while not c.done do
	savestate.loadslot(0);

	--------------------------------------	
	c.RndAtLeastOne();
	c.RandomFor(1);
	lag = true;
	while lag == true do
		c.WaitFor(1);
		lag = emu.islagged();
	end

	frame = emu.framecount();

	console.log('frame: ' .. frame);

	if (frame == 23776) then
		c.done = true;
	end
	c.attempts = c.attempts + 1
	--c.LogProgress(c.done, c.attempts, 0, 'rng2: ' .. rng2);
end

c.Finish();


