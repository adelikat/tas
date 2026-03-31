-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 10 then
    error('must be run in level 10')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.GrabLadderRight()
    c.ClimbUntil(9)
    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.UntilGoldLeft()
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.RightFor(1)
    c.UntilDig('Right', 'A')
    c.WaitFor(7) -- optimization
    c.FrameSearch(function() return c.RightFor(2) end)
    --     c.WaitFor(1) -- Manip enemy spawn here, if needed
    c.RightFor(2)
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
    c.UntilDig('Right', 'B')
    c.FallLeft()
    c.UntilDig('Left', 'B')
    c.UntilGoldLeft()
    c.UntilGoldLeft()
    c.UntilGoldLeft()
    c.UntilDig('Right', 'A')
    c.FallRight()

    c.GrabLadderRight()
    c.ClimbUntil(9)
    c.UntilGoldRight()
    c.RightFor(1)
    c.UntilDig('Right', 'A')

    c.FrameSearch(function() return c.RightFor(2) end)

    c.BestOf({
        function()
            c.RightFor(2)
            return c.GrabLadderRight()
        end,
        function()
            c.ClimbUntil(10)
            return c.GrabLadderRight()
        end,
    })

    c.ClimbUntil(7)
    c.UntilGoldLeft()
    c.GrabLadderRight()
    c.ClimbUntil(4)
    c.UntilGoldRight()
    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.UntilGoldLeft()
    c.GrabLadderRight()
    c.ClimbUntilLevelEnd()

    c.Marker('lv 10 end')

    c.Done()
end

c.Finish()
