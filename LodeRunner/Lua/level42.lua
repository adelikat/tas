-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 42 then
    error('must be run in level 42')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    -- c.GrabLadderLeft()
    -- c.ClimbUntil(11)
    -- c.UntilDig('Left', 'A')
    -- c.UntilGoldLeft()
    -- c.FallRight()
    -- c.UntilDig('Right', 'B')

    -- c.BestOf({
    --     c.UntilGoldLeft,
    --     function()
    --         c.ClimbUntil(13)
    --         return c.UntilGoldLeft()
    --     end,
    -- })

    -- c.RightUntil(16)
    -- c.GrabLadderRight()
    -- c.ClimbUntil(12)
    -- c.RightUntil(22)

    -- c.WaitFor(1) -- Reduces lag for some reason
    -- c.UntilDig('Right', 'A')
    -- c.WalkOverEnemy('Right')
    -- c.GrabLadderRight()

    -- c.ClimbUntil(3)

    -- c.LeftUntil(16)
    -- c.UntilDig('Left', 'B')
    -- c.Assert(c.FrameSearch(function()
    --     c.FallLeft()
    --     return c.Enemy(3).levelX > 12
    -- end))
    -- c.GrabLadderRight()
    -- c.ClimbUntil(7)
    -- c.UntilGoldRight()
    -- c.UntilGoldRight()

    -- c.Marker('temp')

    c.GrabLadderLeft('Down')
    c.ClimbUntil(9)
    c.FallRight()
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.GrabLadderRight()
    c.ClimbUntil(2)
    c.LeftUntil(22)
    c.PushDown()
    c.FinishFalling()
    c.LeftUntil(19)
    c.UntilDig('Left', 'B')

    c.WaitFor(2) -- Reduces lag

    c.FallLeft()
    c.FallRight()
    c.GrabLadderRight()

    c.ClimbUntil(4)
    c.Assert(c.FrameSearch(function()
        local result = c.ClimbUntil(2)
        if not result then return false end
        return c.LeftUntil(15)
    end))

    c.LeftUntil(6)
    c.GrabLadderLeft('Down')

    c.ClimbUntil(6)
    c.UntilGoldRight()
    c.GrabLadderLeft()
    c.ClimbUntil(5)
    c.FallLeft()
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.FallRight()
    c.GrabLadderRight()
    c.ClimbUntil(2)
    c.LeftUntil(2)
    c.UntilDig('Left', 'B')
    c.FallLeft()
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.FallRight()
    c.GrabLadderRight()
    c.ClimbUntil(2)
    c.LeftFor(1)
    c.GrabLadderLeft()
    c.ClimbUntilLevelEnd()

    -- c.Marker('lv 42 end')

    c.Done()
end

c.Finish()
