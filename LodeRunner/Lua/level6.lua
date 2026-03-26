-- Start at the end of a level, where pressing up for 1 frame will end the level
dofile('lode-runner-core.lua')

c.Start()

local function Get1stGoldLeft()
    c.UntilGold('Left')
    return true
end

local function Get1stGoldDownLeft()
    c.ClimbDown()
    c.UntilGold('Left')
    return true
end

--
local function GetTopLeftGoldLeft()
    c.UntilDig('Left', 'A')
    c.UntilGold('Left')
    c.UntilFall('Right')
    return true
end

local function GetTopLeftGoldDownLeft()
    c.UntilDig('Left', 'A')
    c.UntilGold('Left')
    c.UntilFall('Right')
    c.ClimbDown()
    return true
end

--

local function DodgeE2()
    c.ClimbUntil(9)
    c.UntilLadderGrab('Right')
    c.ClimbUntil(6)
    local result = c.UntilLadderGrab('Right')
    if not result then
        return false
    end

    c.Climb(2)

    return c.Player().isAlive
end

--

local function MiddleMultiDig1()
    c.UntilDig('Right', 'A')
    c.UntilDig('Left', 'A')
    c.UntilDig('Right', 'A')
    c.UntilFall('Right')
    c.FinishFalling()
    c.RightFor(1)

    c.UntilDig('Left', 'B')
    c.UntilFall('Left')
    c.FinishFalling()
    c.UntilGold('Right')
    return true
end

local function MiddleMultiDig2()
    c.RightFor(1)
    c.UntilDig('Right', 'A')
    c.UntilDig('Left', 'A')
    c.UntilDig('Right', 'A')
    c.UntilFall('Right')
    c.UntilDig('Left', 'A')
    c.UntilFall('Right')
    c.FinishFalling()
    c.UntilGold('Right')
    return true
end

--

local function DodgeEnemiesBeforeBigDig()
    c.ClimbUntil(9)
    c.UntilGold('Left')
    c.UntilGold('Left')
    c.UntilLadderGrab('Right')
    c.ClimbUntil(6)

    c.LeftFor(4)
    local result = c.UntilDig('Left', 'B')
    if not result then return false end

    result = c.UntilDig('Right', 'B')
    if not result then return false end

    result = c.UntilDig('Right', 'B')
    if not result then return false end

    c.UntilFall('Left')
    c.FinishFalling()
    c.LeftFor(1)

    result = c.UntilDig('Left', 'B')
    if not result then return false end

    result = c.UntilDig('Right', 'B')
    if not result then return false end

    result = c.UntilDig('Left', 'B')
    if not result then return false end

    result = c.UntilDig('Left', 'A')
    if not result then return false end

    c.UntilFall('Right')
    c.FinishFalling()

    return c.Player().isAlive
end

local function RightToFinalLadder()
    return c.UntilLadderGrab('Right')
end

local function LastGoldLeft()
    c.UntilGold('Left')
    return c.UntilLadderGrab('Right')
end

local function LastGoldDownLeft()
    c.ClimbDown()
    c.UntilGold('Left')
    return c.UntilLadderGrab('Right')
end

local function DodgeE2GoldGet()
    c.ClimbUntil(9)
    c.UntilLadderGrab('Right')
    c.ClimbUntil(6)
    local result = c.UntilGold('Right')
    console.log('gold get right', tostring(result))
    if not result then return false end


    --result = c.UntilLadderGrab('Left')
    --if not result then return false end
    c.PushLeft() -- Hack, ladder grab doesn't work when only 1 frame is enough
    c.Climb(2)

    return c.Player().isAlive
end

local function FinalSection()
    c.UntilDig('Right', 'A')

    local result = c.FrameSearch(RightToFinalLadder, 20)
    if not result then
        error('did not dodge the enemy')
        return false
    end

    c.ClimbUntil(2)
    c.UntilDig('Up', 'B')
    c.UntilDig('Down', 'B')
    c.UntilDig('Down', 'B')

    c.BestOf({
        LastGoldLeft,
        LastGoldDownLeft
    })

    c.Climb()
    c.ClimbUntilLevelEnd()
    return true
end

-- TODO: this depends on the spawn timer for a gold drop, validate the correct range of values
-- Note: getting the gold rather than letting the enemy drop it, is the same number of steps
-- Logic would make you think that this would be equal and less timing dependent, but it is actually slower
-- The enemy patters are very slightly different and causes significant lag differences
while not c.IsDone() do
    c.RightFor(1)
    c.UntilDig('Right', 'B')
    c.UntilDig('Right', 'B')
    c.UntilDig('Left', 'B')
    c.UntilDig('Right', 'B')
    c.UntilDig('Left', 'B')
    c.UntilDig('Right', 'B')

    c.BestOf({
        Get1stGoldLeft,
        Get1stGoldDownLeft,
    })

    c.UntilLadderGrab('Right')
    c.Climb(2)
    c.RightFor(1)
    c.UntilLadderGrab('Right')
    c.UntilGold('Up')
    c.UntilLadderGrab('Left')
    c.ClimbUntil(2)
    c.LeftFor(2)
    c.UntilLadderGrab('Left')
    c.UntilDig('Up', 'B')

    c.BestOf({
        GetTopLeftGoldLeft,
        GetTopLeftGoldDownLeft,
    })

    c.FinishFalling()

    c.UntilLadderGrab('Right')
    c.ClimbUntil(10)

    local result = c.FrameSearch(DodgeE2GoldGet, 20)
    if not result then
        error('Fail')
    end

    c.ClimbUntil(2)
    c.UntilLadderGrab('Left')
    c.RightUntil(16)

    MiddleMultiDig1()

    c.ClimbDown()

    local result = c.FrameSearch(DodgeEnemiesBeforeBigDig, 30)
    if not result then
        error('Failed to dodge enemy')
    end

    c.UntilGold('Left')
    c.RightUntil(21)

    c.BestSearch(FinalSection, 8)

    c.Marker('lv 6 end')

    c.Done()
end

c.Finish()
