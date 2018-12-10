-----------------
-- Settings
-----------------
maxDelay = 16; --Max amount of delay to use during delayable moments
reportFrequency = 5; -- How many attempts before it logs a result

-------------------------
local c = require("DW4-ManipCore");
c.InitSession();

while not c.done do
	maxDelay = math.floor(c.attempts / 64) + 1;
	savestate.loadslot(0);
	delay = 0;

	-- Loop
	--------------------------------------
	

	delay = delay + c.DelayUpTo(maxDelay);
	c.RndAtLeastOne();
	c.RandomFor(17);
	c.WaitFor(1);

	delay = delay + c.DelayUpTo(maxDelay);
	c.RndAtLeastOne();
	c.RandomFor(145);

	--------------------------------------
	c.attempts = c.attempts + 1
	-- Eval
	--------------------------------------
	drop = memory.readbyte(0x00C4);

    if drop ~= 0xFF --Nothing
   and drop ~= 0x01 --Club
   and drop ~= 0x02 --Copper Sword
   and drop ~= 0x04 --Chain Sickle
   and drop ~= 0x05 --Iron Spear
   and drop ~= 0x06 --Broad Sword
   and drop ~= 0x25 --Wayfarers Clothes
   and drop ~= 0x26 --Leather Armor
   and drop ~= 0x27 --Chain Mail
   --and drop ~= 0x28 --Half Plate Armor
   and drop ~= 0x3D --Leather Shield
   and drop ~= 0x3E --Scale Shield
   and drop ~= 0x46 --Leather Hat
   and drop ~= 0x47 --Wooden Hat
   and drop ~= 0x53 --Medical Herb
   and drop ~= 0x54 --Antitode Herb
   and drop ~= 0x56 --Wing of Wryvern

   then
		c.done = true;
	end
		
	c.LogProgress(c.done, c.attempts, string.format('%02d', delay), 'drop: ' .. c.Items[drop]);
	
	--------------------------------------
end

c.Finish();


