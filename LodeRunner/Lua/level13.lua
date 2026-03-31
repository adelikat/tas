-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 13 then
    error('must be run in level 13')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    -- This causes E1 to lag by a pixel, just enough to die from the dig
    -- This may not be necessary, remove if he dies without it
    --c.PushBtnsFor({'Left', 'Down'}, 15)
    c.UntilGoldLeft()
    c.GrabLadderLeft()
    c.ClimbUntil(8)
    c.RightFor(3)
    c.UntilDig('Right', 'B')
    c.ClimbUntil(4)
    c.FallRight()
    c.LeftFor(1)
    c.Assert(c.FrameSearch(c.GrabLadderLeft))

    c.ClimbUntil(1)
    c.FallLeft()
    c.RightUntil(6)
    c.GrabLadderRight()
    c.ClimbUntil(1)
    c.FallRight()
    c.RightFor(2)
    c.GrabLadderRight()
    c.ClimbUntil(4)
    c.FallRight()

    c.RightFor(2)
    c.GrabLadderRight()
    c.ClimbUntil(1)
    c.FallRight()

    c.RightFor(2)
    c.GrabLadderRight()
    c.ClimbUntil(4)
    c.FallRight()

    c.RightFor(2)
    c.GrabLadderRight()
    c.ClimbUntil(1)
    c.FallRight()

    c.UntilDig('Left', 'B')
    c.FallLeft()
    c.UntilGoldLeft()
    c.UntilGoldLeft()
    c.FallRight()
    c.UntilGoldLeft()
    c.GrabLadderRight()
    c.ClimbUntilLevelEnd()

    -- c.Marker('lv 13 end')

    c.Done()
end

c.Finish()
