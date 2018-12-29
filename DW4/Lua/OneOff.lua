local c = require("DW4-ManipCore")

c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 0

function _nextInputFrame()
	c.Save(600)

	while emu.islagged() == true do
		c.Save(600)
		c.WaitFor(1)
	end

	c.Load(600)
end

best = 999999

while not c.done do
	c.Load(0)

	c.RandomFor(1)
	c.UntilNextMenu()
	c.RndAorB()
	c.WaitFor(23)
	c.RndAtLeastOne()
	c.WaitFor(50)
	_nextInputFrame()
	
	count = emu.framecount()
	if count < best then
		c.Debug('New best: ' .. count, true)
		c.Save(9)
		best = count
	end

end

c.Finish()


