
-- Runs through a scenario poking all RNG values to see if the situation is possible
-- The _do method should not have any random button presses or delays
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local bestDamage = 0
-- local function _do()
-- 	c.PushA()
-- 	c.WaitFor(10)
-- 	local dmg = c.ReadDmg()
-- 	c.Debug('dmg: ' .. dmg)
-- 	if dmg > bestDamage then
-- 		c.Log('New Best Damage: ' .. dmg)
-- 		bestDamage = dmg
-- 	end
--     return false
-- end

local leastDamage = 99999
local maxNonCritDmg = 30
local function _do()
	c.WaitFor(1)
    c.WaitFor(14)

    c.PushA()
    c.WaitFor(7)
    
    c.PushA()
    c.WaitFor(26)
    c.WaitFor(5)
    if not c.PushAWithCheck() then return false end
    c.WaitFor(10)
    c.WaitFor(5)
    if not c.PushAWithCheck() then return false end
    c.WaitFor(2)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end
    c.WaitFor(30)

    --------------------
    if c.ReadTurn() ~= 4 then
        return c.Bail('Rhinoking did not go first')
    end

    if c.Read(c.Addr.E1Action) ~= 67 then
        return c.Bail('Rhinoking did not attack')
    end

    if c.Read(c.Addr.E1Target) ~= 0 then
        return c.Bail('Rhinoking did not target Hero')
    end

    if c.ReadBattleOrder1() < c.ReadBattleOrder5() then
        return c.Bail('Hero went before Rhinoking')
    end

	if c.ReadBattleOrder6() < c.ReadBattleOrder2() then
        return c.Bail('Bengal went before Taloon')
    end

    if c.Read(0x7334) ~= 247 then
        return c.Bail('Rhinoking had a 2nd action')
    end

    --------------------

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

	c.Log('Total Best Damage: ' .. bestDamage)
	c.Done()
end

c.Finish()



