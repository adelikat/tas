-- Starts on the frame after pressing select to do the scroll skip
-- all levels from this file onward do this
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 3 then
    error('must be run in level 3')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

local function GoLeftButClimbDownLadder()
    c.UntilLadderGrab('Left', 'Down')
    c.ClimbDown()
    c.PushFor('Left', 2)
    c.FinishFalling()
    c.UntilLadderGrab('Left')
end

local function DigThenGetGold()
    c.UntilLadderGrab('Right', 'Down')
    c.UntilDig('Down', 'A')
    c.ClimbDown()
    c.UntilGold('Left')
    c.UntilFall('Right')
    c.FinishFalling()
    c.UntilGold('Right')
end

local function WaitForE2ThenClimb()
    c.Climb()
    local result = c.UntilLadderGrab('Left')
    if not result then
        return false
    end
    return c.Climb(2)
end

while not c.IsDone() do
    c.UntilLadderGrab('Right')
    c.Climb(2)
    c.UntilGold('Right')

    c.WaitFor(2)

    GoLeftButClimbDownLadder()
    c.WaitFor(1)
    c.Climb(3)
    c.PushRight()
    c.Climb(4)

    --

    c.UntilGold('Left')
    c.UntilLadderGrab('Right')
    c.Climb(3)
    c.UntilGold('Left')
    c.UntilLadderGrab('Left')
    c.Climb()
    c.UntilGold('Right')

    DigThenGetGold()

    c.PushBtnsFor({'Left', 'Down'}, 2)
    c.FinishFalling()
    c.ClimbDown(3)
    c.UntilGold('Left')
    c.UntilLadderGrab('Right')
    c.Climb(3)
    c.UntilLadderGrab('Left')


    local result = c.FrameSearch(WaitForE2ThenClimb, 30)
    if not result then
        error('could not find frame')
    end

    c.RightFor(1)
    c.UntilLadderGrab('Right')
    c.Climb(3)
    c.RightFor(1)
    c.UntilLadderGrab('Right')
    c.Climb()
    c.RightFor(1)
    c.UntilLadderGrab('Right')
    c.ClimbUntilLevelEnd()
    c.Marker('lv 3 end')

    c.Done()
end

c.Finish()
