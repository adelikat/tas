-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 11 then
    error('must be run in level 11')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.BestOf({
        function()
            c.LeftUntil(2)
            return c.GrabLadderLeft()
        end,
        function()
            c.GrabLadderLeft('Down')
            c.ClimbUntil(13)
            c.GrabLadderLeft()
        end,
    })
    c.ClimbUntil(1)
    c.UntilGoldRight()

    c.Assert(c.FrameSearch(function()
        c.FallRight()
        c.UntilDig('Right', 'A')
        return c.Player().isAlive
    end))

    c.FrameSearch(function() return c.RightFor(2) end)

    c.RightUntil(10)
    c.UntilDig('Right', 'A')

    c.WaitFor(2) -- Manip enemy dying and getting favorable spawn
    c.UntilDig('Left', 'A')

    c.UntilDig('Left', 'B')
    c.FrameSearch(function() return c.RightFor(3) end)
    c.UntilGoldRight()

    c.UntilDig('Right', 'B')
    c.FrameSearch(function() return c.LeftFor(2) end)

    c.ClimbUntil(11)
    c.UntilGoldLeft()

    c.GrabLadderRight()
    c.ClimbUntil(10)
    c.UntilGoldRight()

    c.GrabLadderLeft()
    c.ClimbUntil(9)
    c.UntilGoldLeft()

    c.GrabLadderRight()
    c.ClimbUntil(8)
    c.UntilGoldRight()

    c.GrabLadderLeft()
    c.ClimbUntil(7)
    c.UntilGoldLeft()

    c.GrabLadderRight()
    c.ClimbUntil(6)
    c.UntilGoldRight()

    c.GrabLadderLeft()
    c.ClimbUntil(5)
    c.UntilGoldLeft()

    c.GrabLadderRight()
    c.ClimbUntil(4)
    c.UntilGoldRight()

    c.GrabLadderLeft()
    c.ClimbUntil(3)
    c.GrabLadderLeft()

    c.ClimbUntil(2)
    c.LeftFor(1)
    c.GrabLadderLeft()
    c.ClimbUntilLevelEnd()

    c.Marker('lv 11 end')

    c.Done()
end

c.Finish()
