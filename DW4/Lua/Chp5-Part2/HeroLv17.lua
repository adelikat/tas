-- Starts at the first frame to dismiss "The marchant army attacks" with the final blow,
-- manipulated with enough damage to defeated balzack
-- Target
-- Str any
-- Ag 2
-- Vit 3 or less
-- Int 2
-- Luck 3
-- HP 6 or less
-- MP 8
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 0
local delay = 0
local targetStr = 2
local targetAg = 2
local targetVit = 3
local targetMp = 7
local rngCache
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
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.RandomFor(100)
    c.UntilNextInputFrame()

    c.RandomFor(2)
    c.UntilNextInputFrame()

    local currStr = c.Read(c.Addr.HeroStr)
    if currStr == origStr then
        c.Log('Jackpot!! 0 str')
        c.Save(string.format('HeroLv16-JackPot-NoStr-%s-Rng2-%s', emu.framecount(), c.ReadRng2()))
        return c.Bail('Jackpot!! 0 Str')
    end

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
    c.WaitFor(35)
    

    local currAg = c.Read(c.Addr.HeroAg)
    local gain = currAg - origAg
    c.Debug('Ag gain: ' .. gain)

    if gain == 0 then
        c.Log('Jackpot, agility skip!')
        c.Save(string.format('HeroLv16-JackPot-NoStr-%s-Rng2-%s', emu.framecount(), c.ReadRng2()))
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
    local orig = c.Read(c.Addr.HeroVit)
    c.AorBAdvance()
    local curr = c.Read(c.Addr.HeroVit)
    local gain = curr - orig
    c.Debug('Vit gain: ' .. gain)

    if gain == 0 then
        c.Log('Jackpot!! vit skip')
        c.Save(string.format('HeroLv16-JackPot-NoVit-%s-Rng2-%s', emu.framecount(), c.ReadRng2()))
    end

    return gain <= targetVit
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

local function _mp()
    local orig = c.Read(c.Addr.HeroMaxMp)
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
--client.speedmode(3200)
client.unpause()
while not c.done do 
    c.Load(100)
    -- local result = c.ProgressiveSearchForLevels(_str, 5, 100)
    -- if result then
    --     result = c.Cap(_ag, 10)
    --     if result then
    --         result = c.Cap(_vit, 10)
    --         if result then
    --             c.Done()
    --         end
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
