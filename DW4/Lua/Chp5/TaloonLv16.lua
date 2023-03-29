-- Starts at the magic frame before lv 16 (lv 15 had an HP skip)
-- Str 4
-- Ag 2
-- Vit 4
-- Hp 9
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 1
local delay = 0
local targetStr = 4
local targetAg = 2
local targetVit = 4
local minHpValue = 10
local rngCache
local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _str()
    local origStr = c.Read(c.Addr.TaloonStr)

    c.RandomFor(2)
    c.UntilNextInputFrame()

    rngCache = c.AddToRngCache()
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
    if currInt > origInt then
        return c.Bail('Got int')
    end     

    local currHp = c.Read(c.Addr.TaloonMaxHP)
    local gain = currHp - origHp
    c.Debug('Hp gain: ' .. gain)

    if gain == 0 then
        c.Log('Jackpot, no HP')
        return true
    end

    if gain >= minHpValue then
        return true
    else
        c.Log(string.format('Got int and luck skip, gain %s, delay %s', gain, delay))
        c.Save(string.format('Hp%s-delay-%s', gain, delay))
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
    -- local result = c.Cap(_str, 500)
    -- if result then
    --     if rngCache then
    --         c.Log('Str found')
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

    -- local result = c.ProgressiveSearchForLevels(_vit, 10)
    -- if result then
    --     c.Done()
    -- end

    local result = c.ProgressiveSearchForLevels(_hp, 20)
    if result then
        c.Done()
    end
end

c.Finish()
