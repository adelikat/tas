local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 2
_ironClaw = 0x03

function _readDrop()
	return c.Read(0x6E0D)
end

while not c.done do
	c.Load(0)
	delay = 0
	--From menu after Terrific blow!
	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.RndAtLeastOne()
	c.WaitFor(47)
	c.RndAtLeastOne()
	c.WaitFor(22)
	c.RndAtLeastOne()

	c.WaitFor(300)
	c.Debug(_readDrop())
	if _readDrop() == _ironClaw then
		c.LogProgress('Iron Claw! delay: ' .. delay, true)
		c.Save(5)
		c.Done()
	end

	Increment('delay: ' .. delay)
end

c.Finish()