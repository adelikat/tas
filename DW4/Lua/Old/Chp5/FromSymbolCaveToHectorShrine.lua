-- Starts at the last lag frame after exiting the Symbol of Faith cave
-- Manipulates up to Hector
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 0

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _enterShrine()
    local result = c.WalkMap({
        { ['Down'] = 5 },
        { ['Left'] = 21 },
        { ['Up'] = 2 },
        { ['Left'] = 11 },
        { ['Up'] = 6 },
        { ['Left'] = 8 },
        { ['Down'] = 2 },
        { ['Left'] = 4 },
        { ['Down'] = 9 },
    })
    if not result then return false end

    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

c.Load(3)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)
    local result = c.Best(_enterShrine, 12)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()
