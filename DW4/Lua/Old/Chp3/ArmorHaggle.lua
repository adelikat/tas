local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
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

function _getOffer1()
	local offer1
	while true do
		c.Load(11)
		c.RndWalkingFor('P1 Up', 78)
		c.PushFor('P1 Left', 2)
		c.RndWalkingFor('P1 Left', 204)
		c.PushFor('P1 Down', 2)
		c.RndWalkingFor('P1 Down', 25)
		c.WaitFor(2)
		c.PushA()
		c.WaitFor(9)
		c.UntilNextInputFrame()
		c.PushA()
		c.RandomFor(2)
		c.WaitFor(5)
		c.UntilNextInputFrame()
		c.RndAorB()
		c.WaitFor(40)
		c.PushA()
		c.WaitFor(50)
		c.UntilNextInputFrame()
		c.PushA()
		c.WaitFor(30)
		offer1 = _readOffer()
		if offer1 >= _offer1 then
			rng1 = c.ReadRng1()
			rng2 = c.ReadRng2()
			c.LogProgress('Full plate max offer! ' .. offer1, true)
			c.Save(4)
			c.Save('4600Offer-' .. _rngToStr())
			return
		else
			c.Increment(' Searching offer 1')
		end
	end
end

function _offerSearch(delay, targetOffer, offerNum)
	local lag = 0
	local found = false
	local offer = 0

	-- We can get good 2nd byte maniuplation here, so only choose to delay now
	while delay < c.maxDelay do
		c.Debug('Searching frame ' .. delay)
		c.Load(10 + offerNum)
		c.WaitFor(delay)
		c.PushA()
		if emu.islagged() then
			c.PushA()
			lag = 1
		end

		c.WaitFor(70)

		offer = _readOffer()		
		if offer == 4600 then
			c.LogProgress('Desync on offer ' .. offerNum .. '!', true)
			c.Save('FailedOffer' .. offerNum .. _rngToStr())
			return -1
		elseif offer >= targetOffer then
			c.Save(4 + offerNum)
			c.Save('Offer' .. offerNum .. '-Delay-' .. (delay + lag) .. _rngToStr())
			c.LogProgress('Offer ' .. offerNum .. ' found!! Offer: ' .. offer, true)
			return delay + lag
		else
			delay = delay + 1
		end
	end

	c.Debug('Failed to find offer ' .. offerNum)
	return -1
end

function _getOffer2()
	c.Save('Offer2Start')

	c.WaitFor(80)
	c.UntilNextInputFrame()
	c.WaitFor(2)
	c.UntilNextInputFrame()
	c.Save(6)
	c.PushA()

	c.WaitFor(38)
	c.UntilNextInputFrame()
	c.RndAorB()
	c.WaitFor(64)
	c.UntilNextInputFrame()
	c.WaitFor(2)
	c.UntilNextInputFrame()
	c.PushA() -- Yes
	c.WaitFor(59)
	c.UntilNextInputFrame()
	c.PushDown()

	c.Save(12)
	return _offerSearch(0, _offer2, 2)
end

function _getOffer3(delayFrames)
	c.Save('Offer3Start')
	c.WaitFor(40)
	c.UntilNextInputFrame()
	c.WaitFor(2)
	c.UntilNextInputFrame()
	c.PushA()
	c.WaitFor(45)
	c.UntilNextInputFrame()
	c.RndAorB()
	c.WaitFor(64)
	c.UntilNextInputFrame()
	c.WaitFor(2)
	c.UntilNextInputFrame()
	c.PushA()
	c.WaitFor(60)
	c.UntilNextInputFrame()

	c.PushDown()
	c.WaitFor(1)
	c.PushDown()

	c.Save(13)
	return _offerSearch(delayFrames, _offer3, 3)
end

while not c.done do
	c.Load(0)
	local foundAll = false
	c.Save(11)
	while not foundAll do
		c.Load(11)
		_getOffer1()

		result = _getOffer2()
		if result >= 0 and result < c.maxDelay then
			result2 = _getOffer3(result)
			if result2 == 0 then
				foundAll = true
				c.Save(9)
				c.Save(99)
				c.Done()
			elseif result2 > 0 then
				c.Save(900 + result2)
				c.LogProgress('3 offers found!!!! delay: ' .. result2)
				c.maxDelay = c.maxDelay - result2

				--Testing
				c.Save(9)
				foundAll = true	
				c.Done()
			end
		end
	end
end

c.Finish()