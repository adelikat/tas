-- Starts at the first frame to dismiss "building power" from the previous round
-- Manipulates Taloon going first, calling reinforcements, doing 2 critical hits enough to kill form 1 of necro, then a 3rd critical afterward
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 2
local delay = 0
local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _turn()
    c.RndAtLeastOne()
    c.RandomFor(26)
    c.WaitFor(4)
    if not c.PushAWithCheck() then return false end
    c.RandomFor(30)
    c.WaitFor(3)

    c.AddToRngCache()
    ------------------------------------
    if c.ReadTurn() == 4 then
        return c.Bail('Taloon did not go first')
    end

    if c.Read(c.Addr.P2Action) ~= c.Actions.Reinforcements then
        return c.Bail('Taloon did not call for reinforcements')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)

   return true
end

local function _crit1()
    delay = c.DelayUpTo(c.maxDelay)
    c.RndAtLeastOne()
    c.WaitFor(86)

    delay = delay + c.DelayUpTo(c.maxDelay - delay)
    c.RndAtLeastOne()
    c.WaitFor(17)

    delay = delay + c.DelayUpTo(c.maxDelay - delay)
    c.RndAtLeastOne()
    c.WaitFor(10)

    --c.AddToRngCache()

    local dmg = c.ReadDmg()
    c.Debug('dmg: ' .. dmg)
    if dmg < 220 then
        return false
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.Debug('delay: ' .. delay)
    return true
end

local function _crit2()
    delay = c.DelayUpTo(2)
    c.RndAtLeastOne()
    c.WaitFor(47)

    c.DelayUpTo(2 - delay)
    c.RndAtLeastOne()
    c.WaitFor(17)

    c.DelayUpTo(2 - delay)
    c.RndAtLeastOne()
    c.WaitFor(10)

    c.AddToRngCache()

    local dmg = c.ReadDmg()
    c.Debug('dmg: ' .. dmg)
    if dmg < 220 then
        return false
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)

    return true
end

local function __next()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
end

local function _crit3()
    delay = 0
    delay = c.DelayUpTo(c.maxDelay - delay)
    c.RndAtLeastOne()
    __next()

    delay = delay + c.DelayUpTo(c.maxDelay - delay)
    c.RndAtLeastOne()
    __next()
    delay = delay + c.DelayUpTo(c.maxDelay - delay)
    c.RndAtLeastOne()
    __next()
    
    delay = delay + c.DelayUpTo(c.maxDelay - delay)
    c.RndAtLeastOne()
    c.WaitFor(7)
    
    c.AddToRngCache()
    local dmg = c.ReadDmg()
    c.Debug('dmg: ' .. dmg)
    if dmg < 220 then
        return c.Bail('Did not do enough damage')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)

    return true
end

c.Load(5)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do    
	c.Load(100)
    -- local result = c.Cap(_turn, 100)
    -- if c.Success(result) then
    --     c.Log('Turn manipulated')
    --     result = c.Cap(_crit1, 500)
    --     if c.Success(result) then
    --         c.Log('delay: ' .. delay)
    --         c.Done()
    --     end
    -- end

    local result = c.Cap(_crit3, 100)
    if c.Success(result) then
        c.Done()
    end
    c.Log('RNG: ' .. c.RngCacheLength())
end

c.Finish()

