-- Starts at the last lag frame after the last stat in crease from level 23
-- Manipulates leaving the Radimvice shrine and entering the Anderoug shrine
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 5000
c.maxDelay = 3
delay = 0

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _leave()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(2)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    local result = c.ChargeUpWalking()
    if not result then return false end

    if c.GenerateRndBool() then
        result = c.WalkMap({
            { ['Down'] = 2 },
            { ['Right'] = 3 },
            { ['Down'] = 1 },
        })
    else
        result = c.WalkMap({
            { ['Down'] = 2 },
            { ['Left'] = 3 },
            { ['Down'] = 1 },
        })
    end
    if not result then return false end

    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _enterShrine()
    c.RandomFor(5)
    c.WaitFor(1)
    local result = c.WalkMap({
        { ['Down'] = 3 },
        { ['Left'] = 2 },
        { ['Down'] = 1 },
        { ['Left'] = 1 },
        { ['Down'] = 1 },
        { ['Left'] = 3 },
        { ['Down'] = 4 },
        { ['Left'] = 1 },
        { ['Down'] = 1 },
        { ['Left'] = 1 },
        { ['Down'] = 2 },
        { ['Left'] = 1 },
        { ['Down'] = 6 },
        { ['Right'] = 3 },
        { ['Down'] = 5 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _do()
    local result = c.Best(_leave, 12)
    if c.Success(result) then
        local result = c.Best(_enterShrine, 12)
        if c.Success(result) then
            return true
        end
    end
    return false
end

c.Load(2)
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
