local _done = false
local _startTime

function _round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    if num >= 0 then return math.floor(num * mult + 0.5) / mult
    else return math.ceil(num * mult - 0.5) / mult end
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
		['P1 Start'] = false
	}
	btns.AtRandom = function()
		btns['P1 Up'] = c.Flip()
		btns['P1 Down'] = c.Flip()
		btns['P1 Left'] = c.Flip()
		btns['P1 Right'] = c.Flip()
		btns['P1 B'] = c.Flip()
		btns['P1 A'] = c.Flip()
		btns['P1 Select'] = c.Flip()
		btns['P1 Start'] = c.Flip()
		return btns
	end
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
	btns.Without = function(b1, b2, b3, b4, b5, b6, b7, b8)
		if b1 == nil then
			error('b1 cannot be nil')
		end

		btns[_addP(b1)] = false
		if b2 ~= nil then
			btns[_addP(b2)] = false
		end
		if b3 ~= nil then
			btns[_addP(b3)] = false
		end
		if b4 ~= nil then
			btns[_addP(b4)] = false
		end
		if b5 ~= nil then
			btns[_addP(b5)] = false
		end
		if b6 ~= nil then
			btns[_addP(b6)] = false
		end
		if b7 ~= nil then
			btns[_addP(b7)] = false
		end
		if b8 ~= nil then
			btns[_addP(b8)] = false
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

local function _doFrame(keys)
	if (keys ~= nil) then
		if (type(keys.ToTable) == 'function') then
			keys = keys.ToTable()
		end
		
		joypad.set(keys)
	end

	emu.frameadvance()
end

local function _isDebug()
	config = client.getconfig()
	return config.SpeedPercent < 800
end

c = {
    Flip = function()
        x = math.random(0, 1)
        return x == 1
    end,
    InitSession = function()
        _startTime = os.clock()
        _done = false
    end,
    Done = function()
		_done = true
	end,
	IsDone = function()
		return _done
	end,
    Finish = function()
        local endTime = os.clock()
        local timeTaken = endTime - _startTime
		console.log('---------------')
        console.log(string.format('Total time: %s seconds', _round(timeTaken, 2)))
		client.displaymessages(true)
		client.pause()
		client.speedmode(100)
        client.getconfig().DispSpeedupFeatures = 2
		_enableHud = true
		console.log('Success!')
		c.Save('Success' .. emu.framecount())
		c.Save(9)
	end,
    FastMode = function()
		client.speedmode(6400)
		client.unpause()
		client.displaymessages(false)
	end,
    BlackscreenMode = function()
        client.getconfig().DispSpeedupFeatures = 0
    end,
    Save = function(slot)
		if slot == nil then
			error("slot can not be nil")
		end
	
		slotNum = tonumber(slot)
		if slotNum == 0 then
			slotNum = 10
		end
	
		if slotNum ~= nill and slotNum > 0 and slotNum <= 10 then
			savestate.saveslot(slot)
		else
			savestate.save(string.format('state-archive/%s.State', slot))
		end
	end,
	Load = function(slot)
		if slot == nil then
			error("slot must be a number")
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
    Log = function(msg)
		console.log(msg)
	end,
	Debug = function(msg)
		if _isDebug() then
			console.log(msg)
		end
	end,
    WaitFor = function(frames)
        if (frames > 0) then
            for i = 1, frames, 1 do
                emu.frameadvance()
            end
        end
    end,
    UntilNextInputFrame = function ()
        c.Save("CoreTemp")
        local startFrameCount = emu.framecount()
    
        while emu.islagged() == true do
            c.WaitFor(1)
        end
    
        local endFrameCount = emu.framecount()
        local targetFrames = endFrameCount - startFrameCount - 1
    
        c.Load("CoreTemp")
        if targetFrames > 0 then		
            c.WaitFor(targetFrames)
        end
    end,
    Push = function(directionButton, frames)
        if not frames then
            frames = 1
        end
        for i = 1, frames, 1 do
            _doFrame(_buttons().With(directionButton))
        end
    end,
    PushA = function(directionButton, frames)
        c.Push('A')
    end,
    PushUp = function(directionButton, frames)
        c.Push('Up')
    end,
    PushDown = function(directionButton, frames)
        c.Push('Down')
    end,
    PushRight = function(directionButton, frames)
        c.Push('Right')
    end,
    RndAtLeastOne = function()
        local btns = _buttons().AtRandom()
        local btnMap = {
            [1] = 'P1 Up',
            [2] = 'P1 Down',
            [3] = 'P1 Left',
            [4] = 'P1 Right',
            [5] = 'P1 B',
            [6] = 'P1 A',
            [7] = 'P1 Select',
            [8] = 'P1 Start'
        }

        r = math.random(1, 8)
        btns[btnMap[r]] = true
        _doFrame(btns)
    end,
    RndAorB = function()
        local btns = _buttons().AtRandom()
        local pushB = c.Flip()
        btns['P1 B'] = pushB
        if not pushB then
            btns['P1 A'] = true
        else
            btns['P1 A'] = c.Flip()
        end

        _doFrame(btns)
    end,
    RndWithout = function(b1, b2, b3, b4, b5, b6, b7, b8)
        local btns = _buttons()
            .AtRandom()
            .Without(b1, b2, b3, b4, b5, b6, b7, b8)
        _doFrame(btns)
    end,
    RandomFor = function(frames)
        if (frames > 0) then
            for i = 1, frames, 1 do
                local btns = _buttons()
                    .AtRandom()
                    .ToTable()
                _doFrame(btns)
            end
        end
    end,
    AorBAdvance = function(count)
        for i = 1, count do
            c.RndAorB()
            c.WaitFor(1)
            c.UntilNextInputFrame()
        end
    end,
    ------- Alorithms
    Success = function(val)
        if val == nil then
            return false
        end
    
        if type(val) == "number" then
            return val > 0
        end
    
        if type(val) == "boolean" then
            return val
        end
    
        error('Unsupported type in Success call: ' .. tostring(val))
    end,
    --[[
    runs a parameterless boolean function until it
    returns true or the cap is reached in which it will
    return false
    ]]
    Cap = function(func, limit)
        local tempFile = 'Cap-'.. emu.framecount()
        c.Save(tempFile)
        local i
        for i = 1, limit do
            c.Debug('Cap Attempt: ' .. i)
            result = func()
            if result then
                return true
            else
                c.Load(tempFile)
            end
        end
        
        c.Log('Cap limit reached')
        return false
    end,
    --[[
    runs a parameterless bool function and runs it
    for the number of tries specified. At the end it will load a
    savestate of the best result and return the frame count, only 
    successful attempts (where the function returns true) will be 
    considered, if 0 is returned it indicated that no successful 
    attempt occurred
    ]]
    Best = function(func, tries)
        local noResult = 9999999
        local best = noResult
        local tempFile = 'Best-Start-'.. emu.framecount()
        c.Save(tempFile)
        local i
        for i = 1, tries do
            c.Load(tempFile)
            c.Debug('Best Search Attempt: ' .. i)
            result = func()

            if result then
                current = emu.framecount()
                if current < best then
                    best = current			
                    c.Log('New best found: ' .. best)
                    c.Save('Best-End-' .. best)
                end			
            end
        end

        if best == noResult then
            return 0		
        else
            c.Load('Best-End-' .. best)
            return best
        end	
    end
}
