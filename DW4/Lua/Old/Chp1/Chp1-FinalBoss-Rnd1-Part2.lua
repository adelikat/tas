--Manipulates the 2nd miss
--Starts at the frame you see "Nimbly" from the first miss
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100

function _ragnarCurrentHp()
	return c.Read(0x60B6)
end

function _readBattle()
	return c.Read(c.Addr.BattleFlag)
end

function _bail(msg)
	c.Debug(msg)
	c.Increment()
	return false
end

function _isMiss()
	return _ragnarCurrentHp() == 27
end

function _manipMiss()
    c.WaitFor(1)
    c.RndAtLeastOne()
	c.RandomFor(6)
    c.WaitFor(10)
    if _readBattle() ~= 76 then
        return _bail('Eyeball on guard')
    end

    c.UntilNextInputFrame()
	c.WaitFor(2)

    c.RndAtLeastOne()
    c.RndAtLeastOne()
    c.WaitFor(10)

	missSearchResult = _isMiss()
	c.UntilNextInputFrame()
	c.WaitFor(2)
	return missSearchResult
end

c.Load(0)
c.Save(100)
while not c.done do
	c.Load(100)
	if c.ProgressiveSearch(_manipMiss, 10, 10) then
		c.Done()		
	end
	
	c.Increment()
end

c.Finish()



