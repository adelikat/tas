--Starts at the first frame that the dialog 'Ragnar, have  a safe journey' can be closed
local c = require("DW4-ManipCore")
c.InitSession()
c.maxDelay = 0
c.reportFrequency = 1

local function _bail(msg)
	c.Debug(msg)
	c.Increment()
	return false
end


local function _toChp2()
    c.RndAtLeastOne()
    c.RandomFor(1)
    c.WaitFor(4)
    c.UntilNextInputFrame()
    c.RandomFor(180)
    c.UntilNextInputFrame()

    c.RandomFor(1) -- Magic frame
    c.WaitFor(75)
    c.UntilNextInputFrame()
    c.WaitFor(1)

    c.RndAtLeastOne() -- 'Thus, Ragnar left on a journey in search of the hero
    c.RandomFor(1)
    c.WaitFor(13)
    c.UntilNextInputFrame()
    c.WaitFor(1)

    c.RndAtLeastOne()
    c.WaitFor(1)

    if not emu.islagged then
        return _bail('Lag at end of journey dialog')
    end

    c.WaitFor(440)
    c.UntilNextInputFrame()

    c.RndAtLeastOne() -- Then End of Chapter 1
    c.WaitFor(13)
    c.UntilNextInputFrame()

    c.RandomFor(1) -- Magic frame
    c.WaitFor(125)
    c.UntilNextInputFrame()

    c.WaitFor(1)

    if c.ReadMenuPosY() ~= 16 then
        return _bail('Lag at Yes/No')
    end

    c.WaitFor(1)
    c.PushA() -- Yes/No to Saving

    c.WaitFor(38)
    c.UntilNextInputFrame()
    c.WaitFor(1)

    c.RndAtLeastOne() -- Chaper 2 Princess Alena's Adventure
    c.WaitFor(115)
    c.UntilNextInputFrame()

    c.RndAorB()

    c.WaitFor(120)
    c.UntilNextInputFrame()

    c.RndAorB() --The King was constantly upset
    c.WaitFor(75)
    c.UntilNextInputFrame()

    c.RndAorB() --Princess! Princess Alena!
    c.WaitFor(75)
    c.UntilNextInputFrame()

    return true
end


c.Save(100)
while not c.done do
	c.Load(100)
    c.Best(_toChp2, 100)
    c.Done()
end

c.Finish()
