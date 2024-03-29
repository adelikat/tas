-- Starts at the first frame to dismiss "terrific blow" from the Esturk battle
-- Str 4
-- Ag 2
-- Vit 3
-- Int 2
-- Hp 8
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 2
local delay = 0
local targetStr = 4
local targetAg = 2
local targetVit = 3
local minHpValue = 8
local rngCache
local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _str()
    local origStr = c.Read(c.Addr.TaloonStr)
    c.RndAtLeastOne()
    c.WaitFor(47)
    c.RndAtLeastOne()
    c.WaitFor(19)
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne()
    c.RandomFor(100)
    c.UntilNextInputFrame()

    c.RandomFor(2)
    c.UntilNextInputFrame()

    rngCache = c.AddToRngCache()
    c.Debug('RNG: ' .. c.RngCacheLength())

    local currStr = c.Read(c.Addr.TaloonStr)
    local gain = currStr - origStr
    c.Log('Str gain: ' .. gain)
    if gain < targetStr then
        return c.Bail('Not enough str: ' .. gain)
    end
    
    _tempSave(4)
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

local function _vit()
    local curr = c.Read(c.Addr.TaloonVit)
    c.AorBAdvance()
    local orig = c.Read(c.Addr.TaloonVit)
    local gain = orig - curr
    c.Debug('Vit gain: ' .. gain)
    return gain >= targetVit
end

local function _hp()
    local origInt = c.Read(c.Addr.TaloonInt)
    local origLuck = c.Read(c.Addr.TaloonLuck)
    local origHp = c.Read(c.Addr.TaloonMaxHP)
    c.AorBAdvance()

    local currLuck = c.Read(c.Addr.TaloonLuck)
    if currLuck > origLuck then
        return c.Bail('Got luck')
    end

    local currInt = c.Read(c.Addr.TaloonInt)
    local intGain = currInt - origInt
    if intGain ~= 2 then
        return c.Bail('Got wrong int')
    end     

    c.AorBAdvance()
    local currHp = c.Read(c.Addr.TaloonMaxHP)
    local gain = currHp - origHp
    c.Debug('Hp gain: ' .. gain)


    if gain >= minHpValue then
        return true
    end

    return false
end

c.Load(4)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)
    -- local result = c.ProgressiveSearchForLevels(_str, 4, 200)
    -- if result then
    --     if rngCache then
    --         c.Log('Str found')
    --         result = c.ProgressiveSearchForLevels(_ag, 5)
    --         if result then
    --             c.Done()
    --         else
    --             c.Log('Unable to get ag RNG: ' .. c.RngCacheLength())
    --         end
    --     else
    --         c.Log('RNG already found')
    --     end        
    -- end
    -- c.Log('RNG: ' .. c.RngCacheLength())

    local result = c.ProgressiveSearchForLevels(_vit, 10)
    if result then
        c.Done()
    end

    -- local result = c.ProgressiveSearchForLevels(_hp, 20)
    -- if result then
    --     c.Done()
    -- end
end

c.Finish()
