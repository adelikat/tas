-- Starts at the last lag frame after exiting Hector's shrine
-- Manipulates entering Konenber
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 0

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _getCloseToTown()
    local result = c.WalkMap({
        { ['Down'] = 13 },
        { ['Right'] = 12 },
        { ['Down'] = 1 },
        { ['Right'] = 2 },
        { ['Down'] = 2 },
        { ['Left'] = 5 },
        { ['Down'] = 9 },
        { ['Left'] = 1 },
        { ['Down'] = 1 },
        { ['Left'] = 1 },
        { ['Down'] = 1 },
        { ['Left'] = 1 },
        { ['Down'] = 1 },
        { ['Left'] = 1 },
        { ['Down'] = 1 },
        { ['Left'] = 1 },
        { ['Down'] = 1 },
        { ['Left'] = 1 },
        { ['Down'] = 1 },
        { ['Left'] = 1 },
        { ['Down'] = 2 },
        { ['Left'] = 1 },
        { ['Down'] = 2 },
        { ['Left'] = 1 },
        { ['Down'] = 1 },
        { ['Left'] = 2 },
        { ['Down'] = 2 },
        { ['Left'] = 2 },
        { ['Down'] = 11 },
        { ['Left'] = 5 },
        { ['Down'] = 3 },
     })
    if not result then return false end
    

    _tempSave(4)
    return true
end

local function _enterKonenber()
    c.WalkDown(6)
    c.WaitFor(10)
    c.UntilNextInputFrame()
    _tempSave(5)
    return true
end

local function _leaveKonenber()
    c.PushRight()
    c.RandomFor(20)
    c.UntilNextInputFrame()
    _tempSave(6)
    return true
end

c.Load(3)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)
    local result = c.Best(_getCloseToTown, 2)
    if c.Success(result) then
        result = c.Best(_enterKonenber, 25)
        if c.Success(result) then
            result = c.Best(_leaveKonenber, 40)
            if c.Success(result) then
                c.Done()
            end
        end
    end
end

c.Finish()
