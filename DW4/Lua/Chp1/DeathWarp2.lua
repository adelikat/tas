--Starts at the magic frame of the lethal gopher encounter after getting the flying shoes
--Manipulates Ragnar going first and getting a max-damage-self-cricial
dofile('../DW4Core.lua')
c.InitSession()
c.FastMode()
--c.BlackscreenMode()
c.Load(4)

local function _turn()
    c.RandomFor(1)
    c.UntilNextInputFrameThenOne()
    c.WaitFor(1)
    c.RandomAtLeastOne()
    c.RandomFor(21)
    c.WaitFor(4)
    if not c.PushAWithCheck() then return false end -- Attack
    c.RandomWithout(1, 'Up')
    c.WaitFor(3)
    if not c.PushUpWithCheck(31) then return false end

    if not c.PushAWithCheck() then return false end -- Pick Arrow
    c.RandomWithout(1, 'A')
    c.WaitFor(1)
    
    if not c.PushAWithCheck() then return false end -- Pick Ragnar
    c.RandomFor(23)
    if addr.Turn:Read() ~= 4 then
        return c.Bail('Lethal Gopher did not go first')
    end

    c.UntilNextInputFrameThenOne()
    c.WaitFor(1)

    c.RngCache:Add()
    c.RandomAtLeastOne()
    c.WaitFor(5)
    if addr.Dmg:Read() < 7 then
        return c.Bail('Lethal Gopher did not do enough damage')
    end

    c.UntilNextInputFrameThenOne()
    c.WaitFor(1)

    c.Log(string.format('RNG2: %s RNG1: %s', addr.Rng2:Read(), addr.Rng1:Read()))
    -- if addr.Rng2:Read() == 181 and addr.Rng1:Read() == 74 then
    --     c.Log('Success, but already found this one')
    --     return false
    -- end

    return true
end

local function _ragnarCrit()
    c.RandomAtLeastOne()
    c.RandomFor(10)
    c.UntilNextInputFrameThenOne()
    c.WaitFor(1)
    c.RngCache:Add()
    c.RandomAtLeastOne()
    c.WaitFor(5)

    if addr.Dmg:Read() < 20 then
        return c.Bail('Ragnar did not do enough damage')
    end

    c.UntilNextInputFrameThenOne()
    c.WaitFor(1)

    return true
end

local function _gopherFirst()
    local result = c.Cap(_turn, 100)
end

c.Save(100)
while not c.IsDone() do
    c.Load(100)
    local result = c.Cap(_turn, 100)
    if c.Success(result) then
        result = c.Cap(_ragnarCrit, 100)
        if c.Success(result) then
            c.Done()
        end
    end

    c.RngCache:Log()
end
