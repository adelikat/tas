local _done = false
local function _isDebug()
	return client.getconfig().SpeedPercent < 800
end

local c = {
	InitSession = function()
		_done = false
	end,
	IsDone = function()
		return _done
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
	end
	Debug = function(msg)
		if _isDebug() then
			console.log(msg)
		end
	end
}

c.InitSession()
client.unpause()
c.Load(0)
-- This template lives at `.../Lua/.template.lua`.
while not c.IsDone() do
	c.Debug('Debugging')
	if emu.framecount() == 3000 then
		c.Done()
	end
	
	-- Code here will run once when the script is loaded, then after each emulated frame.
	emu.frameadvance();
end

c.Finish()
