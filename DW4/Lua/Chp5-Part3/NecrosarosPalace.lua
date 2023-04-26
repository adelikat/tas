-- Starts at the last lag frame after entering the Gigademon shrine
-- Manipulates encountering Gigademon
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function __barrierRight()
    c.PushRight()
    c.RandomFor(14)
    c.WaitFor(5)
    return not c.IsEncounter()
end

local function _floor1()
    if not c.WalkUp(9) then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end


local function __clayFightAvoiding()
    local result = c.WalkMap({
        { ['Up'] = 5 },
        { ['Right'] = 3 },
    })
    if not result then return false end
    if not c.Cap(__barrierRight, 20) then return false end
    if not c.Cap(__barrierRight, 20) then return false end
    local result = c.WalkMap({
        { ['Right'] = 1 },
        { ['Up'] = 8 },
        { ['Right'] = 1 },
    })
    if not result then return false end
    return not c.IsEncounter()
end
local function _floor2()
    local result = c.Cap(__clayFightAvoiding, 100)
    if not result then return false end
    local result = c.Best(c.WalkRightToCaveTransition, 12)
    if not c.Success(result) then return false end
    result = c.WalkMap({
        { ['Right'] = 4 },
        { ['Down'] = 16 },
        { ['Left'] = 2 },
        { ['Down'] = 5 },
        { ['Left'] = 4 },
        { ['Up'] = 4 },
        { ['Right'] = 1 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor3()
    local result = c.WalkMap({
        { ['Left'] = 1 },
        { ['Down'] = 4 },
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
        { ['Up'] = 3 },
        { ['Right'] = 2 },
        { ['Up'] = 3 },
        { ['Right'] = 2 },
        { ['Up'] = 3 },
        { ['Right'] = 1 },
        { ['Up'] = 1 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor5()
    local result = c.WalkMap({
        { ['Up'] = 2 },
        { ['Left'] = 24 },
        { ['Down'] = 5 },
        { ['Right'] = 7 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor6()
    if not c.WalkDown(10) then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor7()
    local result = c.WalkMap({
        { ['Down'] = 1 },
        { ['Left'] = 8 },
        { ['Up'] = 1 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor8()
    local result = c.WalkMap({
        { ['Up'] = 3 },
        { ['Right'] = 2 },
    })
    if not result then return false end
    c.WaitFor(50)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor9()
    local result = c.WalkMap({
        { ['Left'] = 2 },
        { ['Down'] = 4 },
        { ['Right'] = 5 },
        { ['Up'] = 4 },
        { ['Right'] = 8 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor10()
    local result = c.WalkMap({
        { ['Right'] = 3 },
        { ['Up'] = 8 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor11()
    local result = c.WalkMap({
        { ['Down'] = 6 },
        { ['Right'] = 4 },
        { ['Up'] = 4 },
        { ['Right'] = 2 },
    })
    if not result then return false end
    c.WaitFor(50)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor12()
    local result = c.WalkMap({
        { ['Left'] = 2 },
        { ['Down'] = 4 },
        { ['Left'] = 4 },
        { ['Up'] = 6 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor13()
    local result = c.WalkMap({
        { ['Down'] = 6 },
        { ['Right'] = 4 },
        { ['Up'] = 8 },
        { ['Right'] = 3 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor14()
    if not c.WalkUp(2) then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor15()
    local result = c.WalkMap({
        { ['Up'] = 4 },
        { ['Left'] = 4 },
    })
    if not result then return false end
    result = c.Best(c.WalkLeftToCaveTransition, 12)
    if not c.Success(result) then return false end
    local result = c.WalkMap({
        { ['Left'] = 2 },
        { ['Down'] = 5 },
        { ['Left'] = 8 },
        { ['Down'] = 2 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor16()
    local result = c.WalkMap({
        { ['Down'] = 1 },
        { ['Left'] = 5 },
        { ['Up'] = 3 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
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
                        local result = c.Best(_floor6, 12)
                        if c.Success(result) then
                            local result = c.Best(_floor7, 12)
                            if c.Success(result) then        
                                local result = c.Best(_floor8, 12)
                                if c.Success(result) then
                                    local result = c.Best(_floor9, 12)
                                    if c.Success(result) then
                                        local result = c.Best(_floor10, 12)
                                        if c.Success(result) then
                                            local result = c.Best(_floor11, 12)
                                            if c.Success(result) then
                                                local result = c.Best(_floor12, 12)
                                                if c.Success(result) then
                                                    local result = c.Best(_floor13, 12)
                                                    if c.Success(result) then
                                                        local result = c.Best(_floor14, 12)
                                                        if c.Success(result) then
                                                            local result = c.Best(_floor15, 12)
                                                            if c.Success(result) then
                                                                local result = c.Best(_floor16, 12)
                                                                if c.Success(result) then
                                                                    return true
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
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
    local result = c.Best(_do, 10)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()
