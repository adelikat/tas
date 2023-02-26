-- Starts at the first frame to end the "terrific blow" dialog from the previous ound

local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 0

function _alenaFirstAndCrit()
	c.RndAtLeastOne()
	c.WaitFor(43)
	c.UntilNextInputFrame()
	c.WaitFor(2)

	c.RndAtLeastOne() -- x Damage points to Roric
	c.RandomFor(16)
	c.UntilNextInputFrame()
	c.WaitFor(2) -- Input frame
	c.UntilNextInputFrame()

	c.PushA() -- Attack
	c.WaitFor(3)
	c.UntilNextInputFrame()

	c.PushA() -- Roric
	c.RandomFor(20)
	c.WaitFor(5)

	
	if c.ReadTurn() ~= 0 then
		return c.Bail('Alena did not go first')
	end
	c.Save(4)
	c.UntilNextInputFrame()
	c.WaitFor(2)

	return true
end

local function _manipCrit()
	c.Save(5)
	c.DelayUpTo(10)
	c.RndAtLeastOne()
	c.WaitFor(4)
	c.Save(6)
	return c.ReadDmg() > 30
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
	local result = c.Cap(_alenaFirstAndCrit, 1000)
	if result then
		c.Log('Turn Manipulated')
		local rngCache = c.AddToRngCache()
		if rngCache then
			result = c.Cap(_manipCrit, 200)
			if result then
				c.Done()
			else
				c.Log('Unable to Manip crit')
			end
		else
			c.Log('RNG found, skipping')
		end		
	else
		c.Log('Unable to get Alena to go first')
	end
end

c.Finish()
