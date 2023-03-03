local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 10
c.maxDelay = 9

local delay = 0

-- Starts from 'Metal Slime has a treasure chest'
function _str3()
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

    local str = c.Read(0x609D)
    if str > 7 then
        c.Log('Jackpot!!! 4 Str')
        c.Done()
        return true
    end

    c.Debug('Str gain: ' .. str - 4)
    return str == 7
end

c.Load(0)
c.Save(100)
while not c.done do
	c.Load(100)
	delay = 0

	local result = c.Cap(_str3, 100)
	if result then
        c.Done()
    end
end

c.Finish()
