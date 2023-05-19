-- Starts at the last lag frame after the hero and village appear 
-- at the beginning of Chapter 5
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _downStairs()
    c.RandomFor(70)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.RandomFor(90)
    c.UntilNextInputFrame()

    c.AorBAdvance()
    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.RandomFor(15)
    c.WaitFor(1)

    local result = c.WalkMap({
        { ['Down'] = 1 },
        { ['Right'] = 7 },
        { ['Up'] = 7 },
        { ['Right'] = 3 },
        { ['Up'] = 7 },
    })
    if not result then return false end

    local result = c.BringUpMenu()
    if not result then return false end

    c.PushA()
    c.RandomFor(5)
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(2)
    c.RndAtLeastOne()
    c.WaitFor(2)
    c.UntilNextInputFrame()

    c.RandomFor(14)
    c.WaitFor(1)

    local result = c.WalkMap({
        { ['Down'] = 10 },
        { ['Left'] = 7 },
        { ['Down'] = 4 },
        { ['Left'] = 4 },
    })

    c.PushUp()
    c.BringUpMenu()
    c.PushA()
    c.RandomFor(5)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushA() -- Yes to lunch
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.WaitFor(2)
    c.DismissDialog()
    c.RandomFor(135)
    c.UntilNextInputFrame()

    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(20)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(60)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(120)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(110)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(110)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(110)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(135)
    c.UntilNextInputFrame()

    return true
end

local function _upStairs()
    c.RandomFor(120)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(220)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(700)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(590)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(15)
    c.WaitFor(1)
    c.WalkRight()
    c.WalkUp(3)
    local result = c.Best(c.WalkUpToCaveTransition, 4)
    if not result then return false end

    result = c.WalkMap({
        { ['Up'] = 5 },
        { ['Left'] = 1 },
        { ['Up'] = 6 }
    })

    c.WaitFor(10)
    c.UntilNextInputFrame()

    return true
end

local function _leaveVillage()
    c.WalkLeft()
    c.WalkUp(2)
    local direction = 'Left'
    if c.GenerateRndBool() then
        direction = 'Right'
    end
    c.Walk(direction, 1)
    c.WalkUp()
    c.WaitFor(10)
    c.UntilNextInputFrame()

    return true
end

local function _do()
    local result = c.Best(_downStairs, 10)
    if result then
        result = c.Best(_upStairs, 10)
        if result > 0 then
            result = c.Best(_leaveVillage, 30)
            if result > 0 then
                c.Done()
            end
        end
    end
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
while not c.done do
    c.Load(100)
    local result = c.Best(_do, 2)
    if result > 0 then
        c.Done()
    end
end

c.Finish()
