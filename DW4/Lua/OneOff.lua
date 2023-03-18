local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 30

local function _do()
	c.PushA()
	c.WaitFor(10)

	local dmg = c.ReadDmg()
	c.Debug('Dmg: ' .. dmg)
	return dmg >= 80
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
	local result = c.FrameSearch(_do, 500)	
	if result then
		c.Done()
	else
		c.Log('Nothing found')
	end
end

c.Finish()



