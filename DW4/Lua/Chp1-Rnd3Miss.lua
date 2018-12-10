local c = require("DW4-ManipCore")
c.InitSession()
c.maxDelay = 128
c.reportFrequency = 100

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

while not c.done do
	c.Load(0)
	delay = 0
	origRagnarHP = _readHp()
	earlyBailout = false
	c.RndAtLeastOne() -- attack enemy (critical)
	c.RandomFor(46)
	c.WaitFor(1)

	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.RndAtLeastOne() 
	c.RandomFor(17)
	c.WaitFor(5)

	--Attack
	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.PushA()
	c.RandomFor(1)
	c.WaitFor(3)

	--Pick Saro
	c.PushA()
	c.RandomFor(1)
		menuPos = _readMenu()
		if (menuPos ~= 31) then
			earlyBailout = true
			c.Debug('Failed to pick Saro, bailing attempt: ' .. c.attempts .. ' maxDelay: ' .. c.maxDelay)
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

		found = false
		if (turn == saroTurn and ragnarHP == origRagnarHP and battleFlag == 76 and newBattleFlag ~= 76) then
			found = true
			c.LogProgress('Miss!! delay: ' .. delay, true)
			c.Save(9)
			c.maxDelay = delay - 1
		end
		
		if (battleFlag == 76) then
			c.Debug(' Dmg: ' .. 27 - ragnarHP .. ' Battleflag: ' ..battleFlag)
		end

		c.Increment()
		if (found == true and delay == 0) then
			c.done = true
		end
	end
end

c.Finish()

