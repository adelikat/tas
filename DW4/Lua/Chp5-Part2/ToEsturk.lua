-- Starts at the last lag frame after entering Esturk Castle
-- manipulates walking to the mini-boss in Esturk's chambers
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _floor1()
    local result = c.WalkMap({
        { ['Right'] = 1 },
        { ['Up'] = 10 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor2()
    local result = c.WalkMap({
        { ['Up'] = 1 },
        { ['Left'] = 13 },
        { ['Down'] = 10 },
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
        { ['Right'] = 18 },
        { ['Down'] = 9 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor4()
    local result = c.WalkMap({
        { ['Up'] = 1 },
        { ['Right'] = 4 },
        { ['Up'] = 9 },
        { ['Left'] = 10 },
        { ['Up'] = 8 },
        { ['Left'] = 2 },
    })
    if not result then return false end
    result = c.Best(c.WalkLeftToCaveTransition, 10)
    if not c.Success(result) then return false end
    local result = c.WalkMap({
        { ['Left'] = 9 },
        { ['Down'] = 1 },
    })
    if not result then return false end
    result = c.Best(c.WalkDownToCaveTransition, 10)
    if not c.Success(result) then return false end
    if not c.WalkDown(2) then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor5()
    local result = c.WalkMap({
        { ['Up'] = 2 },
        { ['Right'] = 2 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _chambers()
    if not c.WalkUp(3) then return false end
    if not c.BringUpMenu() then return false end
    if not c.PushAWithCheck() then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushB()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.DismissDialog()
    return true
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
                        local result = c.Best(_chambers, 10)
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
    local result = c.Best(_do, 4)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()
