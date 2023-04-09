-- Starts at the magic frame before the Esturk Fight
-- Manipulates round 1
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _turn()
    c.RandomFor(1)
    c.WaitFor(14)

    c.RndAtLeastOne()
    c.WaitFor(7)
    
    c.RndAtLeastOne()
    c.RandomFor(26)
    c.WaitFor(5)
    if not c.PushAWithCheck() then return false end
    c.RandomFor(10)
    c.WaitFor(5)
    if not c.PushAWithCheck() then return false end
    c.WaitFor(2)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end
    c.RandomFor(30)

    --------------------
    -- TODO

    --------------------

    c.UntilNextInputFrame()
    c.WaitFor(2)
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

    local result = c.Cap(_turn, 100)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()



