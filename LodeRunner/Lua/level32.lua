-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 32 then
    error('must be run in level 32')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.GrabLadderLeft()
    c.ClimbUntil(2)
    c.RightFor(1)
    c.GrabLadderRight()
    c.ClimbUntil(1)
    c.RightUntil(6)
    c.ClimbUntil(3)
    c.FinishFalling()
    c.LeftUntil(2)
    c.UntilDig('Left', 'A')
    c.BestOf({
        c.UntilGoldRight,
        function()
            c.ClimbUntil(12)
            return c.UntilGoldRight()
        end,
    })
    c.LeftFor(2)
    c.GrabLadderLeft()
    c.ClimbUntil(5)
    c.GrabLadderLeft()
    c.ClimbUntil(2)
    c.RightFor(1)
    c.GrabLadderRight()
    c.ClimbUntil(1)
    c.RightFor(4)
    c.GrabLadderRight('Down')
    c.ClimbUntil(5)
    c.UntilGoldRight()
    c.UntilGoldLeft()
    c.GrabLadderRight()
    c.ClimbUntil(4)
    c.LeftUntil(9)
    c.PushDown()
    c.FinishFalling()
    c.UntilDig('Left', 'A')
    c.FallRight()

    c.Assert(c.FrameSearch(function()
        console.log(string.format('%s Loop', emu.framecount()))
        c.UntilDig('Right', 'A')
        c.ClimbUntil(11)
        c.UntilDig('Right', 'A')
        c.ClimbUntil(10)
        while c.Enemy(2).levelY < 8 do
            c.WaitFor(1)
        end

        local result = c.FrameSearch(function()
            local result = c.FallRight()
            if not result then return false end
            result = c.UntilGoldRight()
            if not result then return false end
            result = c.GrabLadderLeft()
            if not result then return false end

            if c.Enemy(2).levelY == 1 and c.Enemy(2).levelX < 7 then
                return true
            end

            return c.Enemy(2).levelX < 14
        end)

        if not result then return false end

        result = c.ClimbUntil(10)
        if not result then return false end
        result = c.RightFor(2)
        if not result then return false end

        return c.GrabLadderRight()
    end, 41))

    -- The gold drop happened to be next ot the ladder, which means we do not have to go out of our way here, but may need to with a different drop
    c.ClimbUntil(7)
    c.UntilGoldLeft()
    c.GrabLadderRight()
    c.ClimbUntil(5)
    c.RightFor(1)
    c.GrabLadderRight()
    c.ClimbUntil(1)
    c.RightUntil(19)
    c.PushDown()
    c.FinishFalling()

    c.RightFor(2)
    c.GrabLadderRight()
    c.ClimbUntil(8)
    c.UntilDig('Right', 'A')
    c.Assert(c.WalkOverEnemy('Right'))
    c.GrabLadderRight()
    c.ClimbUntil(6)
    c.RightUntil(27) -- There may be gold here but if not we need to waste time anyway
    c.PushRight()

    c.GrabLadderLeft()
    c.ClimbUntil(2)
    c.RightFor(1)

    c.Assert(c.FrameSearch(function()
        c.ClimbUntil(1)
        return  c.FrameSearch(function()
            return c.LeftUntil(24)
        end, 30)

    end, 20))

    c.FinishFalling()
    c.UntilDig('Left', 'B')
    c.FallLeft()
    c.FallRight()
    c.ClimbUntil(8)
    c.GrabLadderLeft('Down')
    c.ClimbUntil(11)
    c.UntilDig('Left', 'B')

    c.BestOf({
        function()
            c.LeftFor(3)
            return c.GrabLadderLeft()
        end,
        function()
            c.ClimbUntil(12)
            c.LeftFor(3)
            return c.GrabLadderLeft()
        end,
    })

    c.ClimbUntil(10)
    c.LeftFor(1)
    c.GrabLadderLeft()
    c.ClimbUntil(7)
    c.GrabLadderRight()
    c.ClimbUntil(4)
    c.LeftFor(1)
    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.LeftFor(4)
    c.Assert(c.GrabLadderLeft())
    c.ClimbUntilLevelEnd()

    c.Marker('lv 32 end')

    c.Done()
end

c.Finish()
