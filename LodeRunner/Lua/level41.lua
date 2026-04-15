-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 41 then
    error('must be run in level 41')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.GrabAndClimbOneRight()
    c.RightUntil(5)
    c.PushDown()
    c.FinishFalling()
    c.FallLeft()
    c.FallLeft()
    c.RightUntil(8)
    c.GrabAndClimbOneRight()
    c.ClimbUntilGold('Right')
    c.GrabAndClimbOneRight()
    c.ClimbUntilGold('Right')
    c.GrabAndClimbOneRight()
    c.ClimbUntilGold('Right')
    c.GrabAndClimbOneRight()
    c.ClimbUntilGold('Right')
    c.FallRight()
    c.RightUntil(19)

    c.Assert(c.FrameSearch(function()
        local result = c.ClimbUntil(9)
        if not result then return false end
        result = c.UntilGoldLeft()
        if not result then return false end
        result = c.UntilGoldLeft()
        if not result then return false end
        return c.FallRight()
    end))

    c.RightUntil(25)
    c.GrabLadderRight()

    c.ClimbUntil(5)

    c.GrabAndClimbOneLeft()
    c.GrabAndClimbOneLeft()
    c.GrabAndClimbOneLeft()
    c.GrabAndClimbOneLeft()
    c.RightUntil(27)
    c.PushDown()
    c.FinishFalling()

    c.GrabAndClimbOneLeft()
    c.GrabAndClimbOneLeft()
    c.GrabAndClimbOneLeft()
    c.GrabAndClimbOneLeft()
    c.RightUntil(26)
    c.PushDown()
    c.FinishFalling()

    c.GrabAndClimbOneLeft()
    c.GrabAndClimbOneLeft()
    c.GrabAndClimbOneLeft()
    c.GrabAndClimbOneLeft()
    c.RightUntil(25)
    c.PushDown()
    c.FinishFalling()

    c.ClimbUntil(6)
    c.FinishFalling()
    c.PushDown()
    c.FinishFalling()

    c.LeftUntil(23)
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

    c.GrabLadderRight()
    c.ClimbUntil(5)
    c.LeftFor(1)
    c.GrabAndClimbOneLeft()
    c.GrabAndClimbOneLeft()
    c.LeftUntil(23)
    c.UntilDig('Left', 'B')
    c.FallLeft()
    c.FallLeft()

    c.UntilGoldLeft()
    c.UntilGoldLeft()
    c.RightUntil(19)
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.RightUntil(25)
    c.GrabLadderRight()
    c.ClimbUntil(5)
    c.LeftFor(1)
    c.GrabAndClimbOneLeft()
    c.GrabAndClimbOneLeft()
    c.GrabAndClimbOneLeft()
    c.GrabAndClimbOneLeft()
    c.LeftUntil(7)
    c.PushDown()
    c.FinishFalling()
    c.FallRight()
    c.FallRight()
    c.FallRight()
    c.RightFor(1)
    c.GrabAndClimbOneRight()
    c.GrabAndClimbOneRight()
    c.GrabAndClimbOneRight()
    c.GrabAndClimbOneRight()
    c.LeftUntil(4)

    c.GrabLadderLeft('Down')
    c.GrabLadderLeft('Down')
    c.UntilGoldLeft()
    c.GrabLadderLeft()
    c.ClimbUntilLevelEnd()

    c.Marker('lv 41 end')

    c.Done()
end

c.Finish()
