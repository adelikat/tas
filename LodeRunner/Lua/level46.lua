-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 46 then
    error('must be run in level 46')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    -- c.LeftUntil(8)
    -- c.GrabLadderLeft()
    -- c.ClimbUntil(8)
    -- c.UntilGoldLeft()

    -- c.RightUntil(6)
    -- c.PushBtnsFor({'Right', 'Down'}, 5) -- Random btns that make E2 lag enough to walk over him at the top
    -- c.RightUntil(8)
    -- --c.GrabLadderRight()
    -- c.ClimbUntil(6)

    -- c.WaitFor(1)
    -- c.Assert(c.FrameSearch(function()
    --     if not c.ClimbUntil(5) then return false end
    --     if not c.UntilGoldLeft() then return false end
    --     if not c.GrabLadderRight() then return false end
    --     return c.ClimbUntil(3)
    -- end))

    -- c.UntilGoldLeft()
    -- c.GrabLadderRight()
    -- c.ClimbUntil(1)
    -- c.RightUntil(9)

    -- c.UntilDig('Right', 'A')
    -- c.LeftUntil(7)
    -- c.UntilDig('Left', 'A')
    -- c.UntilGoldLeft()
    -- c.RightUntil(6)
    -- c.Assert(c.FallRight())

    -- c.RightUntil(14)
    -- c.GrabLadderRight()
    -- c.ClimbUntil(2)

    -- c.Marker('temp')

    -- c.ClimbUntilGold('Right')
    -- c.RightUntil(26)
    -- c.UntilDig('Right', 'B')
    -- c.FallLeft()
    -- c.GrabLadderLeft('Down')
    -- c.ClimbUntil(7)
    -- c.LeftUntil(15)
    -- c.GrabLadderLeft('Down')
    -- c.ClimbUntil(9)
    -- c.RightUntil(25)
    -- c.UntilDig('Right', 'A')
    -- c.FallRight()
    -- c.LeftUntil(20)

    -- c.Marker('temp')

    c.WaitFor(10)
    c.Assert(c.FrameSearch(function()
        if not c.ClimbUntil(9) then return false end
        if not c.LeftUntil(14) then return false end
        if not c.GrabLadderLeft() then return false end
        return c.ClimbUntil(7)
    end))

    c.LeftFor(2)
    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.RightFor(1)
    c.GrabLadderRight()
    c.ClimbUntilLevelEnd()

    c.Done()
end

c.Finish()
