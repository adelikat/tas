-- Starts from the first input frame to press A or B to get
-- the last stat of the previous level
-- Ensures only Str, Ag, Vit, and HP go up
-- Looks for 'Jackpot' scenarios of skipping one of these major stats
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 29
local stat = c.Addr.TaloonAg
local minValue = 3

local function _stat()
    local origStat = c.Read(stat)
    local delay = c.DelayUpToForLevels(c.maxDelay)
	c.RndAorB()
    c.WaitFor(30)
	c.UntilNextInputFrame()

    local currStat = c.Read(stat)

    c.Debug('Gain: ' .. currStat - origStat)
    return currStat - origStat >= minValue
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
    
	local result = c.Cap(_stat, 1000)
    if result then
        c.Done()
    else
        c.Log('Failed to get stat')
    end
end

c.Finish()
