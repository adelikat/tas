-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 37 then
    error('must be run in level 37')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.LeftUntil(3)
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.UntilDig('Left', 'A')
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.UntilGoldRight()
    c.GrabLadderLeft()
    c.ClimbUntil(8)
    c.UntilDig('Right', 'A')
    c.Assert(c.WalkOverEnemy('Right'))
    c.RightUntil(13)
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.GrabLadderRight()
    c.ClimbUntil(7)

    c.BestOf({
        function()
            c.RightUntil(18)
            c.UntilDig('Right', 'A')
            c.FallRight()
            c.FallLeft()
            c.UntilGoldLeft()
            return c.GrabLadderLeft()
        end,
        function()
            c.RightUntil(17)
            c.UntilDig('Right', 'A')
            c.FallRight()
            c.UntilGoldRight()
            c.UntilGoldRight()
            c.FallLeft()
            c.UntilGoldLeft()
            return c.GrabLadderLeft()
        end,
    })

    c.ClimbUntil(8)
    c.RightUntil(13)
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.GrabLadderRight()
    c.ClimbUntil(7)
    c.RightUntil(24)
    c.GrabLadderRight()
    c.ClimbUntil(1)

    c.BestOf({
        function()
            c.LeftUntil(24)
            c.PushDown()
            c.FinishFalling()
            c.FallRight()
            c.GrabLadderRight()
            c.ClimbUntil(1)

            c.LeftUntil(20)
            c.PushDown()
            c.FinishFalling()
            c.FallRight()
            c.GrabLadderRight()
            c.ClimbUntil(1)
            return c.LeftUntil(17)
        end,
        function()
            c.LeftUntil(20)
            c.PushDown()
            c.FinishFalling()
            c.FallRight()
            c.GrabLadderRight()
            c.ClimbUntil(1)

            c.LeftUntil(24)
            c.PushDown()
            c.FinishFalling()
            c.FallRight()
            c.GrabLadderRight()
            c.ClimbUntil(1)

            return c.LeftUntil(17)
        end
    })

    c.LeftUntil(2)
    c.PushDown()
    c.FinishFalling()

    c.GrabLadderRight('Down')
    c.ClimbUntil(3)
    c.GrabLadderRight('Down')
    c.ClimbUntil(4)

    c.BestOf({
        function()
            c.FallRight()
            return c.GrabLadderRight()
        end,
        function()
            c.ClimbUntil(5)
            return c.GrabLadderRight()
        end,
    })

    c.ClimbUntil(3)
    c.GrabLadderRight()
    c.ClimbUntil(2)
    c.RightUntil(13)

    c.BestOf({
         function()
            c.UntilDig('Right', 'A')
            c.UntilDig('Left', 'A')
            c.UntilDig('Left', 'A')
            c.FallRight()
            c.RightFor(1)
            c.UntilDig('Right', 'A')
            c.UntilDig('Left', 'A')
            c.FallRight()
            c.UntilDig('Right', 'B')
            c.FallLeft()
            return c.FallLeft()
        end,
        function()
            c.RightFor(2)
            c.UntilDig('Right', 'B')
            c.UntilDig('Right', 'B')
            c.UntilDig('Right', 'B')
            c.FallLeft()
            c.LeftFor(1)
            c.UntilDig('Left', 'B')
            c.UntilDig('Right', 'B')
            c.FallLeft()
            c.UntilDig('Left', 'B')
            c.FallLeft()
            return c.FallLeft()
        end,
    })
    c.UntilDig('Right', 'A')
    c.FallRight()

    c.GrabLadderRight()
    c.ClimbUntil(7)
    c.RightUntil(20)

    c.BestOf({
        function()
            c.GrabLadderRight()
            c.ClimbUntil(4)
            c.RightFor(2)
            c.GrabLadderRight()
            return c.ClimbUntilLevelEnd()
        end,
        function()
            c.RightUntil(25)
            c.GrabLadderRight()
            return c.ClimbUntilLevelEnd()
        end,
    })

    c.Marker('lv 37 end')

    c.Done()
end

c.Finish()
