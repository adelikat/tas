local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 10000
local stat = c.Addr.TaloonVit


local function _readOffer()
    local offer = memory.read_u16_le(0x006F)
    c.Debug('offer: ' .. offer)
    return offer
end

local function _do()
	c.PushA()
	c.WaitFor(20)
	if _readOffer() < 2381 then
		return false
	end

	return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
	local result = c.RngSearch(_do)
	
	if result then
		c.Done()
	end
end

c.Finish()



