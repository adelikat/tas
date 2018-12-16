local c = require("DW4-ManipCore")

c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 0

chameleonTurn = 5
attacks = 76
alenaTargeted = 0
cristoTargeted = 1
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

function _readChamTarget()
	return c.Read(0x7305)
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

function _readBreyTarget()
	return c.Read(0x7302)
end

function _step(wait)
	if (wait > 0) then
		delay = delay + c.DelayUpTo(c.maxDelay - delay)
		c.RndAtLeastOne()
		c.RandomFor(wait - 2)
		c.WaitFor(2)
	end
end

successCount = 0
function _saveSuccess()
	c.Save(1000 + successCount)
	successCount = successCount + 1
end

function _getCritical()
	c.Save(20)
	local cap = 1200
	local cur = 0
	local found = false
	local wait2 = 62
	local wait1 = 32
	local minDmg = 10
	local asleep = false
	while cur < cap do
		delay = 0
		c.Load(20)
		_step(wait2)
		_step(wait1)
			if _readBattle() == 102 then
				c.Debug('Brey asleep')
				asleep = true
			end
		delay = delay + c.DelayUpTo(c.maxDelay - delay)
		c.RndAtLeastOne()
		c.Save(21)
		battle = _readBattle()
		c.WaitFor(35)
		dmg = _readDmg()
		if dmg >= minDmg and asleep == false and battle ~= 102 then --102 can happen if brey falls asleep
			found = true
			c.LogProgress('Critical! delay: ' .. delay, true)
			c.Load(21)
			c.Save(600 + delay)
			c.maxDelay = delay - 1
		elseif dmg >= 10 and battle ~= 102 then
			c.LogProgress('Low Critical: ' .. dmg)
		end
		if delay == 0 then
			cur = cap
		else
			cur = cur + 1
			c.Increment('delay: ' .. delay .. ' dmg: ' .. dmg)
		end
	end

	if found == false then
		return 999
	else
		return c.maxDelay
	end
end

while not c.done do
	c.Load(0)
	local orderManipulated = false
	c.RndAtLeastOne()
	c.RandomFor(27)
	c.WaitFor(3)
	delay = delay + c.DelayUpTo(c.maxDelay - delay)
	c.PushA() --Alena Attack
	c.RandomFor(1)
	c.WaitFor(4)
	bail = false
		if _readMenuX() ~= 5 then
			c.Debug('Lagged on alena attack, aborting')
			bail = true
		end
	if not bail then
		c.PushDown()
		c.PushA() --Pick Rab B
		c.RandomFor(1)
		bail = false
			if _readAlenaTarget() ~= 138 then
				c.Debug('Lagged on alena target, aborting')
				bail = true
			end
		if not bail then
			c.RandomFor(12)
			c.WaitFor(2)
			delay = delay + c.DelayUpTo(c.maxDelay - delay)
			c.PushA() -- Cirsto Attack
			c.RandomFor(1)
			bail = false
				if _readMenuX() ~= 5 then
					c.Debug('Lagged on cristo attack, aborting')
					bail = true
				end
			if not bail then
				c.WaitFor(4)
				c.PushA() -- Pick Cham
				c.RandomFor(1)
				bail = false
					if _readCristoTarget() ~= 137 then
						c.Debug('Lagged on cristo target, aborting')
						bail = true
					end
				if not bail then
					c.RandomFor(12)
					c.WaitFor(2)
					c.PushDown()
					bail = false
						if _readMenuY() ~= 17 then
							c.Debug('Lagged on brey spell, aborting')
							bail = true
						end
					if not bail then
						delay = delay + c.DelayUpTo(c.maxDelay - delay)
						c.PushA() -- Brey Spell
						c.RandomFor(1)
						c.WaitFor(6)
						c.PushA() -- Ice bolt
						c.RandomFor(1)
						c.WaitFor(6)
						c.PushA() -- Pick Cham
						c.RandomFor(1)
						bail = false
							if _readBreyTarget() ~= 137 then
								c.Debug('Lagged on brey target, aborting')
								bail = true
							end
						if not bail then
							c.RandomFor(30)
							c.WaitFor(8)

							--eval
							-- Chameleon attacks
							turn = _readTurn()
							battle = _readBattle()
							chamTarget = _readChamTarget()
							rabBTarget = _readRabBTarget()

							bo1 = c.Read(0x7348) == 116;
							bo2 = c.Read(0x7349) == 2;
							bo3 = c.Read(0x734A) == 117;
							c.Debug('turn: ' .. turn .. ' battle: ' .. battle .. ' chamTarget: ' .. chamTarget)

							if turn == chameleonTurn
								and battle == attacks
								and chamTarget == breyTargeted
								and rabBTarget == breyTargeted
								--and bo1
								--and bo2
								and bo3
							then
								c.Save(4)
								_saveSuccess()
								orderManipulated = true
							end
						end
					end
				end
			end
		end
	end

	if orderManipulated then
		c.LogProgress('Order manipulated, attempting Cristo critical', true)
		--result = _getCritical()
		result = fail
		if result == -1 then
			c.Done()
		else
			c.Log('Failed to find optimal critical, continuing', true)
		end
	end

	c.Increment()
end

c.Finish()


