-- Starts at the last lag frame after entering the royal crypt
-- Manipulates getting the staff of transform and casting outside
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 2

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _enterDoor()
    if not c.WalkUp(6) then return false end
    if not c.BringUpMenu() then return false end
    if not c.Door() then return false end
    c.ChargeUpWalking()
    if not c.WalkUp() then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
	return not c.IsEncounter()
end

local function _floor1()
    if not c.WalkUp(4) then return false end
    if not c.BringUpMenu() then return false end
    if not c.Door() then return false end
    c.ChargeUpWalking()
    local result = c.WalkMap({
        { ['Up'] = 10 },
        { ['Left'] = 2 },
        { ['Up'] = 1 },
    })
    if not result then return false end
    result = c.Best(c.WalkUpToCaveTransition, 5)
    if not c.Success(result) then return false end
    if not c.WalkUp(2) then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor2()
    if not c.WalkUp(5) then return false end
    c.PushUp()
    c.RandomFor(278)
    c.WaitFor(1)
    local result = c.WalkMap({
        { ['Up'] = 3 },
        { ['Right'] = 3 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor3()
    if not c.WalkUp(2) then return false end
    c.PushRight()
    c.RandomFor(118)
    c.WaitFor(1)
    if not c.WalkLeft() then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor4()
    c.PushLeft()
    c.RandomFor(254)
    c.WaitFor(1)
    local result = c.WalkMap({
        { ['Up'] = 2 },
        { ['Left'] = 4 },
        { ['Up'] = 2 },
        { ['Left'] = 5 },
        { ['Down'] = 3 },
        { ['Left'] = 4 },
        { ['Down'] = 15 },
        { ['Right'] = 5 },
        { ['Down'] = 10 },
        { ['Right'] = 2 },
        { ['Down'] = 6 },
        { ['Right'] = 17 },
        { ['Up'] = 7 },
        { ['Right'] = 4 },
        { ['Up'] = 2 },
    })
    if not result then return false end
    result = c.Best(c.WalkUpToCaveTransition, 10)
    if not c.Success(result) then return false end
    result = c.WalkMap({
        { ['Up'] = 2 },
        { ['Right'] = 2 },
        { ['Up'] = 2 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor5()
    result = c.WalkMap({
        { ['Left'] = 2 },
        { ['Down'] = 2 },
        { ['Left'] = 11 },
        { ['Down'] = 7 },
        { ['Right'] = 2 },
        { ['Down'] = 5 },
        { ['Left'] = 2 },
        { ['Down'] = 4 },
        { ['Right'] = 3 },
        { ['Down'] = 4 },
        { ['Left'] = 2 },
        { ['Down'] = 1 },
        { ['Left'] = 2 },
    })
    if not result then return false end
    result = c.Best(c.WalkLeftToCaveTransition, 10)
    if not c.Success(result) then return false end
    result = c.WalkMap({
        { ['Left'] = 2 },
        { ['Down'] = 5 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor6()
    result = c.WalkMap({
        { ['Left'] = 3 },
        { ['Up'] = 1 },
        { ['Left'] = 16 },
    })
    if not result then return false end
    result = c.Best(c.WalkLeftToCaveTransition, 10)
    if not c.Success(result) then return false end
    result = c.WalkMap({
        { ['Left'] = 2 },
        { ['Down'] = 11 },
        { ['Right'] = 2 }
    })
    if not result then return false end
    result = c.Best(c.WalkRightToCaveTransition, 10)
    if not c.Success(result) then return false end
    result = c.WalkMap({
        { ['Right'] = 2 },
        { ['Down'] = 10 },
        { ['Right'] = 4 },
        { ['Up'] = 2 },
        { ['Right'] = 9 },
    })
    if not c.BringUpMenu() then return false end
    if not c.Search() then return false end
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(2)
    c.DismissDialog()
    c.ChargeUpWalking()
    if not c.BringUpMenu() then return false end
    c.HeroCastOutside()
    return not c.IsEncounter()
end

local function _do()
    local result = c.Best(_enterDoor, 9)
    if c.Success(result) then
        result = c.Best(_floor1, 9)
        if c.Success(result) then
            result = c.Best(_floor2, 9)
            if c.Success(result) then
                result = c.Best(_floor3, 9)
                if c.Success(result) then
                    result = c.Best(_floor4, 9)
                    if c.Success(result) then
                        result = c.Best(_floor5, 9)
                        if c.Success(result) then
                            result = c.Best(_floor6, 9)
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
	local result = c.Best(_do, 4)
	if c.Success(result) then
		c.Done()
	end
end

c.Finish()



