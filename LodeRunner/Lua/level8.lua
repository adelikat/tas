-- Start at the end of a level, where pressing up for 1 frame will end the level
dofile('lode-runner-core.lua')

c.Start()

--Right until ladder, then down
local function LeftFall1()
    c.RightUntil(9)
    c.ClimbDown()
    c.FinishFalling()
    c.ClimbUntil(12)
    c.RightUntil(11)
    return true
end

-- Right one, fall on brick, run right
local function LeftFall2()
    c.RightFor(1)
    c.FinishFalling()
    c.PushDown()
    c.FinishFalling()
    c.PushDown()
    c.FinishFalling()
    c.RightUntil(11)
    return true
end

-- Right 2, fall to ground, run right
local function LeftFall3()
    c.RightFor(2)
    c.PushDown()
    c.FinishFalling()
    c.PushDown()
    c.FinishFalling()
    c.RightUntil(11)
    return true
end

--Down ladder for 1, then to right and fall
local function LeftFall4()
    c.ClimbDown()
    c.RightUntil(9)
    c.ClimbDown()
    c.FinishFalling()
    c.ClimbUntil(12)
    c.RightUntil(11)
    return true
end

-- Down ladder until pole, then right down
local function LeftFall5()
    c.ClimbDown(6)
    c.RightUntil(9)
    c.ClimbUntil(12)
    c.RightUntil(11)
    return true
end

-- so many ways to do this one thing!
-- same as 5 but go right 1 square from the bottom
local function LeftFall6()
    c.ClimbDown(6)
    c.RightUntil(9)
    c.ClimbUntil(11)
    c.RightUntil(11)
    return true
end

-- Left until ladder and climb
local function RightFall1()
    c.LeftUntil(18)
    c.Climb()
    c.Fall('Left')
    return true
end

-- Climb down then left
local function RightFall2()
    c.ClimbDown()
    c.LeftUntil(18)
    c.Climb()
    c.Fall('Left')
    return true
end

-- Climb down and ensure E2 follows
local function WaitForEnemy()
    c.ClimbDown(2)
    return c.Enemy(2).xPos() > 14
end

local function FallThenGo()
    c.Fall('Left')
    c.UntilLadderGrab('Left')
    c.ClimbUntilLevelEnd()
    return true
end

local function ClimbDownThenGo()
    c.ClimbDown()
    c.UntilLadderGrab('Left')
    c.ClimbUntilLevelEnd()
end

while not c.IsDone() do
    c.UntilLadderGrab('Left')
    c.ClimbUntil(1)
    c.RightFor(1)
    c.UntilDig('Right', 'A')
    c.UntilFall('Right')
    c.Fall('Right')
    c.RightUntil(4)
    c.UntilDig('Left', 'B')
    c.Fall('Left')
    c.UntilLadderGrab('Left')
    c.ClimbUntil(10)

    c.PushUp() -- This might be variable but this exact input worked and better than the built in methods
    c.WaitFor(4)
    c.PushFor('Up', 3)

    c.FrameSearch(function() return c.Climb(4) end)
    c.ClimbUntil(1)
    c.RightUntil(6)

    c.BestOf({
        LeftFall1,
        LeftFall2,
        LeftFall3,
        LeftFall4,
        LeftFall5,
        LeftFall6,
    })


    c.UntilLadderGrab('Right')
    c.ClimbUntil(7)
    c.UntilLadderGrab('Right')
    c.ClimbUntil(1)
    c.RightFor(1)
    c.UntilDig('Right', 'A')
    c.Fall('Right')
    c.RightUntil(25)
    c.UntilDig('Left', 'B')
    c.Fall('Left')
    c.UntilLadderGrab('Right')

    c.ClimbUntil(8)
    c.PushUp()
    c.FrameSearch(function() return c.Climb(4) end)
    c.ClimbUntil(1)
    c.LeftUntil(21)

    c.BestOf({
        RightFall1,
        RightFall2,
    })

    c.FrameSearch(WaitForEnemy, 25)

    c.BestOf({
        FallThenGo,
        ClimbDownThenGo,
    })

    c.Marker('lv 8 end')

    c.Done()
end

c.Finish()
