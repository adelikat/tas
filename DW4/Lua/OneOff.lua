local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100

local poke = 0
local function _pokeRng()
    poke = (poke + 1) % 65535
    c.Debug(string.format('Writing %s to RNG', poke))
    memory.write_u16_be(0x0012, poke)
    c.Debug('RNG 1: ' .. c.ReadRng1())
    c.Debug('RNG 2: ' .. c.ReadRng2())
end

c.Load(0)
c.Save(100)
while not c.done do
	--[[
	c.Load(100)
	_pokeRng()
	c.PushA()
	c.WaitFor(50)
	local newVit = c.Read(0x60BD)
	if newVit == 13 then
		c.Done()
		c.Save(9)
	else
		c.Increment()
	end
	]]
	c.PushA()
	c.WaitFor(67)
	c.UntilNextInputFrame()
	c.PushA()
	
	c.Done()
	c.Debug('done: ' .. tostring(c.done))
end

c.Finish()



