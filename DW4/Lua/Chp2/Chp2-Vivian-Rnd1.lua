local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 0

function _vivianFirst()
	c.Save(20)
	delay = 0
	local found = false
	while not found do
		c.Load(20)
		--Magic frame
		c.RndAtLeastOne()
		c.WaitFor(14)

		delay = delay + c.DelayUpTo(c.maxDelay - delay)
		c.RndAtLeastOne()
		c.RandomFor(23)
		c.WaitFor(2)

		c.PushA()
		c.WaitFor(4)

		delay = delay + c.DelayUpTo(c.maxDelay - delay)
		c.PushA()
		c.RandomFor(1)
		bail = false
				if c.ReadMenuPosY() ~= 31 then
					bail = true
					c.Debug('Lagged at Vivian pick')
				end
		if not bail then
			c.RandomFor(31)
			c.WaitFor(2)

			bail = false
			if c.ReadTurn() == 4 and c.ReadBattle() == 76 then
				found = true
				c.LogProgress('Vivian Initiative', true)
				c.Save(300)
				c.Save(3)
			end
		end
		
		Increment()
	end
end

bestDelay = 300
function _miss()
	c.Save(21)
	local missDelay = 0
	local missFound = false
	while not missFound and missDelay < bestDelay do
		c.Load(21)
		c.WaitFor(missDelay)
		c.PushA()
		c.WaitFor(50)
		isMiss = c.ReadBattle()
		c.Debug('Frame: ' .. missDelay .. ' isMiss: ' .. isMiss)
		if isMiss == 98 then
			c.LogProgress('-----', true)
			c.LogProgress('Miss found! delay: ' .. missDelay, true)
			bestDelay = missDelay
			missFound = true
			c.Save(9)
			c.Save(99)
		else
			missDelay = missDelay + 1
		end
	end

	if not missFound then
		return -1
	end

	return bestDelay
end

while not c.done do
	c.Load(0)
	_vivianFirst()
	result = _miss()
	if result == 0 then
		c.Done()
	else
		c.LogProgress('Best so far: ' .. bestDelay .. ', restarting', true)
	end
end

c.Finish()