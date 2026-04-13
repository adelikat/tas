-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 38 then
    error('must be run in level 38')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.UntilGoldRight()
    c.LeftFor(4)
    c.GrabLadderLeft()

    c.ClimbUntil(9)
    c.RightFor(3)
    c.GrabLadderRight()
    c.ClimbUntil(1)

    c.LeftFor(3)
    c.WaitFor(1)
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
    c.UntilDig('Left', 'A')

    c.FallRight()
    c.GrabLadderRight()
    c.ClimbUntil(1)
    c.FallLeft()

    c.PushBtnsFor({'Down', 'Left'})
    c.ClimbUntil(5)
    c.GrabLadderLeft('Down')
    c.ClimbUntil(6)
    c.FinishFalling()
    c.PushDown()
    c.FinishFalling()

    c.FallRight()
    c.UntilGoldRight()
    c.FallRight()
    c.GrabLadderRight()
    c.ClimbUntil(11)
    c.RightFor(3)
    c.GrabLadderRight()
    c.ClimbUntil(9)
    c.PushUp()
    c.Assert(c.FrameSearch(function()
        return c.ClimbUntil(1)
    end))

    c.FallLeft()
    c.GrabLadderLeft('Down')
    c.ClimbUntil(5)

    c.LeftUntil(14)
    c.GrabLadderLeft('Down')
    c.ClimbUntil(6)
    c.LeftUntil(13)
    c.PushBtnsFor({'Down', 'Left'}, 4) -- This very specific input is somehow better than built in methods
    c.FinishFalling()
    c.FallLeft()
    c.FallLeft()
    c.FallLeft()
    c.FallLeft()
    c.FallLeft()
    c.GrabLadderLeft('Down')
    c.ClimbUntil(13)
    c.UntilGoldLeft()

    c.RightFor(4)
    c.GrabLadderRight()
    c.ClimbUntil(9)
    c.LeftFor(5)
    c.GrabLadderLeft()
    c.ClimbUntilGold('Right')
    c.RightUntil(3)
    c.UntilDig('Right', 'A')
    c.UntilDig('Left', 'A')
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.RightFor(1)
    c.UntilDig('Right', 'A')
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.UntilDig('Right', 'B')

    c.Assert(c.FrameSearch(function()
        c.FallLeft()
        c.GrabLadderLeft()
        return c.Enemy(3).levelX == 1
    end))

    c.ClimbUntil(1)
    c.FallRight()
    c.GrabLadderRight()
    c.ClimbUntilLevelEnd()

    c.Marker('lv 38 end')

    c.Done()
end

c.Finish()
