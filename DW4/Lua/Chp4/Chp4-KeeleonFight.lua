-- Starts at the first frame to press A or B to get MP from the last level up
-- Manipulates the Keeleon fight and leaving the castle
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _startFight()
    c.RndAorB()
    c.WaitFor(30)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.RandomFor(110)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.RndAtLeastOne()
    c.RandomFor(10)
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()

    return true
end

local function _keeleonFight()
    c.RandomFor(1)
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.RandomFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(2) -- Last input frame
    c.UntilNextInputFrame()

    c.PushA() -- Mara Attack
    c.WaitFor(2)
    c.UntilNextInputFrame()

    c.PushA()
    c.RandomFor(22)
    c.UntilNextInputFrame()

    if c.ReadTurn() ~= 4 then
        return c.Bail('Keeleon did not go first')
    end

    if c.ReadBattle() ~= 76 then
        return c.Bail('Keeleon did not attack')
    end

    c.WaitFor(2)
    c.RndAtLeastOne()
    c.WaitFor(10)
    if c.Read(c.Addr.MaraHp) > 0 then
        return c.Bail('Keeleon missed')
    end
    c.WaitFor(20)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- x damage points
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne()
    c.RandomFor(30)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()

    return true
end

local function _leaveCastle()
    c.RandomFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne()
    c.WaitFor(5)
    c.UntilNextInputFrame()
    
    -- Walk methods do not work because E1 Group type is not FF!
    c.PushDown()
    c.RandomFor(14)
    c.WaitFor(1)

    c.PushRight()
    c.RandomFor(14)
    c.WaitFor(1)
    c.PushRight()
    c.RandomFor(14)
    c.WaitFor(1)

    c.PushDown()
    c.RandomFor(14)
    c.WaitFor(1)
    c.PushDown()
    c.RandomFor(14)
    c.WaitFor(1)

    c.PushLeft()
    c.RandomFor(14)
    c.WaitFor(1)

    c.PushDown()
    c.RandomFor(14)
    c.WaitFor(1)
    c.PushDown()
    c.RandomFor(14)
    c.WaitFor(1)

    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.PushDown()
    c.RandomFor(14)
    c.WaitFor(1)
    c.PushLeft()
    c.RandomFor(14)
    c.WaitFor(1)
    c.PushA()
    c.UntilNextMenuY()
    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.Search()

    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne()
    c.WaitFor(5)
    c.UntilNextInputFrame()

    c.RandomFor(14)
    c.WaitFor(1)

    c.PushRight()
    c.RandomFor(14)
    c.WaitFor(1)
    c.PushRight()
    c.RandomFor(14)
    c.WaitFor(1)
    c.PushRight()
    c.RandomFor(14)
    c.WaitFor(1)
    c.PushRight()
    c.RandomFor(14)
    c.WaitFor(1)
    c.PushRight()
    c.RandomFor(14)
    c.WaitFor(1)

    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.PushRight()
    c.RandomFor(14)
    c.WaitFor(1)
    c.PushRight()
    c.RandomFor(14)
    c.WaitFor(1)
    c.PushRight()
    c.RandomFor(14)
    c.WaitFor(1)
    c.PushRight()
    c.RandomFor(14)
    c.WaitFor(1)
    c.PushRight()
    c.RandomFor(14)
    c.WaitFor(1)
    c.PushRight()
    c.RandomFor(14)
    c.WaitFor(1)
    c.PushRight()
    c.RandomFor(14)
    c.WaitFor(1)
    c.PushRight()
    c.RandomFor(14)
    c.WaitFor(1)
    c.PushRight()
    c.RandomFor(14)
    c.WaitFor(1)

    c.PushUp()
    c.RandomFor(14)
    c.WaitFor(1)
    c.PushUp()
    c.RandomFor(14)
    c.WaitFor(1)
    c.PushUp()
    c.RandomFor(14)
    c.WaitFor(1)
    c.PushUp()
    c.RandomFor(14)
    c.WaitFor(1)
    c.PushUp()
    c.RandomFor(14)
    c.WaitFor(1)
    c.PushUp()
    c.RandomFor(14)
    c.WaitFor(1)
    c.PushUp()
    c.RandomFor(14)
    c.WaitFor(1)
    c.PushUp()
    c.RandomFor(14)
    c.WaitFor(20)
    c.UntilNextInputFrame(0)

    return true
end

local function _leaveKeelon()
    c.RndAtLeastOne()
    c.RandomFor(20)
    c.UntilNextInputFrame()
    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.RndAtLeastOne()
    c.RandomFor(10)
    c.UntilNextInputFrame()
    c.RandomFor(150)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(5)
    c.PushFor('Down', 49)
    c.WaitFor(1)

    c.PushDown()
    c.RandomFor(14)
    c.WaitFor(1)
    c.PushDown()
    c.RandomFor(14)
    c.WaitFor(1)
    c.PushDown()
    c.RandomFor(14)
    c.WaitFor(1)
    c.PushDown()
    c.RandomFor(14)
    c.WaitFor(30)
    c.UntilNextInputFrame()
   
    return true
end

local function _do()
    local result = c.Best(_startFight, 12)    
    if result > 0 then
        local rngResult = c.AddToRngCache()
        if rngResult then
            result = c.Best(_keeleonFight, 12)
            if result > 0 then
                result = c.Best(_leaveCastle, 5)
                if result > 0 then
                    result = c.Best(_leaveKeelon, 10)
                    if result > 0 then
                        c.Done()
                    end
                end
            end
        else
            c.Log('RNG already found')
        end        
    end
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
    local result = c.Best(_do, 10)
    if result > 0 then
        c.Done()
    end    
end

c.Finish()
