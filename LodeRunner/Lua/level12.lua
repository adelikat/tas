-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 12 then
    error('must be run in level 12')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

local function AvoidEnemyPickups()
    c.PushDown()
    c.FinishFalling()
    c.LeftFor(1)
    c.FallLeft()
    c.UntilGoldRight()
    return c.Enemy(1).timer >= 0 and c.Enemy(2).timer >= 0 and c.Enemy(3).timer >= 0
        and c.Enemy(1).levelY <= 10
        --and c.Player().isAlive and c.Enemy(1).levelX < 13
end

local function End(amt)
    if not amt or amt < 2 then
        error('must be 2 or more')
    end

    c.LeftFor(amt)
    c.PushDown()
    if amt < 5 then
        c.LeftUntil(19)
        c.UntilGoldLeft()
    end

    c.FallRight()
    c.GrabLadderRight()
    c.ClimbUntil(6)
    c.UntilGoldRight()
    c.GrabLadderLeft()
    c.Climb(3)
    c.UntilGold('Right')
    c.UntilLadderGrab('Left')
    c.Climb(4)
    c.UntilGold('Right')
    c.UntilLadderGrab('Left')
    c.ClimbUntilLevelEnd()


    return true
end

local function End5()
    c.LeftFor(5)
    c.PushDown()
    c.FinishFalling()
    c.RightFor(1)

    c.FallRight()
    c.UntilLadderGrab('Right')
    c.Climb(3)
    c.UntilGold('Right')
    c.UntilLadderGrab('Left')
    c.Climb(3)
    c.UntilGold('Right')
    c.UntilLadderGrab('Left')
    c.ClimbUntil(2)
    c.UntilGoldRight()
    c.GrabLadderLeft()
    c.ClimbUntilLevelEnd()


    return true
end

while not c.IsDone() do
    c.UntilGoldLeft()
    c.RightFor(5)
    c.WaitFor(4) -- Manip gold drop -- wait of 3 costs no frames, but 4 costs 6, weird
    c.GrabLadderRight()
    c.ClimbUntil(11)
    c.WaitFor(1) -- more manip
    c.ClimbUntil(9)
    c.UntilGoldLeft()
    c.GrabLadderLeft()

    c.ClimbUntil(7)
    c.GrabLadderRight()

    c.ClimbUntil(6)
    c.GrabLadderRight()

    c.ClimbUntil(5)
    c.GrabLadderRight()

    c.ClimbUntil(4)
    c.GrabLadderRight()

    c.ClimbUntil(2)
    c.RightUntil(16)
    c.GrabLadderRight()
    c.ClimbUntil(1)
    c.LeftUntil(5)
    c.PushDown()
    c.FinishFalling()
    c.LeftFor(2)
    c.UntilDig('Left', 'A')

    c.UntilDig('Left', 'A')
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.RightFor(1)
    c.UntilDig('Right', 'A')
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.UntilDig('Right', 'B')
    c.FallLeft()
    c.UntilDig('Left', 'A')
    c.UntilGoldLeft()
    c.FallRight()

    c.RightUntil(15)

    -- --c.Marker('temp')

    -- c.Assert(c.FrameSearch(AvoidEnemyPickups))
    -- c.GrabLadderRight()

    -- c.ClimbUntil(9)

    -- c.BestOf({
    --     function() return End(2) end,
    --     function() return End(3) end,
    --     function() return End(4) end,
    --     End5
    -- })

    -- c.Marker('lv 12 end')
    c.LeftUntil(21)
    c.PushDown()
    c.FinishFalling()
    c.RightFor(1)
    c.FallRight()
    c.GrabLadderRight()
    c.ClimbUntil(9)
    c.UntilGoldRight()
    c.GrabLadderLeft()
    c.ClimbUntil(6)
    c.BestOf({
        function()
            c.UntilGoldRight()
            c.UntilGoldLeft()
            return c.GrabLadderRight()
        end,
        function()
            c.UntilGoldLeft()
            c.UntilGoldRight()
            return c.GrabLadderLeft()
        end,
    })

    c.ClimbUntil(2)
    c.UntilGoldRight()
    c.GrabLadderLeft()
    c.ClimbUntilLevelEnd()


    c.Done()
end

c.Finish()
