-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 29 then
    error('must be run in level 29')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.FallLeft()
    c.GrabLadderLeft()
    c.ClimbUntil(6)
    c.LeftFor(2)
    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.LeftUntil(3)
    c.UntilDig('Left', 'B')
    c.UntilDig('Right', 'B')
    c.FallLeft()
    c.UntilDig('Left', 'B')
    c.FallLeft()
    c.UntilDig('Left', 'A')
    c.FallRight()

    c.RightFor(1)
    c.UntilDig('Right', 'B')
    c.ClimbUntil(10)
    c.UntilDig('Left', 'B')
    c.FallLeft()
    c.UntilGoldLeft()
    c.FallRight()
    c.RightFor(1)

    c.Assert(c.FrameSearch(function()
        local result = c.FallRight()
        if not result then return false end
        c.RightFor(1)
        result = c.GrabLadderRight()
        if not result then return false end
        return c.ClimbUntil(6)
    end))

    c.LeftUntil(7)

    c.Assert(c.BestSearch(function()
        c.PushDown()
        c.FinishFalling()
        c.UntilDig('Right', 'A')
        c.UntilDig('Left', 'A')
        c.FallRight()
        c.UntilDig('Right', 'B')
        c.FallLeft()
        c.UntilDig('Left', 'A')
        c.FallRight()

        local result =  c.RightUntil(16)
        if not result then return false end

        c.GrabLadderRight()
        c.ClimbUntil(10)
        c.GrabLadderRight()
        c.ClimbUntil(4)
        local result = c.RightUntil(22)
        if not result then return false end
        result = c.UntilDig('Right', 'A')
        if not result then return false end

        result = c.ClimbUntil(5)
        if not result then return false end
        c.UntilDig('Right', 'A')
        c.FallRight()
        c.UntilGoldRight()
        c.FallLeft()
        c.LeftFor(1)
        c.UntilDig('Left', 'A')
        c.FallRight()
        c.UntilDig('Right', 'B')
        c.FallLeft()
        c.LeftFor(2)
        c.GrabLadderLeft()
        result = c.ClimbUntil(10)
        if not result then return false end
        c.GrabLadderRight()
        result = c.ClimbUntil(4)
        if not result then return false end
        c.RightFor(1)
        c.GrabLadderRight()
        result = c.ClimbUntil(1)
        if not result then return false end

        c.FallLeft()
        c.UntilDig('Left', 'A')
        c.UntilDig('Left', 'A')
        c.UntilDig('Left', 'A')
        c.UntilDig('Left', 'A')
        c.FallRight()
        c.UntilDig('Right', 'B')
        c.UntilDig('Right', 'B')
        c.UntilDig('Right', 'B')
        c.FallLeft()
        c.UntilDig('Left', 'A')
        c.UntilDig('Left', 'A')
        c.FallRight()
        c.UntilDig('Right', 'B')
        c.FallLeft()

        c.BestOf({
            function()
                c.UntilDig('Left', 'A')
                c.UntilGoldLeft()
                c.FallRight()
                c.FallRight()
                return c.GrabLadderRight()
            end,
            function()
                c.LeftFor(2)
                c.UntilDig('Left', 'A')
                c.FallRight()
                c.FallRight()
                return c.GrabLadderRight()
            end,
        })

        c.ClimbUntil(10)
        c.RightFor(1)
        c.GrabLadderRight()
        c.ClimbUntil(4)
        c.GrabLadderRight()
        c.ClimbUntil(1)
        c.LeftFor(1)
        c.FallLeft()
        c.LeftFor(1)
        c.GrabLadderLeft()
        return c.ClimbUntilLevelEnd()
    end, 20))

    c.Marker('lv 29 end')

    c.Done()
end

c.Finish()
