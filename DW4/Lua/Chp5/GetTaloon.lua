
-- Starts at the last lag frame after entering Konenber after the lighthouse
-- Manipulates picking up Taloon and leaving town
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 2

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _leave()
    c.WalkMap({
        { ['Left'] = 19 },
        { ['Up'] = 7 },
        { ['Left'] = 3 },
    })
    c.WaitFor(12)
    c.UntilNextInputFrame()
    c.PushA() -- Talk
    c.RandomFor(5)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushA()
    c.WaitFor(12)
    c.UntilNextInputFrame()
    c.RndAorB()
    c.WaitFor(300)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(600)
    c.UntilNextInputFrame()

    -- On world map
    c.RandomFor(2)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()

	return true
end

c.Load(3)
c.Save(100)
c.RngCacheClear()
client.unpause()
client.speedmode(3200)
while not c.done do
	c.Load(100)
	local result = c.Best(_leave, 20)	
	if c.Success(result) then
		c.Done()
	end
end

c.Finish()



