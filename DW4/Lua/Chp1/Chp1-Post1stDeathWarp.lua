--Manipulates 6 damage and the fastest screen load after death
--Starts on the arrow after you see "Critical Hit" in the demon stump fight
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 0

function _readDmg()
	return c.Read(c.Addr.Dmg)
end

function _readTurn()
	return c.Read(c.Addr.Turn)
end

function _readStep()
	return c.Read(0x62ED)
end

function _demonStumpDmg()
	c.RndAtLeastOne() -- 21 dmg
	c.RandomFor(1)
	c.WaitFor(58)
	
	c.RndAtLeastOne() -- Demon stump attacks
	c.RandomFor(20)
	c.WaitFor(7)

	c.RndAtLeastOne() -- demon stump dmg
	c.RandomFor(1)
	c.WaitFor(10)
	dmg = _readDmg()
	c.Debug('Dmg: ' .. dmg)
	if dmg >= 6 then
		c.Log('Got 6 damage from Demon Stump')
		return true
	end

	return false
end

function _postDmg()
		c.WaitFor(51)
		c.RndAtLeastOne() -- death
		c.RandomFor(1)
		c.WaitFor(20)
		c.RndAtLeastOne() -- passes away
		c.RandomFor(6)
	
		if _readTurn() ~= 5 then
			c.Debug('lagged before dying, bailing')
			return false
		end
	
		c.Log('saving to slot 6')
		c.Save(6)	

		c.RandomFor(30)
		c.WaitFor(9)
		c.RndAtLeastOne()

		c.RandomFor(20)

		if _readStep() ~= 0 then
			c.Debug('Step count is not 0, bailing')
			return false
		end

		c.WaitFor(67)
		c.PushAorB()
		c.WaitFor(45)
		c.PushAorB()
		c.WaitFor(50)
		c.PushAorB()

		--TODO: wait for non lag frame and save best
end

while not c.done do
	c.Load(0)
	result = _demonStumpDmg()
	if result then
		c.Debug('Ragnar is dead, optimizing post death')
		c.Save(7)
		result = _postDmg()
		if result then
			c.Debug('Successfully died')
			c.WaitFor(100)
		end
	end

	c.Increment()
end

c.Finish()