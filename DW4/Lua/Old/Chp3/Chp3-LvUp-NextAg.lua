-- Starts from the first input frame to press A or B to get
-- the last stat of the previous level
-- Ensures only Str, Ag, Vit, and HP go up
-- Looks for 'Jackpot' scenarios of skipping one of these major stats
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 10
c.maxDelay = 4
local minValue = 3
local delay = 0

local function _magicFrame()
    local origStat = c.Read(c.Addr.TaloonStr)
    c.RandomFor(1)
    c.WaitFor(5)
	c.UntilNextInputFrame()

    local currStat = c.Read(c.Addr.TaloonStr)
    local gain = currStat - origStat
    c.Debug('Str Gain: ' .. gain)
    return gain >= 2
end

local function _str()    
    delay = delay + c.DelayUpToForLevels(c.maxDelay - delay)
	c.RndAorB()
	c.WaitFor(200)
	c.UntilNextInputFrame()	

    c.Log('Trying with delay: ' .. delay)

	return c.Cap(_magicFrame, 50)
end

local function _stat()
    local origStat = c.Read(c.Addr.TaloonAg)
    delay = delay + c.DelayUpToForLevels(c.maxDelay - delay)
	c.RndAorB()
    c.WaitFor(30)
	c.UntilNextInputFrame()

    local currStat = c.Read(c.Addr.TaloonAg)
    local gain = currStat - origStat

    c.Debug('Ag Gain: ' .. gain)
    if gain == 0 then
        c.Log('Jackpot!! No agility')
        c.Save('AgSkip-'..emu.framecount())
    end
    return currStat - origStat >= minValue
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
    --local strResult = c.Cap(_str, 100)
    strResult = true
    if strResult then
        --c.Log('Got str, trying Ag')
        local result = c.ProgressiveSearchForLevels(_stat, 30)
        if result then
            c.Log('Delay: ' .. delay)
            c.Done()
        else
            c.Log('Failed to get stat')
        end
    end
	
end

c.Finish()
