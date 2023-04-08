
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
	c.PushA()
	c.WaitFor(10)
	local dmg = c.ReadDmg()
	c.Debug('dmg: ' .. dmg)
	if dmg < leastDamage and dmg > maxNonCritDmg then
		c.Log('New Best Damage: ' .. dmg)
		leastDamage = dmg
	end
    return false
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



