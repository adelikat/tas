-- Starts at the magic frame before the Roric fight
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100

local function _miss()
	c.RandomFor(1)
	c.WaitFor(11)
	c.UntilNextInputFrame()
	c.WaitFor(2)
	c.RndAtLeastOne()
	c.RandomFor(19)
	c.UntilNextInputFrame()
	c.WaitFor(2) -- Input frame
	c.UntilNextInputFrame()
	c.PushA() -- Attack
	c.WaitFor(3)
	c.UntilNextInputFrame()
	c.PushA() -- Pick Roric
	c.RandomFor(30)
	c.UntilNextInputFrame()
	if c.ReadTurn() ~= 4 then
		return c.Bail('Roric did not go first')
	end
	if c.ReadBattle() ~= 76 then
		return c.Bail('Roric did not attack')
	end

	c.WaitFor(2)

	local origHp = c.Read(c.Addr.AlenaHP)
	c.RndAtLeastOne()
	c.WaitFor(5)
	local currHp = c.Read(c.Addr.AlenaHP)

	c.Debug(string.format('Roric did %s dmg', (origHp - currHp)))
	if currHp == origHp then
		c.UntilNextInputFrame()
		c.WaitFor(2)
		return true
	end

	return false
end

local function _critical()
	c.RndAtLeastOne()
	c.RandomFor(19)
	c.UntilNextInputFrame()
	c.WaitFor(2)
	c.RndAtLeastOne()
	c.WaitFor(5)
	local dmg = c.ReadDmg()
	c.Save(6)
	c.Debug('Alena dmg: ' .. dmg)
	return dmg > 40
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
	local result = c.Cap(_miss, 1000)	
	if result then
		local cacheResult = c.AddToRngCache()
		if cacheResult then
			c.Save(6)
			result = c.Cap(_critical, 256)
			if result then
				c.Done()
			else
				c.Log('Failed to find critical')
			end
			
		else
			c.Log('Rng found, skipping')
		end		
	else
		c.Log('Unable to manip miss')
	end
end

c.Finish()
