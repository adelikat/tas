-----------------
-- Settings
-----------------
_wait3 = 0
_wait2 = 0 --47
_wait1 = 27 --28

_odds = 128
_hpAddr = 0x60B6
_attack = 76
_miss = 98

-------------------------
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = _odds
local delay = 0

function _readBattle()
	return c.Read(c.Addr.BattleFlag)
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

	originalHP = c.Read(_hpAddr)
	delay = 0
	wait = 23

	delay = delay + c.DelayUpTo(c.maxDelay - delay)
		c.RndAtLeastOne()
		c.RandomFor(wait - 2)
		c.WaitFor(2)

	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	battle = _readBattle()
	c.RndAtLeastOne()
	c.RandomFor(2)
	c.WaitFor(50) -- Ensure damage is calculated and in memory
	postBattle = _readBattle()
	--------------------------------------
	newHP = c.Read(_hpAddr)
	if newHP == originalHP
		and battle == _attack
		and postBattle == _miss
	 then
	 	found = true
	 	c.LogProgress('Miss! ' .. ' newHP: ' .. newHP, true)
	 	c.maxDelay = delay - 1
	 	c.Save(9)
	else
		found = false
	end

	dmg = originalHP - newHP
	c.Increment('dmg: ' .. dmg .. ' newHP: ' .. newHP .. ' action: ' .. battle)

	if (found == true and delay == 0) then
		c.done = true
	end
end

c.Finish()



