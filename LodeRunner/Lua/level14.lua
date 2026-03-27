dofile('lode-runner-core.lua')

c.Start()

local function KeepE3OnLeft()
    c.ClimbUntil(6)
    c.RightUntil(17)
    return c.Enemy(3).levelX < 4
end

local function AvoidE2()
    c.ClimbUntil(11)
    c.FinishFalling()
    c.RightFor(1)
    c.FinishFalling()
    c.RightFor(2)
    local result = c.UntilLadderGrab('Right')
    if not result then return false end

    return c.ClimbUntil(6)
end

local function LastAvoid()
    c.PushDown()
    c.WaitFor(1)
    c.FinishFalling()
    c.LeftUntil(24)
    c.UntilGold('Up')
    c.LeftFor(5)
    local result = c.UntilLadderGrab('Left')
    if not result then return false end
    return c.Climb(2)
end

while not c.IsDone() do
    -- Left section
    c.UntilGold('Right')
    c.LeftFor(3)
    c.UntilLadderGrab('Left')
    c.UntilGold('Up')
    c.LeftUntil(0)
    c.ClimbUntil(5)
    c.RightUntil(10)
    c.UntilLadderGrab('Right')
    c.ClimbUntil(8)
    c.FallRight()
    c.UntilLadderGrab('Left')
    c.UntilGold('Up')
    c.LeftUntil(8)
    c.UntilLadderGrab('Left')
    c.ClimbUntil(5)
    c.RightFor(1)
    c.PushDown()
    c.FinishFalling()
    c.UntilLadderGrab('Left')
    c.ClimbUntil(1)
    c.LeftUntil(3)
    c.UntilLadderGrab('Left')
    c.ClimbUntil(1)
    c.LeftUntil(0)
    c.FinishFalling()
    c.PushDown()
    c.WaitFor(1)
    c.FinishFalling()

    -- Left to Right
    c.RightUntil(11)
    c.UntilLadderGrab('Right')
    c.ClimbUntil(10)

    c.FrameSearch(KeepE3OnLeft)

    c.ClimbUntil(1)
    c.FallLeft()
    c.PushDown()
    c.FinishFalling()
    c.RightFor(1)
    c.WaitFor(1)
    c.FinishFalling()
    c.RightUntil(17)
    c.ClimbUntil(4)
    c.FallRight()
    c.UntilLadderGrab('Left', 'Down')
    c.ClimbUntil(9)

    -- Final
    c.FrameSearch(AvoidE2, 20)
    c.LeftFor(5)
    c.UntilLadderGrab('Left')
    c.ClimbUntil(2)
    c.RightUntil(22)
    c.ClimbUntil(3)
    c.FallLeft()
    c.RightUntil(22)
    c.ClimbUntil(1)
    c.RightUntil(25)
    c.FinishFalling()
    c.PushDown()
    c.FinishFalling()
    c.RightUntil(27)
    c.WaitFor(1)
    c.FinishFalling()

    c.FrameSearch(LastAvoid)
    c.ClimbUntilLevelEnd()

    c.Done()
end

c.Finish()
