-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 27 then
    error('must be run in level 27')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.UntilDig('Left', 'B')
    c.WaitFor(1) -- Manip E3 spawn
    c.FallLeft()
    c.LeftFor(1)
    c.UntilDig('Left', 'B')

    c.FallLeft()
    c.UntilDig('Right', 'B')
    c.FallLeft()
    c.GrabLadderLeft()
    c.ClimbUntil(7)
    c.UntilGoldRight()
    c.Assert(c.WalkOverEnemy('Right'))
    c.GrabLadderRight()
    c.ClimbUntil(5)

    c.Assert(c.FrameSearch(function()
        c.ClimbUntil(1)
        c.RightFor(1)
        c.UntilDig('Right', 'A')
        c.FallRight()
        c.GrabLadderLeft()
        c.ClimbUntil(1)
        c.LeftFor(2)
        c.UntilDig('Left', 'B')
        c.FallLeft()
        c.FallRight()
        c.GrabLadderRight()
        c.ClimbUntil(1)
        c.RightUntil(11)
        c.PushDown()
        c.FinishFalling()
        c.UntilDig('Right', 'B')
        c.FallLeft()

        return c.Enemy(1).levelX < 16
    end))

    c.Done()
end

c.Finish()
