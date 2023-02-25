-- Starts from the magic frame at the beginning of the Skeleton encounter
-- Gives medicine to king and wings to bazaar
local c = require("DW4-ManipCore")

c.InitSession()
c.reportFrequency = 2000

local function _rnd1()
    c.RandomFor(1)
    
    c.RndAorB() -- I became worried
    c.WaitFor(67)
    c.UntilNextInputFrame()

    c.RndAorB() -- Something terrible may be about to happen
    c.WaitFor(96)
    c.UntilNextInputFrame()

    c.RndAorB() -- I won't stop you
    c.WaitFor(76)
    c.UntilNextInputFrame()

    c.RndAtLeastOne() -- Brey and Cristo, I place Alena's safety in your hands
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.PushA() -- Bring up menu

    c.WaitFor(25)
    c.UntilNextInputFrame()

    if c.ReadMenuPosY() ~= 16 then
        return c.Bail('Unable to open menu')
    end

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to status')
    end

    c.PushRight()
    if c.ReadMenuPosY() ~= 33 then
        return c.Bail('Unable to navigate to item')
    end

    c.PushA() -- Pick Item
    c.WaitFor(14)
    c.UntilNextInputFrame()

    c.PushA() -- Pick Alena
    c.WaitFor(8)
    c.UntilNextInputFrame()

    c.PushDown()
    c.PushA() -- Pick Wing of Wyvern

    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.PushA() -- Use

    c.WaitFor(4)
    c.UntilNextInputFrame()

    c.PushDown()
    c.WaitFor(1)
    c.PushDown()
    c.WaitFor(1)
    c.PushDown()
    c.PushA()

    c.WaitFor(220)
    c.UntilNextInputFrame()

    c.Save(5)
    return true
end



c.Load(0)
c.Save(100)
while not c.done do
	c.Load(100)
    local result = c.Best(_giveMedicineAndWing, 100)
    if result > 0 then        
        c.Done()
    end
    c.Increment()
end

c.Finish()

