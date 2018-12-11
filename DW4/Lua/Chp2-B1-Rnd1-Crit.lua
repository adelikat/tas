local c = require("DW4-ManipCore")

c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 0

while not c.done do
	c.Load(0)
	c.RndWalkingFor('Up', 145)
	c.PushA()
	
	c.WaitFor(100)
	c.Increment()
end

c.Finish()


