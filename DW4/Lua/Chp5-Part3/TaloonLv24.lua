-- Starts at the first frame to dismiss "terrific blow" from the Infernus Shadow Fight
-- Str 4
-- Ag 2
-- Vit any
-- Int any
-- Hp any
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 2
local delay = 0
local targetStr = 4
local targetAg = 2
local targetVit = 4
local minHpValue = 10
local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _str()
    c.RndAtLeastOne()
    c.WaitFor(47)
    c.RndAtLeastOne()
    c.WaitFor(22)
    c.RndAtLeastOne()
    c.WaitFor(46)
    c.RndAtLeastOne()
    c.RandomFor(100)
    c.WaitFor(200)
    c.UntilNextInputFrame()

     local origStr = c.Read(c.Addr.TaloonStr)

    c.RandomFor(2)
    c.UntilNextInputFrame()

    c.Debug('RNG: ' .. c.RngCacheLength())

    local currStr = c.Read(c.Addr.TaloonStr)
    local gain = currStr - origStr
    c.Debug('Str gain: ' .. gain)
    if gain < targetStr then
        return c.Bail('Not enough str: ' .. gain)
    end
    
    return true
end

local function _ag()
    local origAg = c.Read(c.Addr.TaloonAg)
    c.RndAorB()
    c.WaitFor(1)
    if c.Read(0x0644) ~= 0xFF then
        c.Log('Lag at Str menu advance!')
        return false
    end
    c.UntilNextInputFrame()
    

    local currAg = c.Read(c.Addr.TaloonAg)
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

-- Assumes Vit/Int cannot be skipped
-- Vit can be anything
-- Int can be anything
-- Manips 0 luck
local function _luckSkip()
    c.AorBAdvance()
    c.AorBAdvance()
    local origLuck = c.Read(c.Addr.TaloonLuck)
    c.Debug('orig luck: ' .. origLuck)
    c.Debug('orig HP: ' .. origHp)
    c.RndAorB()
    c.WaitFor(50)

    local currLuck = c.Read(c.Addr.TaloonLuck)
    c.Debug('curr luck: ' .. currLuck)
    if currLuck > origLuck then
        return c.Bail('Got luck')
    end

    return true
end

c.Load(3)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)
    local result = c.Cap(_str, 100)
    if c.Success(result) then
        result = c.Cap(_ag, 5)
        if c.Success(result) then
        result = c.AddToRngCache()
        if c.Success(result) then
            result = c.ProgressiveSearchForLevels(_luckSkip, 20)
                if c.Success(result) then
                    c.Done()
                end
            end
        else
            c.Log('RNG already found')
        end
    end
    -- local result = c.ProgressiveSearchForLevels(_luckSkip, 25)
    -- if c.Success(result) then
    --     c.Done()
    -- end
end

c.Finish()
