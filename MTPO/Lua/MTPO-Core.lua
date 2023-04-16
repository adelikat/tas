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
		['IsOppKnockedDown'] = 0x0005,
		['OpponentTimer'] = 0x0039,
		['HeartsTens'] = 0x0323,
		['HeartsSingle'] = 0x0324,
		['Stars'] = 0x0342,
		['MacHp'] = 0x0391,
		['OppHp'] = _oppHp,
		['OppNextHealth'] = 0x039E,
		['IsOppBeingHit'] = 0x03E0,
	},	
}

c.Processing = function()
	_trackOppHealth()	
	return _done
end
c.ReadOppHealth = function()
	return c.Read(c.Addr.OppHp)
end
c.IsOppBeingHit = function()
	return c.Read(c.Addr.IsOppBeingHit) > 0
end
c.LastOppHealth = function()
	return _lastOppHealth
end
c.LastDamage = function()
	return _lastOppHealth - _currOppHealth
end

------------------------------------------------------------------------------------------------

c.InitSession()
client.unpause()
c.Load(0)
while not c.Processing() do
	gui.text(0, 70, 'Opp Health: ' .. c.ReadOppHealth())
	
	
	if c.IsOppBeingHit() or true then
		gui.text(200, 230, c.LastDamage())
		gui.text(200, 250, string.format('Last %s', _lastOppHealth))
		gui.text(200, 270, string.format('Curr %s', _currOppHealth))		
	end

	emu.frameadvance();
end

c.Finish()
