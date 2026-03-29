-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 3 then
    error('must be run in level 3')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

local function LeftClimb()
    c.ClimbUntil(9)
    c.PushRight()
    return c.ClimbUntil(5)
end

local function WaitForE2ThenClimb()
    c.ClimbUntil(8)
    c.LeftFor(4)
    local result = c.GrabLadderLeft()
    if not result then return false end
    return c.ClimbUntil(6)
end

local function End()
    c.ClimbUntil(1)
    c.UntilGold('Right')

    c.GrabLadderRight('Down')
    c.UntilDig('Down', 'A')
    c.ClimbUntil(3)
    c.UntilGold('Left')
    c.FallRight()
    c.UntilGold('Right')

    c.LeftUntil(26)
    c.PushDown()
    c.FinishFalling()
    c.ClimbUntil(12)
    c.UntilGold('Left')
    c.GrabLadderRight()
    c.ClimbUntil(9)
    c.GrabLadderLeft()

    c.Assert(c.FrameSearch(WaitForE2ThenClimb))
    c.GrabLadderRight()
    c.ClimbUntil(3)
    c.GrabLadderRight()
    c.ClimbUntil(2)
    c.RightUntil(27)
    c.ClimbUntilLevelEnd()
    if tastudio.engaged() then
        tastudio.createnewbranch()
    end
    return true
end

while not c.IsDone() do
    c.RightFor(3)
    c.GrabLadderRight()
    c.ClimbUntil(10)
    c.UntilGold('Right')

    c.WaitFor(2) -- Magic delay saves a lag frame throughout the level, and different spawn timer

    c.GrabLadderLeft('Down')
    c.ClimbUntil(11)
    c.FallLeft()
    c.LeftUntil(3)

    c.Assert(c.FrameSearch(LeftClimb))

    c.UntilGold('Left')
    c.GrabLadderRight()
    c.ClimbUntil(2)
    c.UntilGold('Left')

    c.LeftUntil(0)

    c.BestSearch(End, 13)

    c.Marker('lv 3 end')

    c.Done()
end

c.Finish()
