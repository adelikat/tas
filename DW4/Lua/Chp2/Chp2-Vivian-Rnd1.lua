local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 0

function _vivianFirst()
	c.RandomFor(1)
	c.WaitFor(2)
	c.UntilNextInputFrame()
	c.WaitFor(2)
	c.RndAtLeastOne() -- Vivian appears
	c.RandomFor(19)
	c.UntilNextInputFrame()
	c.WaitFor(2) -- Input frame
	c.UntilNextInputFrame()
	c.PushA() -- Attack
	c.WaitFor(3)
	c.UntilNextInputFrame()

	c.DelayUpTo(10)
	
	c.PushA() -- Pick Vivian
	c.RandomFor(28)
	c.UntilNextInputFrame()
	
	c.Save(3)
	if c.ReadTurn() ~= 4 then
		return c.Bail('Vivian did not go first')
	end

	if c.ReadBattle() == 94 then
		return c.Bail('Vivian cast spell')
	end

	if c.ReadBattle() == 46 then
		return c.Bail('Vivian is on guard')
	end

	c.WaitFor(2)

	return true
end

function _miss()
	local origHp = c.Read(c.Addr.AlenaHP)
	c.RndAtLeastOne()
	c.WaitFor(5)

	local currHp = c.Read(c.Addr.AlenaHP)
	local dmg = origHp - currHp
	c.Debug('dmg: ' .. dmg)
	return dmg == 0
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
	local result = c.Cap(_vivianFirst, 1000)
	if result then
		c.Log('Turn manipulated')
		local cacheResult = c.AddToRngCache()
		if cacheResult then
			local result = c.ProgressiveSearch(_miss, 10, 10)
			if result then
				c.Done()
			else
				c.Log('Could not get a miss')
			end
		else
			c.Log('RNG already found')
		end
		c.Done()
	else
		c.Log('Unable to manip turn')
	end
end

c.Finish()
