-- Start at the end of a level, where pressing up for 1 frame will end the level
dofile('lode-runner-core.lua')

c.Start()


-- Options for top left section after getting 1st gold
local function RightDown()
    c.RightFor(3)
    c.ClimbDown(2)
    c.FinishFalling()
    c.RightFor(1)
    c.UntilGold('Right')
    return true
end

local function DownThenRight()
    c.ClimbDown(3)
    c.UntilGold('Right')
    c.RightFor(1)
    c.UntilGold('Right')

    return true
end

local function DownRightDown()
    c.RightFor(1)
    c.ClimbDown()
    c.RightFor(1)
    c.ClimbDown()
    c.RightFor(1)
    c.ClimbDown()
    c.FinishFalling()
    c.RightFor(2)
    c.UntilGold('Right')

    return true
end

local function DownRightDown2()
    c.RightFor(1)
    c.ClimbDown(2)
    c.FinishFalling()
    c.UntilGold('Right')
    c.RightFor(2)
    c.UntilGold('Right')

    return true
end

--

-- Options on top left after getting last gold (on top right)
local function JustLeft()
    c.LeftFor(3)
    c.UntilLadderGrab('Left')
    return true
end

local function DownThenLeft()
    c.ClimbDown()
    c.LeftFor(3)
    c.UntilLadderGrab('Left')
    return true
end

local function LeftDownLeft()
    c.LeftFor(1)
    c.ClimbDown()
    c.LeftFor(1)
    c.UntilLadderGrab('Left')
    return true
end

--Options for top right after getting right most gold, gets gold in middle and falls
local function ZigZag()
    c.ClimbDown()
    c.LeftFor(1)
    c.ClimbDown()
    c.FinishFalling()
    c.UntilGold('Left')
    c.UntilLadderGrab('Right', 'Down')
    return true
end

local function LeftThenDown()
    c.LeftFor(3)
    c.ClimbDown(2)
    c.FinishFalling()
    c.UntilLadderGrab('Right', 'Down')
    return true
end

local function Left2DownLeft()
    c.LeftFor(2)
    c.FinishFalling()
    c.ClimbDown(2)
    c.FinishFalling()
    c.UntilGold('Left')
    c.UntilLadderGrab('Right', 'Down')
    return true
end

--

local function FindLatest()
    c.Save('temp')
    local origFrame = emu.framecount()

    local done = false
    local delay = 0

    while not done do
        c.Load('temp')
        c.WaitFor(delay)
        c.Climb()
        if not c.Player().isAlive then
            done = true
        else
            delay = delay + 1
        end
    end


    c.Load('temp')
    console.log('found death at delay ' .. delay)
    return delay - 1
end

local function FromRightUntilEnd()
    c.UntilFall('Left')
    c.FinishFalling()
    c.LeftFor(12)

    local delayAmt = FindLatest()
    console.log('waiting for ' .. delayAmt .. ' frames')
    c.WaitFor(delayAmt)
    c.Climb(3)
    local result = c.UntilLadderGrab('Left')
    if not result then
        return false
    end

    c.ClimbUntilLevelEnd()
    return true
end

while not c.IsDone() do
    c.LeftFor(5)
    c.UntilLadderGrab('Left')
    c.Climb(10)
    c.RightFor(2)

    c.PushDown()
    c.WaitFor(2)
    c.FinishFalling()

    c.BestOf({
        RightDown,
        DownThenRight,
        DownRightDown,
        DownRightDown2,
    })

    --DownRightDown()

    c.UntilLadderGrab('Right')
    c.UntilGold('Up')

    c.BestOf({
        JustLeft,
        DownThenLeft,
        LeftDownLeft,
    })

    --JustLeft()

    c.Climb(2)
    c.UntilFall('Right')
    c.UntilDigAppears('Right', 'A')
    c.UntilFall('Right')
    c.FinishFalling()
    c.ClimbDown(4)
    c.FinishFalling()
    c.UntilLadderGrab('Right')

    c.Climb(3)
    c.UntilLadderGrab('Right')
    c.Climb()
    c.UntilLadderGrab('Left')
    c.UntilGold('Up')

    c.RightFor(6)
    c.UntilLadderGrab('Right')
    c.Climb()
    c.UntilGold('Right')

    c.BestOf({
        ZigZag,
        LeftThenDown,
        Left2DownLeft,
    })

    --ZigZag()


    c.ClimbDown(3)
    c.FinishFalling()
    c.UntilGold('Left')
    c.LeftFor(3)

    local result = c.FrameSearch(FromRightUntilEnd, 10)
    if not result then
        error('could not find ending delay')
    end

    c.Marker('lv 4 end')
    c.Done()

end

c.Finish()
