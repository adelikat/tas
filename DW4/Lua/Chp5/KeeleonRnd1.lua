-- Starts at the magic frame at the beginning of the encounter
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 5
local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _turn()
    c.RandomFor(2)
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne()
    c.RandomFor(25)
    c.WaitFor(4)
    
    if not c.PushAWithCheck() then return false end
    c.RandomFor(8)
    c.WaitFor(6)
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to spell')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Unable to navigate to parry')
    end
    c.WaitFor(3)
    c.DelayUpToWithLAndR(c.maxDelay)
    if not c.PushAWithCheck() then return false end
    c.RandomFor(20)
    c.WaitFor(15)

    c.AddToRngCache()
    -------------------------------

    if c.ReadTurn() ~= 1 then
        return c.Bail('Taloon did not go first')
    end

    if c.ReadTurn() == 1 and c.Read(c.Addr.P2Action) ~= 62 then
        return c.Bail('Taloon did not build power')
    end
    -- if c.ReadTurn() ~= 0 then
    --     return c.Bail('Hero did not go first')
    -- end

    if c.Read(c.Addr.E1Action) ~= 67 then
        return c.Bail('Keeleon did not attack')
    end

    -- -- Looks like Keeleon will go twice if going last but not 2nd, weird
    -- local heroInitiative = c.ReadBattleOrder1()
    -- if heroInitiative ~= 3 then
    --     return c.Bail('Hero went too soon')
    -- end
    local bo1 = c.ReadBattleOrder1()
    local bo5 = c.ReadBattleOrder5()
    if bo5 < bo1 then
        return c.Bail('Hero did not go 2nd')
    end

    -- The higher bits seem to control if keeleon goes twice
    if c.Read(c.Addr.BattleOrder5) > 31 then
        return c.Bail('Keeleon did not do the correct thing')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.Log('Candidate found')
    c.Save(string.format('KeeleonRnd1Candidate-%s-Rng2-%s-Rng1-%s', emu.framecount(), c.ReadRng2(), c.ReadRng1()))
    return true
end

local function _keeleonMiss()
    c.RndAtLeastOne()
    c.WaitFor(8)
    local dmg = c.ReadDmg()
    c.Debug('dmg: ' .. dmg)
    if dmg > 0 then
        return c.Bail('Did not get a miss')
    end

    return true
end

local function _taloonBuildPower()
    c.DelayUpTo(5)
    c.RndAtLeastOne()
    c.RandomFor(20)
    c.WaitFor(10)
    c.AddToRngCache()
    if c.Read(c.Addr.P2Action) ~= 62 then
        return c.Bail('Did not build power')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)
    return true
end

c.Load(2)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)
    local result = c.Cap(_turn, 100)
    if c.Success(result) then
        c.Done()
    end

    c.Log('RNG: ' .. c.RngCacheLength())
end

c.Finish()

