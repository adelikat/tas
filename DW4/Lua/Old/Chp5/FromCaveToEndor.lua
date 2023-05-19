-- Starts at the last lag frame after the hero leaves the cave to endor
-- Manipulates entering Endor
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _do()
    local result = c.WalkMap({
        { ['Down'] = 3 },
        { ['Left'] = 2 },
        { ['Down'] = 2 },
        { ['Left'] = 3 },
        { ['Down'] = 1 },
        { ['Left'] = 12 },
        { ['Down'] = 2 },
    })

    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    _tempSave(3)
    return true
end

c.Load(2)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
while not c.done do
    c.Load(100)
    local result = c.Best(_do, 12)
    if result > 0 then
        c.Done()
    end
end

c.Finish()
