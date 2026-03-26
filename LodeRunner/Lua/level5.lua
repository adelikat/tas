-- Start at the end of a level, where pressing up for 1 frame will end the level
dofile('lode-runner-core.lua')

c.Start()

local function E2Fall()
    c.Climb(2)
    return c.Enemy(2).yPos() > 12
end

local function FirstDig()
    function dig()
        c.Climb(2)
        local result = c.UntilDig('Up', 'A')
        if not result then
            return false
        end

        c.Save('temp')
        c.WaitFor(20)
        local enemyPos = c.Enemy(3).xPos()
        result = c.Enemy(3).xPos() == 1.375
        c.Load('temp')
        return result
    end

    function grab()
        return c.UntilLadderGrab('Right')
    end

    local result = c.FrameSearch(dig, 10)
    if not result then
        return false
    end

    c.WaitFor(2)
    return c.FrameSearch(grab, 15)
end

--

local function Fall()
    c.ClimbDown(2)
    c.UntilFall('Right')
    c.FinishFalling()
    c.RightFor(1)
    c.UntilFall('Right')
    c.FinishFalling()
    c.RightFor(1)
    return true
end

local function ClimbAllTheWayDown()
    c.ClimbDown(3)
    c.RightFor(2)
    return true
end

--

local function Right3Tiles()
    local result = c.RightFor(3)
    if not result then
        return false
    end

    return c.Player().yPos() < 12
end

--

local function GrabFinalLadder()
    c.PushFor('Left', 2)
    c.FinishFalling()
    return c.UntilLadderGrab('Left', 'Down')
end

local function GoUpFinalLadder()
    local result = c.Climb(4)
    if not result then
        return false
    end

    c.ClimbUntilLevelEnd()
    return true
end

while not c.IsDone() do
    c.UntilLadderGrab('Left')
    local result = c.FrameSearch(E2Fall, 5)
    if not result then
        error('Failed to manip E2')
    end

    FirstDig()

    c.Climb(3)
    c.UntilGold('Left')
    c.UntilLadderGrab('Right', 'Down')

    Fall()

    c.UntilDig('Right', 'A')
    c.WaitFor(2)
    c.FrameSearch(Right3Tiles, 25)

    c.UntilLadderGrab('Right')
    c.ClimbUntil(8)
    c.UntilGold('Right')
    c.UntilLadderGrab('Left')
    c.ClimbUntil(5)
    c.RightFor(6)
    c.UntilGold('Right')
    c.UntilLadderGrab('Left')
    c.ClimbUntil(1)
    c.LeftFor(2)
    c.UntilFall('Left')

    c.LeftFor(4)
    c.FinishFalling()

    local result = c.FrameSearch(GrabFinalLadder, 15)
    if not result then
        error('could not grab final ladder')
    end

    local result = c.FrameSearch(GoUpFinalLadder, 15)
    if not result then
        error('could not climb final ladder')
    end

    c.Marker('lv 5 end')

    c.Done()
end

c.Finish()
