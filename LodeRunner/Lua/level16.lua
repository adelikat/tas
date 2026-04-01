-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 16 then
    error('must be run in level 16')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.LeftUntil(1)
    c.UntilDig('Left', 'A')

    c.FallRight()
    c.RightUntil(6)
    c.UntilDig('Right', 'A')

    c.Assert(c.FrameSearch(function() return c.RightFor(2) end))
    c.GrabLadderRight()
    c.ClimbUntil(4)
    c.GrabLadderLeft()
    c.ClimbUntil(3)
    c.LeftFor(1)
    c.GrabLadderLeft()
    c.ClimbUntil(2)
    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.LeftUntil(5)
    c.UntilDig('Left', 'B')

    c.WaitFor(10) -- This is a long wait
    c.Assert(c.FrameSearch(function()
        c.FallLeft()
        c.RightUntil(8)
        c.FallRight()
        local result = c.GrabLadderRight()
        if not result then return false end
        return c.ClimbUntil(4)
    end))

    c.GrabLadderLeft()
    c.ClimbUntil(3)
    c.LeftFor(1)
    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.RightFor(2)

    c.BestOf({
        function()
            c.FallRight()
            c.RightUntil(24)
            return c.UntilDig('Right', 'A')
        end,
        function()
            c.GrabLadderRight('Down')
            c.ClimbUntil(2)
            c.FallRight()
            c.RightUntil(24)
            return c.UntilDig('Right', 'A')
        end,
        function()
            c.GrabLadderRight('Down')
            c.ClimbUntil(10)
            c.RightUntil(24)
            return c.UntilDig('Right', 'A')
        end,
        function()
            c.GrabLadderRight('Down')
            c.ClimbUntil(3)
            c.FallRight()
            c.RightUntil(24)
            return c.UntilDig('Right', 'A')
        end
    })

    c.FallRight()

    c.BestOf({
        function()
            c.ClimbUntil(12)
            c.LeftFor(5)
            c.UntilGoldLeft()
            c.UntilGoldLeft()
            return c.GrabLadderRight()
        end,
        function()
            c.ClimbUntil(13)
            c.LeftFor(5)
            c.UntilGoldLeft()
            c.UntilGoldLeft()
            return c.GrabLadderRight()
        end,
    })

    c.ClimbUntil(11)
    c.GrabLadderRight()

    c.ClimbUntil(9)
    c.GrabLadderLeft()
    c.ClimbUntil(8)
    c.GrabLadderLeft()
    c.ClimbUntil(7)
    c.GrabLadderLeft()
    c.ClimbUntil(6)
    c.GrabLadderLeft()
    c.ClimbUntil(5)
    c.GrabLadderLeft()

    c.ClimbUntil(4)
    c.GrabLadderRight()
    c.ClimbUntil(3)
    c.GrabLadderRight()
    c.ClimbUntil(2)
    c.GrabLadderRight()
    c.ClimbUntil(1)
    c.GrabLadderRight()
    c.ClimbUntilLevelEnd()

    c.Marker('lv 16 end')

    c.Done()
end

c.Finish()
