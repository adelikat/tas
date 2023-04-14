-- Starts at the last lag frame upon entering Stancia
-- Manipulates talking to someone that will trigger the ability to pick up Panon, and then casting return to Soretta
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
    local result = c.WalkMap({
        { ['Down'] = 5 },
        { ['Right'] = 1 },
        { ['Down'] = 2 },
        { ['Right'] = 5 },
    }) 
    if not result then return false end
    if not c.BringUpMenu() then return false end
    if not c.PushAWithCheck() then return false end
    c.RandomFor(5)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.WaitFor(2)
    c.DismissDialog()
    if not c.BringUpMenu() then return false end
    if not c.HeroCastReturn() then return false end
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then return false end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then return false end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then return false end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 20 then return false end
    if not c.PushAWithCheck() then return false end
    c.RandomFor(5)
    c.UntilNextInputFrame()
    return true
end

local function _do()
    local result = c.Best(_enterCastle, 9)
    if c.Success(result) then
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

    local result = c.Best(_do, 9)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()
