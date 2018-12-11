local c = require("DW4-ManipCore")

c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 0

while not c.done do
	c.Load(0)
	c.RndWalkingFor('Up', 520)
	c.WaitFor(652)
	c.RandomFor(1)
	local bail = false
		if emu.islagged() then
			c.Debug('Lagged on magic frame, aborting')
			bail = true
		end

	if bail == false then
		c.WaitFor(14)
		c.RndAtLeastOne()
	end

	c.WaitFor(100)
	c.Increment()
end

c.Finish()


