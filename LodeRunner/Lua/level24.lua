-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 24 then
    error('must be run in level 24')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.GrabLadderLeft()
    c.ClimbUntil(8)
    c.UntilDig('Left', 'B')
    c.ClimbUntil(9)
    c.UntilDig('Left', 'B')
    c.BestOf({
        function() return c.UntilGoldLeft() end,
        function()
            c.ClimbUntil(10)
            return c.UntilGoldLeft()
        end
    })

    c.GrabLadderLeft()
    c.ClimbUntil(9)
    c.UntilDig('Left', 'B')
    c.WalkOverEnemy('Left')
    c.GrabLadderLeft('Down')
    c.ClimbUntil(11)
    c.UntilGoldRight()
    c.LeftFor(2)
    c.GrabLadderLeft()
    c.ClimbUntil(9)
    c.UntilGoldLeft()
    c.GrabLadderRight('Down')
    c.ClimbUntil(11)
    c.UntilGoldLeft()

    c.GrabLadderLeft()
    c.ClimbUntil(10)
    c.LeftFor(1)
    c.UntilDig('Left', 'B')
    c.WalkOverEnemy('Left')
    c.LeftFor(1)
    c.UntilDig('Left', 'A')
    c.ClimbUntil(9)
    c.UntilDig('Left', 'B')
    c.ClimbUntil(10)
    c.UntilDig('Left', 'B')
    c.UntilGoldLeft()

    c.GrabLadderRight()
    c.ClimbUntil(10)
    c.Assert(c.FrameSearch(function() return c.RightFor(3) end))
    c.GrabLadderRight('Down')
    c.ClimbUntil(11)
    c.RightUntil(16)
    c.GrabLadderRight()
    c.ClimbUntil(6)
    c.FallLeft()
    c.GrabLadderLeft()
    c.ClimbUntil(5)
    c.UntilGoldLeft()
    c.UntilDig('Right', 'B')
    c.ClimbUntil(6)
    c.UntilDig('Right', 'B')
    c.UntilGoldLeft()
    c.UntilGoldLeft()
    c.GrabLadderRight()
    c.ClimbUntil(5)

    c.Assert(c.FrameSearch(function() return c.GrabLadderLeft() end))
    c.ClimbUntil(3)
    c.GrabLadderLeft()

    c.BestOf({
        function()
            c.ClimbUntil(1)
            c.GrabLadderRight()
            return c.ClimbUntilLevelEnd()
        end,
        -- function()
        --     c.ClimbUntil(2)
        --     c.GrabLadderRight()
        --     return c.ClimbUntilLevelEnd()
        -- end,
    })

    c.Marker('lv 24 end')

    c.Done()
end

c.Finish()
