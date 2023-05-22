-- Starts from the last lag frame upon entering Izmut with Alex's wife
-- Manipulates walking down stairs, back up stairs, and exiting Izmut
dofile('../DW4Core.lua')
c.InitSession()
c.FastMode()
c.Load(3)

local function __walk()
    return c.WalkMap({
        { ['Up'] = 17 },
        { ['Right'] =  7 },
        { ['Up'] = 6 },
        { ['Right'] =  1 },
        { ['Up'] = 1 },
    })
end

local function _downStairs()
    c.NoEncountersPossible = true
    if not c.Cap(__walk, 50) then return false end
    c.NoEncountersPossible = false
    c.UntilNextInputFrame()
    return true
end

local function _upStairs()
    c.PushUp()
    c.RandomFor(50)
    c.UntilNextInputFrame()
    c.AorBAdvance(7)
    c.AorBAdvanceThenOne()
    c.WaitFor(1)
    c.DismissDialog()
    if not c.ChargeUpWalking() then return false end
    if not c.ChargeUpWalking() then return false end
    c.PushDown()
    c.WalkDown()
    c.UntilNextInputFrame()
    return true
end

local function _leave()
    c.NoEncountersPossible = true
    local result = c.WalkMap({
        { ['Down'] = 1 },
        { ['Left'] = 1 },
        { ['Down'] = 6 },
        { ['Right'] = 8 },
    })
    c.NoEncountersPossible = false
    if not result then return false end
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _do()
    local result = c.Best(_downStairs, 12)
    if c.Success(result) then
        result = c.Best(_upStairs, 12)
        if c.Success(result) then
            result = c.Best(_leave, 12)
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