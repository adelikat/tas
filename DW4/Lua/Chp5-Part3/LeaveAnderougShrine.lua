-- Starts at the last lag frame after the map screen appears after the Anderoug fight
-- Manipulates leaving the shrine
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _floor1()
    c.RandomFor(2)
    c.WaitFor(20)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    if not c.ChargeUpWalking() then return false end
    local result = c.WalkMap({
        { ['Down'] = 3 },
        { ['Right'] = 4 },
        { ['Down'] = 2 },
    })
    if not result then return false end
    result = c.Best(c.WalkDownToCaveTransition, 5)
    if not c.Success(result) then return false end
    local result = c.WalkMap({
        { ['Down'] = 1 },
        { ['Right'] = 5 },
        { ['Down'] = 4 },
        { ['Left'] = 4 },
        { ['Down'] = 3 },
        { ['Left'] = 1 },
    })
    if not result then return false end
    result = c.Best(c.WalkLeftToCaveTransition, 5)
    if not c.Success(result) then return false end
    local result = c.WalkMap({
        { ['Left'] = 1 },
        { ['Up'] = 2 },
        { ['Left'] = 2 },
        { ['Down'] = 2 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor2()
    local result = c.WalkMap({
        { ['Left'] = 1 },
        { ['Down'] = 7 },
        { ['Right'] = 1 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()

    return true
end

local function _floor3()
    if not c.WalkDown(6) then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()

    return true
end

local function _do()
    local result = c.Best(_floor1, 10)
    if c.Success(result) then
        local result = c.Best(_floor2, 10)
        if c.Success(result) then
            local result = c.Best(_floor3, 10)
            if c.Success(result) then
                return true
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
    local result = c.Best(_do, 5)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()
