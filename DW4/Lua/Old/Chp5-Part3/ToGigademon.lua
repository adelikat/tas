-- Starts at the last lag frame after entering the Gigademon shrine
-- Manipulates encountering Gigademon
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _barrierLeft()
    c.PushLeft()
    c.RandomFor(14)
    c.WaitFor(5)
    return not c.IsEncounter()
end


local function _floor1()
    local result = c.WalkMap({
        { ['Left'] = 4 },
        { ['Down'] = 4 },
        { ['Right'] = 1 },
        { ['Down'] = 2 },
        { ['Right'] = 3 },
        { ['Down'] = 2 },
    })
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor2()
    if c.GenerateRndBool() then
        c.WalkRight()
        c.WalkLeft()
    else
        c.WalkUp()
        c.WalkDown()
    end    
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor3()
    local result = c.WalkMap({
        { ['Left'] = 2 },
        { ['Down'] = 5 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor4()
    local result = c.WalkMap({
        { ['Up'] = 4 },
        { ['Right'] = 4 },
        { ['Up'] = 5 },
        { ['Left'] = 4 },
        { ['Up'] = 1 },
    })
    if not result then return false end
    result = c.Best(c.WalkUpToCaveTransition, 2)
    if not c.Success(result) then return false end
    c.PushUp()
    c.RandomFor(14)
    c.WaitFor(5)
    if not c.Cap(_barrierLeft, 100) then return false end
    if not c.Cap(_barrierLeft, 100) then return false end
    if not c.Cap(_barrierLeft, 100) then return false end
    if not c.WalkLeft() then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor5()
    if not c.WalkUp(7) then return false end
    if not c.BringUpMenu() then return false end
    if not c.PushAWithCheck() then return false end
    c.RandomFor(5)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.WaitFor(2)
    c.DismissDialog()
    c.RandomFor(15)

    -- Given the dialog is to not turn your back, it's a tiny bit funny to not push down
    if c.GenerateRndBool() then
        c.PushLeft()
    else
        c.PushRight()
    end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.DismissDialog()
    return true
end

local function _do()
    local result = c.Best(_floor1, 12)
    if c.Success(result) then
        local result = c.Best(_floor2, 12)
        if c.Success(result) then
            local result = c.Best(_floor3, 12)
            if c.Success(result) then
                local result = c.Best(_floor4, 12)
                if c.Success(result) then
                    local result = c.Best(_floor5, 12)
                    if c.Success(result) then
                        return true
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
    local result = c.Best(_do, 100)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()
