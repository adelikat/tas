-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 36 then
    error('must be run in level 36')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.UntilGoldRight()
    c.GrabLadderLeft()
    c.ClimbUntil(11)
    c.GrabAndClimbOneRight()
    c.GrabAndClimbOneLeft()
    c.Assert(c.UntilGoldLeft())
    c.UntilGoldLeft()
    c.RightUntil(5)

    c.Assert(c.FrameSearch(function()
        c.FallRight()
        c.UntilDig('Left', 'A')
        return not c.Enemy(1).hasGold()
    end, 30))

    c.UntilGoldLeft()
    c.UntilGoldLeft()
    c.RightUntil(5)

    c.Assert(c.FrameSearch(function()
        local result = c.GrabLadderRight()
        if not result then return false end
        c.GrabAndClimbOneRight()
        c.GrabAndClimbOneLeft()
        c.GrabAndClimbOneRight()
        c.GrabAndClimbOneLeft()
        return c.Enemy(3).levelX < 15
    end))

    c.GrabAndClimbOneRight()
    c.GrabAndClimbOneLeft()
    c.GrabAndClimbOneRight()
    c.GrabAndClimbOneLeft()
    c.GrabAndClimbOneRight()
    c.ClimbUntil(1)
    c.UntilGoldLeft()
    c.FallRight()
    c.RightUntil(16)

    c.GrabAndClimbOneRight()
    c.ClimbUntil(5)
    c.RightFor(5)
    c.GrabLadderRight()
    c.ClimbUntil(4)
    c.GrabAndClimbOneLeft()
    c.GrabAndClimbOneRight()
    c.GrabAndClimbOneLeft()
    c.ClimbUntil(1)
    c.UntilGoldLeft()
    c.GrabLadderRight('Down')
    c.ClimbUntil(3)
    c.FinishFalling()

    c.BestOf({
        function()
            c.FallLeft()
            c.PushDown()
            c.FinishFalling()
            c.LeftFor(1)
            return c.LeftUntil(24)
        end,
        function()
            c.ClimbUntil(5)
            c.LeftUntil(25)
            c.PushDown()
            c.FinishFalling()
            c.LeftFor(1)
            return c.LeftUntil(24)
        end,
        function()
            c.ClimbUntil(5)
            c.FinishFalling()
            c.ClimbUntil(7)
            c.FinishFalling()
            c.UntilGoldLeft()
            return c.LeftUntil(24)
        end,
    })

    c.UntilDig('Left', 'B')
    c.UntilDig('Right', 'B')
    c.FallLeft()
    c.UntilDig('Left', 'A')
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.UntilDig('Right', 'A')
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.UntilDig('Right', 'A')
    c.UntilDig('Left', 'A')
    c.UntilGoldRight()
    c.UntilGoldRight()
    c.LeftUntil(22)

    c.BestOf({
        function()
            c.FallLeft()
            return c.GrabAndClimbOneLeft()
        end,
        function()
            c.LeftUntil(21)
            c.PushDown()
            c.FinishFalling()
            return c.GrabAndClimbOneLeft()
        end
    })

    c.GrabAndClimbOneLeft()
    c.ClimbUntilGold('Right')
    c.GrabAndClimbOneRight()
    c.GrabAndClimbOneLeft()
    c.GrabAndClimbOneRight()
    c.GrabAndClimbOneLeft()
    c.GrabAndClimbOneRight()
    c.GrabAndClimbOneLeft()
    c.GrabAndClimbOneRight()
    c.GrabAndClimbOneLeft()
    c.ClimbUntil(1)
    c.UntilGoldLeft()
    c.GrabLadderRight()
    c.ClimbUntilLevelEnd()

    c.Marker('lv 36 end')

    c.Done()
end

c.Finish()
