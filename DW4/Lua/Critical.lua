_odds = 17 --1 in x
_minDmg = 10
_idealDmg = 10 --Max critical
_wait3 = 0
--alena rnd 1: _wait2 = 62
--alena rnd 1: _wait1 = 33
_wait2 = 51
_wait1 = 31

local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = _odds
local bestDmg = 0
local delay = 0

function _readDmg()
	return c.Read(c.Addr.Dmg)
end

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
	delay = 0

	_step(_wait3)
	_step(_wait2)
	_step(_wait1)

	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.RndAtLeastOne()
	c.WaitFor(35)

	-- Eval
	--------------------------------------
	dmg = _readDmg()
	battle = _readBattle()

	if dmg >= _minDmg and dmb ~= 13
		--and battle == 76
		then
		found = true
		c.LogProgress('Critical! dmg: ' .. dmg .. ' delay: ' .. delay, true)
		c.maxDelay = delay - 1
		c.Save(9)
		bestDmg = dmg
	elseif dmg  > bestDmg and battle == 76 then
		bestDmg = dmg
		c.Save(9)
		c.LogProgress('New Best for this delay: ' .. dmg .. ' delay: ' .. delay, true)
	else
		found = false
	end

	c.Increment('dmg: ' .. dmg)

	if (found == true and delay == 0 and bestDmg == _idealDmg) then
		c.done = true
	end
end

c.Finish()
