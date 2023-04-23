
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
    c.WaitFor(2)
    c.WaitFor(12)
    c.PushA()
    c.WaitFor(23)
    c.WaitFor(5)
    if not c.PushAWithCheck() then return false end
    c.WaitFor(32)

    if c.ReadTurn() ~= 4 then
        return c.Bail('Infernus did not go first')
    end

    c.WaitFor(2)

    if c.Read(c.Addr.E1Action) ~= 67 then
        return c.Bail('Infernus did not attack')
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



