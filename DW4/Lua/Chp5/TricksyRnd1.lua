-- Starts at the 'magic frame' at the beginning of the Tricksy Urchin fight
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 6
local delay = 0

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _turn()
    c.RandomFor(1)
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- Vampire Bat appears
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne()
    c.RandomFor(23)
    c.UntilNextInputFrame()
    c.WaitFor(2) -- Input frame
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to spell')
    end
    c.PushA() -- Pick Spell

    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushA() -- Pick Expel
    c.WaitFor(2)
    c.UntilNextInputFrame()
    delay = c.DelayUpToWithLAndR(2)
    c.PushA() -- Pick Vampire Bats
    c.RandomFor(40)
    c.UntilNextInputFrame()

    c.AddToRngCache()
    c.Debug('RNG: ' .. c.RngCacheLength())

    if c.ReadTurn() ~= 0 then
        return c.Bail('Hero did not go first')
    end

    c.WaitFor(2)

    _tempSave(4)
    return true
end

local function _expel()
    c.RndAtLeastOne()
    c.WaitFor(10)
    if c.ReadE1Hp() > 0 then
        return c.Bail('Vampire-A did not disappear')
    end
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne()
    c.WaitFor(10)
    if c.ReadE2Hp() > 0 then
        return c.Bail('Vampire-B did not disappear')
    end

    _tempSave(5)
    return true
end

c.Load(3)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)
    
    local result = c.Cap(_expel, 100)
    if c.Success(result) then       
        c.Log('Delay: ' .. delay) 
        c.Done()
    else
        c.Log('Could not manip turn')
    end
end

c.Finish()
