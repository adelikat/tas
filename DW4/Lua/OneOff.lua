local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 30

local function _do()
	-- c.RndAtLeastOne()
	-- c.WaitFor(14)
	-- c.RndAtLeastOne()
	-- c.RandomFor(20)
	-- c.UntilNextInputFrame()
	-- c.WaitFor(2)

	-- local delay = c.DelayUpTo(c.maxDelay)
	c.RndAtLeastOne()
	c.WaitFor(4)

	local dmg = c.ReadDmg()
	c.Debug('dmg: ' .. dmg)	
	if dmg >= 18 then		
		return true
	end
	
	return false
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
	local result = c.RngSearch(_do, 1900)	
	if result then
		c.Done()
	else
		c.Log('Nothing found')
	end
end

c.Finish()



