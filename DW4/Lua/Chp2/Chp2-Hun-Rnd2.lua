-- Begins on the first frame to end the 'Alena eludes nimbly' dialog from the previous menu
-- Unfinished, got manip during development
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _alenaFirst()
	--Magic frame
	c.RndAtLeastOne()
	c.RandomFor(16)
    c.UntilNextInputFrame()
    c.WaitFor(2) -- input frame
    c.UntilNextInputFrame()
    
    c.PushA()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.Save(4)
	return c.ReadTurn() == 0
end



c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
	local result = c.Cap(_alenaFirst, 1000)
	if result then		
		c.Done()
	else
		c.Log('Unable to manipulate turn order')
	end
end

c.Finish()
