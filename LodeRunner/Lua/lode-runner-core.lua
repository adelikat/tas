local _done = false
local _success = true
local _config = client.getconfig()

local function _validateDirection(direction)
    if direction ~= 'Up'
        and direction ~= 'Down'
        and direction ~= 'Left'
        and direction ~= 'Right' then
            error('Invalid direction: ' .. tostring(direction))
    end
end

local function _validateHorizontalDirection(direction)
    if direction ~= 'Left' and direction ~= 'Right' then
        error('Invalid horizontal direction: ' .. tostring(direction))
    end
end

local function _validateVerticalDirection(direction)
    if direction ~= 'Up' and direction ~= 'Down' then
        error('Invalid direction: ' .. tostring(direction))
    end
end

local function _tastudioGoToFrame(frame)
    tastudio.setplayback(frame)
    client.unpause()
    while emu.framecount() < frame do
        emu.frameadvance()
    end
    client.pause()
end

local function _doFrameTastudio(keys)
    local frame = emu.framecount()
    if (keys ~= nil) then
		if (type(keys.ToTable) == 'function') then
			keys = keys.ToTable()
		end
	end

    for k, v in pairs(keys) do
        tastudio.submitinputchange(frame, k, v)
    end
    tastudio.applyinputchanges()
    _tastudioGoToFrame(frame + 1)
end

local function _doFrame(keys)
    if tastudio.engaged() then
        _doFrameTastudio(keys)
        return
    end

	if (keys ~= nil) then
		if (type(keys.ToTable) == 'function') then
			keys = keys.ToTable()
		end

		joypad.set(keys)
	end

	emu.frameadvance()
end

function _addP(str)
	if (not bizstring.startswith(str, 'P1')) then
		return 'P1 ' .. str
	end

	return str
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

    btns.With = function(b1, b2, b3, b4, b5, b6, b7, b8)
		if b1 == nil then
			error('b1 cannot be nil')
		end

		btns[_addP(b1)] = true
		if b2 ~= nil then
			btns[_addP(b2)] = true
		end
		if b3 ~= nil then
			btns[_addP(b3)] = true
		end
		if b4 ~= nil then
			btns[_addP(b4)] = true
		end
		if b5 ~= nil then
			btns[_addP(b5)] = true
		end
		if b6 ~= nil then
			btns[_addP(b6)] = true
		end
		if b7 ~= nil then
			btns[_addP(b7)] = true
		end
		if b8 ~= nil then
			btns[_addP(b8)] = true
		end

		return btns
	end

    btns.ToTable = function()
		return {
			['P1 Up'] = btns['P1 Up'],
			['P1 Down'] = btns['P1 Down'],
			['P1 Left'] = btns['P1 Left'],
			['P1 Right'] = btns['P1 Right'],
			['P1 B'] = btns['P1 B'],
			['P1 A'] = btns['P1 A'],
			['P1 Select'] = btns['P1 Select'],
			['P1 Start'] = btns['P1 Start']
		}
	end

    return btns
end

local function _untilNextInputFrameTastudio()
    if emu.framecount() > 0 and not emu.islagged() then
        c.WaitFor(1)
        if not emu.islagged() then
            c.Save('error')
            error('This function must be run during lag, or one frame before it ' .. emu.framecount())
        end
    end

    while emu.islagged() or emu.framecount() == 0 do
        c.WaitFor(1)
    end

    _tastudioGoToFrame(emu.framecount() - 1)
end

local function _untilNextInputFrame()
    if emu.framecount() > 0 and not emu.islagged() then
        c.WaitFor(1)
        if not emu.islagged() then
            c.Save('error')
            error('This function must be run during lag, or one frame before it')
        end
    end

    c.Save("CoreTemp")
    local startFrameCount = emu.framecount()

    while emu.islagged() or emu.framecount() == 0 do
        c.WaitFor(1)
    end

    local endFrameCount = emu.framecount()
    local targetFrames = endFrameCount - startFrameCount - 1

    c.Load("CoreTemp")
    if targetFrames > 0 then
        c.WaitFor(targetFrames)
    end
end

-- end ON the lag frame, untilNextInput frame ends 1 frame before it
function _untilNextLagFrame()
    if emu.framecount() > 0 then
        if emu.islagged() then
            c.WaitFor(1)
            if emu.islagged() then
                console.log('already lag')
                return
            end
        end
    end

    c.Save("CoreTemp")
    local startFrameCount = emu.framecount()

    while not emu.islagged() do
        c.WaitFor(1)
    end

    local endFrameCount = emu.framecount()
    local targetFrames = endFrameCount - startFrameCount - 1

    c.Load("CoreTemp")
    if targetFrames > 0 then
        c.WaitFor(targetFrames)
    end
end

function _untilNextLagFrameTastudio()
    if emu.framecount() > 0 then
        if emu.islagged() then
            c.WaitFor(1)
            if emu.islagged() then
                console.log('already lag')
                return
            end
        end
    end

    while not emu.islagged() do
        c.WaitFor(1)
    end

    _tastudioGoToFrame(emu.framecount() - 1)
end

local function _isDebug()
	return _config.SpeedPercent < 800
end

local function _playerDied()
    if c.Player().isAlive == false then
        c.Debug('Player died')
        return true
    end

    return false
end

-- a key value pair of label and frame number to store when c.Save is called with that label
local saveFrameDict = {}

local _debugMode = false
c = {
    --------------------Core functions--------------------
    ToSignedByte = function(b)
        if b > 127 then
        return b - 256
        else
            return b
        end
    end,
    ToHex = function(b)
        return string.format("%02X", b)
    end,
    ToLeftNibble = function(b)
        return string.sub(string.format("%01X", b), 1, 1)
    end,
    Debug = function(msg)
		if _isDebug() then
			console.log(msg)
		end
	end,
    Fail = function()
        _success = false
        c.Done()
    end,
    Done = function()
        c.Scrub(100)
		_done = true
	end,
	IsDone = function()
		return _done
	end,
    DebugMode = function()
        _debugMode = true
    end,
    Start = function()
        client.unpause()
        if _debugMode then
            client.speedmode(25)
        else
            client.speedmode(1600)
        end

        if tastudio.engaged() then
            local frame = tastudio.find_marker_on_or_before(emu.framecount())
            c.GoToFrame(frame)
        end
    end,
    Finish = function()
        console.log('---------------')
        client.speedmode(100)
        client.pause()
        if _done then
            if _success then
                console.log('Success!')
                c.Save('Success' .. emu.framecount())
                c.Save(99)
            else
                console.log('Failure! No Successful Result')
            end

        end
    end,
    Marker = function(markerName)
        if tastudio.engaged() and markerName ~= nil then
            tastudio.setmarker(emu.framecount(), markerName)
        else
            c.Save('marker-' .. markerName)
        end
    end,
    Save = function(slot)
        if tastudio.engaged() then
            saveFrameDict[slot] = emu.framecount()
            return
        end

		if slot == nil then
			error("slot can not be nil")
		end

		slotNum = tonumber(slot)
		if slotNum == 0 then
			slotNum = 10
		end

		if slotNum ~= nil and slotNum > 0 and slotNum <= 10 then
            local orig = _config.Savestates.SaveScreenshot
            _config.Savestates.SaveScreenshot = true
			savestate.saveslot(slot)
            console.log('Saved to slot ' .. slot)
            _config.Savestates.SaveScreenshot = orig
		else
			savestate.save(string.format('state-archive/%s.State', slot))
		end
	end,
	Load = function(slot)
		if slot == nil then
			error("slot must be a number")
		end

        if tastudio.engaged() then
            local currentFrame = emu.framecount()
            local loadFrame = saveFrameDict[slot]
            if loadFrame == nil then
                error('No save found for slot ' .. slot)
            end

            c.GoToFrame(saveFrameDict[slot] or 0)

            for i = loadFrame, currentFrame, 1 do
                for k, v in pairs(_buttons()) do
                    tastudio.submitinputchange(i, k, false)
                end
            end
            tastudio.applyinputchanges()

            return
        end

		slotNum = tonumber(slot)

		if slotNum == 0 then
			slotNum = 10
		end

		if slotNum ~= nil and slotNum > 0 and slotNum <= 10 then
			savestate.loadslot(slotNum)
		else
			savestate.load(string.format('state-archive/%s.State', slot))
		end
	end,
    Scrub = function(amt)
        if not tastudio.engaged() then
            return
        end

        local start = emu.framecount()
        for i = start, start + amt, 1 do
            for k, v in pairs(_buttons()) do
                tastudio.submitinputchange(i, k, false)
            end
        end
        tastudio.applyinputchanges()
    end,
    WaitFor = function(frames)
        if not frames then
			frames = 1
		end
		for i = 1, frames, 1 do
            btns = _buttons()
			_doFrame(btns)
		end
	end,
    PushFor = function(btn, frames)
		if not frames then
			frames = 1
		end
		for i = 1, frames, 1 do
            local btns = _buttons().With(btn)
			_doFrame(btns)
		end
	end,
    PushBtnsFor = function(btns, frames)
        if not frames then
            frames = 1
        end
        local allBtns = _buttons()
        for _, btn in ipairs(btns) do
            allBtns.With(btn)
        end
        for i = 1, frames, 1 do
            _doFrame(allBtns)
        end
    end,
    PushUpAndSelect = function()
        local btns = _buttons().With('Select').With('Up')
        _doFrame(btns)
    end,
    PushDownAndSelect = function()
        local btns = _buttons().With('Select').With('Down')
        _doFrame(btns)
    end,
    PushLeftAndSelect = function()
        local btns = _buttons().With('Select').With('Left')
        _doFrame(btns)
    end,
    PushRightAndSelect = function()
        local btns = _buttons().With('Select').With('Right')
        _doFrame(btns)
    end,
    PushAAndSelect = function()
        local btns = _buttons().With('Select').With('A')
        _doFrame(btns)
    end,
    PushUpAndLeft = function()
        local btns = _buttons().With('Up').With('Left')
        _doFrame(btns)
    end,
    PushUpAndRight = function()
        local btns = _buttons().With('Up').With('Right')
        _doFrame(btns)
    end,
    PushStart = function(numFrames)
		c.PushFor('Start', numFrames)
	end,
    PushSelect = function(numFrames)
		c.PushFor('Select', numFrames)
	end,
	PushB = function(numFrames)
		c.PushFor('B', numFrames)
	end,
	PushA = function(numFrames)
		c.PushFor('A', numFrames)
	end,
	PushUp = function(numFrames)
		c.PushFor('Up', numFrames)
	end,
    PushDown = function(numFrames)
		c.PushFor('Down', numFrames)
	end,
    PushLeft = function(numFrames)
		c.PushFor('Left', numFrames)
	end,
    PushRight = function(numFrames)
		c.PushFor('Right', numFrames)
	end,
    UntilNextInputFrame = function()
        if tastudio.engaged() then
            _untilNextInputFrameTastudio()
        else
            _untilNextInputFrame()
        end
    end,
    UntilNextLagFrame = function()
        if tastudio.engaged() then
            _untilNextLagFrameTastudio()
        else
            _untilNextLagFrame()
        end
    end,
    GoToFrame = function(frame)
        if not tastudio.engaged() then
            error('tastudio must be engaged to use GoToFrame')
        end
        _tastudioGoToFrame(frame)
    end,
    Assert = function(bool)
        if not bool then
            error('Assertion failed')
        end
    end,
    --[[
    runs a parameterless boolean function, delaying 1 frame each attempt, until it
    returns true or the limit is reached in which it will
    return false
    ]]
    FrameSearch = function(func, limit)
        if limit == nil then
            limit = 25
        end
        c.Save('frame-search-temp-' .. limit)
        local delay = 0;

        while delay < limit do
            c.Load('frame-search-temp-' .. limit)
            c.WaitFor(delay)
            local result = func()
            if result then
                return true
            end

            delay = delay + 1
        end

        return false
    end,
    --[[
    runs a parameterless boolean function, delaying 1 frame each attempt,
    until the limit is reached.  It tracks the best result, and replays that and returns true
    if the boolean function never returns true on any attempt, will return false
    ]]
    BestSearch = function(func, limit)
        local saveStateName = 'best-search-temp-' .. limit
        c.Save(saveStateName)

        local delay = 0
        local best = 9999999
        local bestDelay = 0
        local anySuccess = false

        while delay <= limit do
            c.Load(saveStateName)
            c.WaitFor(delay)
            local result = func()
            if result then
                anySuccess = true
                local final = emu.framecount()
                if final < best then
                    console.log(string.format('New best found %s delay %s', final, delay))
                    best = final
                    bestDelay = delay
                end
            end

            delay = delay + 1
        end

        if anySuccess then
            c.Load(saveStateName)
            c.WaitFor(bestDelay)
            return func()
        end


        console.log('No attempts succeeded')
        return false
    end,
    --[[
    receives an array of paramterless boolean functions, runs each one and evaluates which one is fastest,
    then replays that one
    ]]
    BestOf = function(funcs)
        c.Save('best-of')
        best = 999999
        bestFunc = function() return true end
        for i, fn in ipairs(funcs) do
            c.Load('best-of')
            local result = fn()
            if result then
                local current = emu.framecount()
                if current < best then
                    console.log('new best: ' .. current)
                    best = current
                    bestFunc = fn
                end
            end
        end

        if best == 999999 then
            console.log('BestOf - no route finished successfully')
            return false
        end

        c.Load('best-of')
        return bestFunc()
    end,
    UntilLag = function(btns)
        c.Save('until-lag')
        while not emu.islagged() do
            c.Save('until-lag')
            c.PushBtnsFor(btns)
            if not c.Player().isAlive then
                return false
            end
        end
        c.Load('until-lag')
        return true
    end,
    ---------------------------------------------------------------------
    --------------------Game specific functions below--------------------
    ---------------------------------------------------------------------
    Directions = {
        Left = 1,
        Right = 65
    },
    CurrentLevel = function()
        return memory.readbyte(0x00A6)
    end,
    GameMode = function()
        return memory.readbyte(0x00DB)
    end,
    GameSpeed = function()
        return memory.readbyte(0x00E5)
    end,
    GraphicsMode = function()
        return memory.readbyte(0x0003)
    end,
    CamX = function()
        return memory.readbyte(0x0004)
    end,
    SpawnTimer = function()
        return memory.readbyte(0x0053)
    end,
    Enemy = function(n)
         local i = n - 1;

        local colors = {
            [0] = 'magenta',
            [1] = 'purple',
            [2] = 'red',
        }

        local enemy = {
            index = i,
            levelX = memory.readbyte(0x0661 + i),
            levelY = memory.readbyte(0x0669 + i),
            timer = c.ToSignedByte(memory.readbyte(0x0671 + i)),
            xTileOffset = memory.readbyte(0x0679 + i),
            yTileOffset = memory.readbyte(0x0681 + i),
            color = colors[i] or 'magenta',
            direction = memory.readbyte(0x0722 + (i * 16))
        }

        enemy.xPos = function()
            return enemy.levelX + (enemy.xTileOffset / 8)
        end

        enemy.yPos = function()
            return enemy.levelY + (enemy.yTileOffset / 8)
        end

        return enemy
    end,
    Player = function()
        local player = {
            levelX = memory.readbyte(0x0020),
            levelY = memory.readbyte(0x0021),
            xTileOffset = memory.readbyte(0x0022),
            yTileOffset = memory.readbyte(0x0023),
            isAlive = memory.readbyte(0x009A) == 1,
            isFalling = memory.readbyte(0x009B) == 0
        }

        player.xPos = function()
            return player.levelX + (player.xTileOffset / 8)
        end

        player.yPos = function()
            return player.levelY + (player.yTileOffset / 8)
        end

        return player
    end,
    XcoordToScreen = function(x)
        local camX = memory.readbyte(0x0004)
        return (((x) * 16) - camX) + 14 + 2
    end,
    YcoordToScreen = function(y)
        return ((y - 1) * 16) + 8
    end,
    --------------------Bot functions below--------------------
    FindSelectSkip = function(direction, maxDelay)
        if direction ~= 'Right' and direction ~= 'Left' then
            error('FindSelectSkip only supports Left or Right currently')
            return false
        end
        c.Save('find-select-temp')
        local max = maxDelay or 310
        local delay = 0
        local found = false
        while not found do
            c.Load('find-select-temp')
            c.WaitFor(delay)
            if direction == 'Left' then
                c.PushLeftAndSelect()
            else
                c.PushRightAndSelect()
            end
            c.WaitFor(12)
            local gameMode = c.GameMode()
            if gameMode == 1 then
                local camX = c.CamX()
                c.WaitFor(12)
                local newCamX = c.CamX()
                if newCamX == camX then
                    found = true
                else
                    delay = delay + 1
                    if delay > max then
                        console.log('find select skip FAILED, bailing after ' .. max .. 'frames')
                        return false
                    end
                    c.Debug('delay: ' .. delay .. ' did not work')
                end

                c.Debug('found select skip')
            else
                delay = delay + 1
                if delay > max then
                    console.log('find select skip FAILED, bailing after ' .. max .. 'frames')
                    return false
                end
                c.Debug('delay: ' .. delay .. ' did not work')
            end


        end
        c.Save(99)
        console.log('success, delay: ' .. delay)
        return true
    end,
    LeftUntil = function(targetX)
        local x = c.Player().levelX
        if targetX > x then
            error(string.format('LeftUntil - Cannot move left from %s to %s', x, targetX))
        end
        while x ~= targetX do
            c.PushLeft()
            x = c.Player().levelX
            if _playerDied() then
                return false
            end
        end

        return true
    end,
    RightUntil = function(targetX)
        local startFrame = emu.framecount()
        local x = c.Player().levelX
        if targetX < x then
            error(string.format('RightUntil - Cannot move right from %s to %s', x, targetX))
        end

        local tilesToWalk = math.abs(targetX - x)
        local panicAbort = (tilesToWalk * 16) + 16
        c.Debug(string.format('Need to talk %s tiles, expecting no more than %s frames to succeed', tilesToWalk, panicAbort))

        while x ~= targetX do
            if emu.framecount() - startFrame > panicAbort then
                c.Debug(string.format('Failed to reach destination after %s frames, aborting', panicAbort))
                return false
            end
            c.PushRight()
            x = c.Player().levelX
            if _playerDied() then
                return false
            end
        end

        return true
    end,
    LeftFor = function (tiles)
        local currentTile = c.Player().levelX
        return c.LeftUntil(currentTile - tiles)
    end,
    RightFor = function (tiles)
        local currentTile = c.Player().levelX
        return c.RightUntil(currentTile + tiles)
    end,
    UntilGoldLeft = function()
        return c.UntilGold('Left')
    end,
    UntilGoldRight = function()
        return c.UntilGold('Right')
    end,
    UntilGold = function(direction)
        if direction == 'Up' then
            console.log('Do not use UntilGold with Up, use ClimbUntilGold instead')
        end

        if (direction ~= 'Left' and direction ~= 'Right' and direction ~= 'Up' and direction ~= 'Down') then
            error('invalid direction for ladder grab: ' .. direction)
        end
        local currentGold = memory.readbyte(0x0093)
        while memory.readbyte(0x0093) == currentGold do
            c.PushFor(direction)
        end
        return true
    end,
    ClimbUntilGold = function(nextDirection)
        _validateDirection(nextDirection)
        c.Save('climb-until-gold')
        local startGold = memory.readbyte(0x0093)
        local done = false
        while not done do
            if not c.Player().isAlive then
                return false
            end

            c.Save('climb-until-gold')
            c.PushFor(nextDirection)
            local newGold = memory.readbyte(0x0093)
            c.Load('climb-until-gold')

            if newGold < startGold then
                done = true
            else
                c.PushFor('Up')
                newGold = memory.readbyte(0x0093)
                if newGold < startGold then
                    done = true
                end
            end
        end
        return true
    end,
    GrabLadderLeft = function(nextDirection)
        return c.GrabLadder('Left', nextDirection)
    end,
    GrabLadderRight = function(nextDirection)
        return c.GrabLadder('Right', nextDirection)
    end,
    GrabLadder = function(horizontalDirection, verticalDirection)
        -- validation
        _validateHorizontalDirection(horizontalDirection)
        if not verticalDirection then
            verticalDirection = 'Up'
        end
        _validateVerticalDirection(verticalDirection)

        -- step 1, move to the next tile, this still stabalize the player y, if they are currently on a ladder, before making any y based decisions later
        c.Debug('GrabLadder')
        local startingX = c.Player().levelX
        local startFrame = emu.framecount()
        c.Save('grab-start')

        while c.Player().levelX == startingX do
            c.PushFor(horizontalDirection)
        end

        local endFrame = emu.framecount()
        local framesUntilNextLevelX = endFrame - startFrame
        c.Debug(string.format('player will cross to the next level x in %s frames', framesUntilNextLevelX))
        c.Load('grab-start')
        c.PushFor(horizontalDirection, framesUntilNextLevelX - 1)

        -- step 2, keep trying to press vertically until y changes, if it does not, just press horizontal
        local done = false
        while not done do
            c.Save('grab-try')
            local before = c.Player().yPos()
            c.PushBtnsFor({horizontalDirection, verticalDirection})
            local after = c.Player().yPos()
            c.Debug(string.format('Pushing both btns before: %s, after: %s)', before, after))

            if before == after or c.Player().levelX == startingX then
                -- if no change in Y then we know we only need to push the horizontal direction
                -- or Y did change but x is still the original levelX, that can only mean we are still climbing a previous ladder, we cannot treat this as a success
                c.Load('grab-try')
                c.PushFor(horizontalDirection)
            else
                c.Debug('change in Y detected')
                done = true
                -- Try just pushing the vertical btn, if that is better, then we just push it
                -- Either way we know we are done since y position started to change
                c.Load('grab-try')
                c.PushFor(verticalDirection)

                local verticalAfter = c.Player().yPos()

                if (verticalDirection == 'Up' and verticalAfter <= after)
                    or (verticalDirection == 'Down' and verticalAfter >= after)
                then
                    c.Debug(string.format('pushing vertical was preferred over pushing both btns, both: %s, vertical only: %s', after, verticalAfter))
                else
                    c.Debug('pushing both btns was necessary')
                    c.Load('grab-try')
                    c.PushBtnsFor({horizontalDirection, verticalDirection})
                end
            end


            -- if player is falling or dead, then all of this failed, bail out before repeating or exiting the while loop
            if not c.Player().isAlive or c.Player().isFalling then
                return false
            end
        end

        return true
    end,
    ClimbUntil = function(targetY)
        local player = c.Player()
        local y = c.Player().levelY

        if y == targetY then
            return true
        end

        local direction = 'Up'
        if y < targetY then
            direction = 'Down'
        end

        while y ~= targetY do
            c.PushFor(direction)
            y = c.Player().levelY
            if c.Player().isAlive == false then

                c.Debug('Player died while trying to move up until ' .. targetY)
                return false
            end
        end

        return true
    end,
    ClimbUntilLevelEnd = function()
        local start = emu.framecount()
        c.Save('up-until-level-end-')

        while not emu.islagged() do
            if emu.framecount() - start > 200 then
                c.Debug('ClimbUntilEnd failed tot get to the end, aborting after 200 frames')
                return false
            end
            c.PushUp()
        end

        local final = emu.framecount()
        local length = final - start
        c.Load('up-until-level-end-')

        -- We want to end 1 frame before the level ends, to manipulate the next level
        c.PushFor('Up', length - 2)
        if tastudio.engaged() then
            c.WaitFor(2)
            tastudio.setplayback(emu.framecount() - 2)
        end

        return true
    end,
    Fall = function(horizontalDirection)
        local result = c.UntilFall(horizontalDirection)
        if not result then return false end
        return c.FinishFalling()
    end,
    FallLeft = function()
        return c.Fall('Left')
    end,
    FallRight = function()
        return c.Fall('Right')
    end,
    UntilFall = function(horizontalDirection)
        _validateHorizontalDirection(horizontalDirection)

        -- If already falling, give it 1 frame before giving up, so we can stack these
        if c.Player().isFalling then
            c.PushFor(horizontalDirection)
        end

        if c.Player().isFalling then
            console.log('Player is already falling')
            return true
        end

        while not c.Player().isFalling do
            c.PushFor(horizontalDirection)
            if not c.Player().isAlive then
                return false
            end
        end

        return true
    end,
    FinishFalling = function()
        c.Save('finish-falling')
        local startFrame = emu.framecount()
        local test = memory.readbyte(0x009B)
        if not c.Player().isFalling then
            -- Wait 1 frame, if still not falling, give up
            c.Save('temp')
            c.WaitFor(1)
            if not c.Player().isFalling then
                c.Debug('Player was not falling ' .. emu.framecount())
                c.Load('temp')
                return
            end
        end

        while c.Player().isFalling do
            c.WaitFor(1)
        end

        local endFrame = emu.framecount()
        c.Load('finish-falling')
        c.WaitFor(endFrame - startFrame - 1)
        return c.Player().isAlive
    end,
    UntilLevelAppears = function()
        while c.GraphicsMode() ~= 8 do
            c.WaitFor(1)
        end
    end,
    UntilDig = function(horizontalDirection, digBtn)
        _validateHorizontalDirection(horizontalDirection)
        if digBtn ~= 'A' and digBtn ~= 'B' then
            error('Invalid dig direction: ' .. digBtn)
        end

        local function checkFrame()
            c.Save('temp')
            c.PushBtnsFor({horizontalDirection, digBtn})
            c.WaitFor(2)

            local success = memory.readbyte(0x00A0) == 1

            c.Load('temp')
            return success
        end

        local function checkJustDig()
            c.Save('temp')
            c.PushBtnsFor({digBtn})
            c.WaitFor(2)

            local success = memory.readbyte(0x00A0) == 1

            c.Load('temp')
            return success
        end

        local done = false

        while not done do
            if not c.Player().isAlive then
                return false
            end

            if checkFrame() then
                if checkJustDig() then
                    c.PushFor(digBtn)
                else
                    c.PushBtnsFor({horizontalDirection, digBtn})
                end
                done = true
            else
                c.PushFor(horizontalDirection)
            end
        end

        local limit = 50
        local count = 0
        while memory.readbyte(0x00A0) < 0x0C do
            c.WaitFor(1)
            count = count + 1
            if count > limit then
                return false
            end
        end

        return true
     end,
     WalkOverEnemy = function(horizontalDirection)
        _validateHorizontalDirection(horizontalDirection)
        local p = c.Player()
        local currentX = p.levelX
        local currentY = p.levelY
        local targetX = p.levelX + 2
        if horizontalDirection == 'Left' then
            targetX = p.levelX - 2
        end

        return c.FrameSearch(function()
            local done = false
            while not done do
                c.Save('walk-over-enemy-temp')
                c.PushFor(horizontalDirection)
                local newP = c.Player()
                if newP.levelX == targetX then
                    -- We need to end 1 frame early, we know it will succeed so it doens't matter when we end, and we need to account for a ladder to climb being on the next tile
                    c.Load('walk-over-enemy-temp')
                    return true
                end

                done = (not newP.isAlive) or newP.isFalling
            end
        end)
     end,
}