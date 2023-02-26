-- Begins on the magic frame before the fight, manipulates the first round
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _readDrop()
	return c.Read(0x6E0D)
end

local function _alenaFirst()
	--Magic frame
	c.RndAtLeastOne()
	c.WaitFor(10)
	c.UntilNextInputFrame()
	c.WaitFor(2)
	c.RndAtLeastOne() -- Hun appears
	c.RandomFor(20)
	c.UntilNextInputFrame()
	c.WaitFor(2) -- Input frame important for early attack
	c.UntilNextInputFrame()

	c.PushDown()
	if c.ReadMenuPosY() ~= 17 then
		return c.Bail('Unable to navigate to Run')
	end
	
	c.WaitFor(1)
	c.PushDown()
	if c.ReadMenuPosY() ~= 18 then
		return c.Bail('Unable to navigate to parry')
	end
	c.WaitFor(1)
	c.PushDown()
	if c.ReadMenuPosY() ~= 19 then
		return c.Bail('Unable to navigate to item')
	end
	c.PushA() -- Pick Item
	
	c.WaitFor(3)
	c.UntilNextInputFrame()
	if c.ReadMenuPosY() ~= 16 then
		return c.Bail('Lagged at item menu')
	end

	c.PushDown()
	if c.ReadMenuPosY() ~= 17 then
		return c.Bail('Unable to navigate to Wing')
	end

	c.WaitFor(1)
	c.PushDown()
	if c.ReadMenuPosY() ~= 18 then
		return c.Bail('Unable to navigate to Wing 2')
	end

	c.WaitFor(1)
	c.PushDown()
	if c.ReadMenuPosY() ~= 19 then
		return c.Bail('Unable to navigate to iron claw')
	end

	c.PushA() -- Pick Iron Claw
	c.WaitFor(2)
	c.UntilNextInputFrame()

	c.PushDown()
	if c.ReadMenuPosY() ~= 17 then
		return c.Bail('Unable to navigate to equip')
	end
	c.PushA() -- Equip
	c.WaitFor(2)
	c.UntilNextInputFrame()

	c.PushA()

	c.RandomFor(30)
	c.UntilNextInputFrame()
	c.WaitFor(2)
	return c.ReadTurn() == 0
end

local function _critical()
	--c.DelayUpTo(1)
	c.RndAtLeastOne()
	c.RandomFor(1)
	c.WaitFor(7)
	c.UntilNextInputFrame()
	c.WaitFor(2)
	--c.DelayUpTo(1)
	c.RndAtLeastOne()
	c.WaitFor(5)
	local dmg = c.ReadDmg()
	c.Debug(string.format('Alena did %s damage', dmg))
	if dmg >= 58 then
		c.UntilNextInputFrame()
		c.WaitFor(2)
		return true
	end
	
	return false
end

local function _miss()
	local origHp = c.Read(c.Addr.AlenaHP)
	c.RndAtLeastOne()
	c.WaitFor(42)
	c.UntilNextInputFrame()
	c.WaitFor(2)
	c.RandomFor(20)
	c.UntilNextInputFrame()
	c.WaitFor(2)
	c.RndAtLeastOne()
	c.WaitFor(5)
	local currHp = c.Read(c.Addr.AlenaHP)
	c.Debug(string.format('Hun did %s', (origHp - currHp)))
	return currHp == origHp
end


c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
	local result = c.Cap(_alenaFirst, 1000)
	if result then		
		local cacheResult = c.AddToRngCache()
		if cacheResult then
			c.Log('Turn manipulated')
			c.Save(3)
			result = c.Cap(_critical, 600)
			if result then
				c.Save(4)
				c.Log('Got critical, attemping miss')
				result = c.ProgressiveSearch(_miss, 1000, 1)
				if result then
					c.Done()
				else
					c.Log('Unable to get miss')
				end		
			else
				c.LogProgress('Failed to get Critical, restarting', true)
			end
		else
			c.Log('Turn RNG already found, skipping')
		end
	else
		c.Log('Unable to manipulate turn order')
	end
end

c.Finish()
