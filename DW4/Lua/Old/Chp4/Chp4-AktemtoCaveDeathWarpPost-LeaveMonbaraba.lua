-- Starts at the first frame to start the dialog with the shaman after the death warp
-- Manipulates leaving the town
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 5

local function _do()
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne()
    c.WaitFor(5)
    c.UntilNextInputFrame()

    local result = c.WalkMap({
        { ['Right'] = 5 },
        { ['Down'] = 4 }
    })
    if not result then return false end

    c.WaitFor(10)
    c.UntilNextInputFrame()

    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)

    local result = c.Best(_do, 50)
    if result > 0 then
        c.Done()
    else
        c.Log('No best result')
    end
end

c.Finish()
