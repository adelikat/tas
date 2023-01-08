--Manipulates the lethal gopher encounter in the cave to prepare 2nd death warp
--Start this script on the earliest frame of pressing right (1 frame before Ragnar is visibly moving right)
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100 -- How many attempts before it logs a result

c.Save(10)
while not c.done do
	c.Load(10)
	c.RndWalkingFor('Right', 236)
	b = c.ReadBattle()
	if b == 0 then
		c.LogProgress('No encounter')
	else		
		
		c.WaitFor(30)
		egt1 = c.ReadEGroup1Type()
		egt2 = c.ReadEGroup2Type()
		eg1Count = memory.readbyte(0x6E49)
		if egt1 == 0x13 and egt2 == 0xFF and eg1Count == 1 then
			c.done = true
		else
			c.LogProgress('Encounter! eg1: ' .. c.Etypes[egt1] .. ' eg2: ' .. c.Etypes[egt2])
		end
	end

	c.Increment()
end

c.Finish()