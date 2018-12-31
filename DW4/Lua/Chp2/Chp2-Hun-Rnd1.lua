local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100

function _readDrop()
	return c.Read(0x6E0D)
end

function _alenaFirst()
	c.Save(20)
	local found = false
	while not found do
		c.Load(20)
		--Magic frame
		c.RndAtLeastOne()
		c.WaitFor(14)
		c.RndAtLeastOne()
		c.RandomFor(23)
		c.WaitFor(2)

		c.PushDown()
		bail = false
			if c.ReadMenuPosY() ~= 17 then
				bail = true
				c.Debug('Lagged at attack options')
			end
		if not bail then
			c.WaitFor(1)
			c.PushDown()
			c.WaitFor(1)
			c.PushDown()
			c.PushA()
			c.WaitFor(6)

			c.PushDown()
			c.WaitFor(1)
			c.PushDown()
			c.WaitFor(1)
			c.PushDown()
			c.PushA()
			bail = false
				if c.ReadMenuPosY() ~= 19 then
					bail = true
					c.Debug('Lagged at Iron claw pick')
				end
			if not bail then
				c.WaitFor(2)
				c.PushDown()
				c.PushA()
				c.WaitFor(4)
				c.PushA()
				c.WaitFor(1)
				bail = false
					if c.ReadMenuPosY() ~= 31 then
						bail = true
						c.Debug('Lagged at Hun pick')
					end
				if not bail then
					c.RandomFor(32)
					c.WaitFor(2)

					bail = false
						if c.ReadTurn() ~= 0 then
							bail = true
							c.Debug('Hun went first')
						end

					if not bail then
						found = true
						c.LogProgress('Alena Initiative Rng2: ' .. c.ReadRng2(), true)
						c.Save(300)
						c.Save(3)
					end
				end
			end
		end
		Increment()
	end
end

function _critical()
	c.Save(21)
	local critFound = false
	local cur = 0
	local cap = 128
	local dmg = 0
	while cur < cap do
		c.Load(21)
		--Alena holds the Iron Claw
		c.RndAtLeastOne()
		c.RandomFor(10)
		c.WaitFor(2)

		--Alena attacks
		c.PushA()
		c.WaitFor(5)
		dmg = c.ReadDmg()
		c.Debug('Alena Dmg: ' .. dmg)

		cur = cur + 1
		c.Increment()
		
		if dmg >= 60 then
			c.LogProgress('Critical!!', true)
			critFound = true
			cur = cap
			c.Save(400)
			c.Save(4)
		end
	end

	return critFound
end

while not c.done do
	c.Load(0)
	_alenaFirst()
	result = _critical()
	if result then
		c.Done()
	else
		c.LogProgress('Failed to get Critical, restarting', true)
	end
end

c.Finish()