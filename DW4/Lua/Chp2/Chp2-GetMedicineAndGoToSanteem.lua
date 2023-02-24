-- Starts from the last lag frame after going upstairs to the top floor of the tower
-- Manipulates getting the medicine, winging to santeem and entering the castle
local c = require("DW4-ManipCore")

c.InitSession()
c.reportFrequency = 2000

local function _pickUpItemAndWing()
    c.PushRight()
    c.RndWalkingFor('Right', 26)
    c.PushFor('Up', 8)
    c.RndWalkingFor('Up', 24)
    c.WaitFor(85)
    c.UntilNextInputFrame()

    c.RndAorB() -- Yeek! You're humans
    c.WaitFor(11)
    c.UntilNextInputFrame()

    c.RndAorB() -- Yes Sister
    c.WaitFor(35)
    c.UntilNextInputFrame()

    c.RndAorB() -- Oops, I dropped the medicine
    c.WaitFor(45)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(4)
    c.UntilNextInputFrame()
    c.PushFor('Up', 33)
    c.RndWalkingFor('Up', 33)
    c.PushA()
    c.WaitFor(23)
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

    c.PushDown()
    if c.ReadMenuPosY() ~= 34 then
        return c.Bail('Unable to navigate to tactics')
    end

    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 35 then
        return c.Bail('Unable to navigate to search')
    end

    c.PushA()

    c.WaitFor(43)
    c.UntilNextInputFrame()
    c.RndAorB() -- Alena searches the area around feet

    c.WaitFor(38)
    c.UntilNextInputFrame()

    c.RndAorB() -- Find the birdsong necxtar
    c.WaitFor(185)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- Close dialog

    c.WaitFor(9)
    c.UntilNextInputFrame()

    c.PushA()

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
    c.PushA()

    c.WaitFor(220)
    c.UntilNextInputFrame()

    c.Save(5)
    return true
end

local function _walkIntoSanteem()
    c.PushFor('Up', 16)
    c.RndWalkingFor('Up', 16)
    c.WaitFor(70)
    c.UntilNextInputFrame()
    return true
end

c.Load(0)
c.Save(100)
while not c.done do
	c.Load(100)
    local result = c.Best(_pickUpItemAndWing, 20)
    if result > 0 then
        result = c.Best(_walkIntoSanteem, 20)
        if result > 0 then
            c.Done()
        end
    end
    c.Increment()
end

c.Finish()

