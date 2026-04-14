-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 40 then
    error('must be run in level 40')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.LeftUntil(9)
    c.UntilDig('Left', 'B')
    c.Assert(c.WalkOverEnemy('Left'))
    c.LeftUntil(3)
    c.GrabLadderLeft()
    c.ClimbUntil(10)
    c.RightFor(5)
    c.GrabLadderRight()
    c.ClimbUntil(8)
    c.LeftUntil(4)
    c.UntilDig('Left', 'B')
    c.Assert(c.WalkOverEnemy('Left'))
    c.GrabLadderLeft()
    c.ClimbUntil(6)
    c.RightFor(5)
    c.GrabLadderRight()
    c.ClimbUntil(4)
    c.LeftUntil(3)
    c.GrabLadderLeft()
    c.ClimbUntil(2)
    c.RightFor(5)
    c.GrabLadderRight()
    c.ClimbUntil(1)
    c.UntilDig('Right', 'A')

    c.BestOf({
        function()
            return c.RightUntil(16)
        end,
        function()
            c.ClimbUntil(2)
            return c.RightUntil(16)
        end,
    })

    c.UntilDig('Left', 'B')
    c.FallLeft()
    c.RightUntil(16)
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.FallLeft()
    c.UntilGoldLeft()
    c.RightUntil(16)
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.FallRight()

    c.GrabLadderRight()
    c.ClimbUntil(10)
    c.UntilGoldRight()
    c.UntilDig('Left', 'A')
    c.ClimbUntil(11)
    c.UntilDig('Right', 'A')

    c.BestOf({
        c.UntilGoldRight,
        function()
            c.ClimbUntil(12)
            return c.UntilGoldRight()
        end,
    })

    c.GrabLadderRight()

    c.ClimbUntil(6)
    c.LeftUntil(24)
    c.UntilDig('Left', 'B')
    c.Assert(c.WalkOverEnemy('Left'))
    c.GrabLadderLeft()
    c.ClimbUntil(1)

    c.BestOf({
        function()
            c.RightUntil(24)
            c.PushDown()
            c.FinishFalling()
            return c.UntilDig('Left', 'B')
        end,
        function()
            c.RightUntil(23)
            c.PushDown()
            c.FinishFalling()
            return c.UntilDig('Right', 'B')
        end,
    })

    c.UntilDig('Right', 'B')
    c.UntilDig('Right', 'B')
    c.FallLeft()

    c.LeftFor(1)
    c.UntilDig('Left', 'B')
    c.UntilDig('Right', 'B')
    c.FallLeft()
    c.UntilDig('Left', 'B')
    c.FallLeft()

    c.WaitFor(2) -- Manip enemy spawn to be 20
    c.UntilDig('Left', 'B')
    c.FallLeft()
    c.LeftUntil(20)

    c.Assert(c.FrameSearch(function()
        c.FallLeft()
        c.LeftUntil(11)
        return c.Enemy(2).yPos() < 7
    end))

    c.LeftUntil(3)

    c.GrabLadderLeft()
    c.ClimbUntil(10)
    c.RightUntil(7)
    c.UntilDig('Right', 'A')
    c.Assert(c.WalkOverEnemy('Right'))
    c.GrabLadderRight()
    c.ClimbUntil(9)
    c.PushUp() -- Depending on lag this might need 2 pushes

    c.Assert(c.FrameSearch(function()
        local result = c.ClimbUntil(8)
        if not result then return false end
        return c.LeftFor(5)
    end))

    c.GrabLadderLeft()
    c.ClimbUntil(6)
    c.RightFor(5)
    c.GrabLadderRight()
    c.ClimbUntil(4)
    c.LeftFor(5)
    c.GrabLadderLeft()
    c.ClimbUntil(2)
    c.RightFor(5)
    c.GrabLadderRight()
    c.ClimbUntilLevelEnd()

    c.Marker('lv 40 end')

    c.Done()
end

c.Finish()
