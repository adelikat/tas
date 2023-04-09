-- Starts at the first frame to dimiss "Intelligence goes up x points" wiht ideal HP manipulated after level 22 after the Esturk fight
-- Manipulates getting the gas canister and manipulating a death warp encounter
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _endLevelups()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    return true
end

local function _leaveChambers()
    c.PushFor('Down', 16)
    c.RandomFor(250)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(200)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(185)
    c.PushFor('Down', 23)
    if not c.WalkDown(6) then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _downStairs()
    local result = c.WalkMap({
        { ['Down'] = 2 },
        { ['Left'] = 2 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _getCloseToTreasure()
    if not c.WalkUp(2) then return false end
    result = c.Best(c.WalkUpToCaveTransition, 12)
    if not c.Success(result) then return false end
    local result = c.WalkMap({
        { ['Up'] = 1 },
        { ['Right'] = 9 },
    })
    if not result then return false end
    result = c.Best(c.WalkRightToCaveTransition, 12)
    if not c.Success(result) then return false end
    local result = c.WalkMap({
        { ['Right'] = 1 },
        { ['Down'] = 7 },
    })
    if not result then return false end
    return not c.IsEncounter()
end

local function __walk()    
    c.RandomFor(14)
    c.WaitFor(1)
    local direction = c.GenerateRndDirection()
    c.Debug('direction: ' .. direction)
    c.PushFor(direction, 1)
    c.RandomFor(16)

    if not c.IsEncounter() then
        return c.Bail('Did not get encounter')
    end

    if c.ReadEGroup2Type() ~= 0xFF then
        return c.Bail('Got 2nd enemy group')
    end

    if c.ReadE1Count() > 2 then
        return c.Bail('Got 3 enemies')
    end

    if c.ReadEGroup1Type() ~= 0x87 then
        return c.Bail('Did not get Chaos Hopper')
    end

    c.UntilNextInputFrame()

    return true
end

local function _getEncounter()
    c.PushRight()
    c.RndWalkingFor('Right', 95)
    if c.IsEncounter() then
        return c.Bail('Encounter')
    end
    c.PushUp()
    c.RndWalkingFor('Up', 63)
    if c.IsEncounter() then
        return c.Bail('Encounter')
    end
    if not c.BringUpMenu() then return false end
    if not c.Search() then return false end
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(2)
    c.DismissDialog()
    
    return c.Cap(__walk, 250)
end

c.Load(3)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
	c.Load(100)

    local result = c.Best(_endLevelups, 10)
    if c.Success(result) then
        result = c.Best(_leaveChambers, 10)
        if c.Success(result) then
            result = c.Best(_downStairs, 10)
            if c.Success(result) then
                result = c.Best(_getCloseToTreasure, 10)
                if c.Success(result) then
                    result = c.Cap(_getEncounter, 20)
                    if c.Success(result) then
                        c.Done()
                    end
                end
            end
        end
    end
end

c.Finish()



