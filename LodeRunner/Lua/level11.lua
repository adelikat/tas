-- Start at the end of a level, where pressing up for 1 frame will end the level
dofile('lode-runner-core.lua')

c.Start()

local function Left()
    c.LeftUntil(2)
    return c.UntilLadderGrab('Left')
end

local function DownLeft()
    c.UntilLadderGrab('Left', 'Down')
    c.ClimbDown()
    return c.UntilLadderGrab('Left')
end

local function DigE3()
    c.FallRight()
    c.UntilDig('Right', 'A')
    return c.Player().isAlive
end

while not c.IsDone() do
    c.BestOf({
        DownLeft,
        Left,
    })
    c.ClimbUntil(1)
    c.UntilGold('Right')

    c.FrameSearch(DigE3)
    c.FrameSearch(function() return c.RightFor(2) end)

    c.RightUntil(10)
    c.UntilDig('Right', 'A')

    c.WaitFor(4) -- Delay to ensure enemy dies, and has favorable spawn
    c.PushBtnsFor({'Left', 'A'})
    c.WaitFor(10)

    c.UntilDig('Left', 'B')
    c.FrameSearch(function() return c.RightFor(3) end)
    c.UntilGold('Right')

    c.UntilDig('Right', 'B')
    c.FrameSearch(function() return c.LeftFor(2) end)

    c.ClimbUntil(11)
    c.UntilGold('Left')

    c.UntilLadderGrab('Right')
    c.ClimbUntil(10)
    c.UntilGold('Right')

    c.UntilLadderGrab('Left')
    c.ClimbUntil(9)
    c.UntilGold('Left')

    c.UntilLadderGrab('Right')
    c.ClimbUntil(8)
    c.UntilGold('Right')

    c.UntilLadderGrab('Left')
    c.ClimbUntil(7)
    c.UntilGold('Left')

    c.UntilLadderGrab('Right')
    c.ClimbUntil(6)
    c.UntilGold('Right')

    c.UntilLadderGrab('Left')
    c.ClimbUntil(5)
    c.UntilGold('Left')

    c.UntilLadderGrab('Right')
    c.ClimbUntil(4)
    c.UntilGold('Right')

    c.UntilLadderGrab('Left')
    c.ClimbUntil(3)
    c.UntilLadderGrab('Left')

    c.ClimbUntil(2)
    c.LeftFor(2)
    c.UntilLadderGrab('Left')
    c.ClimbUntilLevelEnd()

    c.Marker('lv 11 end')

    c.Done()
end

c.Finish()
