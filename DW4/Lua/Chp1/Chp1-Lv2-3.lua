local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 3

function _readDmg()
	return c.Read(c.Addr.Dmg)
end

function _readLv()
	return c.Read(c.Addr.RagnarLv)
end

function _attack(delay)
	delayAmt = delay
	c.Save(10)
	local attackFound = false
	while (attackFound == false) do
		delayAmt = delay
		c.Load(10)
		delayAmt = delayAmt + c.DelayUpTo((c.maxDelay / 2) - delayAmt)
		c.RndAtLeastOne()
		c.RandomFor(20)
		c.WaitFor(3)

		--Advance and check
		c.Save(11)
		c.PushA()
		c.WaitFor(5)
		local dmg = _readDmg()
		if (dmg == 18) then
			c.LogProgress('18 Dmg found delay: ' .. delayAmt, true)
			c.Load(11)
			attackFound = true
		else
			c.Debug(' delay: ' .. delayAmt .. ' dmg: ' .. dmg)
		end

		c.Increment()
	end

	return delayAmt
end

function _getJackPot1(delay)
	c.Save(11)
	local maxDelay = c.maxDelay - delay
	local jfound = false
	local cur = 0
	local cap = 3000
	while cur < cap do
		c.Load(11)
		delayAmt = 0
		c.RndAtLeastOne() -- Ragnar attacks
		c.WaitFor(52)

		delayAmt = delayAmt + c.DelayUpTo(maxDelay - delayAmt)
		c.RndAtLeastOne() -- 18 damage
		c.WaitFor(23)

		delayAmt = delayAmt + c.DelayUpTo(maxDelay - delayAmt)
		c.RndAtLeastOne() -- Foes defeated
		c.RandomFor(30)
		c.WaitFor(295)

		c.RandomFor(1)
		c.WaitFor(8)

		delayAmt = delayAmt + c.DelayUpTo(maxDelay - delayAmt)
		c.PushAorB() -- Level goes up

		--Jackpot check
		c.Save(12)
		c.WaitFor(60)
		lv = _readLv()
		if lv == 3 then
			c.LogProgress('Jackpot!!! delay: ' .. delayAmt .. ' total delay: ' .. delayAmt + delay, true)
			jfound = true
			maxDelay = delayAmt - 1
			c.Load(12)
			c.Save(800 + delayAmt + delay)
			c.Save(9)
			if delayAmt == 0 then
				return 0
			end

			-- Temp, stop looking after the first jackpot
			if jfound then
				cur = cap
			end
		end

		cur = cur + 1
		c.Increment('cur: ' .. cur .. ' attack delay: ' .. delay)
	end

	if jfound == false then
		return 999999
	end

	return delayAmt
end

function _nextInputFrame()
	c.Save(20)
	while emu.islagged() == true do
		c.Save(20)
		c.WaitFor(1)
	end

	c.Load(20)
end

function _getJackPot2(delay)
	c.WaitFor(200)
	_nextInputFrame()
	c.LogProgress(' Searching for 2nd jackpot', true)
	c.Save(13)
	local maxDelay = c.maxDelay - delay
	local jfound = false
	local cur = 0
	local cap = 1500
	while cur < cap do
		c.Load(13)
		c.RndAtLeastOne()
		c.UntilNextMenu()
		c.RndAorB() -- Level goes up
		c.Save(14)
		c.WaitFor(60)
		lv = _readLv()
		if lv == 4 then
			c.LogProgress('-----------------')
			c.LogProgress('----Double Jackpot!!! delay: ' .. delayAmt .. ' total delay: ' .. delayAmt + delay, true)
			jfound = true
			maxDelay = delayAmt - 1
			c.Load(14)
			c.Save(99)
			c.Save(999)
			c.Save(9)
			if delayAmt == 0 then
				return 0
			end
		end

		cur = cur + 1
		c.Increment('cur: ' .. cur .. ' lv 2 delay: ' .. delay)
	end

	if jfound == false then
		c.LogProgress(' Jackpot 1 search failed', true)
		return 999999
	end

	return delayAmt
end

while not c.done do
	c.Load(0)
	local delay = 0
	delay = delay + _attack(delay)
	delay = delay + _getJackPot1(delay)
	--delay = delay + _getJackPot2(delay)

	if delay <= c.maxDelay then
		--c.LogProgress(' Double Jackpot found delay: ' .. delay, true)
		c.LogProgress('New Best!!')
		c.maxDelay = delay - 1
		c.Save(9)
	--else
		--c.LogProgress(' Double Jackpot search failed', true)
	end

	if delay == 0 then
		c.Done()
	end

	c.attempts = c.attempts + 1
end

c.Finish()


