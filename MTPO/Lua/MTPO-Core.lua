-- TODO
-- Scrambler ram address
-- guard stuff
-- mapping opponent ai script
local _lastOppHealth = -1
local _currOppHealth = -1
local _oppHp = 0x0398
local _done = false
local function _isDebug()
end
c = {
	TrackHealth = function()
		local newHealth = memory.readbyte(_oppHp) 
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
	FastMode = function()
		client.speedmode(3200)
		client.unpause()
		client.displaymessages(false)
	end,
	InitSession = function()
		_done = false
		c.TrackHealth()
	end,
	Done = function()
		_done = true
	end,
	IsDone = function()
		return _done
	end,
	Finish = function()
		console.log('---------------')
		client.displaymessages(true)
		client.pause()
		client.speedmode(100)

		console.log('Success!')
		--c.Save(99)
		--c.Save(9)
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
	Read = function(addr)
		return memory.readbyte(addr)
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
	Addr = {
		['IsInFight'] = 0x0000,
		['OppNumber'] = 0x0001,
		['ModeStuff'] = 0x0004,
		['WhoIsKnockedDown'] = 0x0005,
		['Round'] = 0x0006,
		['RNG'] = 0x0018,
		['Scrambler'] = 0x0019,
		['IsInFightMode'] = 0x022, -- If 1, then opponent is doing intro moves or is being knocked down
		['OpponentTimer'] = 0x0039,
		['OpponentNextMove'] = 0x003A, -- Don't understand this one yet
		['FightEndFlag'] = 0x0044, -- Don't understand fully yet, but 26 while Mario is declaring Mac the winner
		['MacCurrentMove'] = 0x0050,
		['OpponentCurrentMove'] = 0x0090,
		['GameMode'] = 0x00A9, -- Bad name, but will change if between rounds, intro screen, fight, etc
		['OppMode'] = 0x00BB, -- 0 in fight, 1 when knocked down, 2 when trying to get up
		['OppGetUpOnCount'] = 0x00C4, -- The number the opponent will get up on, 0 = KO'ed, 154 = 1, 155 = 2, etc
		['WinsTensDigit'] = 0x0170,
		['WinsDigit'] = 0x0171,
		['LossesTensDigit'] = 0x0172,
		['LossesDigit'] = 0x0173,
		['KOsTensDigit'] = 0x0174,
		['KOsDigit'] = 0x0175,
		['HeartsTens'] = 0x0323,
		['HeartsSingle'] = 0x0324,
		['Stars'] = 0x0342,
		['StarCountdown'] = 0x0347,
		['UppercutsUntilOppDodge'] = 0x0348,
		['MacHealth'] = 0x0391,
		['MacHealthGraudal'] = 0x0393,
		['MacNextHealth'] = 0x0397,
		['OppHp'] = _oppHp,
		['OppHpGradual'] = 0x039A,
		['OppNextHealth'] = 0x039E,
		['KnockdownsRound'] = 0x03CA,
		['TotalKnockdowns'] = 0x03D1,
		['IsOppBeingHit'] = 0x03E0,
		['TotalStarCountdown'] = 0x05B0,		
	},
	OpponentNames = {
		['GlassJoe'] = 'Glass Joe',
		['VonKaiser'] = 'Von Kaiser',
		['PistonHonda1'] = 'Piston Honda 1',
		['DonFlamenco1'] = 'Don Flamenco 1',
		['KingHippo'] = 'King Hippo',
		['GreatTiger'] = 'Great Tiger',
		['BaldBull1'] = 'Bald Bull 1',
		['PistonHonda2'] = 'Piston Honda 2',
		['SodaPopinski'] = 'Soda Popinski',
		['BaldBull2'] = 'Bald Bull 2',
		['DonFlamenco2'] = 'Don Flamenco 2',
		['MrSandman'] = 'Mr. Sandman',
		['SuperMachoMan'] = 'Super Macho Man',
		['Mike Tyson'] = 'Mike Tyson',
		['Demo'] = 'Demo Bald Bull',
	},
}

c.Opponents = {
	[0] = c.OpponentNames.GlassJoe,
	[1] = c.OpponentNames.VonKaiser,
	[2] = c.OpponentNames.PistonHonda1,
	[3] = c.OpponentNames.DonFlamenco1,
	[4] = c.OpponentNames.KingHippo,
	[5] = c.OpponentNames.GreatTiger,
	[6] = c.OpponentNames.BaldBull1,
	[7] = c.OpponentNames.PistonHonda2,
	[8] = c.OpponentNames.SodaPopinski,
	[9] = c.OpponentNames.BaldBull2,
	[10] = c.OpponentNames.DonFlamenco2,
	[11] = c.OpponentNames.MrSandman,
	[12] = c.OpponentNames.SuperMachoMan,
	[13] = c.OpponentNames.MikeTyson,
	[19] = c.OpponentNames.Demo,
	[20] = c.OpponentNames.KingHippo,
	[21] = c.OpponentNames.GreatTiger,
	[22] = c.OpponentNames.PistonHonda2,
	[23] = c.OpponentNames.SodaPopinski,
	[24] = c.OpponentNames.BaldBull2,
	[25] = c.OpponentNames.DonFlamenco2,
	[26] = c.OpponentNames.MrSandman,
	[27] = c.OpponentNames.SuperMachoMan,
	[28] = c.OpponentNames.MikeTyson
}

c.Processing = function()
	_trackOppHealth()	
	return _done
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

c.IsOppBeingHit = function()
	local currMoveNum = c.Read(c.Addr.OpponentCurrentMove)
	return __hitValues[currMoveNum] ~= nil
end
c.IsOppKnockedDown = function()
	return c.Read(c.Addr.WhoIsKnockedDown) == 1
end
c.IsMacKnockedDown = function()
	return c.Read(c.Addr.WhoIsKnockedDown) == 2
end
c.LastOppHealth = function()
	return _lastOppHealth
end
c.LastDamage = function()
	return _lastOppHealth - _currOppHealth
end
c.CurrentOpponent = function()
	local opp = c.Opponents[c.Read(c.Addr.OppNumber)]
	if opp ~= nill then
		return opp
	end

	return 'Unknown'
end
c.CurrentRound = function()
	return c.Read(c.Addr.Round)
end
c.IsInFight = function()
	return c.Read(c.Addr.IsInFight) == 1
end
c.IsOpponentKnockedOut = function()
	if c.Read(c.Addr.KnockdownsRound) >= 3 then
		return true
	end

	if c.IsOppKnockedDown() and c.OpponentWillGetUpOnCount() == 0 then
		return true
	end

	return false
end
c.OpponentWillGetUpOnCount = function()
	if not c.IsOppKnockedDown() then
		return -1
	end

	local count = c.Read(c.Addr.OppGetUpOnCount)
	if count == 0 then
		return 0
	end

	-- TODO: probably only certain bits are used
	return c.Read(c.Addr.OppGetUpOnCount) - 153
end

c.Modes = {
	['OpeningBlackScreen'] = 'Opening Black Screen',
	['MenuScreen'] = 'Menu Screen',
	['PreRound'] = 'Before Round',
	['FightIsStarting'] = 'Fight is starting',
	['Fighting'] = 'Fighting',
	['BlackScreenBetweenFights'] = 'Black Screen Between Fights'
}

c.Mode = function()
	-- Hack, first frame, nothing is set yet
	if emu.framecount() < 10 then
		return c.Modes.OpeningBlackScreen
	end
	local isInFight = c.Read(c.Addr.IsInFight)
	local modeStuff = c.Read(c.Addr.ModeStuff)
	local mode = c.Read(c.Addr.GameMode)
	if modeStuff == 0 then
		return c.Modes.OpeningBlackScreen
	elseif modeStuff == 1 and isInFight == 0 and mode == 4 then
		return c.Modes.MenuScreen
	elseif modeStuff == 2 then
		return 'Mike Tyson Intro'
	end

	if c.Read(c.Addr.IsInFightMode) == 1 then
		local nextCount = c.OpponentWillGetUpOnCount()
		if nextCount == 0 then
			local kosThisRound = c.Read(c.Addr.KnockdownsRound)
			if kosThisRound == 3 then
				return 'TKO'
			end
			return 'KOed'	
		elseif c.IsOppKnockedDown() then
			return 'Opponent knocked down'
		end

		return c.Modes.FightIsStarting
	end

	if c.IsInFight() then
		if c.IsOppKnockedDown() then
			return 'Opponent knocked down'
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
		return 'Post Fight Screen'
	end
	if mode == 1 and c.Read(0x03C9) == 16 then
		return 'Newspaper'
	end
	if mode == 5 or mode == 6 or mode == 8 then
		if c.Read(0x03C9) == 16 then -- Don't understand this value yet
			return 'Training for next circuit'
		end

		return c.Modes.PreRound
	end	

	return 'Unknown'
end

c.Moves = {
	-- Generic
	[0xFF] = {
		[01] = 'Waiting',
		[02] = 'Hit Uppercut',
		[03] = 'Dodge Upper',
		[04] = 'Ducking',
		[05] = 'Block R. Face',
		[06] = 'Block L. Face',
		[07] = 'Block R. Gut',
		[08] = 'Block L. Gut',
		[13] = 'Hit R. Face',
		[14] = 'Hit L. Face',
		[15] = 'Hit R. Gut',
		[16] = 'Hit L. Gut',
		[17] = 'Stun R. Face',
		[18] = 'Stun L. Face',
		[19] = 'Stun R. Gut',
		[20] = 'Stun L. Gut',
		[21] = 'R. Hook',
		[22] = 'L. Jab',
		[23] = 'R. Uppercut',		
		[24] = 'L. Uppercut',
		[25] = 'Special 1',
		[26] = 'Special 2',
		[27] = 'Special 3',
		[64] = 'Walk To Mac',
	},
	[00] = {
		[25] = 'Taunt'
	},
	[02] = {
		[24] = 'R. Bonzai',
		[25] = 'Bonzai Attack',
		[26] = 'L. Bonzai',
	},
	[03] = {
		[24] = 'Taunt',
	},
	[04] = {
		[23] = 'R. Open Mouth',
		[24] = 'L. Open Mouth',
		[26] = 'Dancing'
	},
	[05] = {
		[25] = 'Tiger Punch',
	},
	[06] = {
		[22] = 'Rolling Jab',
		[25] = 'Bull Charge',
	},
	[07] = {
		[24] = 'R. Bonzai',
		[25] = 'Bonzai Attack',
		[26] = 'L. Bonzai',
		[28] = 'Eye Roll',
		[29] = 'Jiving Upper',
	},
	[08] = { -- Soda Popinski
		[22] = 'R. Jab',
		[26] = 'Dancing',
		[65] = 'Walking To Mac',
	},
	[09] = {
		[22] = 'Rolling Jab',
		[25] = 'Eye Rub',
		[26] = 'Bull Charge'
	},
	[10] = {
		[24] = 'Taunt',
	},
	[11] = { -- Mr. Sandman
		[03] = 'Dodge L.',
		[04] = 'Dodge R.',
		[24] = 'R. Jab',
		[26] = 'Dreamland E',
		[27] = 'Dreamland E',
		[28] = 'L. Hook-Jab',
		[29] = 'Dreamland E',
		[31] = 'Dreamland E',
	},
	[12] = {
		[25] = 'Reg. Spin',
		[26] = 'Super Spin',
		[27] = 'Jiving Upper',
	},
	[13] = { -- Tyson
		[24] = 'R. Hook',
		[25] = 'Eye Blink',
		[26] = 'L. Hook',
		[28] = 'L. Hook',
		[29] = 'L. Uppercut',
		[65] = 'Walking To Mac',
	},
	[19] = {
		[22] = 'Rolling Jab',
		[25] = 'Bull Charge',
	},	
	[20] = {
		[23] = 'R. Open Mouth',
		[24] = 'L. Open Mouth',
		[26] = 'Dancing',
	},
	[21] = {
		[25] = 'Tiger Punch',
	},
	[22] = {
		[24] = 'R. Bonzai',
		[25] = 'Bonzai Attack',
		[26] = 'L. Bonzai',
		[28] = 'Eye Roll',
		[29] = 'Jiving Upper',
	},
	[23] = { -- Soda Popinski
		[22] = 'R. Jab',
		[26] = 'Dancing',
		[65] = 'Walking To Mac',
	},
	[24] = {
		[22] = 'Rolling Jab',
		[25] = 'Eye Rub',
		[26] = 'Bull Charge'
	},
	[25] = {
		[24] = 'Taunt'
	},
	[26] = { -- Mr. Sandman
		[03] = 'Dodge L.',
		[04] = 'Dodge R.',
		[24] = 'R. Jab',
		[26] = 'Dreamland E',
		[27] = 'Dreamland E',
		[28] = 'L. Hook-Jab',
		[29] = 'Dreamland E',
		[31] = 'Dreamland E',
	},
	[28] = { -- Tyson
		[24] = 'R. Hook',
		[25] = 'Eye Blink',
		[26] = 'L. Hook',
		[28] = 'L. Hook',
		[29] = 'L. Uppercut',
		[65] = 'Walking To Mac',
	},	
}

c.CurrentMacMove = function()
	return c.Read(c.Addr.MacCurrentMove) & 0x7F
end

c.GetMove = function()
	local oppMoveStr = nil

	local currOpp = c.Read(c.Addr.OppNumber)
	--last bit indicates something else, seems to be indicating the opponent got hit?
	local currMoveNum = c.Read(c.Addr.OpponentCurrentMove) & 0x7F

	-- Look for the opp table move
	local oppTable = c.Moves[currOpp]
	if oppTable ~= nil then
		oppMoveStr = oppTable[currMoveNum]
	end

	-- Fall back to generic
	if oppMoveStr == nil then
		oppMoveStr = c.Moves[0xFF][currMoveNum]
	end
	
	if oppMoveStr ~= nil then
		return oppMoveStr
	end

	-- Last resort, just return number
	return tostring(currMoveNum)
end

---------------------------------------
-- Bool Algorithms
---------------------------------------
c.Cap = function(func, limit)
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
end

---------------------------------------
-- TAS functions
---------------------------------------

function _addP(str)
	if (not bizstring.startswith(str, 'P1')) then
		return 'P1 ' .. str
	end

	return str
end

local function _doFrame(keys)
	if (keys ~= nil) then
		joypad.set(keys)
	end

	emu.frameadvance()
end

local function _keys()
	return {
		['P1 Up'] = false,
		['P1 Down'] = false,
		['P1 Left'] = false,
		['P1 Right'] = false,
		['P1 B'] = false,
		['P1 A'] = false,
		['P1 Select'] = false,
		['P1 Start'] = false,
	}
end

local function _push(b1, b2, b3, b4, b5, b6, b7, b8)
	if b1 == nil then
		error('b1 cannot be nil')
	end	
	keys = _keys()

	keys[_addP(b1)] = true
	if b2 ~= nil then
		keys[_addP(b2)] = true
	end
	if b3 ~= nil then
		keys[_addP(b3)] = true
	end
	if b4 ~= nil then
		keys[_addP(b4)] = true
	end
	if b5 ~= nil then
		keys[_addP(b5)] = true
	end
	if b6 ~= nil then
		keys[_addP(b6)] = true
	end
	if b7 ~= nil then
		keys[_addP(b7)] = true
	end
	if b8 ~= nil then
		keys[_addP(b8)] = true
	end

  	return keys
end

local function _rndButtons()
	return {
		['P1 Up'] = c.Flip(),
		['P1 Down'] = c.Flip(),
		['P1 Left'] = c.Flip(),
		['P1 Right'] = c.Flip(),
		['P1 B'] = c.Flip(),
		['P1 A'] = c.Flip(),
		['P1 Select'] =c.Flip(),
		['P1 Start'] = c.Flip(),
	}
end

local function _rndButtonsAtLeast(name)
	name = _addP(name)
	key1 = _rndButtons()
	key1[name] = true
 	return key1
end

c.WaitFor = function(frames)
	if (frames > 0) then
		for i = 1, frames, 1 do
			emu.frameadvance()
		end
	end
end

-- Ensures you will be on the lag frame before the input frame
c.UntilNextInputFrame = function ()
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
end

--Waits frames until the given mode, assumes no input is needed
c.UntilMode = function (mode)
	c.Save("CoreTemp")
	local startFrameCount = emu.framecount()

	while c.Mode() ~= mode do
		c.WaitFor(1)
	end

	local endFrameCount = emu.framecount()
	local targetFrames = endFrameCount - startFrameCount - 1

	c.Load("CoreTemp")
	if targetFrames > 0 then		
		c.WaitFor(targetFrames)
	end
end

--During the 'Fight is Starting' Mode, pushes random buttons until the Fighting mode and then to the first frame that punches can be thrown
c.RandomUntilMacCanFight = function()
	if c.Mode() ~= c.Modes.FightIsStarting then
		error('This function must only be called while the fight is starting!')
	end

	c.Save("CoreTemp")
	local startFrameCount = emu.framecount()

	while c.Mode() ~= c.Modes.Fighting do
		c.WaitFor(1)
	end

	local currMove = c.Read(c.Addr.OpponentCurrentMove)
	if currMove ~= 64 then
		error('Something went wrong, opponent is not walking to mac')
	end
	while currMove == 64 do
		c.WaitFor(1)
		currMove = c.Read(c.Addr.OpponentCurrentMove)
	end

	local endFrameCount = emu.framecount()
	local targetFrames = endFrameCount - startFrameCount - 2 -- Minus 2 to ensure we can dodge on the first frame if needed

	c.Load("CoreTemp")
	if targetFrames > 0 then		
		c.RandomFor(targetFrames)
	end

	c.WaitFor(2) -- We want to be one the exact frame that punches can be thrown
end

c.RandomFor = function(frames)	
	if (frames > 0) then
		for i = 1, frames, 1 do
			joypad.set(_rndButtons())
			emu.frameadvance()
		end
	end
end

c.PushFor = function(directionButton, frames)
	if not frames then
		frames = 1
	end
	if (not bizstring.startswith(directionButton, 'P1')) then
		directionButton = 'P1 ' .. directionButton
	end
	for i = 1, frames, 1 do
		_doFrame(_push(_addP(directionButton)))
	end
end

c.PushStart = function(numFrames)
	c.PushFor('Start', numFrames)
end

c.PushB = function(numFrames)
	c.PushFor('B', numFrames)
end

c.PushA = function(numFrames)
	c.PushFor('A', numFrames)
end

c.PushUpAndB = function(numFrames)
	if not frames then
		frames = 1
	end
	for i = 1, frames, 1 do
		_doFrame(_push('Up', 'B'))
	end
end

c.PushUpAndA = function(numFrames)
	if not frames then
		frames = 1
	end
	for i = 1, frames, 1 do
		_doFrame(_push('Up', 'A'))
	end
end

--Does a left quick dodge in the fewest frames possible and with as many random buttons as possible
c.QuickDodge = function()
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
end

--Does a left quick dodge in the fewest frames possible and with as many random buttons as possible
c.QuickRightDodge = function()
	c.PushFor('Right', 2)
	if c.CurrentMacMove() ~= 3 then
		c.Log('Mac did not start dodging')
		return false
	end

	c.RandomFor(3)
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
end

-- Peforms a duck in the fewest frames possible with as many random buttons as possible
c.Duck = function()
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

	c.RandomFor(23)
	c.WaitFor(2)
	if c.CurrentMacMove() ~= 1 then
		c.Log('Mac did not finish dodge')
		return false
	end

	return true
end

local function __finishFacePunch(punchType)
	if c.CurrentMacMove() ~= punchType then
		c.Log('Mac did not start face punch')
		return false
	end

	local orig = c.Read(c.Addr.OppHp)
	c.Save("CoreTemp")
	local startFrameCount = emu.framecount()

	while c.CurrentMacMove() ~= 1 and not c.IsOppKnockedDown() do
		c.WaitFor(1)
	end

	local endFrameCount = emu.framecount()
	local targetFrames = endFrameCount - startFrameCount - 2 -- Minus 2 to ensure we can take the next action, regardless of button state

	c.Load("CoreTemp")
	if targetFrames > 0 then		
		c.RandomFor(targetFrames)
	end
	c.WaitFor(2)

	local curr = c.Read(c.Addr.OppHp)
	local loss = orig - curr
	c.Debug(string.format('Opponent lost %s hp', loss))
	
	return loss > 0
end

-- Performs a left punch to the face of the opponent, pressing up minimally, and pushing as many random buttons as possible
c.LeftFacePunch = function()
	c.PushB()
	c.PushUpAndB()
	return __finishFacePunch(12)
end

c.RightFacePunch = function()
	c.PushA()
	c.PushUpAndA()
	return __finishFacePunch(11)
end

-- Advanced until opponent is KOed, and ensures they do not try and fail to get up
c.UntilKoFinishes = function()
	if not c.IsOppKnockedDown() then
		c.Log('Opponent must be knocked down to run this method')
		return false
	end

	if c.Read(c.Addr.OppMode) == 0 then
		while c.Read(c.Addr.OppMode) ~= 1 do
			c.RandomFor(1)
		end
	end

	while c.Read(c.Addr.FightEndFlag) ~= 26 do
		c.RandomFor(1)
		if c.Read(c.Addr.OppMode) == 2 then
			c.Log('Opponent tried to get up')
			c.Save(5)
			return false
		end
	end

	return true
end

c.UntilPostFightBlackScreen = function(maxFrames)
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
end
