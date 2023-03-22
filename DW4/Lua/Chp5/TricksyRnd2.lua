-- Starts at the first frame to dimiss the last action of round 1
-- Tricksy Urchin actions
-- 77 emit fireball
-- 62 building up power
--  attack

local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 5
local delay = 0


local function _tempSave(slot)
    --c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _turn()
    c.RndAtLeastOne()
    c.RandomFor(16)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.UntilNextInputFrame()

    c.PushA() -- Attack
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.DelayUpTo(1)
    c.PushA() -- Pick Tricksy Urchin
    c.RandomFor(25)
    c.UntilNextInputFrame()

    c.AddToRngCache()

    if c.ReadTurn() ~= 0 then
        return c.Bail('Hero did not go first')
    end

    if c.Read(0x732A) ~= 67 then
        return c.Bail('Tricksy Urchin-A did not attack')
    end

    -- if c.Read(0x732B) == 77 then
    --     return c.Bail('Tricksy Urchin-B emitted a fireball')
    -- end

    if c.Read(0x732B) ~= 62 then
        return c.Bail('Tricksy Urchin-B did not build power')
    end
    
    c.WaitFor(2)

    return true
end

local function _critical()
    delay = c.DelayUpTo(c.maxDelay)
    c.RndAtLeastOne()
    c.WaitFor(5)
    local dmg = c.ReadDmg()
    c.Debug('Dmg: ' .. dmg)
    if dmg < 10 then
        return c.Bail('Did not get critical')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.Log('-----------')
    c.Log('Got critical!!')
    c.Save(string.format('TricksyRnd2-Crit-%s-Rng2-%s-Rng1-%s', emu.framecount(), c.ReadRng2(), c.ReadRng1()))

    -- TODO: this is a 50/50 problem, need to check which TRicksy Urchin the Hero hit, and it must be the one that built up power

    return false
end

local function _miss()
    local origHp = c.Read(c.Addr.HeroHP)
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.RandomFor(20)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.RandomFor(20)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.WaitFor(7)
    local currHp = c.Read(c.Addr.HeroHP)
    local dmg = origHp - currHp
    c.Debug('Dmg: ' .. dmg)

    if dmg > 0 then
        return c.Bail('Did not get miss')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)

    _tempSave(5)
    return true
end


c.Load(0)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)

    local result = c.Cap(_miss, 100)
    if result then
        c.Done()
    end
    
    -- local result = c.Cap(_turn, 100)
    -- if c.Success(result) then 
    --     result = c.Cap(_critical, (delay * delay * 50) + 10)
    --     if result then
    --         c.Log('Delay: ' .. delay)
    --         c.Done()
    --     else
    --         c.Log('Could not get critical')
    --     end
    -- else
    --     c.Log('Could not manip turn RNG: ' .. c.RngCacheLength())
    -- end
end

c.Finish()
