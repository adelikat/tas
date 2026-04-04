-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 26 then
    error('must be run in level 26')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.RightFor(1)
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.FallLeft()
    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.Assert(c.FrameSearch(function()
        local result = c.RightFor(3)
        if not result then return false end
        return c.Player().levelY == 1
    end))

    c.UntilDig('Right', 'A')
    c.FallRight()
    c.RightFor(1)
    c.UntilDig('Right', 'A')
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.UntilDig('Right', 'B')
    c.UntilDig('Right', 'B')
    c.FallLeft()
    c.UntilDig('Left', 'A')
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.UntilDig('Right', 'B')
    c.FallLeft()
    c.UntilDig('Left', 'A')
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.GrabLadderRight()
    c.ClimbUntil(1)
    c.LeftFor(1)
    c.UntilDig('Left', 'B')
    c.FallLeft()
    c.FallRight()
    c.GrabLadderRight()
    c.ClimbUntil(2)
    c.RightFor(1)

    c.Assert(c.FrameSearch(function()
        c.UntilDig('Right', 'A')
        c.FallRight()
        c.FallRight()
        c.LeftFor(1)
        c.PushDown()
        c.FinishFalling()
        c.FallRight()
        c.RightUntil(24)
        c.GrabLadderRight()
        c.ClimbUntil(11)
        local eX = c.Enemy(3).levelX
        console.log(string.format('enemy X: %s', eX))
        return eX > 17 -- TODO: there might be some bad values after 17 but did not test because I got a good value right away
    end))

    c.ClimbUntil(9)
    c.GrabLadderRight()
    c.ClimbUntilGold('Down')
    c.ClimbUntil(9)
    c.GrabLadderLeft()
    c.ClimbUntil(7)
    c.UntilGoldLeft()

    c.BestOf({
        function()
            c.LeftUntil(20)
            c.PushDown()
            c.FinishFalling()
            return c.FallLeft()
        end,
        function()
            c.LeftUntil(19)
            c.PushDown()
            c.FinishFalling()
            return c.FallLeft()
        end,
    })

    c.LeftUntil(2)
    c.GrabLadderLeft()
    c.ClimbUntil(10)
    c.RightUntil(9)
    c.GrabLadderRight()
    c.ClimbUntil(1)

    c.Assert(c.FrameSearch(c.UntilGoldRight))

    c.Assert(c.FrameSearch(function()
        return c.RightUntil(22)
    end))

    c.GrabLadderRight()
    c.ClimbUntil(1)
    c.UntilGoldLeft()
    c.GrabLadderRight()
    c.ClimbUntilLevelEnd()

    c.Marker('lv 26 end')

    c.Done()
end

c.Finish()
