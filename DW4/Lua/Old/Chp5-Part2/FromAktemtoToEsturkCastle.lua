-- Starts at the last lag frame after entering Aktemto
-- Manipulates walking into the cave and into Esturk's castle
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _enterCave()
    local result = c.WalkMap({
        { ['Up'] = 7 },
        { ['Left'] = 3 },
        { ['Up'] = 7 },
    })
    if not result then return false end
    if not c.BringUpMenu() then return false end
    if not c.Door() then return false end
    c.ChargeUpWalking()
    if not c.WalkUp(6) then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end
 
local function _floor1()
    local result = c.WalkMap({
        { ['Up'] = 2 },
        { ['Right'] = 2 },
        { ['Up'] = 6 },
        { ['Right'] = 3 },
        { ['Up'] = 12 },
        { ['Right'] = 3 },
        { ['Up'] = 6 },
        { ['Right'] = 7 },
        { ['Up'] = 2 },
        { ['Right'] = 3 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor2()
    local result = c.WalkMap({
        { ['Up'] = 11 },
        { ['Right'] = 1 },
        { ['Up'] = 11 },
        { ['Right'] = 2 },
        { ['Up'] = 3 },
        { ['Right'] = 5 },
    })
    if not result then return false end
    result = c.Best(c.WalkRightToCaveTransition, 10)
    if not c.Success(result) then return false end
    local result = c.WalkMap({
        { ['Up'] = 1 },
        { ['Right'] = 3 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()

    return not c.IsEncounter()
end

local function _floor3()
    local result = c.WalkMap({
        { ['Up'] = 9 },
        { ['Left'] = 7 },
        { ['Up'] = 12 },
        { ['Right'] = 3 },
    })
    if not result then return false end
    result = c.Best(c.WalkRightToCaveTransition, 10)
    if not c.Success(result) then return false end
    local result = c.WalkMap({
        { ['Up'] = 1 },
        { ['Right'] = 4 },
        { ['Up'] = 9 },
        { ['Right'] = 3 },
    })
    if not result then return false end
    result = c.Best(c.WalkRightToCaveTransition, 10)
    if not c.Success(result) then return false end
    local result = c.WalkMap({
        { ['Up'] = 1 },
        { ['Right'] = 5 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()

    return not c.IsEncounter()
end

local function _floor4()
    local result = c.WalkMap({
        { ['Up'] = 2 },
        { ['Right'] = 3 },
        { ['Up'] = 4 },
    })
    if not result then return false end
    result = c.Best(c.WalkUpToCaveTransition, 10)
    if not c.Success(result) then return false end
    local result = c.WalkMap({
        { ['Up'] = 4 },
        { ['Left'] = 1 },
        { ['Up'] = 12 },
        { ['Right'] = 3 },
        { ['Up'] = 8 },
        { ['Right'] = 2 },
        { ['Up'] = 5 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor5()
    local result = c.WalkMap({
        { ['Up'] = 3 },
        { ['Right'] = 9 },
        { ['Down'] = 3 },
        { ['Right'] = 1 },
        { ['Down'] = 1 },
        { ['Right'] = 17 },
        { ['Up'] = 2 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _do()
    local result = c.Best(_enterCave, 10)
    if c.Success(result) then
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
                            return true
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



