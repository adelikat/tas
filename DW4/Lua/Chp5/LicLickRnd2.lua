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

    if c.ReadTurn() == 0 then
        return c.Bail('Hero went first')
    end

    if c.ReadBattle() ~= 76 then
        return c.Bail('Liclick did not attack')
    end

    c.WaitFor(2)
    return true
end

local function _miss()    
    c.RndAtLeastOne()
    c.WaitFor(5)
    if c.Read(c.Addr.HeroHP) < 25 then
        return c.Bail('Did not miss')
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

c.Load(3)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)
    
    local result = c.Cap(_turn, 100)
    if c.Success(result) then
        result = c.Cap(_miss, 5)
        if result then
            local rngCache = c.AddToRngCache()
            if rngCache then
                c.Save(string.format('aRnd2Miss1-%s-Rng2-%s-Rng1-%s', emu.framecount(), c.ReadRng2(), c.ReadRng1()))
                result = c.Cap(_miss2, (c.maxDelay * 150) + 1)
                if result then
                    c.Done()
                else
                    c.Log('Could not manip 2nd miss')
                end
                
            else
                c.Log('RNG already found')
            end
            
        --else
           -- c.Log('Could not manip miss')
        end        
    else
        c.Log('Could not manip turn')
    end
end

c.Finish()
