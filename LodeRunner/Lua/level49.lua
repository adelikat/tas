-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 49 then
    error('must be run in level 49')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.WaitFor(16)
    c.FallLeft()
    c.UntilDig('Right', 'B')
    c.FallLeft()
    c.LeftFor(2)
    c.GrabLadderLeft()
    c.ClimbUntil(8)
    c.RightUntil(4)
    c.WalkOverEnemy('Right') -- It is a pit, but it works
    c.RightUntil(10)
    c.UntilDig('Right', 'A')
    c.ClimbUntil(9)
    c.UntilDig('Right', 'A')
    c.ClimbUntil(10)
    c.UntilDig('Right', 'A')

    c.ClimbUntil(8)
    c.UntilGoldRight()

    c.LeftUntil(12)
    c.GrabLadderLeft('Down')

    c.BestOf({
        function()
            c.ClimbUntil(12)
            c.UntilGoldLeft()
            c.UntilGoldLeft()
            return c.GrabLadderRight()
        end,
        function()
            c.ClimbUntil(11)
            c.FallLeft()
            c.UntilGoldLeft()
            c.UntilGoldLeft()
            return c.GrabLadderRight()
        end,
    })

    c.ClimbUntil(11)
    c.Assert(c.FallRight())

    c.GrabLadderRight()
    c.ClimbUntil(11)

    c.Assert(c.FrameSearch(function()
        c.ClimbUntil(12)

        c.Save('49-temp')

        c.WaitFor(10)

        local e1 = c.Enemy(1)
        local e2 = c.Enemy(2)
        local result = e1.levelX == 19 and e1.levelY == 12
        and e2.levelX == 18 and e2.levelY == 12

        c.Load('49-temp')
        return result
    end))

    c.Assert(c.FrameSearch(function()
        c.ClimbUntil(11)
        return c.GrabLadderRight()
    end))

    c.ClimbUntil(1)
    c.UntilGoldRight()
    c.UntilGoldRight()
    c.GrabLadderLeft('Down')
    c.ClimbUntil(3)
    c.RightFor(3)
    c.GrabLadderRight('Down')
    c.ClimbUntil(7)
    c.FinishFalling()
    c.LeftFor(2)
    c.GrabLadderLeft()
    c.ClimbUntil(5)
    c.FallRight()
    c.PushDown()
    c.FinishFalling()
    c.LeftUntil(24)
    c.UntilDig('Left', 'B')
    c.FallLeft()
    c.UntilDig('Left', 'A')
    c.UntilDig('Left', 'A')

    c.BestOf({
        function()
            c.FallRight()
            c.UntilGoldRight()
            c.UntilGoldRight()
            c.LeftFor(2)
            return c.GrabLadderLeft()
        end,
        function()
            c.ClimbUntil(12)
            c.UntilGoldRight()
            c.UntilGoldRight()
            c.LeftFor(2)
            return c.GrabLadderLeft()
        end,
    })

    c.LeftUntil(18)
    c.UntilDig('Left', 'B')
    c.RightUntil(19)
    c.UntilDig('Right', 'A')

    c.Assert(c.FrameSearch(function()
        c.PushDown()
        if not c.Player().isAlive then return false end
        if not c.FinishFalling() then return false end
        if not c.GrabLadderRight() then return false end
        if not c.ClimbUntil(8) then return false end
        if not c.UntilGoldLeft() then return false end
        if not c.GrabLadderRight() then return false end
        if not c.ClimbUntil(6) then return false end
        if not c.UntilGoldLeft() then return false end
        if not c.GrabLadderRight() then return false end
        if not c.ClimbUntil(1) then return false end
        return true
    end))

    c.LeftUntil(15)
    c.FinishFalling()
    c.GrabLadderLeft()
    c.ClimbUntil(5)
    c.LeftUntil(3)
    c.UntilGoldLeft()
    c.RightFor(5)
    c.GrabLadderRight()
    c.ClimbUntilLevelEnd()

    c.Marker('lv 49 end')

    c.Done()
end

c.Finish()
