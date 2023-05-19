--Manipulates the first round of the chatper 1 final boss
--Starts from first visible move walking up, X = 22, Y = 21
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
_missCap = 10000 -- Number of attempts before giving up on manipulating first 2 misses

saroTurn = 4
eyeBallTurn = 5
ragnarTurn = 0
attackAction = 76

function _ragnarCurrentHp()
	return c.Read(0x60B6)
end

function _menuY()
	return c.Read(c.Addr.MenuPosY)
end

function _readBattle()
	return c.Read(c.Addr.BattleFlag)
end

function _turn()
	return c.Read(c.Addr.Turn)
end

function _readDmg()
	return c.Read(c.Addr.Dmg)
end

function _readX()
	return c.Read(0x0045)
end

function _bail(msg)
	c.Debug(msg)
	c.Increment()
	return false
end

function _startBattle()
	c.RndWalkingFor('Up', 100)
	c.WaitFor(42)
	if not emu.islagged() then
		return _bail('Lag before dialog')
	end

	c.WaitFor(29)
	c.RndAtLeastOne()
	c.WaitFor(1)


	if not emu.islagged() then
		return _bail('Lag after dialog')
	end

	c.UntilNextInputFrame()
	c.PushFor('Up', 17)

	if _readX() > 17 then
		return _bail('Lag after dialog')
	end

	c.RndWalkingFor('Up', 15)
	c.PushFor('Right', 16)
	c.PushFor('Up', 14)
	c.RndWalkingFor('Up', 63)

	if not emu.islagged() then
		return _bail('Lag at bosss stairs')
	end

	c.UntilNextInputFrame()
	c.PushA()
	c.WaitFor(22)

	if c.ReadMenuPosY() ~= 16 then
		return _bail('Lag at command menu')
	end

	c.WaitFor(1)
	c.UntilNextInputFrame()
	c.PushA()
	c.RandomFor(1)
	
	if c.ReadMenuPosY() ~= 31 then
		return _bail('Lag after command menu')
	end

	c.WaitFor(78)
	c.RndAtLeastOne()

	if c.ReadEGroup1Type() ~= 179 then
		return _bail('Lag talking to boss')
	end

	c.WaitFor(1)
	c.UntilNextInputFrame() -- Up to magic frame

	frames = emu.framecount()

	c.Save('Chp1FinalBoss' .. frames)
	if frames > 23504 then --TODO: 23500!!!
		return _bail('Magic frame too slow got: ' .. frames .. ' target: 23500')
	elseif frames < 23500 then
		c.Log('Jackpot!! Magic frame at: ' .. frames)
	end

	return true
end

function _manipSarosTurn()
	c.RandomFor(1)
	c.WaitFor(1)
	c.UntilNextInputFrame()
	c.WaitFor(2)
	c.RndAtLeastOne() -- Saro's Shadow Appears
	c.RandomFor(1)
	c.WaitFor(1)
	c.UntilNextInputFrame()
	c.WaitFor(2)
	c.RndAtLeastOne() -- Giant Eyeball Appears
	c.RandomFor(1)
	c.WaitFor(1)
	c.RandomFor(23) -- A magic frame is in here
	c.UntilNextInputFrame()

	-- Menu down to item
	c.PushDown()
	if _menuY() ~= 17 then
		return _bail('Lag navigating to item menu')
	end
	c.WaitFor(1)

	c.PushDown()
	if _menuY() ~= 18 then
		return _bail('Lag navigating to item menu')
	end
	c.WaitFor(1)

	c.PushDown()
	if _menuY() ~= 19 then
		return _bail('Lag navigating to item menu')
	end

	c.PushA()
	c.WaitFor(2)
	c.UntilNextInputFrame()
	c.PushUp() -- Navigate to ->
	if _menuY() ~= 31 then
		return _bail('Lag navigating to arrow')
	end

	c.PushA()
	c.RandomFor(1)
	c.UntilNextInputFrame()

	c.PushDown() --Navigate to sword of malice
	if _menuY() ~= 16 then
		return _bail('Lag navigating to sword of malice')
	end
	c.PushA()
	c.WaitFor(2)

	c.PushDown() -- Navigate to equip
	if _menuY() ~= 17 then
		return _bail('Lag navigating to equip')
	end

	c.PushA()
	c.WaitFor(1)
	if _menuY() ~= 16 then
		return _bail('Lag equipping sword of malice')
	end

	c.WaitFor(1)
	c.UntilNextInputFrame()

	c.PushDown()
	if _menuY() ~= 17 then
		return _bail('Lag navigating to giant eyeball')
	end

	c.PushA() -- Attack Giant eyeball
	c.RandomFor(30)
	c.UntilNextInputFrame()
	c.WaitFor(2)
	if not _isSaroAttack() then
		return false
	end
		
	return true
end

function _isSaroAttack()
	turn = _turn()

	-- Just in case it is possible
	if turn == 0 then
		c.Log('Jackpot!!! Ragnar can go first, not known to be possible')
		c.Save('Chp1FinalBoss-RagnarGoesFirst' .. emu.framecount())
		c.Done()
		c.Finish()
		return false
	end

	if turn ~= saroTurn and turn ~= eyeBallTurn then
		c.Log('Unknown turn!')
		s.Save('Chp1FinalBoss-UnknownTurn' .. turn)
		return false
	end

	if turn ~= saroTurn then
		return false
	end

	eyeballCheapo = memory.readbyte(0x7288)
	if eyeballCheapo == 194 then
		return _bail('Eyeball cheapo parry')
	end

	--bo1 = c.Read(0x7348) always 132 or 133
	--bo2 = c.Read(0x7349) always 1 or 2
	--bo3 = c.Read(0x734A)
	--bo4 = c.Read(0x734B)

	battleFlag = _readBattle()
	return battleFlag == attackAction
end

function _isMiss()
	return _ragnarCurrentHp() == 27
end

function _manipMiss()
	c.PushA()
	c.RandomFor(1)
	c.WaitFor(5)

	missSearchResult = _isMiss()
	c.UntilNextInputFrame()
	c.WaitFor(2)
	return missSearchResult
end

function _manipRagnarTurn()
	c.RndAtLeastOne()
	c.RandomFor(20)
	if _turn() ~= 0 then
		return false
	end
	
	c.UntilNextInputFrame()
	c.WaitFor(2)

	return true
end

c.Load(0)
c.Save(100)
while not c.done do
	c.Load(100)
	if c.Cap(_startBattle, 100) then
		if c.Cap(_manipSarosTurn, 100) then
			if c.Cap(_manipMiss, 1) then
				c.Done()
			end
		end	
	end
	
	c.Increment()
end

c.Finish()



