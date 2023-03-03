local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 10000

local function _do()
	local direction = c.GenerateRndDirection()
	--c.RndWalkingFor(direction, 10)
	c.WaitFor(10)
	c.RndAorB()
	c.WaitFor(10)
	
	return c.AddToRngCache()
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
	local result = _do()
	
	if result then
		c.Log('New RNG, total: ' .. c.RngCacheLength())
	end
end

c.Finish()



