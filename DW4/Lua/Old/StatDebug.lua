local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 50

_statAddr = c.Addr.AlenaLuck

function _readStat()
	return c.Read(_statAddr)
end

local vals = {}

local start = 500
function _pokeRng()
	memory.write_u16_be(0x0012, start)
	start = start + 1
end

while not c.done do
	c.Load(0)
	_pokeRng()
	o = _readStat()

	c.PushA()
	c.UntilNextMenu()

	c.PushA()
	c.UntilNextMenu()
	
	n = _readStat()
	inc = n - o
	c.Debug('inc: ' .. inc)
	if vals[inc] == nil then
		vals[inc] = inc
		c.Log('New Val: ' .. inc)
	end

	c.LogProgress('Rng: ' .. start)
	if start >= 65535 then
		c.Done()
	end
	c.Increment()
end

c.Finish()
