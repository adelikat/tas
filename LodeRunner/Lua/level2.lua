-- Starts in the lag frames before the level appears
dofile('lode-runner-core.lua')

c.Start()


if c.CurrentLevel() ~= 2 then
    error('must be run in level 2')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

local function Left10()
    c.PushFor('Left', 10)
    return c.Player().isAlive
end

-- wait until E3 decides to move right to chase, instead of left
local function E3ChaseRight()
    c.Climb(2)
    return c.Enemy(3).xPos() >= 4
end

local function MultilevelDig()
    c.UntilDigAppears('Right', 'B')
    c.UntilDigAppears('Right', 'B')
    c.LeftFor(1)
    c.FinishFalling()
    c.UntilDigAppears('Left', 'B')
    c.LeftFor(1)
    c.FinishFalling()
    c.UntilDigAppears('Left', 'A')
    c.RightFor(1)
    c.FinishFalling()
    c.RightFor(5)
end

while not c.IsDone() do
    c.UntilLadderGrab('Left')
    c.Climb(2)
    c.UntilLadderGrab('Right')
    c.Climb(4)
    local result = c.FrameSearch(Left10, 15)
    if not result then
        error('could not find delay')
    end

    c.UntilLadderGrab('Left')
    c.Climb(4)
    local result = c.FrameSearch(E3ChaseRight, 15)
    if not result then
        error('could not find delay')
    end

    c.UntilLadderGrab('Left', 'Down')
    c.ClimbDown(2)
    c.UntilGold('Right')
    c.UntilLadderGrab('Left', 'Down')

    c.ClimbDown(2)
    c.RightFor(1)
    c.WaitFor(2)
    c.FinishFalling()

    MultilevelDig()


    c.Done()
end

c.Finish()
