-----------------
-- Settings
-----------------

_wait2 = 62
_wait1 = 24

_enemyDmg = 6
_minDmg = 27
_cap = 2000

local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 128

function _readDmg()
	return c.Read(c.Addr.Dmg)
end

function _readBattle()
	return c.Read(c.Addr.BattleFlag)
end

function _readTurn()
	return c.Read(c.Addr.Turn)
end

function _getToEnemyAttack()
	c.Save(10)
	local dmg = 0
	local found = false
	while found == false do
		c.Load(10)
		c.RandomFor(1) -- Magic frame
		c.WaitFor(14)

		--Enemy Appears
		c.RndAtLeastOne()
		c.RandomFor(1)
		c.WaitFor(1) 
		c.RandomFor(18)
		c.WaitFor(5)

		--Attack
		c.PushA()
		c.RandomFor(1)
		c.WaitFor(3)

		--Pick Arrow
		c.PushUp()
		c.PushA()
		c.WaitFor(2)

		--Pick Self
		c.PushA()
		
		c.RandomFor(1)
		c.WaitFor(1)
		c.RandomFor(12)
		c.WaitFor(23)

		attacks = _readTurn() == 4 and _readBattle() == 76

		if attacks then
			--check that dmg will be correct
			c.Save(11)
			c.RndAtLeastOne()
			c.WaitFor(2)
			c.WaitFor(100)

			dmg = _readDmg()
			if dmg >= _enemyDmg then
				_minDmg = _minDmg - dmg
				c.Load(11)
				found = true
			end
		end
	end

	c.Log('Found Enemy Attack First with ' .. dmg .. ' dmg Need to critical: ' .. _minDmg)
end

function _getCritical()
	c.Save(11)
	local cur = 0
	

	local found = false
	while found == false and cur < _cap do
		c.Load(11)
		c.RndAtLeastOne()
		c.RandomFor(_wait2 - 2)
		c.WaitFor(2)

		c.RndAtLeastOne()
		c.RandomFor(_wait1 - 2)
		c.WaitFor(2)

		c.RndAtLeastOne()
		c.WaitFor(35)

		dmg = _readDmg()
		battle = _readBattle()

		c.Increment('dmg: ' .. dmg)
		if dmg >= _minDmg then
			found = true
			c.Log('Critical! Attempt: ' .. c.attempts .. ' delay: ' .. delay .. ' dmg: ' .. dmg)
			savestate.saveslot(9)
		elseif dmg >= 17 then
			c.Log('Critical ' .. dmg)
		end

		cur = cur + 1
	end

	local success = cur < _cap
	c.Log('Search success? ' .. tostring(success))
	return success
end

while not c.done do
	c.Load(0)
	_getToEnemyAttack()
	success = _getCritical()
	if (success == true) then
		c.done = true
	end
	

	--if (found == true and delay == 0) then
--		c.done = true
--	end
end

c.Finish()
