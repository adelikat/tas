dofile('lode-runner-core.lua')

c.Start()


if c.CurrentLevel() ~= 2 then
    error('must be run in level 2')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

-- local function Left10()
--     c.PushFor('Left', 10)
--     return c.Player().isAlive
-- end

-- wait until E3 decides to move right to chase, instead of left, also E1 need to be closer to make him take longer to get to the top of the ladder later
local function E3ChaseRight()
    c.Climb(2)

    return c.Enemy(3).xPos() > 4 and c.Enemy(1).xPos() < 10.750
end

local function E3ChaseLeft()
    c.UntilLadderGrab('Left', 'Down')
    c.ClimbDown(3)  -- 3 instead of 2, more magic behavior for E2 and E3

    return c.Enemy(3).xPos() < 4.5
end

local function WaitE1()
    return c.Enemy(1).xPos() >= 15
end

local function MultilevelDig()
    c.UntilDig('Right', 'A')
    c.UntilDig('Left', 'A')
    c.RightFor(1)
    c.FinishFalling()
    c.UntilDig('Right', 'B')
    c.LeftFor(1)
    c.FinishFalling()
    c.UntilDig('Right', 'A')
    c.RightFor(1)
    c.FinishFalling()
    c.RightFor(5)
end

while not c.IsDone() do
    c.UntilLadderGrab('Left')
    c.Climb(2)

    -- magic frames to get E1 and E3 in precise positions
    c.PushRight()
    c.WaitFor(2) -- magic frames to get E2 to be in a better position
    --c.UntilLadderGrab('Right')
    c.PushFor('Right', 11) -- super precise
    --c.WaitFor(2) -- more magic, reduces lag
    c.Climb(5)
    c.UntilLadderGrab('Left')

    c.Climb(2)
    local result = c.FrameSearch(E3ChaseRight, 15)
    if not result then
        error('could not find delay')
    end

    c.LeftFor(1)
    c.WaitFor(4) -- magic frames
    c.UntilLadderGrab('Left', 'Down')
    c.ClimbDown(2)
    c.UntilGold('Right')
    c.PushRight() -- magic, slows down E1 by 1 pixel

    -- local result = c.FrameSearch(E3ChaseLeft, 30)
    -- if not result then
    --     error('could not find delay')
    -- end

    c.WaitFor(8)
    c.UntilLadderGrab('Left', 'Down')
    c.ClimbDown(3)

    c.WaitFor(2)
    c.PushFor('Right', 2)

    c.FinishFalling()

    MultilevelDig()

    c.WaitFor(1)

    local result = c.FrameSearch(WaitE1, 30)
    if not result then
        error('could not find delay')
    end

    c.UntilLadderGrab('Right')
    c.Climb(2)
    c.UntilLadderGrab('Right')
    c.Climb(3)
    c.UntilGold('Left')
    c.UntilLadderGrab('Right')

    -- TODO: should look for a delay here, it happened to be 0
    c.Climb(2)
    c.RightFor(3)
    c.PushDown()
    c.FinishFalling()
    c.UntilLadderGrab('Right')

    c.Climb(1)
    c.UntilLadderGrab('Right')

    c.Climb(4)
    c.UntilGold('Left')

    c.UntilLadderGrab('Right', 'Down')
    c.ClimbDown(1)
    c.RightFor(5)
    c.PushFor('Right', 4)
    c.FinishFalling()

    c.UntilLadderGrab('Right', 'Down')
    c.ClimbDown(2)
    c.UntilLadderGrab('Left', 'Down')
    c.ClimbDown(2)
    c.PushFor('Right', 2)
    c.FinishFalling()
    c.UntilGold('Right')
    c.UntilLadderGrab('Left')
    c.Climb(3)
    c.UntilLadderGrab('Right')
    c.ClimbUntilLevelEnd()

    c.Marker('lv 2 end')

    c.Done()
end

c.Finish()
