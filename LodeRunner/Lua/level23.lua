-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 23 then
    error('must be run in level 23')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.GrabLadderRight('Down')
    c.ClimbUntil(8)
    c.GrabLadderRight('Down')
    c.ClimbUntil(9)
    c.RightUntil(20)
    c.PushDown()
    c.FinishFalling()
    c.RightUntil(24)
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.UntilDig('Right', 'B')
    c.UntilDig('Right', 'B')
    c.Assert(c.FrameSearch(function()
        c.LeftFor(1)
        return c.Enemy(1).levelY == 11
    end))

    c.UntilGoldLeft()
    c.GrabLadderRight()

    c.WaitFor(1) -- Hardcoded - difficult to find a timing that reliably measures the enemy falling back into the pit
    c.ClimbUntil(6) -- Just happened to get a 27 spawn, yay

    -- Just in case delaying the enemy can cause a bit less lag, but it didn't
    c.BestSearch(function()
        c.ClimbUntil(3)
        c.GrabLadderLeft()
        c.ClimbUntil(1)
        c.LeftFor(3)
        c.UntilDig('Left', 'B')
        return c.WalkOverEnemy('Left')
    end, 3)

    c.GrabLadderLeft()
    c.ClimbUntil(0)
    c.UntilDig('Left', 'B')

    c.BestOf({
        function()
            c.ClimbUntil(1)
            return c.LeftFor(3)
        end,
        function()
            return c.LeftFor(3)
        end,
    })

    -- Happened to get perfect E2 spawn! otherwise this is a place to delay to manip
    c.UntilDig('Left', 'B')
    c.WalkOverEnemy('Left')
    c.LeftUntil(5)
    c.UntilDig('Left', 'A')
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.UntilDig('Right', 'A')
    c.RightUntil(9)
    c.PushDown()
    c.FinishFalling()
    c.LeftFor(1)
    c.UntilDig('Left', 'B')

    c.UntilDig('Right', 'B')
    c.UntilDig('Right', 'B')
    c.FallLeft()
    c.LeftFor(1)
    c.UntilDig('Left', 'B')
    c.UntilDig('Right', 'B')
    c.FallLeft()
    c.UntilDig('Left', 'B')
    c.FallLeft()
    c.LeftUntil(2)
    c.PushDown()
    c.FinishFalling()
    c.RightUntil(7)

    c.BestOf({
        c.UntilGoldRight,
        function()
            c.GrabLadderRight('Down')
            c.ClimbUntil(13)
            c.UntilGoldRight()
        end,
    })

    c.GrabLadderRight()
    c.ClimbUntil(9)
    c.RightUntil(26)
    c.GrabLadderRight()

    c.ClimbUntil(3)
    c.LeftFor(2)
    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.UntilGoldRight()
    c.LeftFor(5)
    c.GrabLadderLeft('Down')
    c.BestOf({
        function()
            c.ClimbUntil(4)
            c.FinishFalling()
            c.UntilDig('Right', 'B')
            return c.FallLeft()
        end,
        function()
            c.ClimbUntil(4)
            c.FinishFalling()
            c.UntilDig('Left', 'A')
            return c.FallRight()
        end,
        function()
            c.ClimbUntil(3)
            c.GrabLadderRight('Down')
            c.ClimbUntil(6)
            c.UntilDig('Left', 'B')
            return c.FallLeft()
        end,
    })

    c.PushDown()
    c.FinishFalling()
    c.UntilDig('Left', 'B')
    c.UntilDig('Right', 'B')
    c.FallLeft()
    c.UntilDig('Left', 'A')
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.UntilDig('Right', 'B')
    c.UntilGoldRight()
    c.FallLeft()
    c.GrabLadderLeft()
    c.ClimbUntil(9)
    c.RightUntil(26)
    c.GrabLadderRight()
    c.ClimbUntil(3)
    c.LeftUntil(20)
    c.PushDown()
    c.FinishFalling()
    c.RightFor(1)
    c.UntilDig('Right', 'B')
    c.FallLeft()
    c.RightUntil(26)
    c.GrabLadderRight()
    c.ClimbUntil(3)

    c.LeftUntil(25)
    c.PushDown()
    c.FinishFalling()
    c.RightFor(1)
    c.UntilDig('Right', 'B')
    c.FallLeft()

    c.GrabLadderRight()
    c.ClimbUntil(3)
    c.LeftFor(2)
    c.GrabLadderLeft()
    c.ClimbUntilLevelEnd()

    c.Marker('lv 23 end')


    c.Done()
end

c.Finish()
