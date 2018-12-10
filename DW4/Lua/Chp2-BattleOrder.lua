-----------------
-- Settings
-----------------
maxDelay = 5; --Max amount of delay to use during delayable moments
wait = 20;
reportFrequency = 10; -- How many attempts before it logs a result
-------------------------
local c = require("DW4-ManipCore");
c.InitSession();

while not c.done do
	savestate.loadslot(0);
	delay = 0;

	-- Loop
	--------------------------------------
	--delay = delay + c.DelayUpTo(maxDelay); --Alena pick attack
	--c.DoFrame(Push('P1 A'));
	--c.RandomFor(3);
	--c.WaitFor(1);
	--delay = delay + c.DelayUpTo(maxDelay);
	--c.DoFrame(Push('P1 A'));

	--c.RandomFor(13);
	--c.WaitFor(1);

	delay = delay + c.DelayUpTo(maxDelay); 
	c.DoFrame(Push('P1 A')); --Alena pick Attack
	c.RandomFor(4);
	c.WaitFor(1);
	delay = delay + c.DelayUpTo(maxDelay);
	c.DoFrame(Push('P1 A')); -- Alena pick Rabidhound
	c.RandomFor(13);
	c.WaitFor(1);

	delay = delay + c.DelayUpTo(maxDelay);
	c.DoFrame(Push('P1 A')); -- Cristo Picks Attack
	c.RandomFor(3);
	c.WaitFor(1);
	c.DoFrame(Push('P1 A')); -- Cristo Picks Rabidhound

	c.RandomFor(30);

	c.attempts = c.attempts + 1;

	-- Eval
	--------------------------------------
	rhbtarget = memory.readbyte(0x7306);
	bo1 = memory.readbyte(0x7348);
	bo3 = memory.readbyte(0x734A);
	bo5 = memory.readbyte(0x734C)
	if rhbtarget == 1
		and bo1 == 116
		and bo3 == 115
		and bo5 == 22
	 then
		c.done = true;
	end
	
	if (rhbtarget == 2) then
		console.log('attempt: ' .. c.attempts .. ' RH targeted Cristo');
	end

	if (bo1) then
		console.log('attempt: ' .. c.attempts .. ' Alena is slow');
	end

	c.LogProgress(c.done, c.attempts, delay, '');

	--------------------------------------
end

c.Finish();



