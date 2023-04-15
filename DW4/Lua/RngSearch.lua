
-- Runs through a scenario poking all RNG values to see if the situation is possible
-- The _do method should not have any random button presses or delays
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

-- local bestDamage = 0
-- local function _do()
-- 	c.PushA()
-- 	c.WaitFor(10)
-- 	local dmg = c.ReadDmg()
-- 	c.Debug('dmg: ' .. dmg)
-- 	if dmg > bestDamage then
-- 		c.Log('New Best Damage: ' .. dmg)
-- 		bestDamage = dmg
-- 	end
--     -- if dmg >= 225 then
--     --     return true
--     -- end
--     -- return false
-- end

local function _do()	
    c.PushA()
    c.WaitFor(35)

    if c.ReadTurn() ~= 4 then
        return c.Bail('Radimvice did not go first')
    end

    if c.ReadBattleOrder1() > 2 then
        return c.Bail('Hero did not get initiative over Demighouls')
    end

	if c.Read(c.E1Action) ~= 15 then
		return c.Bail('Radimvice must cast Intermost in order for Taloon to cover mouth')
	end

	c.UntilNextInputFrame()
	c.WaitFor(2)
	_tempSave(4)
	-----------------
	c.Save('RadimviceTemp')
	local origHeroHp = c.Read(c.Addr.HeroHP)
	local origTaloHp = c.Read(c.Addr.TaloonHP)
	c.RndAtLeastOne()
	c.WaitFor(5)
	local currHeroHp = c.Read(c.Addr.HeroHP)
	local currTaloHp = c.Read(c.Addr.TaloonHP)
	local heroLoss = origHeroHp - currHeroHp
	local taloonLoss = origTaloHp - currTaloHp
	c.Debug(string.format('H loss: %s, T loss: %s', heroLoss, taloonLoss))
	if currHeroHp ~= origHeroHp or origTaloHp ~= currTaloHp then
		return c.Bail('Taloon did not cover mouth')
	end
	-----------------
	c.Load('RadimviceTemp')

    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
client.unpause()
client.speedmode(3200)
while not c.done do
	c.Load(100)
	local result = c.RngSearch(_do)	
	if c.Success(result) then
		c.Log('Attempts: ' .. c.attempts)
		c.Done()
	else
		c.Log('Nothing found')
	end

	--c.Log('Total Best Damage: ' .. bestDamage)
	c.Done()
end

c.Finish()



