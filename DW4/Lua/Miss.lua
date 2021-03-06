local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 64

_wait3 = 0
_wait2 = 47
_wait1 = 24 

_hpAddr = c.Addr.TaloonHp
_attack = 76
_miss = 98

-------------------------
local delay = 0

function _readBattle()
	return c.Read(c.Addr.BattleFlag)
end

function _readHp()
	return c.Read(_hpAddr)
end

function _step(wait)
	if (wait > 0) then
		delay = delay + c.DelayUpTo(c.maxDelay - delay)
		c.RndAtLeastOne()
		c.RandomFor(wait - 2)
		c.WaitFor(2)
	end
end

while not c.done do
	c.Load(0)
	delay = 0
	oHp = _readHp()

	_step(_wait3)
	_step(_wait2)
	_step(_wait1)

	
	battle = _readBattle()
	c.RndAtLeastOne()
	c.RandomFor(2)
	c.WaitFor(50) -- Ensure damage is calculated and in memory
	postBattle = _readBattle()
	--------------------------------------
	newHP = _readHp()
	if newHP == oHp
		and battle == _attack
		and postBattle == _miss
	 then
	 	found = true
	 	c.LogProgress('Miss! ' .. ' delay: ' .. delay, true)
	 	c.maxDelay = delay - 1
	 	c.Save(9)
	else
		found = false
	end

	dmg = oHp - newHP
	c.Increment('delay: ' .. delay .. ' dmg: ' .. dmg .. ' newHP: ' .. newHP .. ' action: ' .. battle)

	if (found == true and delay == 0) then
		c.done = true
	end
end

c.Finish()



