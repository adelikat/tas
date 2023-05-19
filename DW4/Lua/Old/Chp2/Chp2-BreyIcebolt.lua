local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 2
_minDmg = 16
delay = 0

_wait1 = 53

function _readDmg()
	return c.Read(c.Addr.Dmg)
end

function _readBattle()
	return c.Read(c.Addr.BattleFlag)
end

function _step(wait)
	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.RndAtLeastOne()
	c.RandomFor(wait - 2)
	c.WaitFor(2)
end

c.Load(0)
c.Save(100)
while not c.done do
	c.Load(100)
	delay = 0

	_step(_wait1)

	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.RndAtLeastOne()
	c.WaitFor(35)

	-- Eval
	--------------------------------------
	dmg = _readDmg()
	battle = _readBattle()

	found = false
	if dmg >= _minDmg and battle == 22
		then
		found = true
		c.LogProgress('Hit! dmg: ' .. dmg .. ' delay: ' .. delay, true)
		c.maxDelay = delay - 1
		c.Save(9)
		bestDmg = dmg
	end

	reportedDmg = dmg
	if battle == 24 then
		reportedDmg = 0
	end

	c.Increment('dmg: ' .. reportedDmg)

	if found == true and delay == 0 then
		c.done = true
	end
end

c.Finish()
