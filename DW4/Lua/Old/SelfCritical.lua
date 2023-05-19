_minDmg = 20
_ragTurn = 0

local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 0

function _readDmg()
	return c.Read(c.Addr.Dmg)
end

function _readTurn()
	return c.Read(c.Addr.Turn)
end

while not c.done do
	c.Load(0)
	delay = 0

	c.RandomFor(1) -- Magic frame
	c.WaitFor(14)

	--Enemy Appears
	delay = delay + c.DelayUpTo(c.maxDelay)
	c.RndAtLeastOne()
	c.RandomFor(1)
	c.WaitFor(1) 
	c.RandomFor(18)
	c.WaitFor(5)

	--Attack
	c.PushA()
	c.RandomFor(1)
	c.WaitFor(4)

	--Pick Arrow
	c.PushUp()
	c.PushA()
	c.RandomFor(1)
	c.WaitFor(2)

	--Pick Self
	--delay = delay + c.DelayUpTo(maxDelay)
	c.PushA()
	c.RandomFor(1)
	c.WaitFor(1)
	c.RandomFor(12)
	c.WaitFor(20)
	c.RndAtLeastOne()

	c.WaitFor(35) -- Ensure damage is calculated and in memory
	c.Increment()

	-- Eval
	--------------------------------------
	if _readTurn() == _ragTurn and _readDmg() > _minDmg 
		then
		c.done = true
	end
end

c.Finish()



