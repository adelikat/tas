-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 19 then
    error('must be run in level 19')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.RightUntil(22)
    c.GrabLadderRight()

    c.WaitFor(3) -- Ensure E3 picks up gold, and E1 will continue to walk left

    c.ClimbUntil(9)
    c.LeftFor(1)
    c.GrabLadderLeft()
    c.ClimbUntil(7)
    c.LeftFor(1)
    c.GrabLadderLeft()
    c.ClimbUntil(5)
    c.LeftFor(1)
    c.GrabLadderLeft()
    c.ClimbUntil(3)
    c.UntilGoldLeft()

    c.GrabLadderRight('Down')
    c.ClimbUntil(5)
    c.GrabLadderRight('Down')
    c.ClimbUntil(7)

    c.UntilGoldLeft()
    c.UntilGoldLeft()
    c.UntilGoldLeft()

    c.UntilDig('Right', 'B')
    c.UntilDig('Right', 'B')
    c.UntilDig('Right', 'B')

    c.Assert(c.WalkOverEnemy('Left'))
    c.LeftUntil(7)
    c.GrabLadderLeft()
    c.ClimbUntil(5)
    c.RightFor(1)
    c.GrabLadderRight()
    c.ClimbUntil(3)
    c.RightFor(1)
    c.GrabLadderRight()
    c.ClimbUntil(1)
    c.UntilGoldRight()
    c.UntilGoldRight()
    c.GrabLadderLeft()
    c.ClimbUntilLevelEnd()

    c.Marker('lv 19 end')

    c.Done()
end

c.Finish()
