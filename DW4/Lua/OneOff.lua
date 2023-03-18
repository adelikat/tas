local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 30

local function _do()
	local origLuck = c.Read(c.Addr.MaraVit)
	c.PushA()
	c.WaitFor(50)

	local currLuck = c.Read(c.Addr.MaraVit)
	local increase = currLuck - origLuck

	if increase > 3 then
		c.Log('Increase ' .. increase)
	end
	c.Debug('Luck Increase: ' .. increase)
	return increase == 0
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
	local result = c.RngSearch(_do)	
	if result then
		c.Done()
	else
		c.Log('Nothing found')
	end
end

c.Finish()



