dofile('lode-runner-core.lua')

c.Start()

while not c.IsDone() do
    c.UntilLadderGrab('Right')
    c.Climb(3)
    c.UntilLadderGrab('Left')
    c.ClimbUntil(1)
    c.UntilGold('Left')
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.RightFor(1)
    c.UntilDig('Right', 'A')
    c.WaitFor(7) -- optimization
    c.FrameSearch(function() return c.RightFor(2) end)
        c.WaitFor(1) -- Manip enemy spawn
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
    c.UntilGold('Left')
    c.UntilGold('Left')
    c.UntilGold('Left')
    c.UntilDig('Right', 'A')
    c.FallRight()

    c.UntilLadderGrab('Right')
    c.Climb(3)
    c.UntilGold('Right')
    c.RightFor(1)
    c.UntilDig('Right', 'A')

    c.FrameSearch(function() return c.RightFor(2) end)

    c.BestOf({
        function() return c.UntilLadderGrab('Right') end,
        function() c.ClimbDown() return c.UntilLadderGrab('Right') end,
    })

    c.Climb(3)
    c.LeftFor(2)
    c.UntilGold('Left')
    c.UntilLadderGrab('Right')
    c.Climb(3)
    c.UntilGold('Right')
    c.UntilLadderGrab('Left')
    c.ClimbUntil(1)
    c.UntilGold('Left')
    c.UntilLadderGrab('Right')
    c.ClimbUntilLevelEnd()

    c.Marker('lv 10 end')

    c.Done()
end

c.Finish()
