-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 43 then
    error('must be run in level 43')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.UntilDig('Right', 'B')
    c.BestOf({
        function()
            c.UntilGoldLeft()
            c.GrabAndClimbOneRight()
            c.RightFor(1)
            return c.GrabLadderRight()
        end,
        function()
            c.ClimbUntil(13)
            c.UntilGoldLeft()
            c.GrabAndClimbOneRight()
            c.RightFor(1)
            return c.GrabLadderRight()
        end,
    })

    c.ClimbUntil(8)
    c.RightFor(1)
    c.GrabAndClimbOneRight()
    c.UntilGoldRight()

    c.GrabLadderLeft()
    c.ClimbUntil(5)
    c.LeftFor(1)
    c.GrabLadderLeft()
    c.ClimbUntil(3)
    c.LeftFor(1)
    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.LeftUntil(13)
    c.UntilDig('Left', 'B')
    c.FallLeft()

        c.WaitFor(2) -- Manip enemy spawn to be far to the right
    c.UntilDig('Right', 'A')
    c.WalkOverEnemy('Right')
    c.RightUntil(17)
    c.UntilDig('Right', 'B')
    c.FallLeft()
    c.ClimbUntil(6)
    c.UntilGoldLeft()

    c.BestOf({
        function()
            c.FallLeft()
            c.FallLeft()
            return c.GrabLadderLeft()
        end,
        function()
            c.GrabLadderLeft('Down')
            c.ClimbUntil(7)
            c.LeftFor(1)
            c.GrabLadderLeft('Down')
            c.ClimbUntil(8)
            c.UntilGoldLeft()
            return c.GrabLadderLeft()
        end,
        function()
            c.FallLeft()
            c.GrabLadderLeft('Down')
            c.ClimbUntil(8)
            c.UntilGoldLeft()
            return c.GrabLadderLeft()
        end,
        function()
            c.GrabLadderLeft('Down')
            c.ClimbUntil(7)
            c.LeftFor(1)
            c.FallLeft()
            return c.GrabLadderLeft()
        end,
    })

    c.ClimbUntil(7)
    c.LeftFor(1)
    c.GrabLadderLeft()

    c.Assert(c.FrameSearch(function()
        local result = c.ClimbUntil(5)
        local result = c.LeftFor(1)
        if not result then return false end
        result = c.GrabLadderLeft()
        if not result then return false end
        result = c.ClimbUntil(3)
        if not result then return false end
        result = c.UntilGoldRight()
        if not result then return false end
        return c.LeftUntil(2)
    end))

    c.PushLeft()
    c.PushLeft()

    c.Assert(c.FrameSearch(function()
        local result = c.FallLeft()
        if not result then return false end
        result = c.UntilGoldLeft()
        if not result then return false end
        return c.RightUntil(5)
    end))

    c.GrabLadderRight()
    c.ClimbUntil(5)
    c.LeftFor(1)
    c.GrabLadderLeft()
    c.ClimbUntil(3)
    c.LeftFor(1)
    c.GrabLadderLeft()
    c.ClimbUntilLevelEnd()

    c.Done()
end

c.Finish()
