-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 42 then
    error('must be run in level 42')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

-- Similar route as regular 42 but lag is reduced a bit by keeping E3 on the left longer, but requires a gold drop of 1 which isn't even always possible
-- This happened to net 2 frames after all the delays for the gold drop manip
while not c.IsDone() do
    c.GrabLadderLeft()
    c.ClimbUntil(11)
    c.UntilDig('Left', 'A')
    c.UntilGoldLeft()
    c.FallRight()
    c.UntilDig('Right', 'B')

    c.BestOf({
        c.UntilGoldLeft,
        function()
            c.ClimbUntil(13)
            return c.UntilGoldLeft()
        end,
    })

    c.RightUntil(16)
    c.GrabLadderRight()
    c.ClimbUntil(12)
    c.RightUntil(22)

    c.WaitFor(1) -- Reduces lag for some reason
    c.UntilDig('Right', 'A')
    c.WalkOverEnemy('Right')
    c.GrabLadderRight()

    c.ClimbUntil(3)

    c.BestOf({
        function()
            c.LeftFor(1)
            c.UntilDig('Left', 'B')
            c.FallLeft()
            c.UntilGoldLeft()
            c.UntilGoldLeft()
            return c.FallRight()
        end,
        function()
            c.LeftFor(2)
            c.UntilDig('Left', 'B')
            c.FallLeft()
            c.UntilGoldLeft()
            c.UntilGoldLeft()
            return c.FallRight()
        end,
    })

    c.GrabLadderRight()

    c.WaitFor(4) -- Manip E3 drop to be exactly 1

    c.ClimbUntil(4)

    c.Assert(c.FrameSearch(function()
        local result = c.ClimbUntil(2)
        if not result then return false end
        return c.LeftUntil(25)
    end))

    c.LeftUntil(22)
    c.PushDown()
    c.FinishFalling()
    c.LeftUntil(16)
    c.UntilDig('Left', 'B')
    c.FallLeft()

    c.GrabLadderRight()
    c.ClimbUntil(7)
    c.UntilGoldRight()
    c.UntilGoldRight()
    c.GrabLadderLeft('Down')

    c.BestOf({
        function()
            c.ClimbUntil(10)
            c.UntilDig('Right', 'A')
            c.FallRight()
            c.GrabLadderRight()
            return c.ClimbUntil(3)
        end,
        function()
            c.ClimbUntil(9)
            c.FallRight()
            c.UntilDig('Right', 'A')
            c.FallRight()
            c.GrabLadderRight()
            return c.ClimbUntil(3)
        end,
    })

    c.Assert(c.FrameSearch(function()
        local result = c.ClimbUntil(2)
        if not result then return false end
        return c.LeftUntil(25)
    end))

    c.LeftUntil(6)
    c.GrabLadderLeft('Down')

    c.ClimbUntil(6)
    c.UntilGoldRight()
    c.GrabLadderLeft()
    c.ClimbUntil(5)
    c.FallLeft()
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.FallRight()
    c.GrabLadderRight()
    c.ClimbUntil(2)
    c.LeftUntil(2)
    c.UntilDig('Left', 'B')
    c.FallLeft()
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.FallRight()
    c.GrabLadderRight()
    c.ClimbUntil(2)
    c.LeftFor(1)
    c.GrabLadderLeft()
    c.ClimbUntilLevelEnd()

    c.Done()
end

c.Finish()
