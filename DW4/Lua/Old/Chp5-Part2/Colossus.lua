-- Starts at the last lag frame after entering colossus
-- Manipulates getting to the lever, pushing it and the following cutscene
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _stairs(direction)
    if c.Read(c.Addr.MoveTimer) ~= 0 then
        error(string.format('Move timer must be zero to call this method! %s', c.Read(c.Addr.MoveTimer)))
        return false
    end
    local cap = 100
    
    c.Save('WalkStart')

    local attempts = 0
    while attempts < cap do
        c.Load('WalkStart')
        c.PushFor(direction, 1)
        if c.Read(c.Addr.MoveTimer) ~= 15 then
            return c.Bail('Move timer did not start on 15')
        end

        c.RandomFor(20)
        c.WaitFor(1)
        if c.IsEncounter() then
            attempts = attempts + 1
        else
			local moveTimer = c.Read(c.Addr.MoveTimer)
			if moveTimer == 1 then
				c.WaitFor(1) -- Accounts for lag during day/night transition
				c.Debug('Lagged, increasing walk by 1 frame')
			end
            return true
        end
    end
    
    c.Debug('Could not avoid encounter')
    return false
end

local function _upStairs()
    c.WalkUp(4)
    if not _stairs('Up') then return false end
    if not _stairs('Up') then return false end
    if not _stairs('Up') then return false end
    if not _stairs('Up') then return false end
    if not _stairs('Up') then return false end
    if not _stairs('Up') then return false end
    c.PushUp()
    c.RandomFor(20)
    c.UntilNextInputFrame()
	return true
end

local function _floor1()
    if not c.WalkUp(13) then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor2()
    local result = c.WalkMap({
        { ['Down'] = 3 },
        { ['Right'] = 11 },
        { ['Up'] = 6 }
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor3()
    local result = c.WalkMap({
        { ['Up'] = 1 },
        { ['Left'] = 3 },
        { ['Up'] = 3 },
        { ['Left'] = 4 },
        { ['Up'] = 3 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor4()
    local result = c.WalkMap({
        { ['Down'] = 1 },
        { ['Left'] = 8 },
        { ['Down'] = 4 },
        { ['Right'] = 6 },
        { ['Down'] = 11 },
        { ['Left'] = 6 },
        { ['Up'] = 4 },
        { ['Left'] = 5 },
        { ['Up'] = 2 },
        { ['Left'] = 4 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor5()
    local result = c.WalkMap({
        { ['Down'] = 1 },
        { ['Right'] = 2 },
        { ['Down'] = 3 },
        { ['Right'] = 3 },
        { ['Down'] = 1 },
        { ['Right'] = 16 },
        { ['Up'] = 2 },
        { ['Right'] = 3 },
        { ['Up'] = 2 },
        { ['Right'] = 2 },
        { ['Up'] = 1 },
        { ['Right'] = 1 },
        { ['Up'] = 6 },
        { ['Left'] = 3 },
        { ['Up'] = 1 },
        { ['Left'] = 3 },
        { ['Up'] = 2 },
        { ['Left'] = 3 },
        { ['Down'] = 1 },
    })
    if not result then return false end
    result = c.Best(c.WalkDownToCaveTransition, 10)
    if not c.Success(result) then return false end
    local result = c.WalkMap({
        { ['Down'] = 1 },
        { ['Left'] = 5 },
        { ['Up'] = 4 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor6()
    local result = c.WalkMap({
        { ['Down'] = 13 },
        { ['Right'] = 5 },
        { ['Up'] = 4 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor7()
    local result = c.WalkMap({
        { ['Left'] = 7 },
        { ['Down'] = 4 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.RndWalkingFor('Left', 10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor8()
    c.ChargeUpWalking()
    if not c.WalkUp(7) then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor9()
    local result = c.WalkMap({
        { ['Up'] = 2 },
        { ['Right'] = 2 },
        { ['Up'] = 3 },
        { ['Right'] = 6 },
        { ['Up'] = 4 },
        { ['Right'] = 2 },
        { ['Up'] = 4 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor10()
    local result = c.WalkMap({
        { ['Right'] = 4 },
        { ['Down'] = 2 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor11()
    local result = c.WalkMap({
        { ['Left'] = 2 },
        { ['Down'] = 8 },
    })
    if not result then return false end
    c.PushUp()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushA()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.DismissDialog()
    c.UntilNextInputFrame()
    c.RandomFor(525)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor12()
    c.ChargeUpWalking()
    local result = c.WalkMap({
        { ['Up'] = 5 },
        { ['Right'] = 4 },
        { ['Down'] = 1 },
        { ['Right'] = 4 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _do()
    local result = c.Best(_upStairs, 9)
    if c.Success(result) then
        result = c.Best(_floor1, 9)
        if c.Success(result) then
            result = c.Best(_floor2, 9)
            if c.Success(result) then
                result = c.Best(_floor3, 9)
                if c.Success(result) then
                    result = c.Best(_floor4, 9)
                    if c.Success(result) then
                        result = c.Best(_floor5, 9)
                        if c.Success(result) then
                            result = c.Best(_floor6, 9)
                            if c.Success(result) then
                                result = c.Best(_floor7, 9)
                                if c.Success(result) then
                                    result = c.Best(_floor8, 9)
                                    if c.Success(result) then
                                        result = c.Best(_floor9, 9)
                                        if c.Success(result) then
                                            result = c.Best(_floor10, 9)
                                            if c.Success(result) then
                                                result = c.Best(_floor11, 9)
                                                if c.Success(result) then
                                                    result = c.Best(_floor12, 9)
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



