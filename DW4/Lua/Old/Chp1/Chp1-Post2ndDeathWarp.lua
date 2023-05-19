--Manipualtes the fatestest screen load after death
--Starts on the frame that "Terrific blow" appears in the lethal gopher fight
--TODO: this isn't done
local c = require("DW4-ManipCore")
c.InitSession()
c.Save(10)

function _Dmg()
	c.WaitFor(1)
	c.RndAtLeastOne() -- demon stump dmg
	c.RandomFor(1)
	c.WaitFor(58)
	c.RndAtLeastOne()
	c.RandomFor(1)
	if c.ReadBattle() ~= 27 then
		c.Debug('Lag at dmg, bailing')
		return false
	end

	c.WaitFor(20)
	c.WaitFor(1)
	c.RndAtLeastOne() -- Ragnar passes away
	c.RandomFor(5)

	if c.ReadTurn() ~= 2 then
		c.Debug('Lag at passes away, bailing')
		return false
	end

	c.RandomFor(10)
	c.WaitFor(29)
	c.RndAtLeastOne() -- Ragnar passes away
	c.RandomFor(20)
	c.WaitFor(20)
	c.Save(7)
	return true
end

while not c.done do
	c.Load(10)
	result = _Dmg()
	if result then
		c.Save(9)
		c.done = true
	else
		c.Increment()		
	end
end