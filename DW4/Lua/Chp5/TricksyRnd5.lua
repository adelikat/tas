-- Starts at the first frame to dimiss the last action of round 3
-- Tricksy Urchin actions
-- 77 emit fireball
-- 62 building up power
--  attack

local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 0

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _turn()
    c.RndAtLeastOne()
    c.WaitFor(30)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- x damage points
    c.RandomFor(20)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.RandomFor(18)
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

    if c.ReadTurn() ~= 0 then
        return c.Bail('Hero did not go first')
    end

    c.WaitFor(2)

    return true
end

local function _critical()
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
    c.Save(string.format('TricksyRnd4-Crit-%s-Rng2-%s-Rng1-%s', emu.framecount(), c.ReadRng2(), c.ReadRng1()))

    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)
    local result = c.Cap(_turn, 100)
    if c.Success(result) then
        result = c.Cap(_critical, 10)
        if result then
            c.Done()
        else
            c.Log('Could not get critical')
        end
    else
        c.Log('Could not manip turn')
    end
end

c.Finish()
