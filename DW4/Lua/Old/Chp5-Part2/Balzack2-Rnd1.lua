-- Starts at the last lag frame after entering Balzack's chambers
-- manipulates walking to him and starting the fight
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 3

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _do()
    c.RandomFor(2)
    c.WaitFor(13)
    c.RndAtLeastOne()
    c.RandomFor(25)
    c.WaitFor(4)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end
    c.RandomFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(4)
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Could not navigate to spell')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Could not navigate to parry')
    end
    c.DelayUpToWithLAndR(c.maxDelay)
    if not c.PushAWithCheck() then return false end 
    c.RandomFor(43)

    c.AddToRngCache()
    -------------------------------
    if c.Read(c.Addr.E1Action) ~= 67 then
        return c.Bail('Balzack did not attack')
    end

    if c.Read(c.Addr.E1Target) ~= 1 then
        return c.Bail('Balzack did not target Ragnar')
    end

    if c.ReadTurn() ~= 2 then
        return c.Bail('Taloon did not go first')
    end

    if c.Read(c.Addr.P3Action) ~= c.Actions.BuildingPower then
        return c.Bail('Taloon did not build power')
    end

    --Seems to be the 2nd action of Balzack, possibly other bosses
    if c.Read(0x7334) ~= 67 then
        return c.Bail('Balzack 2nd action was not an attack')
    end

    -------------------------------
    c.UntilNextInputFrame()
    c.WaitFor(2)

    _tempSave(4)
    return true
end

-- Taloon builds power
-- Hero parries
-- Balzack attacks Ragnar who dies
-- Balzack attacks hero and misses
local function _finishRound()
    c.RndAtLeastOne()
    c.RandomFor(21)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.RandomFor(22)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.WaitFor(8)
    local currRagnarHp = c.Read(c.Addr.RagnarHp)
    if currRagnarHp > 0 then
        return c.Bail('Ragnar did not die')
    end
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- x Damage points
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.RandomFor(11)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.AddToRngCache()
    
    local origHeroHp = c.Read(c.Addr.HeroHp)
    c.RndAtLeastOne()    
    c.WaitFor(7)
    local currHeroHp = c.Read(c.Addr.HeroHp)
    if origHeroHp ~= currHeroHp then
        return c.Bail('Hero got hit')
    end
    
    c.UntilNextInputFrame()
    c.WaitFor(2)

    return true
end

c.Load(4)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)
    --local result = c.Cap(_do, 100)
    local result = true
    if c.Success(result) then
        result = c.ProgressiveSearch(_finishRound, 200, 5)
        if c.Success(result) then
            c.Done()
        end
    end
    c.Log('RNG: ' .. c.RngCacheLength())
end

c.Finish()
