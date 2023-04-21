
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
    local origHp = c.Read(c.Addr.HeroHP)
	c.PushA()
	c.WaitFor(5)
	local currHp = c.Read(c.Addr.HeroHP)

	return currHp == origHp
end

local function _buildPower()
    --delay = c.DelayUpTo(c.maxDelay)
    c.PushA()
    c.WaitFor(55)

    --c.AddToRngCache()
	local actionNum = c.Read(c.Addr.P2Action)
	c.Debug('actionNum ' .. actionNum)
	local action = c.TaloonActions[actionNum]
	c.Debug('Taloon action: ' .. action)
    if c.Read(c.Addr.P2Action) ~= c.Actions.BuildingPower then
        --return c.Bail('Taloon did not build power')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)
	return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
client.unpause()
--client.speedmode(3200)
while not c.done do
	c.Load(100)
	local result = c.RngSearch(_buildPower)	
	--local result = c.FrameSearch(_do, 1000)	
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



