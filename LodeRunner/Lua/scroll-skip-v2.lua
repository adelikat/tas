local maxDelay = 7
local maxSkipDelay = 15
local direction = 'Left'
local changeSpeedSlower = false
local changeSpeedFaster = true

if direction ~= 'Left' and direction ~= 'Right' then
    error('invalid direction')
end

-- Start at the end of a level, where pressing up for 1 frame will end the level
dofile('lode-runner-core.lua')

c.Start()
c.Save('find-skip-start')

local function PushSelectUntilLevelSkip()
    c.Save('find-lv-select')
    local done = false
    local frames = 1
    while not done do
        c.PushFor('Select', frames)
        c.WaitFor(1)
        if c.GameMode() == 0 then
            return true
        else
            c.Load('find-lv-select')
            frames = frames + 1
        end
    end
end

function FindSkipFromBeginningOfLevel()
    local origPlayer = c.Player()
    local origX = (origPlayer.levelX * 16) + origPlayer.xTileOffset
    c.PushBtnsFor({direction, 'Select'})

    c.Save('lv1-select-skip')
    local startFrame = emu.framecount()

    c.WaitFor(12)
    local gameMode = c.GameMode()
    local newPlayer = c.Player()
    local newX = (newPlayer.levelX * 16) + newPlayer.xTileOffset

    c.Load('lv1-select-skip')

    c.Debug(string.format('eval: GameMode %s, origX: %s, newX: %s', gameMode, origX, newX))

    return gameMode == 1 and newX ~= origX
end

local function FindSkip()
    local result = c.UntilLag({'Up'});
    if not result then return false end

    c.UntilNextInputFrame()

    PushSelectUntilLevelSkip()
    c.UntilNextLagFrame()
    c.UntilNextInputFrame()
    if changeSpeedSlower then
        if c.GameSpeed() ~= 1 then
            error('attempted to change game speed slower when not at 1, ' .. c.GameSpeed())
        end
        c.PushBtnsFor({'Select', 'B'})
        c.PushSelect()
        c.PushBtnsFor({'Select', 'B'})
        c.PushSelect()
        c.PushBtnsFor({'Select', 'B'})
        if c.GameSpeed() ~= 4 then
            error('failed to set game speed')
        end
    elseif changeSpeedFaster then
        if c.GameSpeed() ~= 4 then
            error('attempted to change game speed faster when not at 4, ' .. c.GameSpeed())
        end

        c.PushBtnsFor({'Select', 'A'})
        c.PushSelect()
        c.PushBtnsFor({'Select', 'A'})
        c.PushSelect()
        c.PushBtnsFor({'Select', 'A'})
        if c.GameSpeed() ~= 1 then
            error('failed to set game speed')
        end
    end
    c.PushStart()
    c.UntilNextLagFrame()
    c.UntilNextInputFrame()

    c.UntilNextLagFrame() -- Level jingle
    c.UntilNextInputFrame()

    result = c.FrameSearch(FindSkipFromBeginningOfLevel, maxSkipDelay)

    if result then
        if tastudio.engaged() then
            tastudio.createnewbranch()
        end
    else
        console.log('could not find skip')
    end

    return result
end

while not c.IsDone() do
    c.Load('find-skip-start')
    local bestResult = c.BestSearch(FindSkip, maxDelay)

    if  bestResult then
        c.Marker('lv ' .. c.CurrentLevel())
        c.Done()
    else
        console.log('---------------')
        console.log('Could not find any level skip!')
        c.Fail()
    end
end

c.Finish()
