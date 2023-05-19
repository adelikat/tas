-- Starts at the magic frame of an encounter with 1 Magemonja
-- Manipulates a death warp
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _turn()
    c.RandomFor(1)
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne() -- X appears
    c.RandomFor(24)    
    c.UntilNextInputFrame()
    c.WaitFor(2) -- Input frame
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Failed to navigate to spell')
    end
    c.PushA() -- Spell
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushA() -- Blaze
    c.WaitFor(2)
    c.UntilNextInputFrame()
   
    c.PushUp()
    if c.ReadMenuPosY() ~= 31 then
        return c.Bail('Unable to navigate to arrow')
    end

    c.PushA() -- Arrow
    c.WaitFor(3)
    --c.DelayUpToForLevels(1)
    c.PushA()
    c.RandomFor(23)
    c.UntilNextInputFrame()

    if c.ReadTurn() ~= 0 then
        return c.Bail('Mara did not go first')
    end
  
    c.WaitFor(2)

    c.Save('DeathWarpTemp')
    c.RndAtLeastOne()
    c.WaitFor(8)
    local dmg = c.ReadDmg()
    if dmg < 11 then
        c.Log('Not enough damage')
        return c.Bail('Blaze did not do enough damage')
    end

    c.Load('DeathWarpTemp')
     
    return true
end

local function _miss()
    c.RndAtLeastOne()
    c.WaitFor(30)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    local delay = c.DelayUpTo(5)
    c.RndAtLeastOne()
    c.WaitFor(20) 
    c.UntilNextInputFrame()
    c.WaitFor(2)

    -- if delay == 0 then
    --     c.WaitFor(1)
    -- end
    local delay = delay + c.DelayUpTo(5)

    c.RndAtLeastOne()
    c.WaitFor(12)

    if c.ReadE1Hp() == 0 and c.ReadDmg() < 14 then
        return c.Bail('Did not get a miss')
    end

    if c.ReadDmg() > 1 then
        return c.Bail('Got Orin Critical')
    end

    c.Log('Saving 5 Delay: ' .. delay)
    c.Save(5)
    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
    local result = c.Cap(_miss, 1000)
    if result then        
        c.Done()
    end
end

c.Finish()
