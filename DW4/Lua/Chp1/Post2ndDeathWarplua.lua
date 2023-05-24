--Starts during Lethal Gopher fight (2nd death warp) at the first frame to dimiss the "terrific blow" message from Ragnar's max damage critical, manipulates until Burland appears
-- Manipulates Burland appearing, using flying shoes, and walking down the first set of stairs
dofile('../DW4Core.lua')
c.InitSession()
c.FastMode()
c.BlackscreenMode()
c.Load(5)

local function _toTower()
    c.BattleAdvance()
    c.BattleAdvance()
    c.RandomAtLeastOne()
    c.RandomFor(40)
    c.UntilNextInputFrameThenOne()
    c.WaitFor(1)
    c.RandomAtLeastOne()
    c.RandomFor(30) -- Magic frame in here
    c.UntilNextInputFrame()
    c.AorBAdvance(3)
    return true
end

local function _shoes()
    c.RandomFor(2)
    c.UntilNextInputFrameThenOne()
    c.WaitFor(1)
    c.DismissDialog()
    if not c.BringUpMenu() then return false end
    if not c.Item() then return false end

    -- Pick flying shoes
    if not  c.PushAWithCheck() then return false end -- Item
    c.RandomWithoutA()
    c.UntilNextInputFrame()
    if not  c.PushAWithCheck() then return false end -- Ragn
    c.RandomWithoutA()
    c.UntilNextInputFrame()
    if not c.PushDownWithCheck(17) then return false end -- Leather Armor
    c.WaitFor(1)
    if not c.PushDownWithCheck(18) then return false end -- Flying Shoes
    if not  c.PushAWithCheck() then return false end
    c.RandomWithoutA()
    c.UntilNextInputFrame()
    if not  c.PushAWithCheck() then return false end
    c.RandomFor(1)
    c.UntilNextInputFrame()
    
    return true
end

local function _downstairs()
    if not c.ChargeUpWalking() then return false end
    if not c.WalkUp(3) then return false end
    c.RandomWithoutA(20)
    c.UntilNextInputFrameThenOne()
    c.DismissDialog()
    c.RandomWithoutA(49)
    if not c.ChargeUpWalking() then return false end
    if not c.WalkUp(6) then return false end
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _do()
    local result = c.Best(_toTower, 25)
    if c.Success(result) then
        result = c.Best(_shoes, 25)
        if c.Success(result) then
            local result = c.Best(_downstairs, 25)
            if c.Success(result) then
                return true
            end
        end
    end
    return false
end

while not c.IsDone() do
    local result = c.Best(_do, 5)
    if c.Success(result) then
        c.Done()
    end

    c.RngCache:Log()
end

