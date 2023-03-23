-- Starts at the first frame to dimiss the last "Terrific blow" from
-- The Tricksy Urchin fight
-- Manipulates Lv 3 stats
-- Str 5 is possible
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 40
local targetStrGain = 4

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _str()
    local origStr = c.Read(c.Addr.HeroStr)
    c.RndAtLeastOne()
    c.WaitFor(30)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.RandomFor(50)
    c.WaitFor(200)
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
    local origAg = c.Read(c.Addr.HeroAg)
    local origVit = c.Read(c.Addr.HeroVit)

    c.RndAorB()
    c.WaitFor(20)
    c.UntilNextInputFrame()

    local currAg = c.Read(c.Addr.HeroAg)
    local gain = currAg - origAg
    c.Debug('Ag gain: ' .. gain)

    if gain > 0 then
        return c.Bail('Got agilility: ' .. gain)
    end

    local currVit = c.Read(c.Addr.HeroVit)
    gain = currVit - origVit

    if gain > 0 then
        return c.Bail('Got Vitality: ' .. gain)
    end

    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)
    --local result = c.Cap(_str, 100)
    local result = c.ProgressiveSearchForLevels(_vitSkip, c.maxDelay)
    if c.Success(result) then
        c.Done()
    else
        c.Log('Could not manip str')
    end
end

c.Finish()
