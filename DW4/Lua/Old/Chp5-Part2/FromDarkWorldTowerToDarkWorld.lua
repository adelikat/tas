-- Starts at the last lag frame upon opening the doors from the final cave into the tower in the dark world
-- Manipulates exiting the tower
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _floor1()
    local result = c.WalkMap({
        { ['Up'] = 6 },
        { ['Right'] = 9 },
        { ['Up'] = 9 },
    })
    if not c.Success(result) then return true end
    result = c.Cap(c.WalkUpToCaveTransition, 20)
    if not c.Success(result) then return false end
    if not c.WalkUp(15) then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor2()
    c.RandomFor(6)
    c.PushDown()
    c.RandomFor(20)
    c.UntilNextInputFrame()
    return true
end

local function _floor3()
    c.RandomFor(6)
    local result = c.WalkMap({
        { ['Up'] = 3 },
        { ['Right'] = 1 }
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor4()
    if not c.WalkDown(8) then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor5()
    if not c.WalkDown(10) then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
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

