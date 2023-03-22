local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 2

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _do()
	local origHp = c.Read(c.Addr.HeroHP)
	c.DelayUpTo(c.maxDelay)
	c.RndAtLeastOne()
	c.RandomFor(25)
	c.UntilNextInputFrame()
	c.WaitFor(2)
	

	c.RndAtLeastOne()
	c.RandomFor(12)
	c.UntilNextInputFrame()
	c.WaitFor(2)

	c.DelayUpTo(c.maxDelay)
	c.RndAtLeastOne()
	c.WaitFor(5)

	local currHp = c.Read(c.Addr.HeroHP)

	if currHp == origHp then
		c.Log('Miss found ' .. emu.framecount())
		c.Save(string.format('TricksyRnd1-Miss-%s-Rng2-%s-Rng1-%s', emu.framecount(), c.ReadRng2(), c.ReadRng1()))
		return true
	end
end

c.Load(4)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
	local result = c.Best(_do, 10000)	
	if c.Success(result) then
		c.Done()
	else
		c.Log('Nothing found')
	end
end

c.Finish()



