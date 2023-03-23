-- Starts at the first frame to get the last stat from the previous level
-- Manipulates Lv 4 stats
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 70
local targetStrGain = 4
local targetAgGain = 2

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _str()
    local origStr = c.Read(c.Addr.HeroStr)

    c.RndAorB()
    c.WaitFor(30)
    c.UntilNextInputFrame()

    c.RndAorB()
    c.WaitFor(20)
    c.UntilNextInputFrame()

    c.RandomFor(2)
    c.UntilNextInputFrame()

    local currStr = c.Read(c.Addr.HeroStr)
    local gain = currStr - origStr
    c.Debug('Str gain: ' .. gain)
    if gain == 4 then
        c.Log('Str gain 4')
    end
    return gain >= targetStrGain
end

local function _vitSkip()
    local origVit = c.Read(c.Addr.HeroVit)

    c.RndAorB()
    c.WaitFor(20)
    c.UntilNextInputFrame()

    local currVit = c.Read(c.Addr.HeroVit)
    gain = currVit - origVit

    if gain > 0 then
        return c.Bail('Got Vitality: ' .. gain)
    end

    return true
end

local function _ag()
    local origAg = c.Read(c.Addr.HeroAg)

    c.RndAorB()
    c.WaitFor(20)
    c.UntilNextInputFrame()

    local currAg = c.Read(c.Addr.HeroAg)
    local gain = currAg - origAg
    c.Debug('Agility Gain: ' .. gain)

    return gain >= targetAgGain
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
--client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)
    -- local result = c.ProgressiveSearchForLevels(_vitSkip, c.maxDelay)
    -- if result then
    --     c.Done()
    -- end

    local result = c.Cap(_str, 100)    
    if c.Success(result) then
        result = c.ProgressiveSearchForLevels(_ag, 1)
        if result then
            c.Done()
        else
            c.Log('Could not manip ag')
        end        
    else
        c.Log('Could not manip str')
    end
end

c.Finish()
