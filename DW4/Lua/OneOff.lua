local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 2

-- local function _tempSave(slot)
--     c.Log('Saving ' .. slot)
--     c.Save(slot)
-- end

c.ReadBattleOrder1 = function()
    return c.Read(c.Addr.BattleOrder1) & 0xF
end

c.ReadBattleOrder2 = function()
    return c.Read(c.Addr.BattleOrder2) & 0xF
end

c.ReadBattleOrder3 = function()
    return c.Read(c.Addr.BattleOrder3) & 0xF
end

c.ReadBattleOrder4 = function()
    return c.Read(c.Addr.BattleOrder4) & 0xF
end

c.ReadBattleOrder5 = function()
    return c.Read(c.Addr.BattleOrder5) & 0xF
end

c.ReadBattleOrder6 = function()
    return c.Read(c.Addr.BattleOrder6) & 0xF
end

c.ReadBattleOrder7 = function()
    return c.Read(c.Addr.BattleOrder7) & 0xF
end

c.ReadBattleOrder8 = function()
    return c.Read(c.Addr.BattleOrder8) & 0xF
end

local function _do()
	c.WaitFor(1)
	c.Log('Hero ' .. c.ReadBattleOrder1())
	c.Log('Nara ' .. c.ReadBattleOrder2())
	c.Log('Mara ' .. c.ReadBattleOrder3())
	c.Log('Hector ' .. c.ReadBattleOrder4())
	c.Log('FlamerA ' .. c.ReadBattleOrder5())
	c.Log('Bengal ' .. c.ReadBattleOrder6())
	c.Log('FlamerB ' .. c.ReadBattleOrder7())
	c.Log('NA ' .. c.ReadBattleOrder7())
	return false
end

-- local function _do()
-- 	local origHp = c.Read(c.Addr.HeroHP)
-- 	c.DelayUpTo(c.maxDelay)
-- 	c.RndAtLeastOne()
-- 	c.RandomFor(25)
-- 	c.UntilNextInputFrame()
-- 	c.WaitFor(2)
	

-- 	c.RndAtLeastOne()
-- 	c.RandomFor(12)
-- 	c.UntilNextInputFrame()
-- 	c.WaitFor(2)

-- 	c.DelayUpTo(c.maxDelay)
-- 	c.RndAtLeastOne()
-- 	c.WaitFor(5)

-- 	local currHp = c.Read(c.Addr.HeroHP)

-- 	if currHp == origHp then
-- 		c.Log('Miss found ' .. emu.framecount())
-- 		c.Save(string.format('TricksyRnd1-Miss-%s-Rng2-%s-Rng1-%s', emu.framecount(), c.ReadRng2(), c.ReadRng1()))
-- 		return true
-- 	end
-- end

--c.Load(4)
--c.Save(100)
c.RngCacheClear()
while not c.done do
	--c.Load(100)
	local result = c.Cap(_do, 10000)	
	if c.Success(result) then
		c.Done()
	else
		c.Log('Nothing found')
	end
end

c.Finish()



