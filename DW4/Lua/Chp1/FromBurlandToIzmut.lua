--Starts at the last lag frame after leaving Burland for the first time
--Manipulates entering and exiting the cave, and entering Izmut
-- ensuring an optimal day/night counter
dofile('../DW4Core.lua')
c.InitSession()
c.FastMode()
c.BlackscreenMode()
c.Load(2)


local function _enterCave()
    c.EnsureDayNight = true
    local result = c.WalkMap({
        { ['Left'] = 4 },
        { ['Up'] = 1 },
        { ['Left'] = 1 },
        { ['Up'] = 1 },
        { ['Left'] = 1 },
        { ['Up'] = 7 },
        { ['Left'] = 2 },
        { ['Up'] = 1 },
        { ['Left'] = 2 },
        { ['Up'] = 1 },
        { ['Left'] = 12 },
        { ['Up'] = 4 },
    })
    c.EnsureDayNight = false
    if not result then return false end
    c.UntilNextInputFrame()
    return not c.IsEncounter() and addr.StepCounter:Read() == 77
end

local function _exitCave()
    local result = c.WalkMap({
        { ['Up'] = 2 },
        { ['Left'] = 2 },
        { ['Up'] = 5 },
        { ['Left'] = 3 },
        { ['Up'] = 6 },
        { ['Right'] = 5 },
        { ['Up'] = 8 },
        { ['Left'] = 4 },
        { ['Up'] = 3 },
        { ['Left'] = 2 },
        { ['Up'] = 1 },
        { ['Left'] = 2 },
    })
    if not result then return false end
    if not c.Cap(c.WalkLeftToCaveTransition, 50) then return false end
    local result = c.WalkMap({
        { ['Left'] = 2 },
        { ['Up'] = 10 },
        { ['Right'] = 1 },
        { ['Up'] = 8 },
        { ['Left'] = 1 },
        { ['Up'] = 2 },
    })
    if not result then return false end
    c.UntilNextInputFrame()
    return true
end

local function _enterIzmut()
    c.EnsureDayNight = true
    local result = c.WalkMap({
        { ['Up'] = 2 },
        { ['Right'] = 2 },
        { ['Up'] = 2 },
        { ['Right'] = 10 },
        { ['Up'] = 2 },
        { ['Right'] = 2 },
        { ['Down'] = 2 },
        { ['Left'] = 2 },
        { ['Up'] = 2 },
        { ['Right'] = 2 },
        { ['Down'] = 2 },
        { ['Left'] = 2 },
        { ['Up'] = 2 },
        { ['Right'] = 2 },
        { ['Down'] = 2 },
        { ['Left'] = 1 },
        { ['Down'] = 2 },
        { ['Up'] = 3 },
    })
    c.EnsureDayNight = false
    if not result then return false end
    c.UntilNextInputFrame()
    return true
end

local function _do()
    local result = c.Best(_enterCave, 50)
    if c.Success(result) then
        result = c.Best(_exitCave, 25)
        if c.Success(result) then
            result = c.Best(_enterIzmut, 50)
            if c.Success(result) then
                return true
            end
        end
    end

    return false
end


while not c.IsDone() do
    local result = c.Best(_do, 5)
    if c.Success(result) then
        c.Done()
    end
end
