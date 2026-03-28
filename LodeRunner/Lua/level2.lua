--Starts on the frame immediately after pressing select to do the select skip
-- all levels from this file onward do this
dofile('lode-runner-core.lua')

c.Start()


if c.CurrentLevel() ~= 2 then
    error('must be run in level 2')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

-- wait until E3 decides to move right to chase, instead of left, also E1 need to be closer to make him take longer to get to the top of the ladder later
local function E3ChaseRight()
    c.ClimbUntil(1)
    return c.Enemy(3).xPos() > 4 and c.Enemy(1).xPos() < 10.750
end

local function MultilevelDig()
    c.UntilDig('Right', 'A')
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.UntilDig('Right', 'B')
    c.FallLeft()
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.RightFor(5)
end

while not c.IsDone() do
    c.GrabLadderLeft()
    c.ClimbUntil(10)

    -- magic frames to get E1 and E3 in precise positions
    c.PushRight()
    c.WaitFor(2) -- magic frames to get E2 to be in a better position
    c.PushFor('Right', 11) -- super precise
    c.ClimbUntil(5)
    c.GrabLadderLeft()

    c.ClimbUntil(3)
    c.Assert(c.FrameSearch(E3ChaseRight, 15))

    c.LeftFor(1)
    c.WaitFor(4) -- magic frames
    c.GrabLadderLeft('Down')

    c.ClimbUntil(3)
    c.UntilGold('Right')

    c.WaitFor(8)
    c.WaitFor(1) -- Magic neshawk only
    c.GrabLadderLeft('Down')
    c.ClimbUntil(6)

    c.WaitFor(2)
    c.FallRight()

    MultilevelDig()

    c.Assert(c.FrameSearch(function() return c.Enemy(1).xPos() >= 15 end))
    c.WaitFor(2) -- Magic frames, reduce lag throughout the rest of the level
    c.GrabLadderRight()
    c.ClimbUntil(10)
    c.RightUntil(11)


    c.ClimbUntil(7)
    c.UntilGold('Left')
    c.GrabLadderRight()

    -- TODO: should look for a delay here, it happened to be 0
    c.ClimbUntil(5)
    c.RightFor(3)
    c.PushDown()
    c.FinishFalling()
    c.GrabLadderRight()

    c.ClimbUntil(5)
    c.RightFor(2)
    c.GrabLadderRight()

    c.ClimbUntil(1)

    c.UntilGold('Left')
    c.GrabLadderRight('Down')
    c.ClimbUntil(2)
    c.FallRight()

    c.GrabLadderRight('Down')
    c.ClimbUntil(7)
    c.GrabLadderLeft('Down')
    c.ClimbUntil(9)
    c.FallRight()
    c.UntilGold('Right')
    c.GrabLadderLeft()
    c.ClimbUntil(7)
    c.GrabLadderRight()
    c.ClimbUntilLevelEnd()

    c.Marker('lv 2 end')

    c.Done()
end

c.Finish()
