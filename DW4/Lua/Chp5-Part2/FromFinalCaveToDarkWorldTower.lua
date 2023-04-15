-- Starts at the last lag frame upon entering the final cave
-- Manipulates walking through all the floors, opening the dorr, and entering the tower in the dark world
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _stairs()
    c.PushUp()
    c.RandomFor(20)
    c.WaitFor(1)
    return not c.IsEncounter()
end

local function _stairsDown()
    c.PushDown()
    c.RandomFor(20)
    c.WaitFor(1)
    return not c.IsEncounter()
end

local function _floor1()
    local result = c.WalkMap({
        { ['Up'] = 3 },
        { ['Left'] = 7 },
    })
    if not result then return false end
    local result = c.Cap(c.WalkLeftToCaveTransition, 20)
    if not c.Success(result) then return false end
    local result = c.WalkMap({
        { ['Left'] = 2 },
        { ['Up'] = 21 },
        { ['Left'] = 3 },
    })
    if not result then return false end
    local result = c.Cap(c.WalkLeftToCaveTransition, 20)
    if not c.Success(result) then return false end
    local result = c.WalkMap({
        { ['Left'] = 30 },
        { ['Down'] = 12 }
    })
    if not result then return false end
    c.Cap(_stairsDown, 20)
    c.Cap(_stairsDown, 20)
    c.Cap(_stairsDown, 20)
    c.Cap(_stairsDown, 20)
    if not c.WalkDown(4) then return false end
    local result = c.Cap(c.WalkDownToCaveTransition, 20)
    if not c.Success(result) then return false end
    local result = c.WalkMap({
        { ['Down'] = 8 },
        { ['Right'] = 27 },
        { ['Up'] = 23 },
        { ['Left'] = 2 },
    })
    if not result then return false end
    local result = c.Cap(c.WalkLeftToCaveTransition, 20)
    if not c.Success(result) then return false end
    local result = c.WalkMap({
        { ['Left'] = 16 },
        { ['Down'] = 6 },
    })
    if not result then return false end
   
    c.Cap(_stairsDown, 20)
    c.Cap(_stairsDown, 20)
    c.Cap(_stairsDown, 20)
    c.Cap(_stairsDown, 20)
    local result = c.WalkMap({
        { ['Down'] = 1 },
        { ['Left'] = 3 },
    })
    if not result then return false end
    local result = c.Cap(c.WalkLeftToCaveTransition, 20)
    if not c.Success(result) then return false end

    return not c.IsEncounter()
end

local function _floor2()
    local result = c.WalkMap({
        { ['Left'] = 3 },
        { ['Up'] = 1 },
        { ['Left'] = 7 },
        { ['Down'] = 7 },
        { ['Right'] = 5 },
        { ['Down'] = 3 },
    })
    if not result then return false end
    local result = c.Cap(c.WalkDownToCaveTransition, 20)
    if not c.Success(result) then return false end
    local result = c.WalkMap({
        { ['Down'] = 6 },
        { ['Left'] = 6 },
        { ['Down'] = 2 },
        { ['Left'] = 2 },
        { ['Down'] = 2 },
        { ['Left'] = 2 },
    })
    if not result then return false end
    local result = c.Cap(c.WalkLeftToCaveTransition, 20)
    if not c.Success(result) then return false end
    local result = c.WalkMap({
        { ['Left'] = 12 },
        { ['Up'] = 10 },
        { ['Left'] = 2 },
        { ['Up'] = 2 },
    })
    if not result then return false end
    local result = c.Cap(c.WalkUpToCaveTransition, 20)
    if not c.Success(result) then return false end
    local result = c.WalkMap({
        { ['Up'] = 5 },
        { ['Right'] = 1 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor3()
    local result = c.WalkMap({
        { ['Left'] = 3 },
        { ['Up'] = 1 },
        { ['Left'] = 2 },
        { ['Down'] = 6 },
        { ['Right'] = 2 },
        { ['Down'] = 5 },
    })
    if not result then return false end
    c.RandomFor(160)
    local result = c.WalkMap({
        { ['Right'] = 1 },
        { ['Up'] = 1 },
    })
    if not result then return false end
    c.RandomFor(48)
    local result = c.WalkMap({
        { ['Right'] = 2 },
        { ['Up'] = 7 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor4()
    local result = c.WalkMap({
        { ['Left'] = 2 },
        { ['Down'] = 3 },
        { ['Left'] = 3 },
        { ['Down'] = 2 },
        { ['Left'] = 2 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor5()
    if not c.WalkUp(2) then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    if not c.WalkRight(17) then return false end
    c.PushRight()
    c.RandomFor(15)
    c.WaitFor(1)
    if not c.WalkRight(2) then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor6()
    local result = c.WalkMap({
        { ['Up'] = 10 },
        { ['Left'] = 18 },
        { ['Down'] = 8 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor7()
    if not c.WalkUp(7) then return false end
    if not c.BringUpMenu() then return false end
    if not c.Door() then return false end
    c.ChargeUpWalking()
    if not c.WalkUp() then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _do()
    local result = c.Best(_floor1, 10)
    if c.Success(result) then
        local result = c.Best(_floor2, 10)
        if c.Success(result) then
            local result = c.Best(_floor3, 10)
            if c.Success(result) then
                local result = c.Best(_floor4, 10)
                if c.Success(result) then
                    local result = c.Best(_floor5, 10)
                    if c.Success(result) then
                        local result = c.Best(_floor6, 10)
                        if c.Success(result) then
                            local result = c.Best(_floor7, 10)
                            if c.Success(result) then
                                return true
                            end
                        end
                    end
                end
            end
        end
    end

    return false
end

c.Load(3)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
	c.Load(100)
    local result = c.Best(_do, 2)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()
