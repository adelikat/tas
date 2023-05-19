local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 0

_holdFrames = 27
_enemy1Target = nil;
_enemy1Count = nil;
_enemy2Target = 0xFF;
-------------------------
origBattleFlag = c.ReadBattle()
while not c.done do
	c.Load(0)

	delay = c.DelayUpTo(c.maxDelay)
	c.WaitFor(delay)
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
		c.LogProgress("battle found", true)
		battleFound = true
	end
	
    eg1Type = c.ReadEGroup1Type()
    eg2Type = c.ReadEGroup2Type()
	eg1Count = c.ReadE1Count()
	c.Debug('eg1Type: ' .. eg1Type)
	c.Debug('eg2Type: ' .. eg2Type)
	c.Debug('eg1Count: ' .. eg1Count)

	if battlefound then
		c.LogProgress('Battle found')
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

c.Finish()


