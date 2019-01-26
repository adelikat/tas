walking = 15
direction = 'Up'
cap = 50
best = 999999999

local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100

function _isEncounter()
	return c.Read(c.Addr.EGroup1Type) ~= 0xFF
end

while not c.done do
	c.Load(0)
	c.RndWalkingFor('Up', 157)
	c.PushA()
	c.WaitFor(21)

	c.PushDown()
	c.WaitFor(1)
	c.PushDown()
	c.WaitFor(1)
	c.PushDown()
	c.PushA()
	c.PushFor('Up', 139)

	encounter = false
	for i = 0, walking, 1 do
		if _isEncounter() then
			encounter = true
			break
		else
			c.RndWalking(direction)
		end
	end

	if encounter then
		c.Debug('Encounter')
	else
		c.WaitFor(10)
		lag = true
		while lag do
			lag = emu.islagged()
			c.WaitFor(1)
		end

		frames = emu.framecount()
		if (frames < best) then
			best = frames
			c.Log("best so far: " .. frames .. " attempt " .. c.attempts)
			c.Save(9)
		end
	end

	c.Increment()
	if (c.attempts > cap) then
		c.Abort()
	end
end

c.Finish()
