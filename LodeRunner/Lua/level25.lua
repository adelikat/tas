-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 25 then
    error('must be run in level 25')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.UntilGoldLeft()
    c.GrabLadderLeft('Down')
    c.ClimbUntil(5)

    c.RightUntil(4)
    c.PushDown()
    c.FinishFalling()
    c.UntilDig('Right', 'B')
    c.FallLeft()
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.RightFor(3)
    c.GrabLadderRight()
    c.ClimbUntil(10)
    c.GrabLadderRight()
    c.ClimbUntil(7)
    c.GrabLadderRight()
    c.ClimbUntil(3)

    c.LeftUntil(3)
    c.GrabLadderLeft('Down')
    c.ClimbUntil(5)
    c.RightUntil(8)
    c.PushDown()
    c.FinishFalling()

    c.ClimbUntil(10)
    c.RightUntil(9)
    c.GrabLadderRight()
    c.ClimbUntil(7)
    c.GrabLadderRight()
    c.ClimbUntil(6)
    c.RightUntil(15)
    c.GrabLadderRight('Down')
    c.ClimbUntil(8)
    c.FinishFalling()
    c.LeftFor(1)
    c.UntilDig('Left', 'B')
    c.FallLeft()

    c.FallLeft()
    c.GrabLadderLeft()
    c.ClimbUntil(10)
    c.GrabLadderRight()
    c.ClimbUntil(7)
    c.GrabLadderRight()
    c.ClimbUntil(6)
    c.RightFor(2)
    c.GrabLadderRight()
    c.ClimbUntil(2)
    c.LeftFor(1)
    c.UntilDig('Left', 'B')
    c.FallLeft()
    c.FallLeft()
    c.GrabLadderRight()
    c.ClimbUntil(1)
    c.RightUntil(19)
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.RightFor(1)
    c.FallRight()

    -- --c.GrabLadderLeft() -- This fails for some reason so hardcoding this time (probably due to isFalling being true on the first frame?)
    c.PushLeft()
    c.PushUp()

    c.ClimbUntil(5)
    c.FallLeft()
    c.GrabLadderRight()
    c.ClimbUntil(5)

    -- We must at least delay enough to climb past the enemies safely
    c.Assert(c.FrameSearch(function()
        return c.Enemy(2).yPos() < 8
    end))

    -- Now we want to delay to get the magic enemy spawn in order to shortcut over the enemy
    c.Assert(c.FrameSearch(function()
        c.Debug(string.format('Attempting on frame %s', emu.framecount()))
        local result = c.FallRight()
        if not result then return false end
        result = c.GrabLadderRight('Down')
        if not result then return false end
        result = c.ClimbUntil(11)
        if not result then return false end
        c.UntilDig('Left', 'A')
        c.UntilDig('Left', 'A')
        c.UntilGoldLeft()
        c.Assert(c.FrameSearch(c.GrabLadderRight))
        c.ClimbUntil(9)
        c.GrabLadderRight()
        c.ClimbUntil(1)
        c.LeftFor(1)
        c.WaitFor(4)
        c.Debug(string.format('Enemy Spawn: %s', c.Enemy(1).levelX))
        return c.Enemy(1).levelX == 24
    end, 50))

    c.Assert(c.FrameSearch(function()
        return c.LeftUntil(22)
    end))

    c.LeftUntil(5)
    c.FallLeft()
    c.FinishFalling()
    c.GrabLadderLeft()
    c.ClimbUntilLevelEnd()

    c.Marker('lv 25 end')

    c.Done()
end

c.Finish()
