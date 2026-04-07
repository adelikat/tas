-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 28 then
    error('must be run in level 28')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.RightUntil(25)
    c.GrabLadderRight()
    c.ClimbUntil(11)

    c.Assert(c.FrameSearch(function()
        local result =  c.ClimbUntil(10)
        if not result then return false end
        c.PushUp()
        return c.Player().isAlive
    end))

    c.Assert(c.FrameSearch(function() return c.ClimbUntil(3) end))

    c.LeftFor(3)
    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.FallLeft()
    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.LeftFor(2)

    c.BestOf({
        function()
            c.PushDown()
            return c.LeftUntil(5)
        end,
        function()
            c.LeftFor(1)
            c.PushDown()
            return c.LeftUntil(5)
        end,
        function()
            c.LeftFor(2)
            c.PushDown()
            return c.LeftUntil(5)
        end,
    })

    c.LeftUntil(1)
    c.UntilDig('Left', 'B')
    c.FallLeft()
    c.RightFor(1)

    c.Assert(c.FrameSearch(function()
        c.PushDown()
        c.FinishFalling()
        c.UntilDig('Left', 'B')
        c.UntilDig('Right', 'B')
        c.FallLeft()
        c.UntilDig('Left', 'A')
        c.FallRight()

        return not c.Enemy(2).hasGold()
    end))

    c.GrabLadderRight()
    c.ClimbUntil(5)
    c.LeftFor(2)
    c.PushDown()
    c.FinishFalling()

    c.FallRight()
    c.UntilDig('Right', 'A')
    c.RightUntil(20)
    c.UntilDig('Right', 'A')
    c.Assert(c.WalkOverEnemy('Right'))
    c.RightUntil(25)
    c.GrabLadderRight()
    c.ClimbUntil(3)
    c.LeftFor(1)
    c.UntilDig('Left', 'B')
    c.UntilDig('Right', 'B')
    c.FallLeft()
    c.UntilDig('Left', 'B')
    c.UntilDig('Right', 'B')
    c.FallLeft()
    c.UntilDig('Left', 'B')
    c.UntilDig('Right', 'B')
    c.FallLeft()
    c.UntilDig('Left', 'B')
    c.FallLeft()
    c.GrabLadderLeft()

    c.ClimbUntil(5)
    c.LeftUntil(17)
    c.UntilDig('Right', 'A')
    c.ClimbUntil(3)
    c.UntilGoldLeft()

    c.Assert(c.FrameSearch(function()
        c.FallRight()
        c.UntilDig('Left', 'B')
        c.FallLeft()
        c.GrabLadderRight('Down')
        c.ClimbUntil(11)
        c.RightUntil(25)
        local result = c.GrabLadderRight()
        if not result then return false end
        return c.ClimbUntil(11)
    end))

    c.Assert(c.FrameSearch(function()
        local result = c.ClimbUntil(10)
        if not result then return false end
        c.PushUp()
        return c.Player().isAlive
    end))

    c.Assert(c.FrameSearch(function() return c.ClimbUntil(3) end))
    c.LeftFor(3)
    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.LeftFor(3)
    c.GrabLadderLeft()
    c.ClimbUntilLevelEnd()

    c.Marker('lv 28 end')

    c.Done()
end

c.Finish()
