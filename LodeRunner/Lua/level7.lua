dofile('lode-runner-core.lua')

c.Start()

local function ClimbAndDigLeft()
    local result = c.ClimbUntil(3)
    if not result then return false end
    result = c.LeftFor(2)
    if not result then return false end
    result = c.UntilDig('Left', 'B')
    if not result then return false end
    return c.UntilFall('Left')
end

local function LeftFor2()
    local result = c.LeftUntil(9)
    if not result then return false end
    local p = c.Player()
    return p.yPos() < 8 and p.isAlive
end

while not c.IsDone() do
    c.RightUntil(18)
    c.UntilDig('Right', 'A')
    c.FrameSearch(function() return c.UntilLadderGrab('Right') end)
    c.Climb(2)
    c.PushUp()

    c.FrameSearch(function() return c.Climb(4) end, 25)
    c.ClimbUntil(1)
    c.RightFor(5)
    c.PushDown()
    c.FinishFalling()

    --
    -- c.LeftFor(1)
    -- c.UntilDig('Left', 'B')
    -- c.UntilDig('Right', 'B')
    -- c.UntilFall('Left')
    -- c.FinishFalling()
    -- c.UntilDig('Left', 'A')
    -- c.UntilFall('Right')
    -- c.FinishFalling()
    -- c.UntilDig('Left', 'B')
    -- c.UntilFall('Left')
    -- c.FinishFalling()
    -- c.UntilLadderGrab('Left')

    -- Alternate dig pattern, 1 frame slower
    -- c.UntilDig('Left', 'A')
    -- c.UntilDig('Left', 'A')
    -- c.UntilFall('Right')
    -- c.FinishFalling()
    -- c.UntilDig('Right', 'B')
    -- c.UntilFall('Left')
    -- c.FinishFalling()
    -- c.UntilDig('Left', 'B')
    -- c.UntilFall('Left')
    -- c.FinishFalling()
    -- c.UntilLadderGrab('Left')

    -- Alt alt, somehow less lag if the enemy never falls into a hole
    c.LeftFor(2)
    c.UntilDig('Left', 'A')
    c.UntilDig('Left', 'A')
    c.UntilFall('Right')
    c.FinishFalling()
    c.UntilDig('Right', 'A')
    c.UntilFall('Right')
    c.FinishFalling()
    c.UntilDig('Left', 'B')
    c.UntilFall('Left')
    c.FinishFalling()
    c.UntilLadderGrab('Left')

    c.ClimbUntil(7)

    c.FrameSearch(ClimbAndDigLeft)
    c.FinishFalling()

    c.UntilLadderGrab('Left')
    c.ClimbUntil(7)
    c.LeftFor(4)

    -- The luck happend too work out but waiting here does not cost any frames, if spawn manip is needed
    -- c.WaitFor(1)

    c.UntilDig('Left', 'B')
    c.WaitFor(5) -- speed optimization
    c.FrameSearch(LeftFor2)
    --c.LeftUntil(3)
    --c.UntilGold('Left')
    c.LeftUntil(2) -- This happened to get the gold due to how fast the game happened to be running, and the above code failed

    c.ClimbUntil(9)
    c.UntilFall('Right')
    c.FinishFalling()
    c.UntilGold('Right')
    c.LeftFor(2)
    c.UntilLadderGrab('Left')
    c.ClimbUntil(7)
    c.UntilLadderGrab('Right')
    c.ClimbUntil(5)
    c.UntilGold('Right')
    c.UntilLadderGrab('Left')
    c.ClimbUntil(2)
    c.LeftFor(1)
    c.UntilLadderGrab('Left')
    c.ClimbUntilLevelEnd()

    c.Marker('lv 7 end')

    c.Done()
end

c.Finish()
