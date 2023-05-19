local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 0

_bestDelay = 300

while not c.done do
	c.Load(0)

	c.RndAtLeastOne()
	c.WaitFor(14)
	c.RndAtLeastOne()

	c.RandomFor(23)
	c.WaitFor(2)
	
	c.PushA()
	if (emu.islagged()) then
		c.Debug('Attempt: ' .. c.attempts .. ' lagged before press attack')
	else
		c.WaitFor(4)
		c.PushUp()
		c.PushA()
		c.WaitFor(3)
		c.PushA()
		if (emu.islagged()) then
			c.Debug('Attempt: ' .. c.attempts .. ' lagged before pick slime')
		else
			c.RandomFor(31)
			c.WaitFor(2)

			turn = c.ReadTurn()
			if (turn == 0) then
				c.Save(3)
				c.PushA()
				c.RandomFor(1)
				c.WaitFor(30)
				dmg = c.ReadDmg()
				if (dmg >= 17) then
					c.Done()
				else
					c.Debug('Dmg: ' .. dmg)
				end				
			end
		end
	end
end

c.Finish()