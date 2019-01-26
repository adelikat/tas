local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 0

function _alenaFirst()
	c.Save(20)
	delay = 0
	local found = false
	while not found do
		c.Load(20)
		--Magic frame
		c.RndAtLeastOne()
		c.RandomFor(20)
		c.WaitFor(2)

		c.PushA()
		c.WaitFor(4)
		c.PushA()

		c.RandomFor(1)
		bail = false
				if c.ReadMenuPosY() ~= 31 then
					bail = true
					c.Debug('Lagged at Roric pick')
				end
		if not bail then
			c.RandomFor(30)
			c.WaitFor(2)
			bail = false
			if c.ReadTurn() == 0 then
				found = true
				c.LogProgress('Alena Initiative', true)
				c.Save(500)
				c.Save(5)
			end
		end
		
		Increment()
	end
end

bestDelay = 55
function _critial()
	c.Save(21)
	local critDelay = 0
	local critFound = false
	while not critFound and critDelay < bestDelay do
		c.Load(21)
		c.WaitFor(critDelay)
		c.PushA()
		c.WaitFor(50)
		dmg = c.ReadDmg()
		c.Debug('Frame: ' .. critDelay .. ' dmg: ' .. dmg)
		if dmg >= 30 then
			c.LogProgress('-----', true)
			c.LogProgress('Crit found! delay: ' .. critDelay, true)
			bestDelay = critDelay
			critFound = true
			c.Save(9)
			c.Save(99)
		else
			critDelay = critDelay + 1
		end
	end

	if not critFound then
		return -1
	end

	return bestDelay
end

while not c.done do
	c.Load(0)
	_alenaFirst()
	result = _critial()
	if result == 0 then
		c.Done()
	else
		c.LogProgress('Best miss: ' .. result .. ', restarting', true)
	end
end

c.Finish()