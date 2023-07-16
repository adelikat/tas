-- TODO
-- mapping opponent ai script
dofile('Address.lua')
dofile('Moves.lua')
dofile('Opponents.lua')
local _lastOppHealth = -1
local _currOppHealth = -1
local _done = false
local _enableHud = true
local _config = client.getconfig()

local function _isDebug()
	return _config.SpeedPercent < 800
end

function _round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    if num >= 0 then return math.floor(num * mult + 0.5) / mult
    else return math.ceil(num * mult - 0.5) / mult end
end

local __hitValues = {
	[02] = 02,
	[13] = 13,
	[14] = 14,
	[15] = 15,
	[16] = 16,
	[17] = 17,
	[18] = 18,
	[19] = 19,
	[20] = 20,
}

function _addP(str)
	if (not bizstring.startswith(str, 'P1')) then
		return 'P1 ' .. str
	end

	return str
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

c = {
	TrackHealth = function()
		local newHealth = addr.OppHp:Read()
		if _lastOppHealth < 0 then
			_lastOppHealth = newHealth
		end
		if _currOppHealth < 0 then
			_currOppHealth = newHealth
		end
		if newHealth ~= _currOppHealth then
			_lastOppHealth = _currOppHealth
			_currOppHealth = newHealth
		end
	end,
	BlackscreenMode = function()
		_config.DispSpeedupFeatures = 0
    end,
	FastMode = function()
		_config.Savestates.SaveScreenshot = false
		math.randomseed(os.time())
		client.speedmode(3200)
		client.unpause()
		client.displaymessages(false)
		_enableHud = false
		_config.Savestates.SaveScreenshot = false
	end,
	InitSession = function()
		math.randomseed(os.time())
        _startTime = os.clock()
		_done = false
		c.TrackHealth()
		event.onexit(c.Finish)
	end,
	Done = function()
		_done = true
	end,
	IsDone = function()
		return _done
	end,
	Success = function(val)
		if val == nil then
            return false
        end
    
        if type(val) == 'number' then
            return val > 0
        end
    
        if type(val) == 'boolean' then
            return val
        end
    
        error('Unsupported type in Success call: ' .. tostring(val))
	end,
	Finish = function()
		console.log('---------------')

		if _startTime ~= nil then
			local endTime = os.clock()
        	local timeTaken = endTime - _startTime
        	console.log(string.format('Total time: %s seconds', _round(timeTaken, 2)))
		end
		
		client.displaymessages(true)
		client.pause()
		client.speedmode(100)
        _config.DispSpeedupFeatures = 2
        _config.Savestates.SaveScreenshot = true
		_enableHud = true
        if _done then
		    console.log('Success!')
            c.Save('Success' .. emu.framecount())
		    c.Save(9)
        end
	end,
	IsHudEnabled = function()
		return _enableHud
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
            local orig = _config.Savestates.SaveScreenshot
            _config.Savestates.SaveScreenshot = true
			savestate.saveslot(slot)
            c.Log('Saved to slot ' .. slot)
            _config.Savestates.SaveScreenshot = orig
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
	Flip = function()
		x = math.random(0, 1)
		if (x == 1) then
			return true
		end
	
		return false
	end,
	Processing = function()
		_trackOppHealth()	
		return _done
	end,
	IsGettingStar = function()
		-- Seems to indicate star animation is happening
		return addr.StarAnimation:Read() == 3
	end,
	IsOppBeingHit = function()
		local currMoveNum = addr.OpponentCurrentMove:Read()
		return __hitValues[currMoveNum] ~= nil
	end,
	IsOppBeingHit = function()
		local currMoveNum = addr.OpponentCurrentMove:Read()
		return __hitValues[currMoveNum] ~= nil
	end,
	IsOppKnockedDown = function()
		return addr.WhoIsKnockedDown:Read() == 1
	end,
	IsMacKnockedDown = function()
		return addr.WhoIsKnockedDown:Read() == 2
	end,
	LastOppHealth = function()
		return _lastOppHealth
	end,
	LastDamage = function()
		return _lastOppHealth - _currOppHealth
	end,
	CurrentOpponent = function()
		local opp = opponents[addr.OppNumber:Read()]
		if opp ~= nil then
			return opp
		end
	
		return 'Unknown'
	end,
	Round = function()
		return addr.Round:Read() 
	end,
	IsInFight = function()
		return addr.IsInFight:Read() == 1
	end,
	IsOpponentKnockedOut = function()
		if addr.KnockdownsRound:Read() >= 3 then
			return true
		end
	
		if c.IsOppKnockedDown() and c.OpponentWillGetUpOnCount() == 0 then
			return true
		end
	
		return false
	end,
	OpponentWillGetUpOnCount = function()
		if not c.IsOppKnockedDown() then
			return -1
		end
	
		local count = addr.OppGetUpOnCount:Read()
		if count == 0 then
			return 0
		end
	
		-- TODO: probably only certain bits are used
		return addr.OppGetUpOnCount:Read() - 153
	end,
	Modes = {
		['OpeningBlackScreen'] = 'Opening Black Screen',
		['MenuScreen'] = 'Menu Screen',
		['PreRound'] = 'Before Round',
		['FightIsStarting'] = 'Fight is starting',
		['Fighting'] = 'Fighting',
		['BlackScreenBetweenFights'] = 'Black Screen Between Fights',
		['PostFightScreen'] = 'Post Fight Screen',
		['OpponentKnockedDown'] = 'Opponent knocked down',
		['TKO'] = 'TKO',
	},
	Mode = function()
		-- Hack, first frame, nothing is set yet
		if emu.framecount() < 10 then
			return c.Modes.OpeningBlackScreen
		end
		local isInFight = addr.IsInFight:Read()
		local modeStuff = addr.ModeStuff:Read()
		local mode = addr.GameMode:Read()
		if modeStuff == 0 then
			return c.Modes.OpeningBlackScreen
		elseif modeStuff == 1 and isInFight == 0 and mode == 4 then
			return c.Modes.MenuScreen
		elseif modeStuff == 2 then
			return 'Mike Tyson Intro'
		end
	
		if addr.IsInFightMode:Read() == 1 then
			local nextCount = c.OpponentWillGetUpOnCount()
			if nextCount == 0 then
				local kosThisRound = addr.KnockdownsRound:Read()
				if kosThisRound == 3 then
					return 'TKO'
				end
				return 'KOed'	
			elseif c.IsOppKnockedDown() then
				return c.Modes.OpponentKnockedDown
			end
	
			return c.Modes.FightIsStarting
		end
	
		if c.IsInFight() then
			if c.IsOppKnockedDown() then
				return c.Modes.OpponentKnockedDown
			end
		
			if c.IsMacKnockedDown() then
				return 'Mac is knocked down'
			end
			
			return c.Modes.Fighting
		end
	
		if mode == 0 then
			return c.Modes.BlackScreenBetweenFights
		end
		if mode == 4 or mode == 7 then
			-- Hack, don't know what this addr does, but this makes the piston honda 1 prefight work
			if addr._0002:Read() == 5 then
				return c.Modes.PreRound
			end
			return c.Modes.PostFightScreen
		end
		if mode == 1 and addr.Newspaper:Read() then
			return 'Newspaper'
		end
		if mode == 5 or mode == 6 or mode == 8 then
			if addr.Newspaper:Read() == 16 then -- Don't understand this value yet
				return 'Training for next circuit'
			end
	
			return c.Modes.PreRound
		end	
	
		return 'Unknown'
	end,
	CurrentMacMove = function()
		return addr.MacCurrentMove:Read() & 0x7F
	end,
	MacIsSetForNextMove = function()
		return bit.check(addr.MacCurrentMove:Read(), 7)
	end,
	OppIsSetForNextMove = function()
		return bit.check(addr.OpponentCurrentMove:Read(), 7)
	end,
	GetMove = function()
		local oppMoveStr = nil
	
		local currOpp = addr.OppNumber:Read()
		--last bit indicates something else, seems to be indicating the opponent got hit?
		local currMoveNum = addr.OpponentCurrentMove:Read() & 0x7F
	
		-- Look for the opp table move
		local oppTable = moves[currOpp]
		if oppTable ~= nil then
			oppMoveStr = oppTable[currMoveNum]
		end
	
		-- Fall back to generic
		if oppMoveStr == nil then
			oppMoveStr = moves[0xFF][currMoveNum]
		end
		
		if oppMoveStr ~= nil then
			return oppMoveStr
		end
	
		-- Last resort, just return number
		return tostring(currMoveNum)
	end,
	---------------------------------------
	-- Bool Algorithms
	---------------------------------------
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
	---------------------------------------
	-- TAS functions
	---------------------------------------
	WaitFor = function(frames)
		if (frames > 0) then
			for i = 1, frames, 1 do
				emu.frameadvance()
			end
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
	RandomWithout = function(frames, b1, b2, b3, b4, b5, b6, b7, b8)
        frames = frames or 1
        for i = 1, frames, 1 do
            local btns = _buttons()
                .AtRandom()
                .Without(b1, b2, b3, b4, b5, b6, b7, b8)
                .ToTable()
            _doFrame(btns)
        end
    end,
	UntilNextInputFrame = function()
        if not emu.islagged() then
            c.WaitFor(1)
            if not emu.islagged() then
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
	--Waits frames until the given mode, assumes no input is needed
	UntilMode = function (mode)
		local bail = 2000
		local frames = 0
		while c.Mode() ~= mode and frames < bail do
			c.WaitFor(1)
			frames = frames + 1
		end

		return c.Mode() == mode
	end,
	-- Advances from the end of a fight to the screen that shows the time, ends on the first frame where start can be pressed
	UntilPostFightTimeScreen = function()
		if not c.UntilPostFightBlackScreen() then return false end

		-- Advance to time screen
		c.UntilMode(c.Modes.PostFightScreen)
		c.WaitFor(2)
		if addr.Timer1:Read() == 0 then
			c.Log('Timer has not started yet')
			return false
		end
		while addr.Timer1:Read() > 1 do
			c.WaitFor(1)        
		end

		return true
	end,	
	UntilMacCanFight = function()
		while not c.MacIsSetForNextMove() do
			c.WaitFor(1)
		end
		return true
	end,
	--During the 'Fight is Starting' Mode, pushes random buttons until the Fighting mode and then to the first frame that punches can be thrown
	-- TODO: simplify, we do not need to use savestates
	RandomUntilMacCanFight = function()
		if c.Mode() ~= c.Modes.FightIsStarting then
			error('This function must only be called while the fight is starting!')
		end

		c.Save("CoreTemp")
		local startFrameCount = emu.framecount()

		while c.Mode() ~= c.Modes.Fighting do
			c.WaitFor(1)
		end

		local currMove = addr.OpponentCurrentMove:Read()
		if currMove ~= 64 then
			error('Something went wrong, opponent is not walking to mac')
		end
		while currMove == 64 do
			c.WaitFor(1)
			currMove = addr.OpponentCurrentMove:Read()
		end

		local endFrameCount = emu.framecount()
		local targetFrames = endFrameCount - startFrameCount - 2 -- Minus 2 to ensure we can dodge on the first frame if needed

		c.Load("CoreTemp")
		if targetFrames > 0 then		
			c.RandomFor(targetFrames)
		end

		c.WaitFor(2) -- We want to be one the exact frame that punches can be thrown
	end,
	PushFor = function(directionButton, frames)
		if not frames then
			frames = 1
		end
		for i = 1, frames, 1 do
			_doFrame(_buttons().With(directionButton))
		end
	end,
	PushStart = function(numFrames)
		c.PushFor('Start', numFrames)
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
	PushUpAndB = function(numFrames)
		if not frames then
			frames = 1
		end
		for i = 1, frames, 1 do
			_doFrame(_buttons().With('Up', 'B'))
		end
	end,
	PushUpAndA = function(numFrames)
		if not frames then
			frames = 1
		end
		for i = 1, frames, 1 do
			_doFrame(_buttons().With('Up', 'A'))
		end
	end,
	PushUpAndStart = function(numFrames)
		if not frames then
			frames = 1
		end
		for i = 1, frames, 1 do
			_doFrame(_buttons().With('Up', 'Start'))
		end
	end,
	------------------------
	-- Macros
	------------------------
	--Does a left quick dodge in the fewest frames possible and with as many random buttons as possible
	QuickDodge = function()
		c.PushFor('Left', 2)
		if c.CurrentMacMove() ~= 5 then
			c.Log('Mac did not start dodging')
			return false
		end

		c.RandomFor(3)
		c.WaitFor(2)
		local direction = 'Up'
		if c.Flip() then
			direction = 'Right'
		end
		c.PushFor(direction, 10)
		c.RandomFor(3)
		c.WaitFor(2)

		if c.CurrentMacMove() ~= 1 then
			c.Log('Mac did not finish dodge')
			return false
		end

		return true
	end,
	--Does a left quick dodge in the fewest frames possible and with as many random buttons as possible
	QuickRightDodge = function()
		c.PushFor('Right', 2)
		if c.CurrentMacMove() ~= 3 then
			c.Log('Mac did not start dodging')
			return false
		end

		c.RandomWithout(3, 'Up', 'Down')
		c.WaitFor(2)
		local direction = 'Up'
		if c.Flip() then
			direction = 'Left'
		end
		c.PushFor(direction, 10)

		c.RandomFor(5)
		c.WaitFor(2)

		if c.CurrentMacMove() ~= 1 then
			c.Log('Mac did not finish dodge')
			return false
		end

		return true
	end,
	-- Peforms a duck in the fewest frames possible with as many random buttons as possible
	Duck = function()
		c.PushFor('Down', 2)
		if c.CurrentMacMove() ~= 7 then
			c.Log('Mac did not start blocking')
			return false
		end
		c.WaitFor(3)
		c.PushFor('Down', 2)
		if c.CurrentMacMove() ~= 14 then
			c.Log('Mac did not start ducking')
			return false
		end

		c.RandomWithout(23, 'Up', 'Down')
		
		c.WaitFor(2)
		if c.CurrentMacMove() ~= 1 then
			c.Log('Mac did not finish dodge')
			return false
		end

		return true
	end,
	-- Performs an uppercut (star punch), and checks that it landed, if it does not knock the opponent down, it will set up for the next action
	Uppercut = function(isMisdirected)
		if addr.Stars:Read() == 0 then
			c.Log('No stars, cannot uppercut')
			return false
		end
		local orig = addr.OppHp:Read()
		c.PushStart()

		-- TODO: need a better API for sending in other button presses
		if isMisdirected then
			c.PushUpAndStart()
		else
			c.PushStart()
		end
		

		if c.CurrentMacMove() ~= 13 then
			c.Log('Mac did not start punch')
			return false
		end

		c.RandomFor(5)

		-- 0712 is some kind of timer, don't understand fully yet, but seems to be for macs moves
		while addr.MacMoveTimer:Read() > 1 do
			c.RandomFor(1)
		end

		if c.IsOppKnockedDown() then
			return true
		end

		local curr = addr.OppHp:Read()
		local loss = orig - curr
		c.Debug(string.format('Opponent lost %s hp', loss))
		if loss == 0 then
			return false
		end

		while not c.MacIsSetForNextMove() do
			c.WaitFor(1)
		end

		return true
	end,
	-- Advanced until opponent is KOed, and ensures they do not try and fail to get up
	UntilKoFinishes = function()
		if not c.IsOppKnockedDown() then
			c.Log('Opponent must be knocked down to run this method')
			return false
		end

		if addr.OppMode:Read() == 0 then
			while addr.OppMode:Read() ~= 1 do
				c.RandomFor(1)
			end
		end

		while addr.FightEndFlag:Read() ~= 26 do
			c.RandomFor(1)
			if addr.OppMode:Read() == 2 then
				c.Log('Opponent tried to get up')
				return false
			end
		end

		return true
	end,
	UntilPostFightBlackScreen = function(maxFrames)
		if maxFrames == nil then
			maxFrames = 2000
		end
	
		local count = 0
		while c.Mode() ~= c.Modes.BlackScreenBetweenFights do
			if count == maxFrames then
				c.Log(string.format('Unable to get to black screen in %s frames, aborting'))
				return false
			end
			c.RandomFor(1)
			count = count + 1
		end
	
		return true
	end,	
}

local function __finishPunch(punchType)
	if c.CurrentMacMove() ~= punchType then
		c.Log('Mac did not start punch')
		return false
	end
	local orig = addr.OppHp:Read()

	-- We know for a punch will last for a certain number of frames before making contact
	c.RandomFor(14)
	if c.IsOppKnockedDown() then
		return true
	end
	local curr = addr.OppHp:Read()
	local loss = orig - curr
	c.Debug(string.format('Opponent lost %s hp', loss))
	if loss == 0 then
		return false
	end
	-- It's important to check and bail right after contact should be made otherwise the below
	-- logic will not work since the outcomes can be different (opp duck vs being hit) and the counts won't match
	---------------------

	c.Save("CoreTemp")
	local startFrameCount = emu.framecount()

	while not c.MacIsSetForNextMove() and not c.IsOppKnockedDown() do
		c.WaitFor(1)
	end

	local endFrameCount = emu.framecount()
	local targetFrames = endFrameCount - startFrameCount - 2 -- Minus 2 to ensure we can take the next action, regardless of button state

	c.Load("CoreTemp")
	if targetFrames > 0 then		
		c.RandomWithout(targetFrames, 'Up', 'Down')
	end
	c.WaitFor(2)

	return c.MacIsSetForNextMove()
end

-- Performs a left punch to the face of the opponent, pressing up minimally, and pushing as many random buttons as possible
c.LeftFacePunch = function()
	c.PushB()
	c.PushUpAndB()
	return __finishPunch(12)
end

c.RightFacePunch = function()
	c.PushA()
	c.PushUpAndA()
	return __finishPunch(11)
end

-- Performs a left gut punch without pressing up or down
c.LeftGutPunch = function()
	c.PushB(2)
	return __finishPunch(10)
end

-- Presses up on the first frame of pressing b, to manipulate the opponents guard
c.MisdirectedLeftGutPunch = function()
	c.PushUpAndB()
	c.PushB()
	return __finishPunch(10)
end

-- Performs a left gut punch without pressing up or down
c.RightGutPunch = function()
	c.PushA(2)
	return __finishPunch(9)
end