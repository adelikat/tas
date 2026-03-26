-- Starts in the lag frames before the level appears
dofile('lode-runner-core.lua')

c.Start()


if c.CurrentLevel() ~= 1 then
    error('must be run in level 1')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

if c.GraphicsMode() ~= 0 then
    error('must be run before the level appears on the screen')
end

function FindLv1SelectSkip()
    local origPlayer = c.Player()
    local origX = (origPlayer.levelX * 16) + origPlayer.xTileOffset
    c.PushLeftAndSelect()

    c.Save('lv1-select-skip')
    local startFrame = emu.framecount()

    c.WaitFor(12)
    local gameMode = c.GameMode()
    local newPlayer = c.Player()
    local newX = (newPlayer.levelX * 16) + newPlayer.xTileOffset

    c.Load('lv1-select-skip')
    return gameMode == 1 and newX < origX
end

local function FindRightAfterFirstDig()
    c.Save('right-after-first-dig')
    return c.RightUntil(20)
end

local function _buttons()
    local btns = {
		['P1 Up'] = false,
		['P1 Down'] = false,
		['P1 Left'] = false,
		['P1 Right'] = false,
		['P1 B'] = false,
		['P1 A'] = false,
		['P1 Select'] = false,
		['P1 Start'] = false,
	}
    return btns
end

while not c.IsDone() do
     c.UntilLevelAppears()

    local found = c.FrameSearch(FindLv1SelectSkip, 25)
    if not found then
        error('Failed to find level 1 select skip')
    end

    c.UntilLadderGrab('Left')
    c.Climb(2)
    c.RightFor(12)
    c.PushRight()
    c.PushDown()
    c.FinishFalling()
    --Requires very a specific frame to start pushing a, or else the spawn timer lags
    ----c.UntilDig('Right', 'A')
    c.PushFor('Right', 2)
    c.PushA()

    c.WaitFor(20)

    found = c.FrameSearch(FindRightAfterFirstDig, 50)
    if not found then
        error('Failed to find right after digging')
    end

    c.UntilLadderGrab('Right')
    c.Climb(1)
    c.UntilLadderGrab('Left')

    c.Climb(5)
    c.UntilLadderGrab('Right')

    c.Climb(2)
    c.LeftUntil(19)

    -- This is hardcoded input patterns found manually
    c.WaitFor(34)
    c.PushB()
    c.WaitFor(51)
    c.PushFor('Left', 3)
    c.WaitFor(4)
    c.PushFor('Up', 9)
    c.WaitFor(4)
    c.PushFor('Up', 1)

    if (c.SpawnTimer() ~= 22 and c.SpawnTimer() ~= 23) then
        error('bad spawn timer: ' .. c.SpawnTimer() .. ' something went wrong')
        c.Done()
    else
        c.Marker('lv 1 end')
        c.UntilNextInputFrame()
        c.PushSelect()
        c.UntilNextLagFrame()
        c.UntilNextInputFrame()
        c.PushStart()
        c.UntilNextLagFrame()
        c.UntilNextInputFrame()
        c.UntilNextLagFrame()
        c.UntilNextInputFrame()
        c.WaitFor(5)
        c.PushBtnsFor({'Left', 'Select'})
        c.Marker('lv 2')
        c.Done()
    end
end

c.Finish()
