local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1

_none = 0xFF
_demonStump = 0x0C
_lethalGopher = 0x13
function _readY()
	return c.Read(c.Addr.CaveY)
end

function _readX()
	return c.Read(c.Addr.CaveX)
end

function _readBattle()
	return c.Read(c.Addr.BattleFlag)
end

function _readEg1()
	return c.Read(c.Addr.EGroup1Type)
end

function _readEg2()
	return c.Read(c.Addr.EGroup2Type)
end

function _readEg1Count()
	return c.Read(0x6E49)
end

function _enterCave()
	c.Save(10)
	enterCave = false
	while enterCave == false do
		c.Load(10)
		oBattle = c.Read(c.Addr.BattleFlag)
		for i = 0, 118, 1 do
			battle =  c.Read(c.Addr.BattleFlag)
			if battle ~= oBattle then
				c.Debug('Encounter')
				enterCave = false
				break
			else
				c.RndWalking('Right')
				enterCave = true
			end
		end

		if enterCave then
			c.Debug('No encounters')
			c.WaitFor(40)
			c.PushFor('Up', 35)			
			c.DebugAddr(c.Addr.CaveY)
			enterCave = c.Read(c.Addr.CaveY) == 15
		end
	end

	local success = true
	Debug('Cave Result: ' .. tostring(success))
	return success
end

function _enterWell()
	c.Save(11)
	local downWell = false
	local cap = 12
	local cur = 0
	while downWell == false and cur < cap do
		c.Load(11)
		c.RndWalkingFor('Up', 113) -- frame 12600
		c.PushFor('Up', 15)
		c.WaitFor(40)
		c.PushA()
		c.PushFor('Up', 9)
		c.WaitFor(100)
		c.PushFor('Down', 30)
		c.DebugAddr(c.Addr.CaveY)
		downWell = _readY() == 4
		cur = cur + 1
	end

	local success = cur < cap
	Debug('Well Result: ' .. tostring(success))
	return success
end

function _floor1_1()
	c.Save(12)
	local condition = false
	local cap = 12
	local cur = 0
	while condition == false and cur < cap do
		c.Load(12)
		c.PushFor('Down', 4)
		c.PushFor('Left', 17)
		c.PushFor('Down', 130)
		c.PushFor('Left', 25)
		c.WaitFor(38)
		c.PushA()
		c.PushFor('Left', 10)
		c.PushFor('Down', 115)
		c.PushFor('Left', 145)
		c.PushFor('Down', 90)
		c.WaitFor(37)
		c.PushA()
		c.PushFor('Down', 16)
		c.PushFor('Left', 110)
		c.PushFor('Down', 9)

		checkPoint = _readY() == 27
		if (checkPoint == false) then
			c.Debug('Failed at checkpoint 1')
		end

		c.PushFor('Down', 180)
		c.PushFor('Right', 161)
		c.WaitFor(32)
		c.PushA()
		c.PushFor('Right', 30)
		c.PushFor('Down', 39)

		c.DebugAddr(c.Addr.CaveY)
		condition = _readY() == 41

		cur = cur + 1
	end

	local success = cur < cap
	Debug('Floor 1_1 Result: ' .. tostring(success))
	return success
end

function _floor1_2()
	c.Save(13)
	local condition = false
	local cap = 12
	local cur = 0

	while condition == false and cur < cap do
		c.Load(13)
		c.RndWalkingFor('Down', 135)
		c.WaitFor(20)
		c.PushFor('Down', 72)

		c.DebugAddr(c.Addr.CaveY)
		condition = _readY() == 41

		if (condition == true) then
			Debug('Jackpot, 1 frame sooner')
		else
			c.PushDown()
			condition = _readY() == 41
		end

		cur = cur + 1
	end

	local success = cur < cap
	Debug('Floor 1_2 Result: ' .. tostring(success))
	return success
end

function _floor2_1()
	c.Save(14)

	local condition = false
	local cap = 12
	local cur = 0

	while condition == false and cur < cap do
		c.Load(14)
		c.PushFor('Down', 25)
		c.PushFor('Right', 202)
		c.WaitFor(39)
		c.PushA()
		c.PushFor('Right', 10)
		c.PushFor('Up', 380)
		c.WaitFor(41)
		c.PushA()
		c.PushFor('Up', 27)
		c.PushFor('Left', 172)
		c.PushFor('Up', 105)
		c.PushFor('Right', 100)
		c.PushFor('Up', 80)
		c.PushFor('Left', 95)
		c.PushA()
		c.WaitFor(15)
		c.PushDown(); c.PushRight(); c.PushDown(); c.WaitFor(1); c.PushDown();
		c.PushA()
		c.WaitFor(5)
		c.PushFor('A', 120)
		c.WaitFor(143)
		c.PushA()
		c.PushFor('Right', 113)
		c.PushFor('Down', 81)
		c.PushFor('Left', 95)
		c.PushFor('Down', 100)
		c.PushFor('Right', 12)

		c.DebugAddr(c.Addr.CaveX)
		condition = _readX() == 8
		cur = cur + 1
	end

	local success = cur < cap
	Debug('Floor 2_1 Result: ' .. tostring(success))
	return success
end

function _floor2_2()
	c.Save(14)

	local condition = false
	local cap = 950
	local cur = 0

	while condition == false and cur < cap do
		c.Load(14)
		obattle = _readBattle()
		c.RndWalkingFor('Right', 216)
		c.WaitFor(40)
		condition = _readBattle() ~= obattle
		cur = cur + 1
		if (cur == 900) then
			console.log('Attempts exceeded 900 to get any encounter')
		end
	end

	local success
	if (cur < cap) then
		local eg1 = _readEg1()
		local eg2 = _readEg2()
		local eg1Count = _readEg1Count()
		console.log('EGroup1: ' .. c.Etypes[eg1] .. '(' .. eg1Count .. ') EGroup2: ' .. c.Etypes[eg2])

		local success = (eg1 == _demonStump or eg1 == _lethalGopher)
			and eg2 == _none
			and eg1Count == 1

		Debug('Floor 2_2 Result: ' .. tostring(success))
		return success
	else
		Debug('Floor 2_2 Result: false')
		return false
	end
end

while not c.done do
	local result = false
	while result == false do
		c.Load(0)
		if _enterCave() then
			if _enterWell() then
				if _floor1_1() then
					if _floor1_2() then
						if (_floor2_1()) then
							result = _floor2_2()
						end
					end
				end
			end
		end
	end

	c.Done()
end

c.Finish()


