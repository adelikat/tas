-- Starts at the last lag frame after entering Balzack's chambers
-- manipulates walking to him and starting the fight
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 0

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _turn()
    c.RndAtLeastOne()
    c.RandomFor(40)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end    
    c.RandomFor(8)
    c.WaitFor(5)
    c.UntilNextInputFrame()

    
    c.PushDown()
    c.WaitFor(1)
    c.PushDown()
    if not c.PushAWithCheck() then return false end
   
    c.RandomFor(38)
    c.WaitFor(2)
    c.AddToRngCache()
    -------------------
    if c.ReadTurn() ~= 1 then
        return c.Bail()
    end

    if c.Read(c.Addr.P2Action) ~= c.Actions.Reinforcements then
        return c.Bail('Taloon did not call for reinforcements')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)
    return true
end

-- Manipulates a regular hit followed by a critical
local function _lastCritical()
    local eHP = c.ReadE1Hp()
    c.Debug('Starting HP: ' .. eHP)
    c.RndAtLeastOne()
    c.WaitFor(1)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.WaitFor(1)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.WaitFor(5)
    local newEhp = c.ReadE1Hp()
    c.Debug('HP after regular hit: ' .. newEhp)
    if newEhp == eHP then
        c.Log('Taloon missed')
        return false
    end
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.WaitFor(1)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.WaitFor(8)
    local finalHp = c.ReadE1Hp()
    if finalHp > 0 then
        return c.Bail('Did not get critical')
    end

    _tempSave(7)
    return true
end

c.Load(6)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)
    -- local result = c.Cap(_turn, 1000)
    -- if c.Success(result) then
    --     c.Done()
    -- end
    local result = c.ProgressiveSearch(_lastCritical, 1000, 3)
    if c.Success(result) then
        c.Done()
    end
    c.Log('RNG: ' .. c.RngCacheLength())
end

c.Finish()
