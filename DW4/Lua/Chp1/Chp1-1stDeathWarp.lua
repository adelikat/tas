--Starts on magic frame before demon stump encounter
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 0
bestDmg = 1
function _turn()
	return memory.readbyte(0x96)
end

function _readDmg()
	return c.Read(c.Addr.Dmg)
end


function _saveBest(delay)
	c.Save(9)
	c.Save('Critical' .. delay)
end

function _doLoop()
	c.Load(0)
	c.RndAtLeastOne()
	c.WaitFor(14)
	c.PushA()
	c.RandomFor(22)
	if c.ReadMenuPosY() ~= 16 then
		c.Debug('lag at APRI, bailing')
		return false
	end

	-- APRI menu
	c.WaitFor(3)
	c.PushA()
	c.RandomFor(1)
	c.WaitFor(3)
	c.PushUp()
	if c.ReadMenuPosY() ~= 31 then
		c.Debug('lag at pushing up, bailing')
		return false
	end

	c.PushA()
	c.RandomFor(1)

	if c.ReadMenuPosY() ~= 16 then
		c.Debug('lag at picking arrow, bailing')
		return false
	end

	c.WaitFor(2)
	c.PushA()
	c.RandomFor(1)

	if c.ReadMenuPosY() ~= 31 then
		c.Debug('lag at picking Rag, bailing')
		return false
	end

	c.RandomFor(31)
	c.WaitFor(2)

	if _turn() ~= 0 then
		c.Debug('demon stump went first, bailing')
		return false
	end

	c.PushA()

	c.WaitFor(20)
	dmg = _readDmg()
	
	if dmg > bestDmg then
		bestDmg = dmg
		c.Log('New best dmg: ' .. dmg)
		_saveBest(dmg)
	else
		c.Debug('Successful attempt but no best')
	end

	if dmg >= 21 then
		return true
	end
end

while not c.done do
	result = _doLoop()
	
	if not c.done then
		c.Increment()
	end
	
	
end

c.Finish()