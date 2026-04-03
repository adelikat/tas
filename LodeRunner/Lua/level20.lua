-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 20 then
    error('must be run in level 20')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.UntilGold('Right')
    c.GrabLadderLeft()
    c.ClimbUntil(9)
    c.RightUntil(8)

    c.Assert(c.FrameSearch(function()
        local result = c.FallRight
        if not result then return false end
        return c.RightFor(2)
    end))

    c.RightUntil(25)
    c.GrabLadderRight()
    c.ClimbUntil(11)

    c.Assert(c.FrameSearch(function()
        c.ClimbUntil(10)
        return c.UntilDig('Left', 'B')
    end))

    c.WalkOverEnemy('Left')
    c.LeftUntil(24)

    c.UntilDig('Left', 'B')
    c.WalkOverEnemy('Left')

    c.GrabLadderLeft()
    c.ClimbUntil(2)
    c.UntilGoldRight()
    c.GrabLadderLeft('Down')
    c.ClimbUntil(4)
    c.UntilGoldRight()
    c.FallLeft()
    c.RightUntil(27)
    c.PushDown()
    c.FinishFalling()
    c.FallLeft()
    c.UntilGoldLeft()
    c.GrabLadderLeft()
    c.ClimbUntil(9)
    c.UntilGoldLeft()

    c.Assert(c.FrameSearch(function() return c.RightUntil(18) end, 35))
    c.GrabLadderRight()

    c.ClimbUntil(7)
    c.UntilGoldLeft()
    c.GrabLadderLeft()
    c.ClimbUntil(5)
    c.LeftUntil(4)

    c.GrabLadderLeft('Down')
    c.ClimbUntil(7)
    c.UntilGoldLeft()
    c.GrabLadderRight()

    c.ClimbUntil(5)
    c.UntilGoldLeft()
    c.RightFor(8)
    c.GrabLadderRight()

    c.ClimbUntil(3)
    c.UntilGoldLeft()
    c.GrabLadderLeft()
    c.ClimbUntil(2)
    c.FallLeft()
    c.GrabLadderLeft()
    c.ClimbUntilLevelEnd()

    c.Marker('lv 20 end')

    c.Done()
end

c.Finish()
