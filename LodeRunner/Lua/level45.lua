-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 45 then
    error('must be run in level 45')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.FallLeft() -- Climbing down 1 is same number of frames
    c.UntilDig('Left', 'A')
    c.LeftUntil(2)
    c.PushDown()
    c.FinishFalling()
    c.GrabLadderLeft()
    c.ClimbUntil(9)
    c.RightFor(2)
    c.GrabLadderRight()

    c.ClimbUntil(8)
    c.RightFor(2)
    c.GrabLadderRight()
    c.ClimbUntil(4)
    c.ClimbUntilGold('Left')

    c.FallLeft()
    c.LeftUntil(9)
    c.PushDown()
    c.FinishFalling()
    c.RightUntil(14)
    c.UntilDig('Right', 'A')

    c.FallRight()
    c.RightUntil(17)
    c.GrabLadderRight()
    c.ClimbUntil(6)

    c.WaitFor(1) -- Manip E3 spawn, only 1 frame window later, delaying here costs time
    c.FallRight()

    c.WaitFor(1) -- Manip E3 spawn to be on left, small window to do this
    c.UntilDig('Right', 'A')
    c.Assert(c.FrameSearch(function()
        c.FallRight()
        c.UntilDig('Left', 'B')
        return c.Enemy(3).levelX < 24
    end))

    c.FallLeft()
    c.LeftFor(2)
    c.GrabLadderLeft()
    c.ClimbUntil(6)
    c.RightUntil(20)
    c.PushDown()
    c.FinishFalling()
    c.GrabLadderLeft()
    c.ClimbUntil(6)
    c.FallRight()
    c.FallRight()
    c.GrabLadderRight()
    c.ClimbUntil(6)

    c.GrabAndClimbOneLeft()
    c.ClimbUntil(4)
    c.LeftFor(5)
    c.GrabLadderLeft()
    c.ClimbUntil(2)
    c.UntilGoldRight()
    c.LeftUntil(17)
    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.LeftUntil(14)
    c.PushDown()
    c.FinishFalling()
    c.RightUntil(15)
    c.PushDown()
    c.FinishFalling()
    c.LeftFor(2)
    c.GrabLadderLeft()
    c.ClimbUntil(5)
    c.FallLeft()
    c.GrabLadderRight()
    c.ClimbUntil(4)
    c.LeftFor(2)
    c.GrabLadderLeft()
    c.ClimbUntil(2)
    c.FallLeft()
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.FallRight()
    c.GrabLadderRight()
    c.ClimbUntil(8)
    c.RightUntil(9)
    c.GrabLadderRight()
    c.ClimbUntil(4)
    c.LeftFor(2)
    c.GrabLadderLeft()
    c.ClimbUntilLevelEnd()

    c.Marker('lv 45 end')

    c.Done()
end

c.Finish()
