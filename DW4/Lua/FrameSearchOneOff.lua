local c = require("DW4-ManipCore");
c.InitSession();
c.reportFrequency = 1;

_hpAddr = 0x6098
_frame = 0;
_delay = 0;
while not c.done do
	c.Load(0);
	origHp = c.Read(_hpAddr)
	

	-- Loop
	c.WaitFor(_delay);
	c.PushA();
	c.WaitFor(30);
	
	--Miss
	hp = c.Read(_hpAddr)
	if hp == origHp then
		c.Save(9)
		c.Done()
	end

	--Crit
	--dmg = memory.readbyte(0x7361);
	--if dmg >= 110 then c.done = true; end

	--------------------------------------

	c.Increment('delay: ' .. _delay .. ' orig hp: ' .. origHp .. ' hp: ' .. hp)
	_delay = _delay + 1;
end

c.Finish();


