-- Starts at the last lag frame upon entering Stancia with Panon
-- Manipulates getting the Zenithian Helm and casting return to Konenber
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _enterCastle()
    if not c.WalkUp(2) then return false end
    if not c.BringUpMenu() then return false end
    if not c.PushAWithCheck() then return false end
    c.RandomFor(5)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomForNoA(14)
    c.WaitFor(1)
    if not c.WalkUp(7) then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.WalkMap({
        { ['Right'] = 1 },
        { ['Up'] = 11 },
    })
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor1()
    if not c.WalkUp(6) then return false end
    local result = c.Best(c.WalkUpToCaveTransition, 5)
    if not c.Success(result) then
        return c.Bail('Could not do transition')
    end
    if not c.WalkUp(10) then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor2()
    if not c.WalkUp(2) then return false end
    c.PushUp()
    c.RandomForNoA(15)
    c.WaitFor(1)
    if not c.WalkUp(5) then return false end
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

local function _kingAndLeave()
    local result = c.WalkMap({
        { ['Up'] = 10 },
        { ['Right'] = 1 },
        { ['Up'] = 1 },
        { ['Right'] = 11 },
        { ['Up'] = 1 },
        { ['Down'] = 1 },
        { ['Left'] = 2 },
        { ['Right'] = 1 },
        { ['Left'] = 1 },
        { ['Right'] = 1 },
        { ['Left'] = 1 },
        { ['Right'] = 1 },
        { ['Left'] = 1 },
        { ['Right'] = 1 },
        -- { ['Left'] = 1 },
        -- { ['Right'] = 1 },
        { ['Left'] = 11 },
    })
    if not result then return false end
    if not c.BringUpMenu() then return false end
    if not c.Item() then return false end
    if not c.PushAWithCheck() then return false end
    c.WaitFor(5)
    c.UntilNextInputFrame()
    if not c.PushDownWithCheck(17) then return false end
    c.WaitFor(5)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end
    c.WaitFor(5)
    c.UntilNextInputFrame()
    if not c.PushDownWithCheck(17) then return false end
    c.WaitFor(1)
    if not c.PushDownWithCheck(18) then return false end
    c.WaitFor(1)
    if not c.PushDownWithCheck(19) then return false end
    if not c.PushAWithCheck() then return false end
    c.WaitFor(3)
    c.UntilNextInputFrame()
    if not c.PushDownWithCheck(17) then return false end
    c.WaitFor(1)
    if not c.PushDownWithCheck(18) then return false end
    if not c.PushAWithCheck() then return false end
    c.RandomFor(5)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.DismissDialog()
    c.ChargeUpWalking()
    if not c.WalkDown() then return false end
    if not c.WalkUp(2) then return false end
    
    if not c.BringUpMenu() then return false end
    if not c.PushAWithCheck() then return false end
    c.RandomFor(5)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(2)
    c.DismissDialog()
    c.RandomFor(14)
    c.WaitFor(1)
    if not c.BringUpMenu() then return false end
    c.PushRight()
    if c.ReadMenuPosY() ~= 32 then return false end
    if not c.PushAWithCheck() then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    if not c.PushDownWithCheck(17) then return false end
    c.WaitFor(5)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end
    c.WaitFor(5)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end
    c.WaitFor(5)
    c.UntilNextInputFrame()
    if not c.PushDownWithCheck(17) then return false end
    c.WaitFor(1)
    if not c.PushDownWithCheck(18) then return false end
    if not c.PushAWithCheck() then return false end
    c.RandomFor(10)
    c.UntilNextInputFrame()

    return true
end

local function _do()
    local result = c.Best(_enterCastle, 10)
    if c.Success(result) then
        local result = c.Best(_floor1, 10)
        if c.Success(result) then
            local result = c.Best(_floor2, 10)
            if c.Success(result) then
                local result = c.Best(_floor3, 10)
                if c.Success(result) then
                    local result = c.Best(_kingAndLeave, 10)
                    if c.Success(result) then
                        return true
                    end
                end
            end
        end
    end
    return false
end

c.Load(4)
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

