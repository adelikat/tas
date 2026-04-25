-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 44 then
    error('must be run in level 44')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.PushBtnsFor({'Left', 'Up'}, 8) -- Causes E2 to lag by a pixel
    c.GrabLadderLeft()
    c.ClimbUntil(10)
    c.GrabLadderLeft()
    c.ClimbUntil(9)
    c.GrabAndClimbOneLeft()
    c.FallLeft()

    c.GrabLadderRight()
    c.ClimbUntil(10)
    c.GrabAndClimbOneRight()
    c.PushRight()
    c.GrabLadderRight()
    c.ClimbUntil(7)
    c.GrabLadderRight()
    c.ClimbUntil(6)
    c.GrabLadderRight()
    c.ClimbUntil(3)
    c.FallRight()
    c.GrabLadderRight()
    c.ClimbUntil(3)
    c.FallRight()

    c.RightFor(1)
    c.GrabLadderRight('Down')
    c.ClimbUntil(8)

    c.Assert(c.FrameSearch(function()
        if not c.ClimbUntil(7) then return false end
        if not c.RightFor(2) then return false end
        return c.ClimbUntil(5)
    end))

    c.RightFor(1) -- Over E3's head
    c.GrabLadderRight()
    c.ClimbUntilGold('Down')
    c.ClimbUntil(5)

    c.RightFor(1)
    c.ClimbUntil(6)
    c.FinishFalling()
    c.GrabLadderRight('Down')
    c.ClimbUntil(8)
    c.FallRight()
        c.LeftUntil(19)
    c.GrabLadderLeft()
    c.ClimbUntil(9)
    c.FallLeft()
    c.GrabLadderRight()
    c.ClimbUntil(9)
    c.FallRight()
    c.LeftUntil(16)
    c.GrabLadderLeft()
    c.ClimbUntil(9)
    c.WaitFor(2)
    c.FallLeft()
    c.LeftUntil(13)
    c.ClimbUntil(13)
    c.LeftUntil(11)

    c.Assert(c.FrameSearch(function()
        return c.ClimbUntil(10)
    end))

    c.ClimbUntilGold('Left')
    c.FallLeft()
    c.GrabLadderLeft()
    c.ClimbUntil(9)
    c.FallLeft()
    c.GrabLadderRight()
    c.ClimbUntilLevelEnd()

    c.Done()
end

c.Finish()
