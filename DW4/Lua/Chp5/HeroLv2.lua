-- Starts at the first frame possible to dismiss the "3 Dmage points" dialog
-- On the last round of the Liclick fight
-- Target
-- Str 4
-- Ag 0
-- Vit 2
-- HP 4
-- MP 4

local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 6

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _str()
    local origStr = c.Read(c.Addr.HeroStr)
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.RandomFor(30)
    c.UntilNextInputFrame()
    c.RandomFor(1)
    c.WaitFor(2)
    c.UntilNextInputFrame()

    local currStr = c.Read(c.Addr.HeroStr)
    local gain = currStr - origStr
    c.Debug('Str Gain: ' .. gain) 
    if gain < 4 then
        return c.Bail('Not enough str')
    end

    _tempSave(4)

    return true
end

local function _vit()
    local origAg = c.Read(c.Addr.HeroAg)
    local origVit = c.Read(c.Addr.HeroVit)

    c.DelayUpToForLevels(1)
    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()

    local currAg = c.Read(c.Addr.HeroAg)

    if currAg > origAg then
        return c.Bail('Got agility')
    end

    local currVit = c.Read(c.Addr.HeroVit)
    local gain = currVit - origVit
    if gain > 2 then
        return c.Bail('Too much vitality')
    end
    
    return true
end

local function _mp()
    local origMp = c.Read(c.Addr.HeroMaxMp)
    c.DelayUpToForLevels(3)
    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()

    local currMp = c.Read(c.Addr.HeroMaxMp)
    local gain = currMp - origMp
    if gain < 4 then
        return c.Bail('Not enough MP')        
    end

    return true
end

c.Load(4)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)
    
    local result = c.Cap(_mp, 100)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()
