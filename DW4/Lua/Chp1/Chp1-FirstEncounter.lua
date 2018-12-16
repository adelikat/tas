local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 500

_blinkerAddr = 0x0059
_demonStump = 0x0C
_none = 0xFF
delay = 0

while not c.done do
	found = false
	savestate.loadslot(0)
	delay = 0
	--------------------------------------	
	c.RndWalkingFor('Left', 100)
	c.WaitFor(70)
	direction = c.RndDirectionButton()
	c.PushFor(direction, 14)

	if (memory.readbyte(_blinkerAddr) == 19) then
		c.RndWalkingFor(direction, 9)
		c.WaitFor(40)

		battleFlag = memory.readbyte(0x008B);
		eg1Type = memory.readbyte(0x6E45);
	 	eg2Type = memory.readbyte(0x6E46);
		if (battleFlag ~= 0) then
			--console.log('encounter: ' .. c.Etypes[eg1Type] .. ' ' .. c.Etypes[eg2Type])
			if (eg1Type == _demonStump and eg2Type == _none) then
				c.WaitFor(39)
				c.WaitFor(45)
				if (emu.islagged() == false) then
					c.done = true
				else
					console.log('found but lag frame attempt: ' .. c.attempts)
				end
			end
		end
	end
	c.Increment()
end

c.Finish()
savestate.saveslot(9)


