-- Starts at the first frame possible to dismiss the "Terrific blow" dialog
-- From the previous round
-- Turn order and 2 misses
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
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- x dmg points
    c.RandomFor(18)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.UntilNextInputFrame()

    c.PushA() -- Pick A
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushA() -- Pick Liclick-A
    c.RandomFor(22)
    c.UntilNextInputFrame()

    if c.ReadTurn() ~= 0 then
        if c.ReadTurn() < 4 then
            c.Log('Turn: '.. c.ReadTurn())
        end
        
        return c.Bail('Hero did not go first')
    end

    c.WaitFor(2)
    return true
end

local function _miss()    
    c.RndAtLeastOne() -- x damage, assume attack will be enough
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- x damage, assume attack will be enough
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() 
    c.RandomFor(18)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    
    c.RndAtLeastOne()
    c.WaitFor(5)
    if c.Read(c.Addr.HeroHP) < 25 then
        return c.Bail('Did not miss: ' .. c.ReadDmg())
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)
    return true
end

local function _miss2()
    delay = c.DelayUpTo(c.maxDelay)
    c.RndAtLeastOne()
    c.WaitFor(23)

    if c.ReadBattle() ~= 76 then
        return c.Bail('Liclick did not attack')
    end

    c.RndAtLeastOne()
    c.WaitFor(5)    
    if c.Read(c.Addr.HeroHP) < 25 then
        return c.Bail('Did not miss')
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
    
    local result = c.ProgressiveSearch(_miss, 100, 10)
    if c.Success(result) then
        c.Done()
        -- result = c.Cap(_miss, 5)
        -- if result then
        --     local rngCache = c.AddToRngCache()
        --     if rngCache then
        --         c.Save(string.format('aRnd2Miss1-%s-Rng2-%s-Rng1-%s', emu.framecount(), c.ReadRng2(), c.ReadRng1()))
        --         result = c.Cap(_miss2, (c.maxDelay * 150) + 1)
        --         if result then
        --             c.Done()
        --         else
        --             c.Log('Could not manip 2nd miss')
        --         end
                
        --     else
        --         c.Log('RNG already found')
        --     end
        -- end        
    else
        c.Log('Could not manip turn')
    end
end

c.Finish()
