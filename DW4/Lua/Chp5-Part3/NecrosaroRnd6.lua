-- Starts at the first frame to dismiss the last action of round 4
-- Manipulates Necrosar's belly writhes grotesquely, followed by Taloon building power
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 0
local delay = 0
local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function __next()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
end

local function _turn()
    c.RndAtLeastOne()
    __next()
    c.RndAtLeastOne()
    __next()
    c.RndAtLeastOne()
    __next()
    c.RndAtLeastOne()
    __next()
    c.RndAtLeastOne()
    __next()
    c.RndAtLeastOne()
    c.RandomFor(24)
    c.WaitFor(4)
    if not c.PushAWithCheck() then return false end
    c.RandomFor(20)
    -- Necrosaro's belly writhes grotesquely
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.RandomFor(10)
    c.UntilNextInputFrame()    
    
    if c.Read(c.Addr.P2Action) ~= c.Actions.BuildingPower then
		return c.Bail('Did not call for reinforcements')
	end

    c.WaitFor(2)

   return true
end

c.Load(3)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do    
	c.Load(100)

    local result = c.Cap(_turn, 300, 5)
    if c.Success(result) then
        c.Done()
    end

    c.Log('RNG: ' .. c.RngCacheLength())
end

c.Finish()

