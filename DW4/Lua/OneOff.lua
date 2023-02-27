local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 10000

local function _do()
	c.RndAorB()
	c.WaitFor(48)
	c.UntilNextInputFrame()
	c.WaitFor(1)
	c.RndAtLeastOne()
	c.WaitFor(90)
	c.UntilNextInputFrame()

	return true
end

function _critical()
    c.RndAtLeastOne()
    c.WaitFor(4)
	local dmg = c.ReadDmg()
	c.Debug('Dmg: ' .. dmg)
    return dmg > 20
end

c.Load(0)
c.Save(100)
while not c.done do
	c.Load(100)
	--local result = c.RngSearch(_critical)
	local result = c.FrameSearch(_critical, 1000)
	if result then
		c.Done()
	end
	c.Log('Critical is impossible!')
end

c.Finish()



