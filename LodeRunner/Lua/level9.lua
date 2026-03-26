-- Start at the end of a level, where pressing up for 1 frame will end the level
dofile('lode-runner-core.lua')

c.Start()

local function TrapEnemy()
    c.ClimbUntil(1)
    return c.Enemy(1).yPos() >= 2
end

local function Cycle2Route1()
    c.PushDown()
    c.UntilDig('Right', 'A')
end

while not c.IsDone() do
    c.UntilLadderGrab('Left')
    c.ClimbUntil(1)
    c.RightUntil(25)

    --c.WaitFor(1) -- We have to wait anyway at the ladder, might as well use those frames to help with lag

    c.PushDown()
    c.FinishFalling()
    c.UntilDig('Right', 'A')
    c.UntilDig('Left', 'A')
    c.UntilDig('Left', 'A')
    c.Fall('Right')
    c.UntilDig('Right', 'B')
    c.UntilDig('Right', 'B')
    c.Fall('Left')
    c.UntilDig('Left', 'A')
    c.UntilGold('Left')
    c.Fall('Right')
    c.ClimbUntil(11)
    c.LeftFor(1)
    c.UntilLadderGrab('Left')
    c.Climb()
    c.LeftUntil(13)
    c.UntilDig('Left', 'B')
    c.LeftUntil(2)
    c.UntilLadderGrab('Left')

    c.ClimbUntil(1)
    c.RightUntil(13)
    c.PushDown()
    c.FinishFalling()
    c.UntilDig('Right', 'A')
    c.UntilDig('Left', 'A')
    c.Fall('Right')
    c.UntilDig('Right', 'A')
    c.Fall('Right')
    c.UntilDig('Right', 'B')
    c.UntilDig('Right', 'B')
    c.Fall('Left')
    c.UntilDig('Left', 'B')
    c.Fall('Left')
    c.LeftUntil(13)
    c.UntilDig('Left', 'B')
    c.LeftUntil(2)
    c.UntilLadderGrab('Left')

    c.ClimbUntil(5)
    c.FrameSearch(TrapEnemy)
    c.RightUntil(9)

    c.PushDown()
    c.FinishFalling()
    c.UntilDig('Right', 'A')
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.UntilGold('Right')
    c.UntilDig('Left', 'A')
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.UntilDig('Right', 'B')
    c.LeftUntil(2)
    c.UntilLadderGrab('Left')
    c.ClimbUntilLevelEnd()

    c.Marker('lv 9 end')

    c.Done()
end

c.Finish()
