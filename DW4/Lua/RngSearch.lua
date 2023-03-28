
-- Runs through a scenario poking all RNG values to see if the situation is possible
-- The _do method should not have any random button presses or delays
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 2

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

-- local function _do()
-- 	local origStat = c.Read(c.Addr.HeroVit)
-- 	c.PushA()
-- 	c.WaitFor(10)
-- 	c.UntilNextInputFrame()
	
-- 	local currStat = c.Read(c.Addr.HeroVit)
-- 	local gain = currStat - origStat
-- 	c.Debug('gain: ' .. gain)

-- 	if gain == 0 then
-- 		return true
-- 	end
-- end

local function _do()
	c.PushUp()
	c.WaitFor(20)
	if not c.IsEncounter() then
		c.Debug('No encounter')
		return false
	end
	
	if c.ReadEGroup1Type() ~= 0x75 then
		c.Debug('Did not get metal babbles')
        return false
    end

	local count = c.ReadE1Count()
	c.Log('Got metal babbles: ' .. count)

    if c.ReadEGroup2Type() ~= 0xFF then
		c.Log('But metals were with other enemies')
		c.Debug('Got 2nd enemy group')
        return false
    end

	
	return count == 1
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
	local result = c.RngSearch(_do)	
	if c.Success(result) then
		c.Done()
	else
		c.Log('Nothing found')
	end
end

c.Finish()



