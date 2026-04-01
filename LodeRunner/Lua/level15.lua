-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 15 then
    error('must be run in level 15')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.UntilGoldLeft()
    c.RightFor(5)
    c.GrabLadderRight()
    c.ClimbUntil(10)
    c.LeftUntil(4)
    c.UntilDig('Left', 'B')
    c.UntilDig('Right', 'B')

    c.WaitFor(10)
    c.Assert(c.FrameSearch(function()
        local result = c.LeftFor(2)
        if not result then return false end
        if c.Player().levelY ~= 10 then return false end
        return c.GrabLadderLeft()
    end))

    c.ClimbUntil(7)
    c.RightFor(2)
    c.GrabLadderRight()
    c.ClimbUntil(2)
    c.RightFor(2)
    c.GrabLadderRight()
    c.ClimbUntil(1)
    c.FallLeft()
    c.UntilGoldLeft()

    c.RightFor(2)
    c.UntilDig('Right', 'A')
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.GrabLadderRight()
    c.ClimbUntil(6)

    c.Marker('temp')

    c.Assert(c.FrameSearch(function() return c.ClimbUntil(2) end))
    c.RightUntil(14)
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.LeftFor(1)
    c.FallLeft()
    c.LeftFor(1)
    c.FallLeft()
    c.RightUntil(17)

    c.WaitFor(3) -- Manip enemy spawn to be 25, right above a gold
    c.UntilDig('Right', 'A')
    c.FallRight()

    c.ClimbUntil(10)
    c.WaitFor(3) -- Force enemy to die -- TODO: frame search this
    c.ClimbUntil(12)
    c.UntilGoldRight()
    c.LeftFor(5)
    c.GrabLadderLeft()
    c.ClimbUntil(10)
    c.UntilGoldRight()
    c.GrabLadderRight()
    c.ClimbUntilGold('Left')
    c.LeftFor(2)
    c.GrabLadderLeft()
    c.ClimbUntilGold('Left')
    c.LeftUntil(18)
    c.UntilDig('Left', 'B')
    c.FallLeft()
    c.UntilGoldRight()

    c.FallRight()
    c.GrabLadderRight()
    c.ClimbUntil(5)

    c.Assert(c.FrameSearch(function()
        c.ClimbUntil(4)
        c.RightFor(1)
        return c.Enemy(2).levelY == 3
    end))

    c.UntilGoldRight()
    c.GrabLadderLeft()
    c.ClimbUntilGold('Left')
    c.LeftFor(2)
    c.GrabLadderLeft()
    c.ClimbUntilLevelEnd()

    c.Marker('lv 15 end')

    c.Done()
end

c.Finish()
