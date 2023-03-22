-- Starts at the 'magic frame' at the beginning of the Tricksy Urchin fight
-- Tricksy Urchin actions
-- 77 emit fireball
-- 62 building up power
-- 67 attack
-- Notes
-- Building up power is not necessarily faster than an attack + miss, but has no RNG so in a chain of unlikely events could be
-- Once power is built up, it is either impossible or incredibly unlikely to miss the next attack
-- So building power is ideal on the round before defeating the enemy but not sooner
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 5
local delay = 0

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _turn()
    c.RandomFor(1)
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- Vampire Bat appears
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne()
    c.RandomFor(23)
    c.UntilNextInputFrame()
    c.WaitFor(2) -- Input frame
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        c.Log('unable to navigate to spell, saving to Fail')
        c.Save('Fail')
        return c.Bail('Unable to navigate to spell')
    end
    c.PushA() -- Pick Spell

    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushA() -- Pick Expel
    c.WaitFor(2)
    c.UntilNextInputFrame()
    delay = c.DelayUpToWithLAndR(2)
    c.PushA() -- Pick Vampire Bats
    c.RandomFor(40)
    c.UntilNextInputFrame()

    c.AddToRngCache()
    c.Debug('RNG: ' .. c.RngCacheLength())

    if c.ReadTurn() ~= 0 then
        return c.Bail('Hero did not go first')
    end

    if c.Read(0x732A) ~= 67 then
        return c.Bail('Tricksy Urchin-A did not attack')
    end

    if c.Read(0x732B) ~= 67 then
        return c.Bail('Tricksy Urchin-B did not attack')
    end

    c.WaitFor(2)

    c.Save(string.format('TricksyRnd1-Turn-%s-Rng2-%s-Rng1-%s', emu.framecount(), c.ReadRng2(), c.ReadRng1()))
    return true
end

local function _expel()
    c.RndAtLeastOne()
    c.WaitFor(10)
    if c.ReadE1Hp() > 0 then
        return c.Bail('Vampire-A did not disappear')
    end
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne()
    c.WaitFor(10)
    if c.ReadE2Hp() > 0 then
        return c.Bail('Vampire-B did not disappear')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.Save(string.format('TricksyRnd1-Expel-%s-Rng2-%s-Rng1-%s', emu.framecount(), c.ReadRng2(), c.ReadRng1()))
    return true
end

local function _miss()
	local origHp = c.Read(c.Addr.HeroHP)
	c.Debug('Orig HP: ' .. origHp)
	c.RndAtLeastOne()
	c.RandomFor(25)
	c.UntilNextInputFrame()
	c.WaitFor(2)

	c.RndAtLeastOne()
	c.WaitFor(10)
	
	local currHp = c.Read(c.Addr.HeroHP)
	c.Debug('Curr HP: ' .. currHp)

	if currHp == origHp then
		c.Log('Miss found ' .. emu.framecount())
		c.Save(string.format('TricksyRnd1-Miss-%s-Rng2-%s-Rng1-%s', emu.framecount(), c.ReadRng2(), c.ReadRng1()))
		return true
	end
end

local function _miss2()
	local origHp = c.Read(c.Addr.HeroHP)
	c.Debug('Orig HP: ' .. origHp)
	c.RndAtLeastOne()
	c.RandomFor(17)
	c.UntilNextInputFrame()
	c.WaitFor(2)

	c.RndAtLeastOne()
	c.WaitFor(10)
	
	local currHp = c.Read(c.Addr.HeroHP)
	c.Debug('Curr HP: ' .. currHp)

	if currHp == origHp then
		c.Log('Miss found ' .. emu.framecount())
		c.Save(string.format('TricksyRnd1-Miss-%s-Rng2-%s-Rng1-%s', emu.framecount(), c.ReadRng2(), c.ReadRng1()))
		return true
	end
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)
    local result = c.ProgressiveSearch(_miss2, 500, 10)
    if result then
        c.Log('Delay: ' .. delay)
        c.Done()
    end
    
    -- local result = c.Cap(_turn, 100)
    -- if c.Success(result) then       
    --     c.Log('Turn Success - Delay: ' .. delay) 
    --     result = c.Cap(_expel, 10)
    --     if result then
    --         c.Log('Expel Success - Delay: ' .. delay) 
    --     end
    --     --c.Done()
    -- else
    --     c.Log('Could not manip turn')
    -- end
end

c.Finish()
