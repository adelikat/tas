-----------------
-- Settings
-----------------
reportFrequency = 1; -- How many attempts before it logs a result
-------------------------
local c = require("DW4-ManipCore");
c.InitSession();

frame = 0;
while not c.done do
	savestate.loadslot(0);
	delay = 0;

	-- Loop
	--------------------------------------
	c.WaitFor(frame);

	c.PushA();
	c.WaitFor(23);
	
	frame = frame + 1;
	c.attempts = c.attempts + 1;	
	-- Eval
	--------------------------------------
	
	hp = memory.readbyte(0x6098);
	if hp == 38 then c.done = true; end
	c.LogProgress(c.done, c.attempts, frame, 'hp: ' .. hp);

	--dmg = memory.readbyte(0x7361);
	--if dmg >= 110 then c.done = true; end
	--c.LogProgress(c.done, c.attempts, frame, 'dmg: ' .. dmg);

	--------------------------------------
end

c.Finish();


