dofile('lode-runner-core.lua')

c.Start()

while not c.IsDone() do
    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.RightUntil(25)

    c.WaitFor(1) -- We have to wait anyway at the ladder, might as well use those frames to help with lag, this seems to consisently be better

    c.PushDown()
    c.FinishFalling()
    c.UntilDig('Right', 'A')
    c.UntilDig('Left', 'A')
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.UntilDig('Right', 'B')
    c.UntilDig('Right', 'B')
    c.FallLeft()
    c.UntilDig('Left', 'A')
    c.UntilGoldLeft()
    c.FallRight()
    c.ClimbUntil(11)
    c.GrabLadderLeft()
    c.ClimbUntil(10)
    c.LeftUntil(13)
    c.UntilDig('Left', 'B')
    c.LeftUntil(2)
    c.GrabLadderLeft()

    c.ClimbUntil(1)
    c.RightUntil(13)
    c.PushDown()
    c.FinishFalling()
    c.UntilDig('Right', 'A')
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.UntilDig('Right', 'B')
    c.UntilDig('Right', 'B')
    c.FallLeft()
    c.UntilDig('Left', 'B')
    c.FallLeft()
    c.LeftUntil(13)
    c.UntilDig('Left', 'B')
    c.LeftUntil(2)
    c.GrabLadderLeft()

    c.ClimbUntil(5)

    c.FrameSearch(function()
        c.ClimbUntil(1)
        return c.Enemy(1).yPos() >= 2
    end)

    c.RightUntil(9)

    c.PushDown()
    c.FinishFalling()
    c.UntilDig('Right', 'A')
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.UntilGoldRight()
    c.UntilDig('Left', 'A')
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.UntilDig('Right', 'B')
    c.LeftUntil(2)
    c.GrabLadderLeft()
    c.ClimbUntilLevelEnd()

    c.Marker('lv 9 end')

    c.Done()
end

c.Finish()
