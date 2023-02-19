-- Starts at the magic frame before the encounter
local c = require("DW4-ManipCore")

c.InitSession()
c.reportFrequency = 5000
c.maxDelay = 5

local function _turn()
    c.RandomFor(1)
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
end

c.Load(0)
c.Save(100)
while not c.done do
	c.Load(100)
	--local result = c.Cap(_turn, 200)
    _turn()
    local result = false
    if result then
        c.Done()
    else
        c.Log('Unable to manip battle order')        
    end
    
	c.Increment()
end

c.Finish()

