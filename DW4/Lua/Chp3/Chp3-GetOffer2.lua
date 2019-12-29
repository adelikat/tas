local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 100

_offer1 = 4600 --test 2600
_offer2 = 2400 --test 1500
_offer3 = 2381 --test 1500

function _readOffer()
	local o = memory.read_u16_le(0x006F)
	c.Debug('Offer: ' .. o)
	return o
end

function _rngToStr()
	return '-Rng2-' .. c.ReadRng2() .. 'Rng1-' .. c.ReadRng1()
end





function _getOffer()
	c.PushFor('P1 A', 2)
	c.WaitFor(70)
	local offer = _readOffer()
	return offer >= _offer3
end


while not c.done do
	c.Load(0)	
	c.Save(11)

	found = false
	for i = 0, 65535 do
		c.Load(11)
		c.Debug('Writing to RNG: ' .. i)
		c.PokeRngVal(i)
		_getOffer()
		if result then
			c.Done()
			c.Save(9)
		else
			c.LogProgress('')
		end
		c.Increment()
	end
	c.Done()
	c.LogProgress('FAILED!!!!', true)
	
	--found = false
	--delay = 0
	--while not found do
		--c.Debug('Frame search: ' .. delay)
		--c.Load(11)
		--c.WaitFor(delay)
		--result = _getOffer()
		--if result then
		--	c.Done()
		--	c.Save(9)
		--	c.Save(99)
		--else
		--	delay = delay + 1
			--c.LogProgress('Delay: ' .. delay)			
		--end
		
	--end
end

c.Finish()