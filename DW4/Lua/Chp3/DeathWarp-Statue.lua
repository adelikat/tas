local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 0

_holdFrames = 27
_enemy1Target = nil;
_enemy1Count = 1;
_enemy2Target = 0xFF;

origBattleFlag = c.ReadBattle()
-------------------------

function __avoidLoop()
	local walkingFrames = 188
	local battleStart = c.ReadBattle()
	for i = 0, walkingFrames, 1 do
		c.RndWalking('P1 Up')
		isBattle = c.ReadBattle()
		if isBattle ~= battleStart then
			c.Debug('Enounter found, retrying')
			return false
		end
	end

	return true
end

function _avoidEncounter()
	found = false
	while not found do
		c.Load(10)
		found = __avoidLoop()
	end
	c.Debug('Encounter avoided')
end

function _getStatue()
	c.PushA()
	c.WaitFor(17)
	c.PushDown()
	c.PushRight()
	c.PushDown()
	c.WaitFor(1)
	c.PushDown()
	c.PushA()
	c.WaitFor(42)
	c.PushA()
	c.WaitFor(42)
	c.PushA()
	c.WaitFor(190)
	c.Debug('Got statue')
end


while not c.done do
	c.Load(0)
	
	c.Save(10)
	_avoidEncounter()
	c.Save(4)

	c.Save(11)
	_getStatue()

	--If an encounter happens on the chest, _avoidEncounter will be false
	lastStepEncounterCheck = c.ReadBattle()
	if lastStepEncounterCheck == origBattleFlag then
		c.Save(5)

		c.RndAtLeastOne()

		direction =  c.RndDirectionButton()

		for i = 0, _holdFrames, 1 do
			c.Push(direction)
		end

		for i = 0, 13, 1 do
			c.RndWalking(direction)
		end

		c.WaitFor(45)
		c.Increment()

		battleFound = false
		battleFlag = c.ReadBattle()
		if battleFlag ~= origBattleFlag then
			battleFound = true
			LogProgress('Battle found: ' .. tostring(battleFound), true)
		end
		
		if battleFound then
			c.Save(6)
			
	    	eg1Type = c.ReadEGroup1Type()
	    	eg2Type = c.ReadEGroup2Type()
			eg1Count = c.ReadE1Count()
			c.Debug('eg1Type: ' .. eg1Type)
			c.Debug('eg2Type: ' .. eg2Type)
			c.Debug('eg1Count: ' .. eg1Count)

			c.LogProgress('Battle found eg2Type: ' .. c.Etypes[eg2Type], true)

			e1TypeFound = _enemy1Target == nil or eg1Type == _enemy1Target
			e2TypeFound = _enemy2Target == nil or eg2Type == _enemy2Target
			e1CountFound = _enemy1Count == nill or eg1Count == _enemy1Count

			if e1TypeFound
				and e1CountFound
				and e2TypeFound
				then
				c.Save(9)
				c.Done()
			end
		end
	end
end

c.Finish()
	


