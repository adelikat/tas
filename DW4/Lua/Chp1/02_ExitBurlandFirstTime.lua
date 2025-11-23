--Starts at the last lag frame after the King's chambers appears after starting the game
dofile('../DW4Core.lua')
c.InitSession()
c.FastMode()
c.BlackscreenMode()
c.Load(2)

local function _leaveChambers()
    c.RandomFor(220)
    c.UntilNextInputFrameThenOne()
    c.DismissDialog()
    c.RandomFor(150)
    c.UntilNextInputFrame()
    c.AorBAdvance(3)
    c.AorBAdvanceThenOne()
    c.DismissDialog()
    c.RandomFor(100)
    c.UntilNextInputFrame()
    c.AorBAdvanceThenOne()
    c.DismissDialog()

    c.RandomWithoutA(10)
    while addr.MoveTimer:Read() < 16 do
        c.PushDown()
    end
    c.RandomFor(15)
    c.WaitFor(1)
    if not c.WalkDown(13) then return false end
    c.PushDown()
    c.RandomWithoutA(20)
    c.UntilNextInputFrame()
    return true
end

local function _leaveBurland()
    local result = c.WalkMap({
        { ['Left'] = 1 },
        { ['Down'] = 19 },
        { ['Right'] = 1 },
        { ['Down'] = 4 },
    })
    if not result then return false end
    c.PushRight()
    if not c.BringUpMenu() then return false end
    if not c.PushAWithCheck() then return false end
    c.RandomFor(1)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.RandomFor(1)
    c.UntilNextInputFrameThenOne()
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end
    c.UntilNextInputFrameThenOne()
    c.DismissDialog()
    c.RandomFor(20) -- Some input frames during the inn stay
    c.UntilNextInputFrameThenOne()
    c.WaitFor(1)
    c.DismissDialog()
    if not c.ChargeUpWalking() then return false end
    result = c.WalkMap({
        { ['Left'] = 3 },
        { ['Down'] = 8 },
    })
    if not result then return false end
    c.UntilNextInputFrame()
    return true
end

local function _do()
    local result = c.Best(_leaveChambers, 10)
    if c.Success(result) then
        result = c.Best(_leaveBurland, 10)
        if c.Success(result) then
            return true
        end
    end

    return false
end

while not c.IsDone() do
    c.NoEncountersPossible = true
    local result = c.Best(_do, 5)
    if c.Success(result) then
        c.Done()
    end
    c.NoEncountersPossible = false
end
