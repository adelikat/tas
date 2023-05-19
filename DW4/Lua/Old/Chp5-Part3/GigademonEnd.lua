-- Starts at the first frame to dismiss "Terrific Blow" the 2nd time, assumes that any regular hit will be enough to defeat the Gigademon
-- Manipulates the 3rd and regular hit, defeating him and getting back to the map screen
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _do()
    c.RndAtLeastOne()
    c.WaitFor(47)
    c.RndAtLeastOne()
    c.WaitFor(17)
    c.RndAtLeastOne()
    c.WaitFor(40)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne()
    c.WaitFor(30)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne()
    c.RandomFor(100)
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
    local result = c.Best(_do, 30)
    if c.Success(result) then
        c.Done()
    end

    c.Log('RNG: ' .. c.RngCacheLength())
end

c.Finish()

