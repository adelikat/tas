--Manipulates the critical hit
--Starts at the frame you see "Nimbly" from the second miss
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100

function _readDmg()
    return c.Read(0x7361)
end

function _bail(msg)
	c.Debug(msg)
	c.Increment()
	return false
end

function _manipCritical()
    c.WaitFor(1)
    c.RndAtLeastOne()
    c.RandomFor(12)
	c.WaitFor(7)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- Ragnar holds the Sword of Malice
    c.RandomFor(8)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- Ragnar attacks
    c.RandomFor(1)
    c.WaitFor(4)

    local dmg = _readDmg()
	local dmgResult = dmg >= 60
    c.Debug('Dmg: ' .. dmg)
	c.UntilNextInputFrame()
	c.WaitFor(2)
	return dmgResult
end

c.Load(0)
c.Save(100)
while not c.done do
	c.Load(100)
	if c.ProgressiveSearch(_manipCritical, 300, 20) then
		c.Done()		
	end
	
	c.Increment()
end

c.Finish()



