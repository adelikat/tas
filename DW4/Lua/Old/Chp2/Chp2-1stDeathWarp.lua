-- Starts at the magic frame before the encounter
local c = require("DW4-ManipCore")

c.InitSession()
c.reportFrequency = 5000
c.maxDelay = 5

local function _deathWarp()
    c.RandomFor(1)
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- Ozwarg appears
    c.RandomFor(24)
    c.UntilNextInputFrame()
    c.WaitFor(2)  -- Last input frame before APRI, need it for early press
    c.UntilNextInputFrame()

    c.PushA() -- Attack
    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.PushA() -- Ozwarg
    c.RandomFor(33)

    if c.ReadTurn() ~= 5 then
        return c.Bail('Ozwarg did not go first')
    end

    c.WaitFor(15)

    if c.ReadBattle() ~= 94 then
        return c.Bail('Ozwarg did not cast spell')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)    

    c.RndAtLeastOne()
    c.WaitFor(4)

    if c.ReadDmg() < 16 then
        c.Log('did not do enough damage, saving')
        c.Save(5)
        return c.Bail('Did not do enough damage with icebolt')
    end

    return true
end

c.Load(0)
c.Save(100)
while not c.done do
	c.Load(100)
	local result = c.Cap(_deathWarp, 1000)
    if result then
        c.Done()
    else
        c.Log('Unable to manip death warp')        
    end
    
	c.Increment()
end

c.Finish()

