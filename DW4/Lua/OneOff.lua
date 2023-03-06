local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 10000
local stat = c.Addr.TaloonVit

local function _do()
	local origStat = c.Read(stat)
	c.PushA()
	c.WaitFor(20)
	c.UntilNextInputFrame()
	
	local currStat = c.Read(stat)
	local gain = currStat - origStat
	c.Debug('gain: ' .. gain)
	return gain >= 5
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
	local result = c.ProgressiveSearchForLevels(_do, 1, 50)
	
	if result then
		c.Done()
	end
end

c.Finish()



