-- Starts at the last lag frame upon entering Haville
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
        { ['Up'] = 3 },
        { ['Left'] = 4 },
        { ['Up'] = 1 },
        { ['Left'] = 3 },
        { ['Up'] = 11 },
        { ['Right'] = 1 },
        { ['Up'] = 11 },
        { ['Left'] = 2 },
        { ['Up'] = 4 },
        { ['Left'] = 10 },
        { ['Down'] = 1 },
        { ['Left'] = 1 },
    })

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
