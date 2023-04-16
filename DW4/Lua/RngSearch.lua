
-- Runs through a scenario poking all RNG values to see if the situation is possible
-- The _do method should not have any random button presses or delays
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 0
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
    c.WaitFor(2)
    c.WaitFor(12)
    c.PushA()
    c.WaitFor(7)
    c.PushA()
    c.WaitFor(30)
    c.WaitFor(5)
    if not c.PushAWithCheck() then return false end -- Fight
    c.WaitFor(10)
    c.WaitFor(5)
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Spell')
    end
    if not c.PushAWithCheck() then return false end -- Spell
    c.WaitFor(6)
    if not c.PushAWithCheck() then return false end -- Expel
    c.WaitFor(6)
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Demighoul')
    end
    c.DelayUpToWithLAndR(c.maxDelay)
    if not c.PushAWithCheck() then return false end
    c.WaitFor(35)

    c.AddToRngCache()
    ---------------------------------------
    if c.ReadTurn() ~= 0 then
		return c.Bail('Hero did not go first')
	end

	if c.Read(c.Addr.E1Action) ~= 15 then
		return c.Bail('Radimvice must cast Intermost in order for Taloon to cover mouth')
	end

    ---------------------------------------
    return true
end

c.Load(2)
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



