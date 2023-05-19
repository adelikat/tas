-- Starts at the first frame to dismiss 'x damage points' that will defeat necrosaro
-- Manipulates showing the map screen
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 0
local delay = 0
local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _do()
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne()
    c.RandomFor(50)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.DismissDialog()
   return true
end

c.Load(3)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do    
	c.Load(100)

    local result = c.Best(_do, 50)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()

