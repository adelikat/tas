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
		['OpponentCurrentMove'] = 0x0090,
		['GameMode'] = 0x00A9, -- Bad name, but will change if between rounds, intro screen, fight, etc
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
		return 'Black Screen Between Fights'
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
-- TAS functions
---------------------------------------
local function _doFrame(keys)
	if (keys ~= nil) then
		joypad.set(keys)
	end

	emu.frameadvance()
end

local function _push(name)
	key1 = {}	
	key1['P1 Up'] = false
	key1['P1 Down'] = false
	key1['P1 Left'] = false
	key1['P1 Right'] = false
	key1['P1 B'] = false
	key1['P1 A'] = false
	key1['P1 Select'] = false
	key1['P1 Start'] = false
	key1[name] = true
  	return key1
end

local function _rndBool()
	x = math.random(0, 1)
	if (x == 1) then
		return true
	end

	return false
end

local function _rndButtons()
	key1 = {}
	key1['P1 Up'] = _rndBool()
	key1['P1 Down'] = _rndBool()
	key1['P1 Left'] = _rndBool()
	key1['P1 Right'] = _rndBool()
	key1['P1 B'] = _rndBool()
	key1['P1 A'] = _rndBool()
	key1['P1 Select'] = _rndBool()
	key1['P1 Start'] = _rndBool()

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
	console.log('Opponent is walking to mac')
	if currMove ~= 64 then
		error('Something went wrong, opponent is not walking to mac')
	end
	while currMove == 64 do
		c.WaitFor(1)
		currMove = c.Read(c.Addr.OpponentCurrentMove)
	end

	c.WaitFor(1) -- We want to be one the exact frame that punches can be thrown


	local endFrameCount = emu.framecount()
	local targetFrames = endFrameCount - startFrameCount - 1

	c.Load("CoreTemp")
	if targetFrames > 0 then		
		c.RandomFor(targetFrames)
	end
end



c.RandomFor = function(frames)	
	if (frames > 0) then
		for i = 1, frames, 1 do
			joypad.set(_rndButtons())
			emu.frameadvance()
		end
	end
end

c.PushStart = function(numFrames)
	if not numFrames then
		numFrames = 1
	end
	for i = 1, numFrames do
		_doFrame(_push('P1 Start'))
	end
end


