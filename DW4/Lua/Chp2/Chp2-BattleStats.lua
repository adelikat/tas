-----------------
-- Settings
-----------------
wait = 255; --255 --55;
odds = 256;
padding = 1;
minStat = 4;
reportFrequency = 1; -- How many attempts before it logs a result
-------------------------
local c = require("DW4-ManipCore");
c.InitSession();

while not c.done do
	savestate.loadslot(0);
	delay = 0;
	maxDelay = math.floor(c.attempts / odds) + padding;
	-- Loop
	--------------------------------------
	delay = delay + c.DelayUpTo(maxDelay); 
	c.PushAorB();
	c.RandomFor(wait);
	c.WaitFor(25);


	c.attempts = c.attempts + 1;

	-- Eval
	--------------------------------------
	str = memory.readbyte(0x6007);
	ag = memory.readbyte(0x6008);
	--vit = memory.readbyte(0x6063);
	--luck = memory.readbyte(0x600A)
	--int = memory.readbyte(0x600B);
	--maxhp = memory.readbyte(0x6067);

	--taloonStr = memory.readbyte(0x609D);

	nexts = memory.readbyte(0x00FD);
	if nexts >= minStat   then
	--if str == 51 then
		c.done = true;
	end
	
	c.LogProgress(c.done, c.attempts, delay, 'nexts: ' .. nexts);

	--------------------------------------
end

c.Finish();


