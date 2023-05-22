-- Starts from the last lag frame upon Burland appearing after the first death warp
-- Manipulates talking to Alex's wife, leaving burland, entering the cave, leaving the cave, and entering Izmut
dofile('../DW4Core.lua')
c.InitSession()
c.FastMode()
c.BlackscreenMode()
c.Load(4)

local function __toWife()
    return c.WalkMap({
        { ['Down'] = 6 },
        { ['Right'] = 7 },
        { ['Down'] = 6 },
    })
end

local function _leaveBurland()
    c.RandomFor(2)
    c.UntilNextInputFrameThenOne()
    c.WaitFor(1)
    c.DismissDialog()
    c.PushDown()
    c.PushA() -- To charge up menu
    c.RandomWithoutA(13)
    c.WaitFor(1)
    c.Save(7)
    c.NoEncountersPossible = true
    if not c.Cap(__toWife, 100) then return false end
    if not result then return false end
    c.PushLeft()
    if not c.BringUpMenu() then return false end
    if not c.PushAWithCheck() then return false end
    c.RandomFor(3)
    c.UntilNextInputFrame()
    c.AorBAdvanceThenOne()
    c.WaitFor(1)
    c.DismissDialog()
    if not c.ChargeUpWalking() then return false end
    local result = c.WalkMap({
        { ['Right'] = 1 },
        { ['Down'] = 6 },
    })
    if not result then return false end
    c.NoEncountersPossible = false
    c.UntilNextInputFrame()

    return not c.IsEncounter()
end

local function _enterCave()
    c.NoEncountersPossible = false
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
    if not result then return false end
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _exitCave()
    c.NoEncountersPossible = false
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
    return not c.IsEncounter()
end

local function _enterIzmut()
    c.NoEncountersPossible = false
    local result = c.WalkMap({
        { ['Up'] = 2 },
        { ['Right'] = 2 },
        { ['Up'] = 2 },
        { ['Right'] = 11 },
        { ['Up'] = 1 },
    })
    if not result then return false end
    c.UntilNextInputFrame()
    return true
end

local function _do()
    local result = c.Best(_leaveBurland, 10)
    if c.Success(result) then
        result = c.Best(_enterCave, 10)
        if c.Success(result) then
            result = c.Best(_exitCave, 10)
            if c.Success(result) then
                result = c.Best(_enterIzmut, 10)
                if c.Success(result) then
                    return true
                end
            end
        end
    end

    return false
end

while not c.IsDone() do
    local result = c.Cap(_do, 5)
    if c.Success(result) then
        c.Done()
    end    
end