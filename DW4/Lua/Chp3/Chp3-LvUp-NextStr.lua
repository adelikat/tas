-- Starts from the first input frame to press A or B to get
-- the last stat of the previous level
-- Ensures only Str, Ag, Vit, and HP go up
-- Looks for 'Jackpot' scenarios of skipping one of these major stats
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 20
local minValue = 4
local delay = 0
local function _magicFrame()
    local origStat = c.Read(c.Addr.TaloonStr)
    c.RandomFor(1)
    c.WaitFor(5)
	c.UntilNextInputFrame()

    local currStat = c.Read(c.Addr.TaloonStr)

    c.Debug('Gain: ' .. currStat - origStat)
    return currStat - origStat >= minValue
end

local function _str()    
	c.RndAorB()
	c.WaitFor(200)
	c.UntilNextInputFrame()	

	return c.Cap(_magicFrame, 25)
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
    
	local result = c.ProgressiveSearchForLevels(_str, c.maxDelay)
    if result then
        c.Log('Found! delay: ' .. delay)
        c.Done()
    else
        c.Log(':(')
        c.Log('Failed to get stat!')
    end
end

c.Finish()
