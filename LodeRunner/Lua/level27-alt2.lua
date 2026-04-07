-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 27 then
    error('must be run in level 27')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.LeftFor(2)
    c.UntilDig('Left', 'B')
    c.FallLeft()
    c.Assert(c.FrameSearch(c.GrabLadderRight))
    c.ClimbUntil(1)
    c.RightFor(1)
    c.UntilDig('Right', 'A')

    c.Assert(c.FrameSearch(function()
        local result = c.FallRight()
        if not result then return false end
        result = c.GrabLadderLeft('Down')
        if not result then return false end
        return c.ClimbUntil(6)
    end))

    c.Assert(c.FrameSearch(function()
        return c.ClimbUntil(1)
    end))

    c.Assert(c.FrameSearch(function()
        return c.RightUntil(12)
    end))

    c.PushDown()
    c.FinishFalling()
    c.UntilDig('Left', 'B')
    c.FallLeft()

    c.GrabLadderLeft()
    c.ClimbUntil(6)

    c.Assert(c.FrameSearch(function()
        c.FallLeft()
        c.UntilDig('Left', 'B')

        c.Assert(c.FrameSearch(function()
            c.FallLeft()
            c.UntilDig('Left', 'B')
            return c.Enemy(3).yPos() >= 2
        end))

        c.FallLeft()
        c.GrabLadderLeft()
        c.ClimbUntil(7)

        c.Assert(c.FrameSearch(function() return c.RightUntil(4) end))
        c.GrabLadderRight('Down')
        c.ClimbUntil(9)
        c.WaitFor(5)

        return true
        -- TODO: we want e3 near or at far left to fall and cause fast speed.  Far right would be ideal
        ---- local e3X = c.Enemy(3).levelX
        ---- console.log(string.format('%s E3 spawn: %s', emu.framecount(), e3X))
        ---- return e3X > 25
    end, 31))

    c.WaitFor(20) -- Long wait
    c.Assert(c.FrameSearch(function()
        return c.RightUntil(8)
    end))

    c.UntilDig('Right', 'A')
    c.FallRight()
    c.GrabLadderRight()
    c.ClimbUntil(7)

    c.FallRight()
    c.UntilDig('Right', 'B')
    c.FallLeft()
    c.GrabLadderLeft()
    c.ClimbUntil(7)
    c.RightFor(1)
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.GrabLadderLeft()
    c.ClimbUntilGold('Right')
    c.UntilGoldRight()
    c.GrabLadderLeft('Down')
    c.ClimbUntil(7)
    c.RightFor(1)

    c.Assert(c.WalkOverEnemy('Right'))

    c.FallRight()
    c.FallRight()

    c.GrabLadderRight()
    c.ClimbUntil(1)
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.GrabLadderLeft()

    c.ClimbUntil(6)
    c.UntilGoldLeft()
    c.GrabLadderRight()
    c.ClimbUntil(3)
    c.UntilGoldLeft()
    c.GrabLadderRight()
    c.ClimbUntil(1)
    c.RightFor(2)
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.FallRight()
    c.FallLeft()
    c.UntilDig('Left', 'A')

    c.FallRight()
    c.GrabLadderRight()
    c.ClimbUntil(7)
    c.LeftFor(1)

    c.WaitFor(10) -- long wait
    c.Assert(c.FrameSearch(function()
        local result = c.FallLeft()
        if not result then return false end
        return c.Player().levelY == 9
    end))

    c.FallLeft()
    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.FallRight()
    c.FallLeft()
    c.FallLeft()
    c.FallLeft()
    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.FallRight()
    c.GrabLadderRight()
    c.ClimbUntilLevelEnd()

    c.Done()
end

c.Finish()
