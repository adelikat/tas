--Starts at the first frame "A terrific blow" apppears
--Manipulates the fastest loading screen entering tower
cap = 500
best = 999999999

local c = require("DW4-ManipCore")
c.reportFrequency = 100
c.InitSession()
c.Save(10)

function _setup()
	c.WaitFor(1)
	c.RndAtLeastOne()
	c.RandomFor(1)
	c.UntilNextInputFrame()
	c.WaitFor(2)

	c.RndAtLeastOne()
	c.RandomFor(1)
	c.UntilNextInputFrame()
	c.WaitFor(2)

	--Ragnar passes away
	c.RndAtLeastOne()
	c.RandomFor(21)
	c.UntilNextInputFrame()
	c.WaitFor(2)

	-- Ragnar passes away (again)
	c.RndAtLeastOne()
	c.RandomFor(20)
	c.UntilNextInputFrame()
	
	--Death text
	c.PushAorB()
	c.WaitFor(1)
	c.UntilNextInputFrame()

	c.PushAorB() --Chosen ones. It's not the time to give up
	c.WaitFor(1)
	c.UntilNextInputFrame()

	c.PushAorB()
	c.WaitFor(1)
	c.UntilNextInputFrame()

	--Magic frame
	c.RandomFor(1)
	c.WaitFor(1)
	c.UntilNextInputFrame()
	c.WaitFor(2)
	c.RndAtLeastOne()
	c.WaitFor(1)
	c.UntilNextInputFrame()
	c.PushA() -- Bring up menu
	c.RandomFor(7) -- Another magic frame
	c.UntilNextInputFrame()

	-- We can move right, down, or vice versa, each changes the rng, so try both
	flip = GenerateRndBool()

    --Sometimes pushing right does not work but down does, what a weird game
	--if 	flip then
	--	c.PushRight()
	--	c.PushDown()
	--else
		c.PushDown()
		c.PushRight()
	--end
	if c.Read(0x03CF) ~= 33 then
		c.Debug('Lagged on command menu, bailing')
		return false
	end

	c.PushA()
	c.WaitFor(2)
	c.UntilNextInputFrame()

	c.PushA() -- Pick Ragn
	c.WaitFor(2)
	c.UntilNextInputFrame()

	c.PushDown()
	c.WaitFor(1)
	c.PushDown()
	c.PushA() -- Pick Flying Shoes
	c.WaitFor(2)
	c.UntilNextInputFrame()

	c.PushA() -- Use
	c.RandomFor(1)
	c.WaitFor(430)

	return true
end

while not c.done do
	c.Load(10)
	result = _setup()

	if result then
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
			c.Save('Tower' .. frames)
		end

		c.Increment()
		if (c.attempts > cap) then
			c.Abort()
		end
	end
end

c.Finish()