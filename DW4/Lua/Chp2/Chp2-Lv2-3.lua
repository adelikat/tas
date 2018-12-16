local c = require("DW4-ManipCore")

c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 0

function _readDrop()
	return c.Read(c.Addr.Drop)
end

while not c.done do
	c.Load(0)

	c.RndAtLeastOne() -- Alena attacks
	c.RandomFor(1)
	c.WaitFor(19)

	c.RndAtLeastOne() -- Alena critical
	c.RandomFor(1)
	c.WaitFor(46)

	c.RndAtLeastOne() -- 13 Dmg
	c.RandomFor(1)
	c.WaitFor(22)

	c.RndAtLeastOne() -- Defeated
	c.RandomFor(1)



	c.Save(4)
	c.WaitFor(200)

	c.Increment()
end

c.Finish()


