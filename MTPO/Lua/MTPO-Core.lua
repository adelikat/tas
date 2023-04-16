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

local c = {
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
		['OpponentTimer'] = 0x0039,
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
		[13] = 'Mike Tyson'
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
------------------------------------------------------------------------------------------------
-- Drawing functions

-- Some rings are offset by 1 pixel for some reason
local function _isRngOffSet()
	local opp = c.Read(c.Addr.OppNumber)
	if opp == 2 or opp == 6 or opp == 7 or opp == 8 or opp == 9 or opp == 11 or opp == 12 or opp == 13 then
		return true
	end
end

local function _drawHealthBar(x1, y1, hp, dmg, color)
	local opp = c.Read(c.Addr.OppNumber)
	if _isRngOffSet() then
		x1 = x1 + 1
	end
	local y2 = 22
	gui.drawBox(x1, y1, x1 + 47, y2, 'black', 'black')
	if hp > 0 then
		if color == nil then
			color = 'ForestGreen'
			if hp < 24 then
				color = 'pink'
			elseif hp < 48 then
				color = 'Gold'
			end
		end

		local x2 = math.ceil(x1 + hp / 2) - 1
		gui.drawBox(x1, y1, x2, y2, color, color)

		if dmg > 0 then
			gui.drawBox(x2, y1, x2 + math.ceil((dmg / 2)), y2, 'Crimson', 'Crimson')
			gui.drawBox(x1 + 16, y1 - 12, x1 + 40 , y1 - 1, 'black', 'black')
			gui.drawText(x1 + 16, y1 - 14, '-' .. dmg, 'Crimson')
		end
		gui.drawBox(x1, y1 - 12, x1 + 16, y1 - 1, 'black', 'black')
		gui.drawText(x1 - 1, y1 - 14, hp, color)
	end
end
hud = {
	Opp = function()
		if not c.IsInFight() then
			return
		end

		local txt = c.CurrentOpponent()
		local w = string.len(txt) * 8
		gui.drawRectangle(256 - w, 0, w, 9, 'Black', 'Black')
		gui.drawText(256, -3, txt, 'white', nil, nil, nil, nil, 'right')
	end,
	Health = function()
		if not c.IsInFight() then
			return
		end

		local hp, dmg, color
		if c.IsOppKnockedDown() then
			if c.IsOpponentKnockedOut() then
				hp = 0
			else
				hp = c.Read(c.Addr.OppNextHealth)
			end			
			dmg = 0
			color = 'darkgray'
		elseif c.IsOppBeingHit() then
			hp = c.Read(c.Addr.OppHp)
			dmg = c.LastDamage()
			color = nil
		else
			hp = c.Read(c.Addr.OppHp)
			dmg = c.Read(c.Addr.OppHpGradual) - hp
			color = nil
		end
		
		_drawHealthBar(144, 16, hp, dmg, color)
		
		if c.IsMacKnockedDown() then
			hp = c.Read(c.Addr.MacNextHealth)			
			dmg = 0
			color = 'darkgray'
		else
			hp = c.Read(c.Addr.MacHealth)
			dmg = c.Read(c.Addr.MacHealthGraudal) - hp
			color = nil	
		end

		-- Mac
		_drawHealthBar(88, 16, hp, dmg, color)
	end,
	StarCountdown = function()		
		totalPunchesToGetStar = c.Read(c.Addr.TotalStarCountdown)
		if totalPunchesToGetStar <= 1 then
			return
		end
		punchesLeftToGetStar = c.Read(c.Addr.StarCountdown)
		local totalWidth = 26
		local percent = punchesLeftToGetStar / totalPunchesToGetStar
		local width = totalWidth * percent
		gui.drawLine(13, totalWidth, 13 + totalWidth, 26, 'darkGray')
		gui.drawLine(13, 26, 13 + width, 26, 'blue')
	end
}
hud.Display = function()
	gui.clearGraphics()
	hud.Opp()
	hud.Health()
	hud.StarCountdown()
end
------------------------------------------------------------------------------------------------

c.InitSession()
--client.unpause()
--c.Load(0)
while not c.Processing() do
	hud.Display()
	emu.frameadvance();
end

c.Finish()
