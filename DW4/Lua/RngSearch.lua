
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

local function _do()
    local origLuck = c.Read(c.Addr.TaloonLuck)
	local origHp = c.Read(c.Addr.TaloonMaxHP)
    c.Debug('orig luck: ' .. origLuck)
	c.Debug('orig hp: ' .. origHp)
    c.PushA()    
    c.WaitFor(60)

    local currLuck = c.Read(c.Addr.TaloonLuck)
    c.Debug('curr luck: ' .. currLuck)
    if currLuck > origLuck then
        return c.Bail('Got luck')
    end

	
    local currHp = c.Read(c.Addr.TaloonMaxHP)
    c.Debug('curr hp: ' .. currHp)
    if currHp > origHp then
        return c.Bail('Got Hp')
    end

	c.Log('orig HP: ' .. origHp)
	c.Log('currHP: ' .. currHp)
    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
client.unpause()
--client.speedmode(3200)
while not c.done do
	c.Load(100)
	local result = c.RngSearch(_do)	
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



