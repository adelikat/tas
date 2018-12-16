-----------------
-- Settings
-----------------
_odds = 256; --Max amount of delay to use during delayable moments

-------------------------
local c = require("DW4-ManipCore");
c.InitSession();
c.maxDelay = 10;
c.reportFrequency = 100;

while not c.done do
	savestate.loadslot(0);
	origRagnarHP = c.Read(0x60B6);
	delay = 0;
	earlyBailout = false;

	c.RndAtLeastOne(); -- attack enemy (critical)
	c.RandomFor(45);
	c.WaitFor(1);

	delay = delay + c.DelayUpTo(c.maxDelay - delay);
	c.RndAtLeastOne();  --Enemy is defeated
	c.RandomFor(14);
	c.WaitFor(1);

	delay = delay + c.DelayUpTo(c.maxDelay - delay);
	c.RndAtLeastOne(); 
	c.RandomFor(17);
	c.WaitFor(5);

	--Attack
	delay = delay + c.DelayUpTo(c.maxDelay - delay);
	c.PushA();
	c.RandomFor(1);
	c.WaitFor(3);

	--Pick Saro
	c.PushA();
	c.RandomFor(1)
		menuPos = memory.readbyte(0x03CF);
		if (menuPos ~= 31) then
			earlyBailout = true;
			c.Debug('Failed to pick Saro, bailing attempt: ' .. c.attempts .. ' maxDelay: ' .. c.maxDelay);
			c.attempts = c.attempts + 1;
		end
	c.RandomFor(15);
	c.WaitFor(21);

	if (earlyBailout == false) then
		turn = memory.readbyte(0x0096);
		battleFlag = memory.readbyte(0x008B);

		c.RndAtLeastOne();
		c.WaitFor(25);

		c.attempts = c.attempts + 1
		ragnarHP = memory.readbyte(0x60B6);
		
		dmg = memory.readbyte(0x7361);
		newBattleFlag = memory.readbyte(0x008B);

		saroTurn = 4;
		saroAttack = 76;

		if (turn == saroTurn and ragnarHP == origRagnarHP and battleFlag == 76 and newBattleFlag ~= 76) then
			found = true;
			c.Log('Miss! ', true)
			c.maxDelay = delay - 1;
			c.Save(9);
		else
			found = false;
		end
		
		if (battleFlag == 76) then
			c.Debug(' Dmg: ' .. 27 - ragnarHP .. ' Battleflag: ' ..battleFlag, true);
		end

		c.Increment()

		if (found == true and delay == 0) then
			c.done = true;
		end
	end
	--------------------------------------
end

c.Finish();
savestate.saveslot(9);

