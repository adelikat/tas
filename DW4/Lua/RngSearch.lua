local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 64

local start = 0
local function _incrementRng()	
	memory.write_u16_be(0x0012, start)
	local rng1 = c.ReadRng1()
	local rng2 = c.ReadRng2()
	c.Debug(string.format('Attempt: %s Rng1: %s Rng2: %s', start, rng1, rng2))
	start = start + 1
end

local origVit = c.Read(0x60BD)
local origLuck = c.Read(0x60BF)
local origInt = c.Read(0x60BE)
-- Arbituary commands god here
local function _runScenario()
	
	c.PushA()
	c.WaitFor(51)
end

-- Check if attempt was successful
local function _checkSuccess()
	local curVit = c.Read(0x60BD)
	local curLuck = c.Read(0x60BF)
	local curInt = c.Read(0x60BE)

	return origVit == curVit
end

c.Load(0)
c.Save(100)
while not c.done do
	c.Load(100)
	
	_incrementRng()
	_runScenario()
	local result = _checkSuccess()
	if result then
		c.Done()
		c.Save(9)
	end	
end

c.Finish()



