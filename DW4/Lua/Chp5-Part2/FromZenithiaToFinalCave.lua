-- Starts at the last lag frame upon entering Zenithia
-- Manipulates falling out of the clouds and entering the final cave
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _stairs()
    c.PushUp()
    c.RandomFor(20)
    c.WaitFor(1)
    return true
end

local function _floor1()
    if not _stairs() then return false end
    if not _stairs() then return false end
    if not _stairs() then return false end
    if not _stairs() then return false end
    local result = c.WalkMap({
        { ['Up'] = 3 },
        { ['Left'] = 3 },
        { ['Up'] = 5 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor2()
    local result = c.WalkMap({
        { ['Up'] = 4 },
        { ['Right'] = 24 },
        { ['Down'] = 1 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor3()
    local result = c.WalkMap({
        { ['Down'] = 5 },
        { ['Left'] = 2 },
        { ['Down'] = 2 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor3()
    local result = c.WalkMap({
        { ['Left'] = 2 },
        { ['Down'] = 7 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor4()
    local result = c.WalkMap({
        { ['Down'] = 1 },
        { ['Right'] = 4 },
        { ['Down'] = 4 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _enter()
    c.RandomFor(5)
    c.WaitFor(1)
    local result = c.WalkMap({
        { ['Up'] = 1 },
        { ['Left'] = 1 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _do()
    local result = c.Best(_floor1, 9)
    if c.Success(result) then
        local result = c.Best(_floor2, 9)
        if c.Success(result) then
            local result = c.Best(_floor3, 9)
            if c.Success(result) then
                local result = c.Best(_floor4, 9)
                if c.Success(result) then
                    local result = c.Best(_enter, 9)
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

    local result = c.Best(_do, 9)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()
