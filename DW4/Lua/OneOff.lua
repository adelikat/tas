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
	c.RndAtLeastOne()
	c.RandomFor(1)
	_nextInputFrame()
	count = emu.framecount()
	if count < best then
		best = count
		c.Save(9)
		c.LogProgress('New Best: ' .. count, true)
	end

	c.WaitFor(2)

	c.Increment()
end

c.Finish()


