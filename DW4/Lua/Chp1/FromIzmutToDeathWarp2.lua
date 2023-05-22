-- Starts from the last lag frame upon leaving Izmut to walk to the cave southeast of Izmut
-- Manipulates entering the case, getting the flying shoes, and getting an optimal encounter
dofile('../DW4Core.lua')
c.InitSession()
c.FastMode()
c.BlackscreenMode()
c.Load(3)
c.NoEncountersPossible = true
local function __dismissComeThisWay()
    c.UntilNextInputFrameThenOne()
    c.DismissDialog()
end

local function _enterCave()
    local result = c.WalkMap{
        { ['Down'] = 4 },
        { ['Right'] = 8 },
    }
    if not result then return false end
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _enterWell()
    if not c.WalkUp(9) then return false end
    c.UntilNextInputFrameThenOne()
    c.DismissDialog()
    if not c.WalkUp(1) then return false end
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor1()
    c.RandomWithoutA(6)
    if addr.MoveTimer:Read() ~= 0 then
        c.Log('Walking charged up too soon')
        return false
    end
    if not c.WalkDown(9) then return false end
    if true then
        if not c.WalkMap({
            { ['Down'] = 1 },
            { ['Left'] = 3 },
        }) then return false end
    else
        if not c.WalkMap({
            { ['Left'] = 1 },
            { ['Down'] = 1 },
            { ['Left'] = 2 },
        }) then return false end
    end
    __dismissComeThisWay()

    if not c.WalkMap({
        { ['Left'] = 1 },
        { ['Down'] = 5 },
        { ['Left'] = 8 },
        { ['Down'] = 7 },
    }) then return false end
    __dismissComeThisWay()

    if not c.WalkMap({
        { ['Left'] = 1 },
        { ['Down'] = 2 },
        { ['Left'] = 7 },
        { ['Down'] = 11 },
        { ['Right'] = 10 },
    }) then return false end
    __dismissComeThisWay()

    if not c.WalkMap({
        { ['Right'] = 2 },
        { ['Down'] = 11 },
    }) then return false end
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function __floor2Encounter()
    if not c.WalkDown(2) then return false end
    if not c.WalkRight(13) then return false end
    c.PushRight()
    c.RandomFor(20)
    c.RngCache:Add()
    if not c.IsEncounter() then
        return false
    end   

    local egt1 = addr.EGroup1Type:Read()
	local egt2 = addr.EGroup2Type:Read()
	local eg1Count = addr.E1Count:Read()
	if egt1 == 0x13 and egt2 == 0xFF and eg1Count == 1 then
        c.UntilNextInputFrame()
        return true
    end

    return false
end

local function _floor2()
    if not c.WalkMap({
        { ['Down'] = 2 },
        { ['Right'] = 2 },
    }) then return false end
    if not c.Best(c.WalkRightToCaveTransition, 2) then return false end
    if not c.WalkRight(9) then return false end
    __dismissComeThisWay()
    if not c.WalkRight() then return false end
    if not c.WalkUp(24) then return false end
    __dismissComeThisWay()
    if not c.WalkMap({
        { ['Up'] = 2 },
        { ['Left'] = 11 },
        { ['Up'] = 2 },
    }) then return false end
    if not c.Best(c.WalkUpToCaveTransition, 2) then return false end
    if not c.WalkMap({
        { ['Up'] = 2 },
        { ['Right'] = 6 },
        { ['Up'] = 5 },
        { ['Left'] = 6 },        
    }) then return false end
    if not c.BringUpMenu() then return false end
    if not c.Search() then return false end
    c.AorBAdvance()
    c.AorBAdvanceThenOne()
    c.WaitFor(1)
    c.DismissDialog()
    if not c.ChargeUpWalking() then return false end
    if not c.WalkMap({
        { ['Right'] = 6 },        
        { ['Down'] = 5 },
        { ['Left'] = 6 },
        { ['Down'] = 2 },
    }) then return false end
    if not c.Best(c.WalkDownToCaveTransition, 2) then return false end
    if not c.Cap(__floor2Encounter, 2000) then return false end

    return true
end

local function _do()
    local result = c.Best(_enterCave, 10)
    if c.Success(result) then
        local result = c.Best(_enterWell, 10)
        if c.Success(result) then
            local result = c.Best(_floor1, 10)
            if c.Success(result) then
                local result = c.Best(_floor2, 10)
                if c.Success(result) then
                    return true
                end
            end
        end
    end
end

while not c.IsDone() do
    local result = c.Best(_do, 100)
    if c.Success(result) then
        c.Done()
    end    
end