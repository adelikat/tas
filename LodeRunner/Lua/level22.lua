-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 22 then
    error('must be run in level 22')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

-- Needs very specific timing to get E3 to pick up and drop gold before climbing down the ladder
while not c.IsDone() do
    c.GrabLadderRight()
    c.ClimbUntil(11)
    c.GrabLadderLeft()

    --specific hardcoded input for this specific timing and spawn timer
    c.WaitFor(1)
    c.PushUp(1)
    c.WaitFor(2)

    c.UntilGoldLeft()
    c.GrabLadderRight()
    c.ClimbUntil(10)
    c.WaitFor(1)
    c.ClimbUntil(11)
    c.FallRight()
    c.UntilGoldRight()
    ----------------------

    c.GrabLadderRight()
    c.ClimbUntil(10)
    c.RightUntil(21)
    c.GrabLadderRight('Down')
    c.ClimbUntil(11)
    c.UntilGoldRight()
    c.GrabLadderLeft()
    c.ClimbUntil(13)
    c.LeftUntil(18)
    c.GrabLadderLeft()
    c.ClimbUntil(10)

    c.RightUntil(21)
    c.GrabLadderRight()
    c.ClimbUntil(9)
    c.GrabLadderRight()

    c.BestSearch(function()
        c.ClimbUntil(7)
        c.UntilGoldLeft()
        c.GrabLadderLeft('Down')
        c.ClimbUntil(8)
        c.UntilGoldLeft()
        c.RightUntil(17)

        return c.FrameSearch(function()
            local result = c.ClimbUntil(7)
            if not result then return false end
            result = c.LeftFor(1)
            if not result then return false end
            result = c.GrabLadderLeft()
            if not result then return false end
            result = c.ClimbUntil(6)
            if not result then return false end
            result = c.GrabLadderLeft()
            if not result then return false end
            return c.ClimbUntil(3)
        end)
    end, 5)

    c.RightUntil(16)
    c.GrabLadderRight()
    c.ClimbUntil(1)
    c.FallLeft()
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.RightUntil(3)

    c.WaitFor(10) -- this is a long wait
    c.Assert(c.FrameSearch(function()
        c.ClimbUntil(6)
        c.RightFor(2)
        c.GrabLadderRight()
        local result = c.ClimbUntil(3)
        if not result then return false end
        result = c.RightUntil(16)
        if not result then return false end
        return c.GrabLadderRight('Down')
    end, 50))

    c.ClimbUntil(4)
    c.UntilGoldRight()
    c.UntilGoldRight()
    c.GrabLadderRight()
    c.ClimbUntilLevelEnd()

    c.Marker('lv 22 end')

    c.Done()
end

c.Finish()
