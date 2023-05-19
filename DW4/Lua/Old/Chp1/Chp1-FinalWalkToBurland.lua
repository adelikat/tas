--Starts on the first frame Ragnar visibly turns right, after going up right after the river (giving as many right squares as possible)

local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100

function _enterIzmit()
	c.RndWalkingFor('Right', 240)
	c.WaitFor(60)
	c.UntilNextInputFrame()
	return true
end

function _leaveIzmit()
	c.PushFor('Up', 2)
	c.RndWalkingFor('Up', 18)
	c.WaitFor(85)
	c.UntilNextInputFrame()
	c.WaitFor(1)
	c.RndAtLeastOne()
	c.WaitFor(100)
	c.PushFor('A', 40)
	c.WaitFor(17)
	c.UntilNextInputFrame()

	c.PushRight()
	if c.ReadMenuPosY() ~= 32 then
		c.Debug('Lag at menu')
		return false
	end

	c.PushDown()
	if c.ReadMenuPosY() ~= 33 then
		c.Debug('Lag at menu')
		return false
	end

	c.PushA() -- Pick Item
	c.WaitFor(10)
	c.UntilNextInputFrame()

	c.PushA() -- Pick Ragn
	c.WaitFor(4)
	c.UntilNextInputFrame()

	c.PushDown()
	if c.ReadMenuPosY() ~= 17 then
		c.Debug('Lag at menu')
		return false
	end
	c.WaitFor(1)

	c.PushDown() -- Flying Shoes
	if c.ReadMenuPosY() ~= 18 then
		c.Debug('Lag at menu')
		return false
	end
	c.WaitFor(1)

	c.PushDown() -- Wing
	if c.ReadMenuPosY() ~= 19 then
		c.Debug('Lag at menu')
		return false
	end
	c.PushA()

	c.WaitFor(3)
	c.UntilNextInputFrame()

	c.PushA() -- Use
	c.WaitFor(3)
	c.UntilNextInputFrame()

	c.PushA() -- Burland
	c.WaitFor(180)

	c.UntilNextInputFrame()
	return true
end

function _enterBurland()
	c.PushFor('Up', 16)
	c.RndWalkingFor('Up', 16)
	c.WaitFor(74)
	c.UntilNextInputFrame()
	return true
end

c.Save(100)
while not c.done do
	c.Load(100)
	
	local result = c.Best(_enterIzmit, 20)
	if result > 0 then
		c.Save(3)
		c.Log('Best town enter: ' ..  result)
	
		result = c.Best(_leaveIzmit, 40)
		if result > 0 then
			c.Save(4)
			c.Log('Best town exit: ' ..  result)

			result = c.Best(_enterBurland, 20)

			if result > 0 then
				c.Save(5)
				c.Log('Best enter Burland: ' .. result)
				c.Save('EnterBurland-' .. result)
			end
		else
			c.Log('Failed to leave town successfully even once')
		end
	else
		c.Log('Failed to enter town successfully even once')
	end
end
