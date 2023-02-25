local c = require("DW4-ManipCore")
c.reportFrequency  = 100
c.InitSession()

_skeleton = 0x48
_empty = 0xFF
_frames = 102

c.Load(0)
c.Save(100)
while not c.done do
	c.Load(100)

	encounter = false
	for i = 0, _frames, 1 do
		c.RndWalking('Right')
		if _isEncounter() then
			c.Debug('Encounter found')
			encounter = true
			break
		end
	end

	if encounter then
		e1Type = c.ReadEGroup1Type()
		e2Type = c.ReadEGroup2Type()
		e1Count = c.ReadE1Count()

		c.LogProgress('e1Type: ' .. c.Etypes[e1Type] .. ' e2Type: ' .. c.Etypes[e2Type] .. ' e1Count: ' .. e1Count)
		if e1Type == _skeleton and e2Type == _empty and e1Count == 1 then
			c.WaitFor(137)
			if c.ReadE1Hp() <= 42 then
				c.Done()
			else
				c.Log('Got skeleton but too much HP')
			end
			
		end
	end

	c.Increment()
end

c.Finish()
