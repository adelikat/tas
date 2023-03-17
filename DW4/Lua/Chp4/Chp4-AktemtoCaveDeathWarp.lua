-- Starts at the magic frame of the encounter with a single enemy
-- in the cave of Aktemto
-- Maniuplates the death warp
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 5

local function _turn()
    c.RandomFor(1)
    c.WaitFor(8)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- x appears
    c.RandomFor(20)
    c.UntilNextInputFrame()
    c.RandomFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.UntilNextInputFrame()

    c.PushA() -- Mara Attack
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushA() -- Target enemy
    c.RandomFor(11)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.UntilNextInputFrame()

    c.PushA() -- Nara attack
    c.WaitFor(4)
    c.PushUp()
    if c.ReadMenuPosY() ~= 31 then
        c.Bail('Could not navigate to arrow')
    end
    c.PushA()
    c.WaitFor(3)
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Could not navigate to Nara')
    end

    c.PushA() -- Target enemy
    c.RandomFor(20)
    c.UntilNextInputFrame()
    if c.ReadTurn() ~= 4 then
        return c.Bail('Enemy did not go first')
    end

    if c.ReadBattle() ~= 76 then
        return c.Bail('Enemy did not attack')
    end

    if c.Read(0x7304) ~= 0 then
        return c.Bail('Enemy did not attack Mara')
    end

    c.WaitFor(2)

    c.Save('TempTurn')
    c.PushA()
    c.WaitFor(5)
    if c.ReadDmg() < 16 then
        return c.Bail('Enemy did not do enough damage')
    end

    c.Load('TempTurn')

    c.Log('Saving 4')
    c.Save(4)

    return true
end

local function _naraCritical()
    c.RndAtLeastOne()
    c.WaitFor(30)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.RandomFor(20)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    local delay = c.DelayUpTo(c.maxDelay)
    c.RndAtLeastOne()
    c.WaitFor(5)

    local dmg = c.ReadDmg()
    c.Debug(string.format('Dmg: %s Delay: %s', dmg, delay))

    if dmg > 10 then
        c.Log(string.format('Got Critical: %s Delay: %s', dmg, delay))
    end

    if dmg < 18 then
        return c.Bail('Did not do enough damage')
    end

    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)

    local result = c.Cap(_turn, 100)
    if result then
        result = c.Cap(_naraCritical, 250)
        if result then
            c.Done()
        else
            c.Log('Could not find max critical')
        end
        
    else
        c.Log('No best result')
    end
end

c.Finish()
