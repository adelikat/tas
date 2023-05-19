-- Starts at first frame to end the 21 damage points to Skeleton dialog
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

c.Load(0)
c.Save(100)
while not c.done do
	c.Load(100)
	c.RndAtLeastOne()
	c.RandomFor(48)
	bail = false
		if c.ReadMenuPosY() ~= 16 then
			c.Debug('Lag before Round begin')
			bail = true
		end
	if not bail then
		c.RandomFor(1)
		c.WaitFor(2)

		c.PushA()
		c.WaitFor(4)
		c.PushA()
		c.RandomFor(2)
		bail = false
			if c.ReadMenuPosY() ~= 31 then
				c.Debug('Lag during attack')
				bail = true
			end
		if not bail then
			c.RandomFor(30)
			if c.ReadTurn() ~= 4 then
				c.WaitFor(4)

				c.LogProgress('Alena attack Rng2: ' .. c.ReadRng2(), true)
				c.Save(4)

				c.RndAtLeastOne()
				c.WaitFor(10)
				if c.ReadDmg() >= 20 then
					c.Save(5)
					c.Save(9)
					c.Save(99)
					c.Done()
				end
			end
		end
	end

	c.Increment()
end

c.Finish()
