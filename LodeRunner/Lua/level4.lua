-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 4 then
    error('must be run in level 4')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

-- Options for top left section after getting 1st gold
local function RightDown()
    c.RightUntil(5)
    c.ClimbUntil(5)
    c.FinishFalling()
    c.RightFor(3)
    c.GrabLadderRight()
    return true
end

local function DownThenRight()
    c.ClimbUntil(5)
    c.RightFor(6)
    c.GrabLadderRight()
    return true
end

local function DownRightDown()
    c.RightFor(1)
    c.ClimbUntil(3)
    c.RightFor(1)
    c.ClimbUntil(4)
    c.RightFor(1)
    c.ClimbUntil(5)
    c.FinishFalling()
    c.RightFor(2)
    c.GrabLadderRight()
    return true
end

local function DownRightDown2()
    c.RightFor(1)
    c.ClimbUntil(4)
    c.FinishFalling()
    c.RightFor(5)
    c.GrabLadderRight()
    return true
end

--

-- Options on top left after getting last gold (on top right)
local function DownThenLeft()
    c.ClimbUntil(3)
    c.LeftFor(3)
    c.GrabLadderLeft()
    return true
end

local function LeftDownLeft()
    c.LeftFor(1)
    c.ClimbUntil(3)
    c.LeftFor(2)
    c.GrabLadderLeft()
    return true
end

--Options for top right after getting right most gold, gets gold in middle and falls
local function ZigZag()
    c.ClimbUntil(3)
    c.LeftFor(1)
    c.ClimbUntil(4)
    c.FinishFalling()
    c.UntilGold('Left')
    c.GrabLadderRight('Down')
    return true
end

local function LeftThenDown()
    c.LeftFor(3)
    c.ClimbUntil(5)
    c.FinishFalling()
    c.RightFor(2)
    c.GrabLadderRight('Down')
    return true
end

local function Left2DownLeft()
    c.FallLeft()
    c.ClimbUntil(5)
    c.FinishFalling()
    c.UntilGold('Left')
    c.RightFor(2)
    c.GrabLadderRight('Down')
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
        c.ClimbUntil(11)
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
    c.FallLeft()
    c.LeftFor(12)

    local delayAmt = FindLatest()
    console.log('waiting for ' .. delayAmt .. ' frames')
    c.WaitFor(delayAmt)
    c.ClimbUntil(9)
    local result = c.GrabLadderLeft()
    if not result then return false end

    c.ClimbUntilLevelEnd()
    return true
end

while not c.IsDone() do
    c.LeftUntil(1)

    c.GrabLadderLeft()
    c.ClimbUntil(1)
    c.RightUntil(2)
    c.PushDown()
    c.FinishFalling()

    c.BestOf({
        RightDown,
        DownThenRight,
        DownRightDown,
        DownRightDown2,
    })

    c.ClimbUntilGold('Left')

    c.BestOf({
           c.GrabLadderLeft,
           DownThenLeft,
           LeftDownLeft,
    })

    c.ClimbUntil(1)
    c.FallRight()
    c.UntilDig('Right', 'A')
    c.FallRight()

    c.ClimbUntil(9)
    c.FinishFalling()
    c.GrabLadderRight()

    c.ClimbUntil(6)
    c.GrabLadderRight()
    c.ClimbUntil(5)
    c.GrabLadderLeft()
    c.ClimbUntilGold('Right')

    c.RightFor(6)
    c.GrabLadderRight()
    c.ClimbUntil(2)
    c.UntilGold('Right')

    c.BestOf({
        ZigZag,
        LeftThenDown,
        Left2DownLeft,
    })

    c.ClimbUntil(7)
    c.FinishFalling()
    c.UntilGold('Left')
    c.WaitFor(5)
    c.LeftFor(3)

    c.Assert(c.FrameSearch(FromRightUntilEnd))

    -- c.Marker('lv 4 end')
    c.Done()

end

c.Finish()
