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
	InitSession = function()
		_done = false
		TrackHealth()
	end,
	Done = function()
		_done = true
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
		['WhoIsKnockedDown'] = 0x0005,
		['Round'] = 0x0006,
		['RNG'] = 0x0018,
		['IsInFightMode'] = 0x022, -- If 1, then opponent is doing intro moves or is being knocked down
		['OpponentTimer'] = 0x0039,
		['OpponentNextMove'] = 0x003A, -- Don't understand this one yet
		['OpponentCurrentMove'] = 0x0090,
		['GameMode'] = 0x00A9, -- Bad name, but will change if between rounds, intro screen, fight, etc
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
	Opponents = {
		[0] = 'Glass Joe',
		[1] = 'Von Kaiser',
		[2] = 'Piston Honda 1',
		[3] = 'Don Flamenco 1',
		[4] = 'King Hippo',
		[5] = 'Great Tiger',
		[6] = 'Bald Bull 1',
		[7] = 'Piston Honda 2',
		[8] = 'Soda Popinski',
		[9] = 'Bald Bull 2',
		[10] = 'Don Flamenco 2',
		[11] = 'Mr. Sandman',
		[12] = 'Super Macho Man',
		[13] = 'Mike Tyson',
		[19] = 'Demo Bald Bull',
		[20] = 'King Hippo',
		[21] = 'Great Tiger',
		[22] = 'Piston Honda 2',
		[23] = 'Soda Popinski',
		[24] = 'Bald Bull 2',
		[25] = 'Don Flamenco 2',
		[26] = 'Mr. Sandman',
		[27] = 'Super Macho Man',
		[28] = 'Mike Tyson'
	}
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
c.IsInFight = function()
	return c.Read(c.Addr.IsInFight) == 1
end
c.IsOpponentKnockedOut = function()
	-- TODO: Ko's
	if c.Read(c.Addr.KnockdownsRound) >= 3 then
		return true
	end

	return false
end
c.Mode = function()
	if c.Read(0x22) == 1 then		
		local kosThisRound = c.Read(c.Addr.KnockdownsRound)
		if kosThisRound == 3 then
			return 'TKO'
		elseif kosThisRound > 0 then
			return 'Opponent knocked down'
		end

		return 'Fight is starting'
	end

	if c.IsInFight() then
		if c.IsOppKnockedDown() then
			return 'Opponent knocked down'
		end
	
		if c.IsMacKnockedDown() then
			return 'Mac is knocked down'
		end
		
		return 'Fighting'
	end

	local mode = c.Read(c.Addr.GameMode)
	if mode == 0 then
		return 'Black Screen'
	end
	if mode == 4 then
		return 'Title Screen'
	end
	if mode == 5 then		
		return 'Between rounds'
	end
	if mode == 6 then
		return 'Between rounds'
	end
	if mode == 7 then
		return 'Round Number screen'
	end
	if mode == 8 then
		return 'Mike Tyson Intro'
	end
	return tostring(mode)
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

