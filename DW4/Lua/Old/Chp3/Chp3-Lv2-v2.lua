local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 10
c.maxDelay = 9
local targetStrGain = 4
local delay = 0

-- Starts from 'Metal Slime has a treasure chest'
function _str3()
    local origStr = c.Read(c.Addr.TaloonStr)
    c.RndAorB()
    c.WaitFor(30)
    c.UntilNextInputFrame()

    c.RndAorB()
    c.WaitFor(20)
    c.UntilNextInputFrame()

    c.RndAorB()
    c.WaitFor(200)
    c.UntilNextInputFrame()

    -- Magic Frame
    c.RandomFor(1)
    c.WaitFor(1)
    c.UntilNextInputFrame()

    local currStr = c.Read(c.Addr.TaloonStr)
    local gain = currStr - origStr
    c.Debug('Str gain: ' .. gain)
    return gain >= targetStrGain
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
	delay = 0

	local result = c.ProgressiveSearch(_str3, 400, 3)
	if result then
        c.Done()
    end
end

c.Finish()
