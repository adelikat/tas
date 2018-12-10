_odds = 128 --1 in x
_minDmg = 55
_idealDmg = 60 --Max critical
_wait3 = 0
_wait2 = 0
_wait1 = 23

local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
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

	if dmg >= _minDmg then
		found = true
		c.LogProgress('Critical! dmg: ' .. dmg .. ' delay: ' .. delay, true)
		c.maxDelay = delay - 1
		c.Save(9)
		bestDmg = dmg
	elseif dmg  > bestDmg then
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
