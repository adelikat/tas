-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 39 then
    error('must be run in level 39')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.UntilGoldLeft()
    c.RightUntil(25)
    c.GrabLadderRight()

    c.ClimbUntil(8)
    c.PushUp() -- should be precisely 7.500

    c.Assert(c.FrameSearch(function()
        return c.ClimbUntil(1)
    end))

    c.LeftUntil(22)
    c.GrabLadderLeft('Down') -- not a ladder but it works
    c.FinishFalling()
    c.GrabLadderLeft('Down')
    c.ClimbUntil(4)

    c.GrabLadderLeft('Down')
    c.ClimbUntil(5)
    c.GrabLadderLeft('Down')
    c.ClimbUntil(7)
    c.LeftUntil(13)
    c.GrabLadderLeft()
    c.ClimbUntil(5)
    c.GrabLadderLeft()
    c.ClimbUntil(4)
    c.GrabLadderLeft()
    c.ClimbUntil(2)
    c.UntilGoldLeft()
    c.GrabLadderRight()
    c.ClimbUntil(1)
    c.LeftFor(3)
    c.GrabLadderLeft('Down')

    c.PushDown()
    c.Assert(c.FrameSearch(function()
        local result = c.ClimbUntil(1)
        if not result then return false end
        return c.LeftFor(2)
    end))

    c.GrabLadderLeft()
    c.ClimbUntilLevelEnd()

    c.Marker('lv 39 end')

    c.Done()
end

c.Finish()
