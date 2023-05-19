local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 20

_wait3 = 20
_wait2 = 47
_wait1 = 18 

local delay = 0

function _saveBest(delay)
	c.Save(9)
	c.Save('Treasure' .. delay)
end

function _step(wait, noDelay)
	if (wait > 0) then
		if not noDelay then
			delay = delay + c.DelayUpTo(c.maxDelay - delay)
		end
		c.RndAtLeastOne()
		c.RandomFor(wait - 2)
		c.WaitFor(2)
	end
end

while not c.done do
	c.Load(0)
	delay = 0

	_step(_wait3, true)
	_step(_wait2)
	_step(_wait1)
	
	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.RndAtLeastOne()
	c.RandomFor(160)

	drop = memory.readbyte(0x00C4);

	if drop ~= 0xFF then
		c.Debug('Found item: ' .. c.Items[drop])
		c.Save(6)
	end

    if drop ~= 0xFF --Nothing
   and drop ~= 0x00 --Cypress stick
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
		found = true
		c.LogProgress('Found! ' .. ' delay: ' .. delay .. ' item: ' .. c.Items[drop], true)
	 	c.maxDelay = delay - 1
	 	_saveBest(delay)
	else
		found = false
	end
	
	c.Increment('delay: ' .. delay .. ' drop: ' .. c.Items[drop])

	if (found == true and delay == 0) then
		c.Done()
		c.Save(9)
	end
end

c.Finish();


