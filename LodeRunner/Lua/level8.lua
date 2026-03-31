-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 8 then
    error('must be run in level 8')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

--Right until ladder, then down
local function LeftFall1()
    c.RightUntil(9)
    c.ClimbUntil(2)
    c.FinishFalling()
    c.ClimbUntil(12)
    c.RightUntil(11)
    return true
end

-- Right one, fall on brick, run right
local function LeftFall2()
    c.FallRight()
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
    c.ClimbUntil(2)
    c.RightUntil(9)
    c.ClimbUntil(3)
    c.FinishFalling()
    c.ClimbUntil(12)
    c.RightUntil(11)
    return true
end

-- Down ladder until pole, then right down
local function LeftFall5()
    c.ClimbUntil(7)
    c.RightUntil(9)
    c.ClimbUntil(12)
    c.RightUntil(11)
    return true
end

-- so many ways to do this one thing!
-- same as 5 but go right 1 square from the bottom
local function LeftFall6()
    c.ClimbUntil(7)
    c.RightUntil(9)
    c.ClimbUntil(11)
    c.RightUntil(11)
    return true
end

while not c.IsDone() do
    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.RightFor(1)
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.RightUntil(4)
    c.UntilDig('Left', 'B')
    c.FallLeft()
    c.GrabLadderLeft()
    c.ClimbUntil(10)

    -- Hardcoded magic frames that depend on the Enemy being in precise places
    -- Delays and extraneous input can manip the enemy into the ideal place
    c.WaitFor(1)
    c.PushFor('Up', 3)

    c.Assert(c.FrameSearch(function() return c.ClimbUntil(6) end))
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

    c.GrabLadderRight()
    c.ClimbUntil(7)
    c.GrabLadderRight()
    c.ClimbUntil(1)
    c.RightFor(1)
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.RightUntil(25)
    c.WaitFor(1) -- Magic frame that made enemy in the ideal place and maybe reduced lag?
    c.UntilDig('Left', 'B')

    -- Hardcoded magic frames that depend on the Enemy being in precise places
    -- Delays and possibly extraneous input can manip the enemy into the ideal place
    c.FallLeft()
    c.GrabLadderRight()

    c.ClimbUntil(8)

    c.PushUp()
    c.FrameSearch(function() return c.ClimbUntil(1) end)

    c.LeftUntil(21)

    c.BestOf({
        function()
            c.LeftUntil(18)
            c.ClimbUntil(1)
            return c.FallLeft()
        end,
        function()
            c.ClimbUntil(2)
            c.LeftUntil(18)
            c.ClimbUntil(1)
            return c.FallLeft()
        end
    })

    c.Assert(c.FrameSearch(function()
        c.ClimbUntil(8)
        return c.Enemy(2).xPos() > 14
    end))

    c.BestOf({
        function()
            c.FallLeft()
            c.GrabLadderLeft()
            return c.ClimbUntilLevelEnd()
        end,
        function()
            c.ClimbUntil(9)
            c.GrabLadderLeft()
            return c.ClimbUntilLevelEnd()
        end,
    })

    c.Marker('lv 8 end')

    c.Done()
end

c.Finish()
