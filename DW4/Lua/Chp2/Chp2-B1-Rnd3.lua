local c = require("DW4-ManipCore")

c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 40

rabBTurn = 6
breyTargeted = 2
delay = 0

function _readMenuX()
	return c.Read(c.Addr.MenuPosX)
end

function _readMenuY()
	return c.Read(c.Addr.MenuPosY)
end

function _readBattle()
	return c.Read(c.Addr.BattleFlag)
end

function _readTurn()
	return c.Read(c.Addr.Turn)
end

function _readDmg()
	return c.Read(c.Addr.Dmg)
end

function _readRabBTarget()
	return c.Read(0x7306)
end

function _readAlenaTarget()
	return c.Read(0x7300)
end

function _readCristoTarget()
	return c.Read(0x7301)
end

function _readCristoHP()
	return c.Read(0x6020)
end

function _step(wait)
	if (wait > 0) then
		delay = delay + c.DelayUpTo(c.maxDelay - delay)
		c.RndAtLeastOne()
		c.RandomFor(wait - 2)
		c.WaitFor(2)
	end
end

function _getCritical()
	c.Save(20)
	c.Log('Attempting critical', true)
	local cap = 2500
	local cur = 0
	local found = false
	local wait2 = 22
	local wait1 = 51
	local minDmg = 11
	while cur < cap do
		delay = 0
		c.Load(20)
		_step(wait2)
		_step(wait1)
		delay = delay + c.DelayUpTo(c.maxDelay - delay)
		c.RndAtLeastOne()
		c.Save(21)
		battle = _readBattle()
		c.WaitFor(35)
		dmg = _readDmg()
		if dmg >= minDmg then
			found = true
			c.LogProgress('Critical! delay: ' .. delay, true)
			c.Load(21)
			c.Save(700 + delay)
			c.maxDelay = delay - 1
			if delay == 0 then
				cur = cap
			end
		else
			c.Debug('dmg: ' .. dmg)
		end

		cur = cur + 1
		c.Increment('delay: ' .. delay .. ' dmg: ' .. dmg)
	end

	if found == false then
		return 999
	else
		return c.maxDelay
	end
end

function _killCristo()
	c.Save(20)
	local killCur = 0
	local killCap = 200
	dead = false
	while not dead and killCur < killCap do
		c.Load(20)
		c.RndAtLeastOne()
		c.RandomFor(1)
		c.WaitFor(10)
		if _readCristoHP() == 0 then
			dead = true
			c.Debug('Cristo dead')
		else
			killCur = killCur + 1
		end
	end

	if dead then
		c.WaitFor(51)
		return true
	else
		return false
	end
end

while not c.done do
	c.Load(0)
	local orderManipulated = false

	c.RndAtLeastOne()
	c.RandomFor(27)
	c.WaitFor(2)
	c.PushA()
	c.WaitFor(1)
	bail = false
		if _readMenuX() ~= 5 then
			c.Debug('Lagged on alena attack, aborting')
			bail = true
		end
	if not bail then
		c.WaitFor(3)
		c.PushA()
		c.RandomFor(1)
		bail = false
			if _readAlenaTarget() ~= 138 then
				c.Debug('Lagged on alena target, aborting')
				bail = true
			end
		if not bail then
			c.RandomFor(13)
			c.WaitFor(2)
			c.PushA()
			c.WaitFor(1)
			bail = false
				if _readMenuX() ~= 5 then
					c.Debug('Lagged on cristo attack, aborting')
					bail = true
				end
			if not bail then
				c.WaitFor(3)
				c.PushA()
				c.RandomFor(1)
				bail = false
					if _readCristoTarget() ~= 138 then
						c.Debug('Lagged on cristo target, aborting')
						bail = true
					end
				if not bail then
					c.RandomFor(30)
					c.WaitFor(3)
					turn = _readTurn()
					rabBTarget = _readRabBTarget()
					c.Debug('Turn: ' .. turn .. ' Target: ' .. rabBTarget)
					if turn == 6 and rabBTarget == 1 then
						orderManipulated = true
						c.Save(6)
						c.Debug('Turn manipulated')
					end
				end
			end
		end
	end


	if orderManipulated then
		c.LogProgress('Order manipulated', true)
		if _killCristo() then
			c.Save(7)
			result = _getCritical()
			--result = -1
			if result == -1 then
				c.Done()
			else
				c.Log('Failed to find optimal critical, continuing', true)
			end
		else
			c.Log('Failed to kill cristo, continuing', true)
		end
		
	end

	c.Increment()
end

c.Finish()