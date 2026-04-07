-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 27 then
    error('must be run in level 27')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.LeftFor(2)
    c.UntilDig('Left', 'B')
    c.FallLeft()
    c.Assert(c.FrameSearch(c.GrabLadderRight))
    c.ClimbUntil(1)
    c.RightFor(1)
    c.UntilDig('Right', 'A')

    c.Assert(c.FrameSearch(function()
        local result = c.FallRight()
        if not result then return false end
        result = c.GrabLadderLeft('Down')
        if not result then return false end
        return c.ClimbUntil(6)
    end))

    c.Assert(c.FrameSearch(function()
        return c.ClimbUntil(1)
    end))

    c.Assert(c.FrameSearch(function()
        return c.RightUntil(12)
    end))

    c.PushDown()
    c.FinishFalling()
    c.UntilDig('Left', 'B')
    c.FallLeft()

    c.GrabLadderLeft('Down')
    c.ClimbUntil(6)

    c.ClimbUntil(7)

    c.WaitFor(2) -- Hardcoded, we have  almost no window here because all 3 enemies must behave in a specific way, need a good starting spawn timer
    c.LeftFor(1)
    c.UntilDig('Left', 'B')

    c.Assert(c.FrameSearch(function()
        c.FallLeft()
        c.UntilDig('Left', 'B')
        return c.Enemy(3).yPos() >= 2
    end))

    c.FallLeft()
    c.GrabLadderLeft()
    c.ClimbUntil(7)

    c.Assert(c.FrameSearch(function() return c.RightUntil(4) end))
    c.GrabLadderRight('Down')
    c.ClimbUntil(9)

    c.Assert(c.FrameSearch(function()
        c.ClimbUntil(6)
        return c.Enemy(1).yPos() >= 8 and c.Enemy(2).yPos() >= 8
    end))

    -- What is subtle here is how E3 is manipulated.  We stay at Y = 6 for as long as possible which happens to be at least enough time for E3 to grab the bottom right ladder
    c.Assert(c.FrameSearch(function()
        c.ClimbUntil(7)
        local result = c.RightUntil(8)
        return result
    end))

    c.UntilDig('Right', 'A')
    c.FallRight()
    c.GrabLadderRight()
    c.ClimbUntil(7)

    c.FallRight()
    c.UntilDig('Right', 'B')
    c.FallLeft()
    c.GrabLadderLeft()
    c.ClimbUntil(7)
    c.RightFor(1)
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.GrabLadderLeft()
    c.ClimbUntilGold('Right')
    c.UntilGoldRight() -- This is necessary because the previous didn't actually get the gold
    c.UntilGoldRight()
    c.GrabLadderLeft('Down')
    c.ClimbUntil(7)
    c.RightFor(1)
    c.Assert(c.WalkOverEnemy('Right'))
    c.FallRight()
    c.FallRight()

    c.GrabLadderRight()
    c.ClimbUntil(1)
    c.RightFor(2)
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.Assert(c.FrameSearch(function()
        local result = c.FallRight()
        if not result then return false end
        return c.FallLeft()
    end))

    c.UntilDig('Left', 'A')
    c.FallRight()
    c.GrabLadderRight()
    c.ClimbUntil(11)

    c.Assert(c.FrameSearch(function()
        local result = c.ClimbUntil(8)
        if not result then return false end

        if c.Enemy(3).levelX >= 26 then
            return false
        end

        result = c.ClimbUntil(7)
        if not result then return false end

        return c.Enemy(3).levelY == 8
    end))

    c.ClimbUntilGold('Left')
    c.FallLeft()
    c.LeftUntil(22)
    c.FinishFalling()
    c.GrabLadderLeft()

    c.ClimbUntil(1)
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.GrabLadderLeft()
    c.ClimbUntil(6)
    c.UntilGoldLeft()
    c.GrabLadderRight()
    c.ClimbUntil(3)
    c.UntilGoldLeft()
    c.GrabLadderRight()
    c.ClimbUntil(1)
     c.FallRight()
    c.GrabLadderRight()
    c.ClimbUntilLevelEnd()

    c.Marker('lv 27 end')

    c.Done()
end

c.Finish()
