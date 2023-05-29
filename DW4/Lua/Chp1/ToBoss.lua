-- Starts from the last lag frame upon leaving Izmut to walk to the cave southeast of Izmut
-- Manipulates entering the case, getting the flying shoes, and getting an optimal encounter
dofile('../DW4Core.lua')
c.InitSession()
c.FastMode()
c.BlackscreenMode()
c.Load(1)

local function __f1path1()
    local result = c.WalkMap({
        { ['Left'] = 4 },
        { ['Up'] = 4 }        
    })

    if not result then return false end
    if not c.Cap(c.WalkUpToCaveTransition, 20) then return false end
    result = c.WalkMap({
        { ['Up'] = 1 },
        { ['Left'] = 1 }        
    })
    return result
end

local function __f1path2()
    local result = c.WalkMap({
        { ['Left'] = 4 },
        { ['Up'] = 4 },   
        { ['Left'] = 1 },     
    })

    if not result then return false end
    if not c.Cap(c.WalkUpToCaveTransition, 20) then return false end
    result = c.WalkMap({
        { ['Up'] = 1 },
    })
    return result
end

local function __f1_2path1()
    if not c.WalkDown(4) then return false end
    if not c.Cap(c.WalkDownToCaveTransition, 20) then return false end
    if not c.WalkRight() then return false end
    return true
end

local function __f1_2path2()
    if not c.WalkRight() then return false end
    if not c.WalkDown(4) then return false end
    if not c.Cap(c.WalkDownToCaveTransition, 20) then return false end
    return true
end

local function __f1_3_Npc()
    if not c.WalkDown(2) then return false end
    if not c.WalkRight(8) then return false end
    if not c.WalkDown(2) then return false end    
    return true
end

local function __f1_3path1()
    if not c.WalkRight(5) then return false end
    if not c.WalkUp(2) then return false end
    if not c.Cap(c.WalkUpToCaveTransition, 20) then return false end
    if not c.WalkRight() then return false end
    return true
end

local function __f1_3path2()
    if not c.WalkRight(6) then return false end
    if not c.WalkUp(2) then return false end
    if not c.Cap(c.WalkUpToCaveTransition, 20) then return false end
    return true
end

local function _floor1()
    local func
    if c.Flip() then
        func = __f1path1
    else
        func = __f1path2
    end
    if not c.Success(c.Best(func, 10)) then return false end

    local result = c.WalkMap({
        { ['Up'] = 3 },
        { ['Left'] = 3 },
        { ['Down'] = 2 },
        { ['Left'] = 4 },
        { ['Down'] = 10 },
    })
    if not result then return false end
    if not c.BringUpMenu() then return false end
    if not c.Search() then return false end
    c.AorBAdvance()
    c.AorBAdvanceThenOne()
    c.WaitFor(1)
    c.DismissDialog()
    if not c.ChargeUpWalking() then return false end
    local result = c.WalkMap({
        { ['Up'] = 10 },
        { ['Right'] = 3 },
        { ['Up'] = 2 },
        { ['Right'] = 4 },
    })

    if c.Flip() then
        func = __f1_2path1
    else
        func = __f1_2path2
    end
    if not c.Success(c.Best(func, 10)) then return false end
    if not c.WalkDown(9) then return false end
    if not c.Cap(c.WalkDownToCaveTransition, 20) then return false end

    if not c.Success(c.Cap(__f1_3_Npc, 30)) then return false end
    if c.Flip() then
        func = __f1_3path1
    else
        func = __f1_3path2
    end
    if not c.Success(c.Best(func, 10)) then return false end
    if not c.WalkMap({
        { ['Up'] = 5 },
        { ['Right'] = 1 },
    }) then return false end
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function __f2_path1()
    if not c.WalkUp(4) then return false end
    if not c.Cap(c.WalkUpToCaveTransition, 20) then return false end
    if not c.WalkLeft(3) then return false end
    return true
end

local function __f2_path1()
    if not c.WalkUp(4) then return false end
    if not c.Cap(c.WalkUpToCaveTransition, 20) then return false end
    if not c.WalkLeft(3) then return false end
    return true
end

local function __f2_path2()
    if not c.WalkLeft(1) then return false end
    if not c.WalkUp(4) then return false end
    if not c.Cap(c.WalkUpToCaveTransition, 20) then return false end
    if not c.WalkLeft(2) then return false end
    return true
end

local function __f2_path3()
    if not c.WalkLeft(2) then return false end
    if not c.WalkUp(4) then return false end
    if not c.Cap(c.WalkUpToCaveTransition, 20) then return false end
    if not c.WalkLeft(1) then return false end
    return true
end

local function __f2_path4()
    if not c.WalkLeft(3) then return false end
    if not c.WalkUp(4) then return false end
    if not c.Cap(c.WalkUpToCaveTransition, 20) then return false end
    return true
end

local function _floor2()
    if not c.WalkMap({
        { ['Left'] = 4 },
        { ['Down'] = 1 },
        { ['Left'] = 6 },
        { ['Down'] = 4 },
        { ['Left'] = 3 },
    }) then return false end
    local d4 = math.random(1, 4)
    local func
    if d4 == 1 then
        func = __f2_path1
    elseif d4 == 2 then
        func = __f2_path2
    elseif d4 == 3 then
        func = __f2_path3
    else
        func = __f2_path4
    end
    if not c.Cap(func, 10) then return false end

    if not c.WalkMap({
        { ['Up'] = 2 },
        { ['Left'] = 1 },
        { ['Up'] = 3 },
    }) then return false end
    if not c.Cap(c.WalkUpToCaveTransition, 20) then return false end
    if not c.WalkMap({
        { ['Up'] = 2 },
        { ['Right'] = 2 },
        { ['Up'] = 3 },
    }) then return false end
    c.UntilNextInputFrame()
    return true
end

local function _floor3()
    if not c.WalkUp(3) then return false end
    if not c.BringUpMenu() then return false end
    if not c.Door() then return false end
    if not c.ChargeUpWalking() then return false end
    if not c.WalkMap({
        { ['Up'] = 3 },
        { ['Left'] = 6 },
    }) then return false end
    if not c.Cap(c.WalkLeftToCaveTransition, 20) then return false end
    if not c.WalkMap({
        { ['Left'] = 4 },
        { ['Down'] = 2 },
    }) then return false end
    if not c.BringUpMenu() then return false end
    if not c.Search() then return false end
    c.AorBAdvance()
    c.AorBAdvanceThenOne()
    c.WaitFor(1)
    c.DismissDialog()
    if not c.ChargeUpWalking() then return false end
    if not c.WalkMap({
        { ['Up'] = 2 },
        { ['Right'] = 4 },
    }) then return false end
    if not c.Cap(c.WalkRightToCaveTransition, 20) then return false end
    if not c.WalkMap({
        { ['Right'] = 6 },
        { ['Down'] = 5 },
        { ['Left'] = 1 },
        { ['Down'] = 6 },
        { ['Left'] = 5 },
        { ['Down'] = 3 },
        { ['Left'] = 5 },
        { ['Down'] = 9 },
        { ['Right'] = 24 },
        { ['Up'] = 4 },
        { ['Right'] = 1 },
        { ['Up'] = 2 },
    }) then return false end
    if not c.Cap(c.WalkUpToCaveTransition, 20) then return false end
    if not c.WalkUp(6) then return false end
    c.UntilNextInputFrame()
    return true
end

local function _floor4()
    if not c.WalkMap({
        { ['Right'] = 10 },
        { ['Down'] = 3 },
        { ['Right'] = 2 },
        { ['Down'] = 1 },
        { ['Right'] = 5 },
        { ['Up'] = 4 },
    }) then return false end
    c.RandomFor(90)
    c.UntilNextInputFrameThenOne()
    c.DismissDialog()
    if not c.ChargeUpWalking() then return false end
    c.PushUp()
    if not c.WalkMap({
        { ['Up'] = 2 },
        { ['Right'] = 1 },
        { ['Up'] = 5 },
    }) then return false end
    if not c.BringUpMenu() then return false end
    if not c.PushAWithCheck() then return false end
    c.RandomFor(5)
    c.UntilNextInputFrameThenOne()
    c.DismissDialog()
    return true
end


local function _do()
    local result = c.Best(_floor1, 50)
    --local result = true
    if c.Success(result) then
        local result = c.Best(_floor2, 25)
        --result = true
        if c.Success(result) then
            local result = c.Best(_floor3, 12)
            if c.Success(result) then
                local result = c.Best(_floor4, 12)
                if c.Success(result) then
                    return true
                end
            end
        end
    end
end

while not c.IsDone() do
    local result = c.Best(_do, 5)
    if c.Success(result) then
        c.Done()
    end    
end