dofile('lode-runner-core.lua')

c.Start()

local function Left2()
    local result = c.LeftFor(2)
    if not result then return false end
    return c.Player().levelY == 8
end

while not c.IsDone() do
    -- This causes E1 to lag by a pixel, just enough to die from the dig
    -- This may not be necessary, remove if he dies without it
    c.PushBtnsFor({'Left', 'Down'}, 15)
    c.UntilGold('Left')
    c.UntilLadderGrab('Left')
    c.ClimbUntil(8)
    c.RightFor(3)
    c.UntilDig('Right', 'B')
    c.ClimbUntil(4)
    c.FallRight()
    c.LeftFor(1)
    c.FrameSearch(Left2)
    c.ClimbUntil(1)
    c.FallLeft()
    c.RightUntil(7)
    c.ClimbUntil(1)
    c.FallRight()
    c.RightUntil(11)
    c.ClimbUntil(4)
    c.FallRight()

    c.RightUntil(15)
    c.ClimbUntil(1)
    c.FallRight()

    c.RightUntil(19)
    c.ClimbUntil(4)
    c.FallRight()

    c.RightUntil(23)
    c.ClimbUntil(1)
    c.FallRight()

    c.UntilDig('Left', 'B')
    c.FallLeft()
    c.UntilGold('Left')
    c.UntilGold('Left')
    c.FallRight()
    c.UntilGold('Left')
    c.UntilLadderGrab('Right')
    c.ClimbUntilLevelEnd()

    c.Marker('lv 13 end')

    c.Done()
end

c.Finish()
