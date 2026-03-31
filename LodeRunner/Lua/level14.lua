-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 14 then
    error('must be run in level 14')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

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
    c.RightFor(3)
    local result = c.GrabLadderRight()
    if not result then return false end

    return c.ClimbUntil(6)
end

local function LastAvoid()
    c.PushDown()
    c.FinishFalling()
    c.LeftUntil(24)
    c.ClimbUntilGold('Left')
    c.LeftFor(5)
    local result = c.GrabLadderLeft()
    if not result then return false end
    return c.Climb(2)
end

while not c.IsDone() do
    -- Left section
    c.UntilGold('Right')
    c.LeftFor(3)
    c.GrabLadderLeft()
    c.ClimbUntilGold('Left')
    c.LeftUntil(0)
    c.ClimbUntil(5)
    c.RightUntil(10)
    c.GrabLadderRight()
    c.ClimbUntil(8)
    c.FallRight()
    c.GrabLadderLeft()
    c.ClimbUntilGold('Left')
    c.LeftUntil(8)

    c.GrabLadderLeft()
    c.ClimbUntil(5)
    c.RightFor(1)
    c.PushDown()
    c.WaitFor(1)
    c.FinishFalling()
    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.LeftUntil(3)
    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.LeftUntil(0)
    c.FinishFalling()
    c.PushDown()
    c.FinishFalling()

    -- Left to Right
    c.RightUntil(11)
    c.GrabLadderRight()
    c.ClimbUntil(10)

    c.FrameSearch(KeepE3OnLeft)

    c.ClimbUntil(1)
    c.FallLeft()
    c.PushDown()
    c.FinishFalling()
    c.RightFor(1)
    c.FinishFalling()
    c.RightUntil(17)
    c.ClimbUntil(4)
    c.FallRight()

    c.GrabLadderLeft('Down')
    c.ClimbUntil(9)

    -- Final
    c.FrameSearch(AvoidE2, 20)
    c.LeftFor(5)
    c.GrabLadderLeft()
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

    c.Marker('lv 14 end')

    c.Done()
end

c.Finish()
