local c = require("DW4-ManipCore")

c.InitSession()
c.reportFrequency = 5000
c.maxDelay = 5

chameleonTurn = 5
attacks = 76
alenaTargeted = 0
cristoTargeted = 1
breyTargeted = 2
delay = 0

function _readMenu()
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
	local cap = 6000
	local cur = 0
	local found = false
	local wait2 = 62
	local wait1 = 33
	local minDmg = 12
	local asleep = false
	while cur < cap do
		delay = 0
		c.Load(20)
		_step(wait2)
		_step(wait1)
			if _readBattle() == 102 then
				c.Debug('Cristo asleep')
				asleep = true
			end
		delay = delay + c.DelayUpTo(c.maxDelay - delay)
		c.RndAtLeastOne()
		c.Save(21)
		battle = _readBattle()
		c.WaitFor(35)
		dmg = _readDmg()
		if dmg >= minDmg and asleep == false and battle ~= 102 then --102 can happen if cristo falls asleep
			found = true
			c.LogProgress('Critical! delay: ' .. delay, true)
			c.Load(21)
			c.Save(700 + delay)
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
	c.RndWalkingFor('Up', 500)
	c.WaitFor(672)
	c.RandomFor(1)
	local bail = false
		if emu.islagged() then
			c.Debug('Lagged on magic frame, aborting')
			bail = true
		end

	orderManipulated= false
	if bail == false then
		c.WaitFor(14)
		c.RndAtLeastOne()
		c.WaitFor(8)
		c.RndAtLeastOne()
		c.WaitFor(8)
		c.RndAtLeastOne() -- Last Rabid hound appears

		c.RandomFor(30)
		c.WaitFor(2)
		c.PushA()
		c.RandomFor(1)
		c.WaitFor(5)
		delay = delay + c.DelayUpTo(c.maxDelay - delay)
		c.PushA() -- Alena > Rabidhound A
		c.WaitFor(8)
			bail = false
			if _readMenu() ~= 31 then
				c.Debug('Lagged on alena attack, aborting')
				bail = true
			end

		if bail == false then
			c.WaitFor(8)
			c.PushA()
			c.RandomFor(1)
			c.WaitFor(5)
			delay = delay + c.DelayUpTo(c.maxDelay - delay)
			c.PushA() -- Cristo -> Rabidhound A
			c.WaitFor(8)
			bail = false
			if _readMenu() ~= 31 then
				c.Debug('Lagged on cristo attack, aborting')
				bail = true
			end

			if bail == false then
				c.WaitFor(8)
				c.PushDown()
				c.PushA()
				c.RandomFor(1)
				c.WaitFor(5)
				delay = delay + c.DelayUpTo(c.maxDelay - delay)
				c.PushA() -- Icebolt
				c.RandomFor(1)
				c.WaitFor(7)
				c.PushDown()
					bail = false
					if _readMenu() ~= 17 then
						c.Debug('Lagged on brey attack, aborting')
						bail = true
					end

				if bail == false then
					c.PushA()
					c.RandomFor(38)
					c.WaitFor(2)

					-- Chameleon attacks
					turn = _readTurn()
					battle = _readBattle()
					chamTarget = _readChamTarget()

					bo1 = c.Read(0x7348) == 114;
					bo2 = c.Read(0x7349) == 3;
					bo3 = c.Read(0x734A) == 118;

					if turn == chameleonTurn
						and battle == attacks
						and chamTarget == cristoTargeted
						and bo1
						and bo2
						and bo3
						then
						c.Save(3)
						orderManipulated = true
					end
				end
			end
		end
	end

	if orderManipulated then
		c.LogProgress('Order manipulated, attempting Alena critical', true)
		result = _getCritical()
		if result == -1 then
			c.Done()
		else
			c.Log('Failed to find optimal critical, continuing', true)
		end
	end

	c.Increment()
end

c.Finish()

