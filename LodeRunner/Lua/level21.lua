-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 21 then
    error('must be run in level 21')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.RightUntil(13)
    c.PushDown()
    c.UntilDig('Right', 'A')
    c.FallRight()

    c.Assert(c.FrameSearch(function()
        c.UntilDig('Right', 'A')
        c.FallRight()
        c.UntilDig('Right', 'B')
        c.Assert(c.FrameSearch(function()
            c.FallLeft()
            return c.Enemy(1).hasGold()
        end))

        return (0 - c.Enemy(1).timer) > 3
    end, 31))

    c.ClimbUntil(12) -- The climb down is necessary here to get E1 to climb down to the floor and drop gold
    c.LeftUntil(4)

    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.RightUntil(18)
    c.PushDown()
    c.UntilDig('Right', 'A')
    c.FallRight()

    c.RightUntil(21)
    c.UntilDig('Left', 'B')

    c.FallLeft()
    c.UntilDig('Left', 'B')
    c.FallLeft()
    c.GrabLadderLeft('Down')
    c.ClimbUntil(10)
    c.FallLeft()
    c.LeftUntil(4)
    c.GrabLadderLeft()
    c.ClimbUntil(1)

    c.RightUntil(18)
    c.PushDown()
    c.FinishFalling()
    c.UntilDig('Right', 'A')
    c.Assert(c.WalkOverEnemy('Right'))
    c.UntilGoldRight()
    c.ClimbUntil(4)
    c.LeftFor(1)
    c.UntilDig('Left', 'B')
    c.FallLeft()
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.UntilDig('Right', 'A')
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.UntilDig('Right', 'B')
    c.FallLeft()
    c.GrabLadderLeft('Down')
    c.ClimbUntil(13)

    c.WaitFor(1) -- Manip E3 to appear on the right (and get stuck)
    c.GrabLadderLeft()
    c.ClimbUntil(12)

    c.GrabLadderLeft()

    c.Assert(c.FrameSearch(function()
        c.ClimbUntil(11)
        local result = c.GrabLadderLeft()
        if not result then return false end
        return c.ClimbUntil(9)
    end))

    c.LeftUntil(5)
    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.LeftFor(1)
    c.GrabLadderLeft()
    c.ClimbUntilLevelEnd()

    c.Marker('lv 21 end')

    c.Done()
end

c.Finish()
