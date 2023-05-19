-------------------------
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000 -- How many attempts before it logs a result
c.maxDelay = 0

_direction = 'Down'
_frames = 46

bestCounter = 999

function _isEncounter()
	return c.Read(c.Addr.EGroup1Type) ~= 0xFF
end

while not c.done do
	c.Load(0)
	encounter = false

	for i = 0, _frames, 1 do
		c.RndWalking(_direction)
		if _isEncounter() then
			encounter = true
			c.Debug('Encounter')
			break
		end
	end

	if not encounter then
		count = c.ReadStepCounter()
		if count < bestCounter then
			c.LogProgress('New Best: ' .. count, true)
			bestCounter = count
			c.Save(9)
			c.Save(99)
		else
			c.Debug('No Ecounters')
		end
	end
	c.Increment()
end

c.Finish()


