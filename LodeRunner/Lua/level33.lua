-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 33 then
    error('must be run in level 33')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.UntilGoldRight()
    c.LeftFor(6)
    c.GrabLadderLeft()
    c.ClimbUntil(8)
    c.UntilGoldRight()
    c.GrabLadderLeft()
    c.ClimbUntil(4)
    c.RightUntil(9)
    c.BestOf({
        function()
            c.UntilGoldRight()
            return c.GrabLadderLeft()
        end,
        function()
            c.GrabLadderRight('Down')
            c.ClimbUntil(5)
            c.UntilGoldRight()
            return c.GrabLadderLeft()
        end
    })

    c.ClimbUntil(4)
    c.LeftFor(1)
    c.GrabLadderLeft('Down')
    c.ClimbUntil(7)
    c.FinishFalling()
    c.FallRight()
    c.RightUntil(14)
    c.UntilDig('Right', 'A')
    c.RightUntil(26)

    c.BestSearch(function()
        c.GrabLadderRight()
        c.ClimbUntil(11)
        c.LeftFor(1)
        local result = c.UntilDig('Left', 'B')
        if not result then return false end
        result = c.UntilDig('Right', 'B')
        if not result then return false end
        result = c.WalkOverEnemy('Left')
        if not result then return false end
        c.LeftFor(1)
        c.GrabLadderLeft()
        c.ClimbUntil(1)
        c.RightFor(1)
        c.UntilDig('Right', 'A')
        c.FallRight()
        c.UntilDig('Right', 'A')
        c.FallRight()
        result = c.LeftUntil(16)
        if not result then return false end
        result = c.GrabLadderLeft()
        if not result then return false end
        result = c.ClimbUntil(1)
        if not result then return false end
        c.RightUntil(17)
        c.UntilDig('Right', 'A')
        c.UntilDig('Left', 'A')
        c.FallRight()
        c.UntilDig('Right', 'A')
        c.FallRight()
        c.UntilDig('Right', 'B')
        c.FallLeft()
        c.GrabLadderLeft()
        c.ClimbUntil(1)
        c.Assert(c.LeftUntil(2))
        c.GrabLadderLeft()
        c.ClimbUntil(1)
        c.RightUntil(2)
        c.GrabLadderRight()
        return c.ClimbUntilLevelEnd()
    end, 10)

    c.Marker('lv 33 end')

    c.Done()
end

c.Finish()
