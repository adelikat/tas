-- TODO:
-- break buttons up into a class
-- add a flag for checking for encounters when walking, then it can easily be toggled for huge speedups in areas with no encounters

dofile('../Address.lua')
dofile('../RngCache.lua')
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
		btns['P1 Select'] = false
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

local function _mapDirectionToWalk(directionStr)
    if directionStr == 'Up' then
        return c.WalkUp
    elseif directionStr == 'Down' then
        return c.WalkDown
    elseif directionStr == 'Left' then
        return c.WalkLeft
    elseif directionStr == 'Right' then
        return c.WalkRight
    end

    error('Unknown direction: ' .. tostring(directionStr))
end

c = {
    RngCache = RngCache:new(addr),
    Flip = function()
        x = math.random(0, 1)
        return x == 1
    end,
    InitSession = function()
        c.EnsureDayNight = false
        c.RngCache:Clear()
        math.randomseed(os.time())
        _startTime = os.clock()
        _done = false
        memory.usememorydomain('System Bus')
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
        if _done then
		    console.log('Success!')
            c.Save('Success' .. emu.framecount())
		    c.Save(9)
        end
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
    Bail = function(msg)
        if _isDebug() then
			console.log(msg)
		end
        return false
    end,
    GenerateRndDirection = function()	
        x = math.random(0, 3)
        if x == 0 then return 'P1 Left' end
        if x == 1 then return 'P1 Right' end
        if x == 2 then return 'P1 Up' end
        return 'P1 Down'
    end,
    WaitFor = function(frames)
        if (frames > 0) then
            for i = 1, frames, 1 do
                emu.frameadvance()
            end
        end
    end,
    UntilNextInputFrame = function()
        if not emu.islagged() then
            c.WaitFor(1)
            if not emu.islagged() then
                c.Save(7)
                error('This function must be run during lag, or one frame before it')
            end
        end

        c.Save("CoreTemp")
        local startFrameCount = emu.framecount()
    
        while emu.islagged() do
            c.WaitFor(1)
        end
    
        local endFrameCount = emu.framecount()
        local targetFrames = endFrameCount - startFrameCount - 1
    
        c.Load("CoreTemp")
        if targetFrames > 0 then		
            c.WaitFor(targetFrames)
        end
    end,
    -- Use this whenver you need to wait for an additonal frame, avoids the need for savestating and is much faster
    UntilNextInputFrameThenOne = function()   
        if not emu.islagged() then
            c.WaitFor(1)
            if not emu.islagged() then
                error('This function must be run during lag, or one frame before it')
            end
        end
        while emu.islagged() do
            c.WaitFor(1)
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
    PushB = function(directionButton, frames)
        c.Push('B')
    end,
    PushUp = function(directionButton, frames)
        c.Push('Up')
    end,
    PushDown = function(directionButton, frames)
        c.Push('Down')
    end,
    PushLeft = function(directionButton, frames)
        c.Push('Left')
    end,
    PushRight = function(directionButton, frames)
        c.Push('Right')
    end,
    RandomAtLeastOne = function()
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
    RandomAorB = function()
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
    RandomWithoutA = function(frames)
        frames = frames or 1
        for i = 1, frames, 1 do
            local btns = _buttons()
                .AtRandom()
                .Without('A')
                .ToTable()
            _doFrame(btns)
        end
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
    IsEncounter = function()
        if addr.EGroup2Type:Read() ~= 0xFF then
            return true
        end
    
        -- Special hack because Keeleon value is not cleared after boss fight of Chp 4
        -- Stays until the next encounter in Chp 5, and Keeleon is never a random encounter
        return addr.EGroup1Type:Read() ~= 0xFF and addr.EGroup1Type:Read() ~= 0xBB
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
    end,

    ------------------------
    -- Macros
    ------------------------
    AorBAdvance = function(count)
        count = count or 1
        for i = 1, count do
            c.RandomAorB()
            c.UntilNextInputFrame()
        end
    end,
    AorBAdvanceThenOne = function()
        c.RandomAorB()
        c.UntilNextInputFrameThenOne()
    end,
    DismissDialog = function()
        c.RandomAtLeastOne()
        c.WaitFor(1)
        c.UntilNextInputFrame()
    end,
    EnsureDayNight = false, -- If true, all walking will check and ensure the day/night cycle advances
    WalkOneSquare = function(direction, cap)
        local dayNight = addr.StepCounter:Read()
        if addr.MoveTimer:Read() ~= 0 then
            c.Log(string.format('Move timer must be zero to call this method! %s', c.Read(c.Addr.MoveTimer)))
            return false
        end
    
        if cap == nil or cap <= 0 then
            cap = 100
        end
        
        c.Save('WalkStart')
    
        local attempts = 0
        while attempts < cap do
            if attempts > 0 then
                c.Load('WalkStart')
            end
            
            c.Push(direction, 1)
            if addr.MoveTimer:Read() == 0 then
                c.Log('Move timer did not increase')
                return false
            end        
    
            while addr.MoveTimer:Read() > 1 do
                c.RandomWithoutA()
            end
           
            c.WaitFor(1)
            if c.IsEncounter() then
                attempts = attempts + 1
            else
                if c.EnsureDayNight and dayNight == addr.StepCounter:Read() then
                    attempts = attempts + 1
                else
                    return true
                end
            end
        end
        
        c.Debug('Could not avoid encounter')
        return false
    end,
    Walk = function(direction, squares)
        if squares == nil then
            squares = 1
        end
        for i = 1, squares do
            if not c.WalkOneSquare(direction) then
                return false
            end
        end
    
        return true
    end,
    WalkUp = function(squares)
        return c.Walk('Up', squares)
    end,
    WalkDown = function(squares)
        return c.Walk('Down', squares)
    end,
    WalkLeft = function(squares)
        return c.Walk('Left', squares)
    end,
    WalkRight = function(squares)
        return c.Walk('Right', squares)
    end,
    WalkMap = function(dirTable)
        if dirTable == nil then
            error('Must have a table!')
        end
    
        local result
        for i = 1, #dirTable do
            for k, v in pairs(dirTable[i]) do
                c.Debug(string.format('walking %s for %s squares', k, v))
                local func = _mapDirectionToWalk(k)
                result = func(v)
                if not result then
                    return false
                end
            end
        end
    
        return true
    end,
    WalkToCaveTransition = function(direction)
        c.WalkOneSquare(direction)
        c.WaitFor(1)
        if not emu.islagged() then
            return c.Bail('Did not arrive at a transition!')
        end
    
        c.WaitFor(2)
        c.UntilNextInputFrame() -- Super inefficient on encounters, but encounter happens on exactly the last lag frame
        if c.IsEncounter() then
            return false
        end
    
        return true
    end,
    WalkUpToCaveTransition = function()
        return c.WalkToCaveTransition('Up')
    end,
    WalkDownToCaveTransition = function()
        return c.WalkToCaveTransition('Down')
    end,
    WalkRightToCaveTransition = function()
        return c.WalkToCaveTransition('Right')
    end,
    WalkLeftToCaveTransition = function()
        return c.WalkToCaveTransition('Left')
    end,
    ChargeUpWalking = function()
        c.RandomWithoutA(14)
        if addr.MoveTimer:Read() ~= 0 then
            c.Log('Walking charged up too soon')
            return false
        end
        c.WaitFor(1)
        return addr.MoveTimer:Read() == 0
    end,
    BringUpMenu = function()   
        c.PushA()
        if addr.MenuPosY:Read() == 16 then
            error('Menu is already 16, this function will not work')
            return false
        end
        
        advance = true
        while advance do
            c.WaitFor(1)
            advance = addr.MenuPosY:Read() ~= 16
        end
    
        c.UntilNextInputFrame()
        return true
    end,
    PushAWithCheck = function()
        c.PushA()
        if addr.MenuCheck:Read() ~= 0xFF then
            c.Log('Pressing A did not pick something')
            return false
        end
        return true
    end,
}

event.onexit(c.Finish)
