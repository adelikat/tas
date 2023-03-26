-- Starts at the first frame to dismiss the terrific blow command
-- From hector's last attack that ends the fight
-- Target
-- Str 4
-- Ag 0
-- Int 0
-- MP 4
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 2
local delay = 0
local targetStr = 4
local rngCache
local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _str()
    local origStr = c.Read(c.Addr.HeroStr)
    c.RndAtLeastOne()
    c.WaitFor(47)
    
    c.RndAtLeastOne()
    c.WaitFor(20)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.RandomFor(70)
    c.WaitFor(250)
    c.UntilNextInputFrame()

    c.RandomFor(2)
    c.WaitFor(11)

    rngCache = c.AddToRngCache()

    local currStr = c.Read(c.Addr.HeroStr)
    local gain = currStr - origStr
    c.Debug('Str gain: ' .. gain)
    if gain < targetStr then
        return c.Bail('Not enough str')
    end

    return true
end

local function _agSkip()
    local origAg = c.Read(c.Addr.HeroAg)
    c.RndAorB()
    c.WaitFor(1)
    if c.Read(0x0644) ~= 0xFF then
        c.Log('Lag at Str menu advance!')
        return false
    end
    c.WaitFor(35)
    

    local currAg = c.Read(c.Addr.HeroAg)
    local gain = currAg - origAg
    c.Debug('Ag gain: ' .. gain)

    if gain == 0 then
        c.UntilNextInputFrame()
        return true
    end

    return false
end

local function _intSkip()
    local orig = c.Read(c.Addr.HeroInt)
    c.RndAorB()
    c.WaitFor(47)
    local curr = c.Read(c.Addr.HeroInt)
    local gain = curr - orig
    c.Debug('Int gain: ' .. gain)

    if gain == 0 then
        c.UntilNextInputFrame()
        return true
    end

    return false
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)
    -- local result = c.Cap(_str, 1000)
    -- if result then
    --     if rngCache then
    --         result = c.ProgressiveSearchForLevels(_agSkip, c.maxDelay)
    --         if result then
    --             c.Done()
    --         else
    --             c.Log('Unable to get ag skip RNG: ' .. c.RngCacheLength())
    --         end
    --     else
    --         c.Log('RNG already found')
    --     end        
    -- end

    local result = c.ProgressiveSearchForLevels(_intSkip, 10)
    if result then
        c.Done()
    end
end

c.Finish()
