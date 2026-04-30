-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 50 then
    error('must be run in level 50')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.UntilGoldLeft()
    c.RightUntil(11)
    c.GrabLadderRight()
    c.ClimbUntil(11)

    c.Assert(c.FrameSearch(function()
        if not c.ClimbUntil(10) then return false end
        if not c.LeftFor(1) then return false end
        if not c.GrabLadderLeft() then return false end
        return true
    end))

    c.ClimbUntil(8)
    c.WaitFor(1) -- This delay manips enemy position to save about 20 frames of lag later in the level

    c.ClimbUntil(7)
    c.LeftFor(2)
    c.GrabLadderLeft()
    c.ClimbUntil(6)
    c.GrabAndClimbOneLeft()
    c.ClimbUntil(2)
    c.FallRight()
    c.RightFor(5)
    c.GrabLadderRight()
    c.ClimbUntil(2)
    c.FallRight()

    c.RightFor(2)
    c.GrabAndClimbOneRight()
    c.GrabAndClimbOneLeft()
    c.GrabAndClimbOneLeft()
    c.GrabAndClimbOneLeft()
    c.ClimbUntil(1)
    c.GrabLadderRight('Down') -- Falling from pole but it works
    c.UntilDig('Right', 'B')
    c.UntilGoldRight()
    c.FallLeft()

    c.ClimbUntil(6)
    c.FinishFalling()
    c.PushDown()
    c.FinishFalling()
    c.UntilDig('Right', 'B')
    c.FallLeft()
    c.UntilGoldRight()
    c.LeftUntil(23)
    c.UntilDig('Left', 'A')
    c.ClimbUntil(11)
    c.FinishFalling()
    c.UntilDig('Left', 'A')
    c.Assert(c.FrameSearch(c.UntilGoldRight))
    c.LeftFor(2)

    c.FallLeft()
    c.GrabLadderLeft()

    c.ClimbUntil(11)

    c.WaitFor(8)
    c.Assert(c.FrameSearch(function()
        if not c.ClimbUntil(10) then return false end
        if not c.LeftFor(1) then return false end
        if not c.GrabLadderLeft() then return false end
        return true
    end))

    c.ClimbUntilGold('Left')
    c.LeftFor(2)
    c.GrabLadderLeft()
    c.ClimbUntil(6)
    c.GrabAndClimbOneLeft()
    c.ClimbUntil(2)
    c.UntilGoldRight()
    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.FallLeft()
    c.LeftFor(1)
    c.GrabLadderLeft()
    c.ClimbUntil(3)
    c.UntilGoldRight()
    c.GrabLadderLeft()
    c.ClimbUntilLevelEnd()

    c.Done()
end

c.Finish()
