-- Starts at the first frame to dismiss the 'Taloon is building up power' dialog from the previous round
-- Manipulates Taloon going first, and calling for reinforcements
-- Rest of round will be 3 crits, will use critical script for those
-- These 3 crits will defeat Necrosaro
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 0
local delay = 0
local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _turn()
    c.RndAtLeastOne()
    c.RandomFor(35)
    c.WaitFor(5)
    if not c.PushAWithCheck() then return false end
    c.RandomFor(37)
    c.WaitFor(5)

    if c.ReadTurn() == 4 then
        return c.Bail('Taloon did not go first')
    end

    if c.Read(c.Addr.P2Action) ~= c.Actions.Reinforcements then
		return c.Bail('Did not call for reinforcements')
	end

    c.UntilNextInputFrame()
    c.WaitFor(2)

   return true
end

-- Use critical script first 1st 2, then this
local function _lastRegular()
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne()
    c.WaitFor(6)
    c.AddToRngCache()
    if c.Read(c.Addr.E1Hp) > 0 then
        return false
    end
    return true
end

c.Load(5)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do    
	c.Load(100)

    -- local result = c.Cap(_turn, 300, 5)
    -- if c.Success(result) then
    --     c.Done()
    -- end

    local result = c.Cap(_lastRegular, 25, 5)
    if c.Success(result) then
        c.Done()
    end

    c.Log('RNG: ' .. c.RngCacheLength())
end

c.Finish()

