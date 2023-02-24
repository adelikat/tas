-- Starts from the last lag frame after going into the king's chambers
-- Gives medicine to king and wings to bazaar
local c = require("DW4-ManipCore")

c.InitSession()
c.reportFrequency = 2000

local function _giveMedicineAndWing()
    c.PushUp()
    c.RndWalkingFor('Up', 16)
    c.WaitFor(55)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(4)
    c.UntilNextInputFrame()
    c.PushUp()
    c.RndWalkingFor('Up', 27)
    c.PushFor('Left', 5)
    c.RndWalkingFor('Left', 27)
    c.PushFor('Up', 3)
    c.RndWalkingFor('Up', 83)
    c.WaitFor(1)
    c.PushA()
    c.WaitFor(19)
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
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Wing')
    end

    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Unable to navigate to Wing')
    end

    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then
        return c.Bail('Unable to navigate to Wing')
    end

    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 20 then
        return c.Bail('Unable to navigate to Birdsong Nectar')
    end

    c.PushA() -- Pick Birdsong Nectar
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushA() -- Use
    c.WaitFor(480)
    c.UntilNextInputFrame()

    c.RndAorB() -- I can speak!
    c.WaitFor(38)
    c.UntilNextInputFrame()

    c.RndAorB() -- You did...I thank you
    c.WaitFor(40)
    c.UntilNextInputFrame()

    c.RndAorB() --I had terrible dreams
    c.WaitFor(98)
    c.UntilNextInputFrame()

    c.RndAorB() -- A big monster came out of the Evil World
    c.WaitFor(138)
    c.UntilNextInputFrame()

    c.RndAorB() -- At first, I intended to keep them to myself
    c.WaitFor(110)
    c.UntilNextInputFrame()

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

