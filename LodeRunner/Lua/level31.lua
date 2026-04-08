-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 31 then
    error('must be run in level 31')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

-- Note this is not generates the final input!!!
-- ClimbUntilGold had a different algorithm where it never attempted U+L or U+R, this made the final one slower so it was fixed
-- However, it made the previous ones slower?? due to lag perhaps, this needs to be reworked if used
while not c.IsDone() do
    c.UntilGoldRight()
    c.GrabLadderLeft()
    c.ClimbUntil(11)
    c.GrabLadderLeft()

    c.BestOf({
        function()
            c.ClimbUntilGold('Left')
            c.FallLeft()
            return c.GrabLadderLeft()
        end,
        function()
            c.ClimbUntilGold('Down')
            c.ClimbUntil(9)
            return c.GrabLadderLeft()
        end,
    })

    c.ClimbUntil(8)
    c.GrabLadderLeft()
    c.ClimbUntil(7)
    c.GrabLadderLeft()

    c.BestOf({
        function()
            c.ClimbUntilGold('Left')
            c.FallLeft()
            return c.GrabLadderLeft()
        end,
        function()
            c.ClimbUntilGold('Down')
            c.ClimbUntil(5)
            return c.GrabLadderLeft()
        end,
    })

    c.ClimbUntil(4)
    c.GrabLadderLeft()
    c.ClimbUntil(3)
    c.GrabLadderLeft()

    c.BestOf({
        function()
            c.ClimbUntil(2)
            c.GrabLadderLeft()
            c.ClimbUntil(1)
            return c.UntilGoldLeft()
        end,
        function()
            c.ClimbUntil(1)
            return c.UntilGoldLeft()
        end,
    })

    c.FallRight()
    c.RightUntil(15)
    c.PushDown()
    c.FinishFalling()

    c.RightUntil(18)
    c.PushDown()
    c.FinishFalling()

    c.BestOf({
        function()
            c.FallRight()
            return c.GrabLadderRight()
        end,
        function()
            c.ClimbUntil(7)
            return c.GrabLadderRight()
        end,
    })

    c.BestOf({
        function()
            c.ClimbUntil(5)
            return c.GrabLadderRight()
        end,
        function()
            c.ClimbUntil(6)
            c.GrabLadderRight()
            c.ClimbUntil(5)
            return c.GrabLadderRight()
        end,
    })

    c.ClimbUntilGold('Right')
    c.FallRight()
    c.GrabLadderRight()

    c.BestOf({
        function()
            c.ClimbUntil(1)
            return c.UntilGoldRight()
        end,
        function()
            c.ClimbUntil(2)
            c.GrabLadderRight()
            c.ClimbUntil(1)
            return c.UntilGoldRight()
        end,
    })

    c.LeftFor(7)
    c.GrabLadderLeft()
    c.ClimbUntilLevelEnd()

    c.Marker('lv 31 end')

    c.Done()
end

c.Finish()
