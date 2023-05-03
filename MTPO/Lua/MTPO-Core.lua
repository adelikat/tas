--TODOs
--Indicate that an opponent is TKO or KO'ed when they get knocked down, instead of showing next health
--Where am I still has issues, bike scene is "between rounds", knocked down is knocked down for a bit but then something else
--Make damage animation last longer
--draw image - make period and pace only take 4 chars, calculate backdrop accordingly
local _lastOppHealth = -1
local _currOppHealth = -1
local _oppHp = 0x0398
local _done = false
local function _isDebug()
	return client.getconfig().SpeedPercent < 800
end
local function _trackOppHealth()
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
end

c = {
	InitSession = function()
		_done = false
		_trackOppHealth()
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
		['IsInFightMode'] = 0x022, -- If 1, then opponent is doing intro moves or is being knocked down
		['OpponentTimer'] = 0x0039,
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
c.IsOppBeingHit = function()
	return c.Read(c.Addr.IsOppBeingHit) > 0 or c.Read(c.Addr.OppHpGradual) > c.Read(c.Addr.OppHp)
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


