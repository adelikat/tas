-- Starts at the last lag frame after the screen appears after Taloon gets level 24
-- Manipulates leaving the Infernus Shadow shrine and entering the Gigademon shrine
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _floor1()
    c.RandomFor(2)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    if not c.ChargeUpWalking() then return false end
    if not c.WalkDown(10) then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor2()
    local result = c.WalkMap({
        { ['Down'] = 1 },
        { ['Right'] = 1 },
        { ['Down'] = 5 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _toShrine()
    local result = c.WalkMap({
        { ['Down'] = 4 },
        { ['Right'] = 2 },
        { ['Down'] = 1 },
        { ['Right'] = 4 },
        { ['Down'] = 5 },
        { ['Right'] = 1 },
        { ['Down'] = 1 },
        { ['Right'] = 1 },
        { ['Down'] = 2 },
        { ['Right'] = 1 },
        { ['Down'] = 6 },
        { ['Left'] = 3 },
        { ['Down'] = 5 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end


local function _do()
    local result = c.Best(_floor1, 9)
    if c.Success(result) then
        local result = c.Best(_floor2, 9)
        if c.Success(result) then
            local result = c.Best(_toShrine, 9)
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
