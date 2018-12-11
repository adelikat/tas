local c = require("DW4-ManipCore")

c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 0

chameleonTurn = 5
attacks = 76
alenaTargeted = 0
cristoTargeted = 1
breyTargeted = 2

function _readMenu()
	return c.Read(c.Addr.MenuPos)
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
						c.Done()
					end
				end
			end
			
		end
		
	end

	
	c.Increment()
end

c.Finish()


