-- Starts at the last lag frame after the map appears after leaving Necrosaro's Palace
-- Manipulates entering the volcano, walking to Necrosar and starting the encounter
-- Manipulates leaving the srine and entering Necrosaro's palace
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function __walkUpSwamp()
    c.PushUp()
    c.RandomFor(14)
    c.WaitFor(5)
    return not c.IsEncounter()
end

local function _toVolcano()
    if not c.Cap(__walkUpSwamp, 16) then return false end
    if not c.Cap(__walkUpSwamp, 16) then return false end
    c.PushUp()
    c.RandomFor(20)
    c.UntilNextInputFrame()

    return not c.IsEncounter()
end

local function _toNecrosaro()
    local result = c.WalkMap({
        { ['Up'] = 5 },
        { ['Left'] = 6 },
        { ['Up'] = 7 },
        { ['Right'] = 7 },
        { ['Up'] = 7 },
        { ['Left'] = 1 },
        { ['Up'] = 1 },
        { ['Left'] = 4 },
        { ['Up'] = 6 },
        { ['Right'] = 3 },
        { ['Up'] = 7 },
    })
    if not result then return false end
    c.RandomFor(5)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    return true
end

local function _do()
    local result = c.Best(_toVolcano, 12)
    if c.Success(result) then
        local result = c.Best(_toNecrosaro, 12)
        if c.Success(result) then
            return true
        end
    end

    return false
end

c.Load(3)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do    
	c.Load(100)
    local result = c.Best(_do, 10)
    if c.Success(result) then
        c.Done()
    end

    c.Log('RNG: ' .. c.RngCacheLength())
end

c.Finish()

