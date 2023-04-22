-- Starts at the last lag frame upon entering the dark world shrine that contains 3 Anderougs
-- Manipulates getting into the boss encounter 
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _floor1()
    if not c.WalkUp(5) then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor2()
    local result

    if c.GenerateRndBool() then
        result = c.WalkMap({
            { ['Left'] = 1 },
            { ['Up'] = 7 },
            { ['Right'] = 1 },
        })
    else
        result = c.WalkMap({
            { ['Right'] = 1 },
            { ['Up'] = 7 },
            { ['Left'] = 1 },
        })
    end
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor3()
    local result = c.WalkMap({
        { ['Up'] = 2 },
        { ['Right'] = 2 },
        { ['Down'] = 2 },
        { ['Right'] = 1 },
    })
    if not result then return false end
    result = c.Best(c.WalkRightToCaveTransition, 3)
    if not c.Success(result) then return false end
    result = c.WalkMap({
        { ['Right'] = 1 },
        { ['Up'] = 3 },
        { ['Right'] = 4 },
        { ['Up'] = 4 },
        { ['Left'] = 5 },
        { ['Up'] = 1 },
    })
    if not result then return false end
    result = c.Best(c.WalkUpToCaveTransition, 3)
    if not c.Success(result) then return false end
    result = c.WalkMap({
        { ['Up'] = 1 },
        { ['Left'] = 4 },
        { ['Up'] = 4 },
    })
    if not result then return false end
    if not c.BringUpMenu() then return false end
    if not c.PushAWithCheck() then return false end
    c.RandomFor(10)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    return true
end

local function _do()
    local result = c.Best(_floor1, 9)
    if c.Success(result) then
        local result = c.Best(_floor2, 9)
        if c.Success(result) then
            local result = c.Best(_floor3, 9)
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
