-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 47 then
    error('must be run in level 47')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.RightUntil(16)
    c.GrabLadderRight()
    c.ClimbUntil(7)
    c.PushUp()

    c.Assert(c.FrameSearch(function()
        if not c.ClimbUntil(6) then return false end
        return c.LeftFor(2)
    end))

    c.GrabAndClimbOneLeft()
    c.LeftFor(2)
    c.GrabAndClimbOneLeft()
    c.LeftFor(2)
    c.GrabAndClimbOneLeft()
    c.LeftFor(2)
    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.UntilGoldRight()
    c.UntilGoldRight()
    c.UntilGoldLeft()
    c.GrabLadderRight('Down')
    c.ClimbUntil(3)
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.UntilDig('Left', 'B')
    c.FallLeft()
    c.UntilDig('Left', 'B')
    c.FallLeft()
    c.GrabLadderRight()
    c.ClimbUntil(10)
    c.UntilDig('Right', 'A')
    c.ClimbUntil(11)
    c.UntilDig('Right', 'A')


    c.RightUntil(12)

        c.WaitFor(2) -- Manip E3 spawn to be on left
    c.UntilDig('Right', 'A')
    c.UntilDig('Left', 'A')
    c.WalkOverEnemy('Right')
    c.GrabLadderRight()
    c.ClimbUntil(10)
    c.LeftFor(3)
    c.GrabAndClimbOneLeft()
    c.LeftUntil(9)
    c.UntilDig('Left', 'B')

    c.Assert(c.FrameSearch(function()
        c.FallLeft()
        if not c.RightUntil(16) then return false end
        return c.GrabLadderRight()
    end))

    c.ClimbUntil(6)
    c.LeftUntil(17)
    c.UntilDig('Left', 'B')

    c.FallLeft()
    c.UntilDig('Left', 'A')
    c.UntilGoldLeft()
    c.FallRight()
    c.GrabLadderLeft('Down')
    c.ClimbUntil(12)
    c.RightUntil(16)
    c.UntilDig('Right', 'A')
    c.WalkOverEnemy('Right')
    c.GrabLadderRight()


    c.ClimbUntil(6)
    c.LeftFor(2)
    c.GrabLadderLeft()

    c.ClimbUntil(4)
    c.RightFor(2)
    c.GrabLadderRight()
    c.ClimbUntilGold('Right')
    c.FallRight()
    c.UntilGoldRight()
    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.RightUntil(24)
    c.UntilDig('Right', 'A')
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.UntilDig('Left', 'B')
    c.UntilDig('Right', 'B')
    c.FallLeft()
    c.UntilDig('Left', 'B')
    c.FallLeft()
    c.RightUntil(26)
    c.GrabLadderRight()
    c.ClimbUntilLevelEnd()

    c.Marker('lv 47 end')

    c.Done()
end

c.Finish()
