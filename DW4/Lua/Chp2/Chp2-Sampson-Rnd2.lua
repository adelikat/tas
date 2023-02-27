local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 0

function _turnOrder()
    c.DelayUpTo(10)
	c.RndAtLeastOne()
	c.WaitFor(43)
	c.UntilNextInputFrame()	
	c.WaitFor(2)

	c.RndAtLeastOne()
	c.RandomFor(17)

	c.UntilNextInputFrame()
	c.WaitFor(2) -- Input frame
	c.UntilNextInputFrame()
	c.PushA() -- Attack
	c.WaitFor(3)
	c.UntilNextInputFrame()

	c.PushA() -- Pick Sampson
	c.RandomFor(28)    
	c.UntilNextInputFrame()
	
	if c.ReadTurn() ~= 4 then
		return c.Bail('Sampson did not go first')
	end

    if c.ReadBattle() ~= 76 then
        return c.Bail('Sampson did not attack')
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

function _critical()
    c.RndAtLeastOne()
    c.WaitFor(4)
    return c.ReadDmg() > 20
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
	local result = c.Cap(_turnOrder, 1000)
	if result then
		local cacheResult = c.AddToRngCache()
		if cacheResult then
			local result = c.Cap(_miss, 1)
			if result then
				c.Done()
			else
				c.Log('Could not get a miss')
			end
		else
			c.Log('RNG already found')
		end
	--else
		--c.Log('Unable to manip turn')
	end
end

c.Finish()
