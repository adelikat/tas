--Starts from the first frame after "A terrific blow" menu appears
local c = require("DW4-ManipCore")

c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 5

local function _bail(msg)
	c.Debug(msg)
	c.Increment()
	return false
end

local function _getDrop()
    c.RndAtLeastOne()
    c.RandomFor(1)
    c.WaitFor(40)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- x damage points to Rabidhound-B
    c.RandomFor(1)
    c.WaitFor(17)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- Rabidhound-B is defeated
    c.RandomFor(41)
    c.WaitFor(120)

    if c.Read(0x01D6) ~= 0x56 then
        return _bail('Failed to get a wing drop')        
    end

    return true
end

c.Load(0)
c.Save(100)
while not c.done do
	c.Load(100)
	local result = c.Cap(_getDrop, 100)
    if result then
        c.Done()
    end
    
	c.Increment()
end

c.Finish()


