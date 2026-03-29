-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 5 then
    error('must be run in level 5')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

local function FirstDig()
    function dig()
        c.ClimbUntil(8)
        local result = c.UntilDig('Up', 'A')
        if not result then return false end

        c.Save('temp')
        c.WaitFor(20)
        local enemyPos = c.Enemy(3).xPos()
        result = c.Enemy(3).xPos() == 1.375
        c.Load('temp')
        return result
    end

    local result = c.FrameSearch(dig)
    if not result then return false end

    c.WaitFor(2)
    return c.FrameSearch(c.GrabLadderRight)
end

while not c.IsDone() do
    c.LeftUntil(0)

    c.Assert(c.FrameSearch(function()
        c.ClimbUntil(10)
        return c.Enemy(2).yPos() > 12
    end))

    c.ClimbUntil(8)
    c.WaitFor(1) -- Hardcoded delay for E2 spawn
    c.UntilDig('Right', 'A')
    c.FrameSearch(c.GrabLadderRight)

    c.ClimbUntil(5)
    c.UntilGold('Left')
    c.GrabLadderRight('Down')

    c.ClimbUntil(7)
    c.FallRight()
    c.RightFor(1)

    -- Alternatively it looks like you could climb down the ladder for a tile then fall
    -- But then E3 will not die
    c.FallRight()
    c.RightFor(1)

    c.UntilDig('Right', 'A')

    c.FrameSearch(function()
        local result = c.RightFor(3)
        if not result then return false end
        return c.Player().yPos() < 12
    end)

    c.RightUntil(18)
    c.GrabLadderRight()
    c.ClimbUntil(8)
    c.UntilGold('Right')
    c.LeftFor(5)
    c.GrabLadderLeft()
    c.ClimbUntil(5)
    c.RightFor(6)
    c.UntilGold('Right')
    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.LeftFor(2)
    c.FallLeft()

    c.LeftFor(4)
    c.FinishFalling()

    c.Assert(c.FrameSearch(function()
        c.LeftFor(1)
        c.FinishFalling()
        local result = c.GrabLadderLeft('Down')
        if not result then return false end
        local isAlive = false
        c.Save('temp')
        c.WaitFor(2)
        isAlive = c.Player().isAlive
        c.Load('temp')
        return isAlive

    end))

    c.Assert(c.FrameSearch(function()
        return c.ClimbUntil(2)
    end))

    c.ClimbUntilLevelEnd()

    c.Marker('lv 5 end')

    c.Done()
end

c.Finish()
