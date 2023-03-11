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
	c.WaitFor(10)
	local dmg = c.ReadDmg()
	c.Log('dmg: ' .. dmg)
	return false
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
	local result = c.FrameSearch(_do, 100)
	
	if result then
		c.Done()
	end
end

c.Finish()



