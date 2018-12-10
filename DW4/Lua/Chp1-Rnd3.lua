local c = require("DW4-ManipCore")
c.InitSession()
c.maxDelay = 0
c.reportFrequency = 1000

function _readBattle()
	return c.Read(c.Addr.BattleFlag)
end

function _readHp()
	return c.Read(0x60B6)
end

function _readDmg()
	return c.Read(c.Addr.Dmg)
end

function _readMenu()
	return c.Read(c.Addr.MenuPos)
end

function _manipulateMiss()
	local done = false
	c.Save(10)

	while not done do
		c.Load(10)
		origRagnarHP = _readHp()
		earlyBailout = false
		c.RndAtLeastOne() -- attack enemy (critical)
		c.RandomFor(46)
		c.WaitFor(1)

		c.RndAtLeastOne() 
		c.RandomFor(17)
		c.WaitFor(5)

		--Attack
		c.PushA()
		c.RandomFor(1)
		c.WaitFor(3)

		--Pick Saro
		c.PushA()
		c.RandomFor(1)
			menuPos = _readMenu()
			if (menuPos ~= 31) then
				earlyBailout = true
				c.Debug('Failed to pick Saro, bailing attempt: ' .. c.attempts)
				c.attempts = c.attempts + 1
			end
		c.RandomFor(15)
		c.WaitFor(21)

		if (earlyBailout == false) then
			turn = c.Read(0x0096)
			battleFlag = _readBattle()

			c.RndAtLeastOne()
			c.WaitFor(25)

			c.attempts = c.attempts + 1
			ragnarHP = _readHp()

			dmg = c.Read(0x7361)
			newBattleFlag = _readBattle()

			saroTurn = 4
			saroAttack = 76

			if (turn == saroTurn and ragnarHP == origRagnarHP and battleFlag == 76 and newBattleFlag ~= 76) then
				done = true
				c.LogProgress('Miss!!', true)
				c.Save(9)
			end
			
			if (battleFlag == 76) then
				c.Debug(' Dmg: ' .. 27 - ragnarHP .. ' Battleflag: ' ..battleFlag)
			end

			--c.Increment()
		end
	end
end

function _manipulateCritical()
	c.Save(11)
	c.attempts = 0
	local done = false
	local cap = 3000
	local cur = 0
	local delay = 0
	local wait = 23
	local minDmg = 57
	local idealDmg = 60
	local bestDmg = 0
	while done == false and cur < cap do
		c.Load(11)
		delay = delay + c.DelayUpTo(c.maxDelay - delay)
		c.RndAtLeastOne()
		c.RandomFor(wait - 2)
		c.WaitFor(2)

		delay = delay + c.DelayUpTo(c.maxDelay - delay)
		c.RndAtLeastOne()
		c.WaitFor(35)

		--------------------------------------
		dmg = _readDmg()
		battle = _readBattle()

		found = false
		if dmg >= minDmg then
			found = true
			c.LogProgress('Critical! dmg: ' .. dmg .. ' delay: ' .. delay, true)
			c.maxDelay = delay - 1
			c.Save(9)
			c.Save(12)
			bestDmg = dmg
		elseif dmg  > bestDmg and dmg > minDmg then
			bestDmg = dmg
			c.Save(12)
			c.LogProgress('New Best for this delay: ' .. dmg .. ' delay: ' .. delay, true)
		end

		c.Increment('dmg: ' .. dmg)
		cur = cur + 1

		if (found == true and delay == 0) then
			c.LogProgress('Done! ' .. bestDmg)
			done = true
		elseif cur == cap then
			done = true
		end
	end

	local success = cur < cap or bestDmg >= minDmg
	Debug('Critical Result: ' .. tostring(success))
	return success
end

while not c.done do
	c.Load(0)
	_manipulateMiss()
	local result = _manipulateCritical()
	if result == true then
		c.done = true
	end
end

c.Finish()

