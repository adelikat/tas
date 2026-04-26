-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 48 then
    error('must be run in level 48')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.GrabLadderLeft()
    c.ClimbUntil(10)
    c.GrabAndClimbOneRight()
    c.GrabAndClimbOneRight()
    c.ClimbUntilGold('Right')
    c.GrabAndClimbOneRight()
    c.GrabAndClimbOneRight()
    c.ClimbUntilGold('Right')
    c.GrabAndClimbOneRight()
    c.GrabAndClimbOneRight()
    c.ClimbUntil(3)
    c.LeftUntil(3)
    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.FallRight()
    c.GrabLadderRight('Down')
    c.ClimbUntil(4)
    c.LeftFor(2)
    c.GrabLadderLeft('Down')
    c.ClimbUntil(6)
    c.RightFor(2)
    c.GrabLadderRight('Down')
    c.ClimbUntil(8)
    c.LeftFor(2)
    c.GrabLadderLeft('Down')
    c.ClimbUntil(10)
    c.FallRight()

    c.UntilDig('Left', 'A')
    c.UntilDig('Left', 'A')
    c.UntilDig('Left', 'A')
    c.WaitFor(3) -- Avoid E3 kill
    c.UntilDig('Left', 'A')
    c.WalkOverEnemy('Right')
    c.RightUntil(15)
    c.GrabLadderRight()
    c.ClimbUntil(3)
    c.RightUntil(25)
    c.GrabLadderRight('Down')
    c.ClimbUntil(10)
    c.UntilGoldLeft()
    c.GrabLadderLeft()
    c.ClimbUntil(6)
    c.RightFor(3)
    c.GrabLadderRight('Down')
    c.ClimbUntil(8)
    c.UntilGoldLeft()
    c.GrabLadderRight()
    c.ClimbUntil(6)
    c.LeftFor(4)
    c.GrabLadderLeft('Down')
    c.ClimbUntil(10)
    c.RightFor(5)

    c.Assert(c.FrameSearch(function()
        c.GrabLadderRight()
        c.ClimbUntil(3)
        c.LeftFor(3)
        c.GrabLadderLeft()
        c.ClimbUntil(1)
        c.UntilGoldRight()
        c.UntilGoldLeft()

        if not c.LeftUntil(11) then return false end
        return c.GrabLadderLeft()
    end))

    c.ClimbUntilLevelEnd()

    c.Marker('lv 48 end')

    c.Done()
end

c.Finish()
