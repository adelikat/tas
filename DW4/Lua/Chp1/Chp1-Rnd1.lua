local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

function _readMenu()
	return c.Read(c.Addr.MenuPosY)
end

function _readBattle()
	return c.Read(c.Addr.BattleFlag)
end

function _readTurn()
	return c.Read(c.Addr.Turn)
end

function _readDmg()
	return c.Read(c.Addr.Dmg)
end

maxSearch = 2
earlyBailOut = false
while not c.done do
	c.Load(0)
	earlyBailOut = false

	--From first move walking up, X = 22, Y = 21
	c.RndWalkingFor('Up', 50)
	c.WaitFor(121)
	c.PushA()
	c.PushFor('Up', 42)
	c.PushFor('Right', 16)
	c.PushFor('Up', 16)
	c.RndWalkingFor('Up', 71)
	c.PushFor('A', 2)
	c.WaitFor(15)
	c.PushA()
	c.WaitFor(79)
	c.RndAtLeastOne()
	c.WaitFor(142)
	if (emu.islagged() == false) then
		c.Debug('Attempt: ' .. c.attempts .. ' lagged before magic frame')
		earlyBailOut = true

	end

	--Random non-lag before appears
	c.RandomFor(1)
	c.WaitFor(13)

	--Enemy Appears
	c.RndAtLeastOne()
	c.RandomFor(1)
	c.WaitFor(6) 
	c.RndAtLeastOne()
	c.RandomFor(20)
	c.WaitFor(7)

	--Attack
	c.PushDown() c.WaitFor(1)
	c.PushDown() c.WaitFor(1)
	c.PushDown()
	c.PushA() --Item
	c.RandomFor(1)
	c.WaitFor(5)

	--Pick Arrow
	c.PushUp()
		if earlyBailOut == false then
			menuPos = _readMenu()
			if (menuPos ~= 31) then
				c.Debug('Attempt: ' .. c.attempts .. ' Failed to nav up from Copper Sword')
				earlyBailOut = true
			end
		end
	c.PushA()
	c.WaitFor(8)

	c.PushDown()
		if earlyBailOut == false then
			menuPos = _readMenu()
			if (menuPos ~= 16) then
				c.Debug('Attempt: ' .. c.attempts .. ' Failed to nav down to Malice')
				earlyBailOut = true
			end
		end
	c.PushA() -- Sword of malice
	c.WaitFor(2)

	c.PushDown()
		--Sanity check
		if earlyBailOut == false then
			menuPos = _readMenu()
			if menuPos ~= 17 then
				c.Debug('Attempt: ' .. c.attempts .. ' Failed to equip Malice')
				earlyBailOut = true
			end
		end
	c.PushA() -- Equip
	c.RandomFor(1)
	c.WaitFor(5)

	c.PushDown()
		if earlyBailOut == false then
			menuPos = _readMenu()
			if menuPos ~= 17 then
				c.Debug('Attempt: ' .. c.attempts .. ' Failed to nav down to Eyeball')
				earlyBailOut = true
			end
		end
	c.PushA() --Eyeball
	c.RandomFor(30)
	c.WaitFor(10)

	eyeballCheapo = memory.readbyte(0x7288)
	if eyeballCheapo == 194 then
		c.Debug('Attempt: ' .. c.attempts .. ' Eyeball cheapo parry')
	elseif earlyBailOut == false then
		turn = _readTurn()
		battleFlag = _readBattle()

		saroTurn = 4
		saroAttack = 76

		proceed = false
		if turn == saroTurn
			and battleFlag == saroAttack
			then
			proceed = true
			c.LogProgress('Saro attack')
		end

		curSearch = 0
		c.Save(11)
		searchDone = false
		if proceed then
			while (not searchDone) and (curSearch < maxSearch) do
				c.Load(11)
				c.WaitFor(curSearch)
				c.RndAtLeastOne()
				c.WaitFor(35) -- Ensure things are calculated
				ragnarHP = memory.readbyte(0x60B6)
				dmg = _readDmg()
				if ragnarHP == 27 and dmg > 1 then
					console.log('Miss! ' .. 'Frame ' .. curSearch)
					maxSearch = curSearch
					savestate.saveslot(9)
					searchDone = true

					if (maxSearch == 0) then
						c.Log('No delay! Done!')
						c.done = true
					end
					break
				else
					curSearch = curSearch + 1
					c.Log('Fail, increase to ' .. curSearch)
				end
			end
		end
	end
	c.Increment()
	

	if (c.attempts == 200000) then
		c.Abort()
	end
	--------------------------------------
end

c.Finish()



