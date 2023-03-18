-- Starts at the last lag frame upon the boat
-- Manipualtes going downstairs
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

-- Override encounter, we don't have any and it doesn't work because
-- E1Group stays 0xBB until the end of the chapter
c.IsEncounter = function()
	return false
end

local function _do()
    c.WalkMap({
        { ['Left'] = 3 },
        { ['Down'] = 8 },
        { ['Left'] = 4 },
    })

    c.PushA()
    c.UntilNextMenuY()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushA()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(5)
    c.UntilNextInputFrame()

    c.PushFor('Left', 15)

    c.WalkLeft(6)
    c.WalkDown(3)
    c.WaitFor(10)
    c.UntilNextInputFrame()
   
    c.Log('Saving 4')
    c.Save(4)
    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
    local result = c.Best(_do, 10)
    if result then
        c.Done()
    end    
end

c.Finish()
