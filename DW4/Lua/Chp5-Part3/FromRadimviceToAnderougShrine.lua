-- Starts at the last lag frame after the last stat in crease from level 23
-- Manipulates leaving the Radimvice shrine and entering the Anderoug shrine
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 5000
c.maxDelay = 3
delay = 0

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _leave()
    c.WaitFor(1)
    c.DismissDialog()
    
    _tempSave(4)
    return true
end

c.Load(4)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
	c.Load(100)
    -- local result = c.Cap(_turn, 250)
    -- if c.Success(result) then
    --     c.Log('Turn Manipulated')
    --     local result = c.ProgressiveSearch(_heroCrit, 200, 3)
    --     if c.Success(result) then
    --         c.Done()
    --     else
    --         c.Log('Failed to find critical')
    --     end
    -- end

    local result = c.Cap(_taloonReinforcements, 250)
    if c.Success(result) then
        c.Done()
    end

    c.Log('RNG: ' .. c.RngCacheLength())
end

c.Finish()
