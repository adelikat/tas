_odds = 64 --1 in x
_minDmg = 18
_idealDmg = 0 --Max critical
_idealDelay = 0

_wait3 = 0
_wait2 = 0
_wait1 = 30

local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = _odds

local bestDmg = 0
local delay = 0

attackBegin = 76
sleep = 102
miss = 7

function _readDmg()
	return c.Read(c.Addr.Dmg)
end

function _readBattle()
	return c.Read(c.Addr.BattleFlag)
end

function _step(wait, noDelay)
	if (wait > 0) then
		if not noDelay then
			delay = delay + c.DelayUpTo(c.maxDelay - delay)
		end
		c.RndAtLeastOne()
		c.RandomFor(wait - 2)
		c.WaitFor(2)
	end
end

function _saveBest(delay)
	c.Save(9)
	c.Save('Critical' .. delay)
end

function _checkBattleFlag(battle)
	if battle == attackBegin then
		c.Debug('Attack delayed, still attempting to attack')
	elseif battle == sleep then
		c.Debug('Someone is aleep!')
	elseif battle == miss then
		c.Debug('Attack missed')
	end
	return battle ~= attackBegin and battle ~= sleep and battle ~= miss
end

while not c.done do
	c.Load(10)
	delay = 0

	_step(_wait3, true)
	_step(_wait2)
	_step(_wait1)

	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.RndAtLeastOne()
	c.WaitFor(10)

	-- Eval
	--------------------------------------
	dmg = _readDmg()
	battle = _readBattle()
	c.Debug('dmg: ' .. dmg .. ' battle: ' .. battle)

	if dmg >= _minDmg and (_idealDmg == 0 or dmg <= _idealDmg)
		and _checkBattleFlag(battle)
		then
		found = true
		c.LogProgress('Critical! dmg: ' .. dmg .. ' delay: ' .. delay, true)
		c.maxDelay = delay - 1
		_saveBest(delay)
		
		bestDmg = dmg
	elseif _minDmg < _idealDmg and dmg  > bestDmg
		and _checkBattleFlag(battle)
		then
		bestDmg = dmg
		_saveBest(delay)
		c.LogProgress('New Best for this delay: ' .. dmg .. ' delay: ' .. delay, true)
	else
		found = false
	end

	c.Increment('dmg: ' .. dmg)

	if (found == true and delay <= _idealDelay and (bestDmg == _idealDmg or _idealDmg == 0)) then
		c.done = true
	end
end

c.Finish()
