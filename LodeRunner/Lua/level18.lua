-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 18 then
    error('must be run in level 18')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.GrabLadderLeft()
    c.ClimbUntil(3)

    c.Assert(c.FrameSearch(function()
        c.FallRight()
        if c.Enemy(3).yPos() >= 12 then
            return false
        end

        c.GrabLadderLeft()
        return c.ClimbUntil(10)
    end))

    c.Assert(c.FrameSearch(function() return c.ClimbUntil(8) end))

    c.Assert(c.FrameSearch(function()
        local result = c.ClimbUntil(4)
        if not result then return false end

        return c.WalkOverEnemy('Right')
    end))

    c.RightUntil(4)
    c.UntilDig('Right', 'A')
    c.UntilDig('Left', 'A')
    c.RightUntil(5)
    c.UntilDig('Right', 'A')
    c.UntilDig('Left', 'A')
    c.WaitFor(2)

    c.Assert(c.FrameSearch(function()
        c.RightUntil(6)
        c.UntilDig('Right', 'A')
        c.UntilDig('Left', 'A')
        return c.Enemy(3).levelX == 0
    end))

    c.FallRight()
    c.UntilDig('Right', 'B')
    c.FallLeft()
    c.UntilDig('Left', 'B')
    c.FallLeft()
    c.GrabLadderLeft()
    c.ClimbUntil(10)

    c.Assert(c.FrameSearch(function() return c.ClimbUntil(4) end))
    c.Assert(c.FrameSearch(function() return c.WalkOverEnemy('Right') end))

    c.RightUntil(9)
    c.UntilDig('Right', 'A')
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.UntilDig('Right', 'A')
    c.FallRight()

    c.RightUntil(18)
    c.WaitFor(1) -- Manip enemy 3 spawn, must be 12 to about 15, narrow range
    c.UntilDig('Right', 'A')
    c.Assert(c.WalkOverEnemy('Right'))
    c.RightUntil(20)
    c.WaitFor(1) -- Manip e2 spawn, must be the same 12 to 15 range
    c.UntilDig('Right', 'A')
    c.Assert(c.WalkOverEnemy('Right'))
    c.GrabLadderRight()
    c.ClimbUntil(6)
    c.GrabLadderRight()
    c.ClimbUntil(5)
    c.FallRight()

    c.RightUntil(27)
    c.Assert(c.FrameSearch(function()
        c.UntilDig('Right', 'B')

        c.Assert(c.FrameSearch(function()
            c.FallLeft()
            c.UntilGoldRight()
            c.FallLeft()
            return c.Enemy(1).levelX == 26
        end))

        c.GrabLadderLeft()
        c.ClimbUntil(6)
        c.GrabLadderRight('Down')
        c.ClimbUntil(7)

        return c.Enemy(1).levelX > 8 and c.Enemy(1).levelX < 16
    end, 29)) -- custom number so the savestates do not collide with the inner one

    c.Assert(c.FrameSearch(function()
            c.ClimbUntil(5)
            c.FallRight()
            return c.Enemy(1).yPos() > 3
    end))

    c.GrabLadderRight()
    c.ClimbUntil(1)
    c.FallLeft()
    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.GrabLadderLeft('Down')
    c.ClimbUntil(6)
    c.FinishFalling()
    c.FallRight()
    c.GrabLadderRight()
    c.ClimbUntil(6)
    c.GrabLadderRight()
    c.ClimbUntil(5)
    c.FallRight()
    c.GrabLadderRight()
    c.ClimbUntil(1)
    c.FallLeft()
    c.GrabLadderLeft()
    c.ClimbUntil(1)

    c.BestOf({
        function()
            return c.LeftUntil(15)
        end,
        function()
            c.GrabLadderLeft('Down')
            c.ClimbUntil(2)
            return c.LeftUntil(15)
        end,
    })

    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.UntilGoldLeft()

    c.BestOf({
        function()
            c.LeftUntil(6)
            return c.GrabLadderLeft()
        end,
        function()
            c.GrabLadderLeft('Down')
            c.ClimbUntil(2)
            c.LeftFor(1)
            return c.GrabLadderLeft()
        end,
    })

    c.ClimbUntilLevelEnd()

    c.Marker('lv 18 end')

    c.Done()
end

c.Finish()
