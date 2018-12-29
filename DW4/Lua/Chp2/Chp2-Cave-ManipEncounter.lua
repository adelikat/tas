local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 0

function _readBattle()
	return c.Read(c.Addr.BattleFlag)
end

function _readE1Type()
	return c.Read(0x6E45)
end

function _readE2Type()
	return c.Read(0x6E46)
end

while not c.done do
	c.Load(0)
	c.RndWalkingFor('Left', 35)
	c.PushA()
	c.WaitFor(23)
	c.PushDown()
	c.PushRight()
	c.PushDown()
	c.WaitFor(1)
	c.PushDown()
	c.PushA()
	c.UntilNextMenu()
	c.RndAorB()
	c.UntilNextMenu()
	c.RndAorB()
	c.WaitFor(200)
	c.UntilNextInputFrame()
	c.WaitFor(2)

	--Treasure get, time to move
	c.RndAtLeastOne()
	c.WaitFor(10)
	direction = c.GenerateRndDirection()
	
	c.PushFor(direction, 18)
	c.RndWalkingFor(direction, 12)
	c.WaitFor(30)
	battle = _readBattle()
	if battle > 0 then
		c.Log('Encounter!', true)
	end
	if battle > 0 and _readE2Type() == 0xFF and _readE1Type() == 0x1D then
		c.Done()
	else
		c.Increment()
	end
end

c.Finish()


