-- Starts at the first frame to dismiss the MP goes up command from level 11,
-- with Repel Maniuplated
-- Str 4
-- Ag 2
-- Int 0
-- Luck 3
-- MP 4
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 0
local delay = 0
local targetStr = 4
local targetAg = 2
local targetMp = 4
local rngCache
local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _str()
    local origStr = c.Read(c.Addr.HeroStr)
    c.RndAorB()
    c.WaitFor(100)
    c.UntilNextInputFrame()

    c.RandomFor(2)
    c.UntilNextInputFrame()

    rngCache = c.AddToRngCache()
    c.Debug('RNG: ' .. c.RngCacheLength())

    local currStr = c.Read(c.Addr.HeroStr)
    local gain = currStr - origStr
    c.Debug('Str gain: ' .. gain)
    if gain < targetStr then
        return c.Bail('Not enough str: ' .. gain)
    end
    
    return true
end

local function _ag()
    local origAg = c.Read(c.Addr.HeroAg)
    c.RndAorB()
    c.WaitFor(1)
    if c.Read(0x0644) ~= 0xFF then
        c.Log('Lag at Str menu advance!')
        return false
    end
    c.UntilNextInputFrame()
    

    local currAg = c.Read(c.Addr.HeroAg)
    local gain = currAg - origAg
    c.Debug('Ag gain: ' .. gain)

    if gain == 0 then
        c.Log('Jackpot, agility skip!')
        c.UntilNextInputFrame()
        return true
    end

    if gain >= targetAg then
        c.UntilNextInputFrame()
        return true
    end

    return false
end

local function _intSkip()
    local orig = c.Read(c.Addr.HeroInt)

    c.AorBAdvance()
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

local function _mp()
    local orig = c.Read(c.Addr.HeroMaxMp)
    c.AorBAdvance()
    c.RndAorB()
    c.WaitFor(51)
    local curr = c.Read(c.Addr.HeroMaxMp)
    local gain = curr - orig
    c.Debug('Mp gain: ' .. gain)

    if gain >= targetMp then
        c.UntilNextInputFrame()
        return true
    end

    return false
end

c.Load(5)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)
    -- local result = c.ProgressiveSearchForLevels(_str, 4, 100)
    -- if result then
    --     if rngCache then
    --         result = c.ProgressiveSearchForLevels(_ag, c.maxDelay)
    --         if result then
    --             c.Done()
    --         else
    --             c.Log('Unable to get ag RNG: ' .. c.RngCacheLength())
    --         end
    --     else
    --         c.Log('RNG already found')
    --     end        
    -- end

    -- local result = c.ProgressiveSearchForLevels(_intSkip, 10)
    -- if result then
    --     c.Done()
    -- end

    local result = c.ProgressiveSearchForLevels(_mp, 20)
    if result then
        c.Done()
    end
end

c.Finish()
