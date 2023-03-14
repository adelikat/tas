-- Starts at the last lag frame upon entering Endor with 7 half plates (which will fulfill the Kings order)
-- Drops off the 7 half plates and uses a wing to exit Endor
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _enterCastle()
    c.PushUp()
    c.RndUntilY('Up', 10, 300)

    if c.Read(c.Addr.XSquare) ~= 23 then
        return c.Bail('NPC got in the way')
    end

    c.RandomFor(10)
    c.UntilNextMenuY()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to status')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Unable to navigate to equip')
    end

    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then
        return c.Bail('Unable to navigate to door')
    end
    c.PushA() -- Pick Door
    c.WaitFor(30)
    c.UntilNextInputFrame()

    c.PushA()
    c.RandomFor(11)
    c.WaitFor(1)
    c.PushFor('Up', 5)
    c.RandomFor(20)
    c.UntilNextInputFrame()

    return true
end

local function _deliverPlates()
    c.PushUp()
    c.RndUntilY('Up', 29)
    c.RandomFor(11)
    c.WaitFor(1)
    c.PushFor('Right', 5)
    c.RndUntilX('Right', 16)

    c.RandomFor(11)
    c.WaitFor(1)
    c.PushFor('Up', 5)

    local result = c.RndUntilY('Up', 23, 50)
    if not result then
        return c.Bail('NPC got in the way')
    end

    if c.Read(c.Addr.XSquare) ~= 16 then
        return c.Bail('NPC got in the way')
    end

    c.RandomFor(11)
    c.WaitFor(1)
    c.PushFor('Right', 5)

    if c.Read(c.Addr.XSquare) ~= 17 then
        return c.Bail('NPC got in the way')
    end

    c.RndUntilX('Right', 18)

    c.RandomFor(11)
    c.WaitFor(1)

    c.PushFor('Up', 5)

    if c.Read(c.Addr.YSquare) ~= 22 then
        return c.Bail('NPC got in the way')
    end

    c.RandomFor(11)
    c.WaitFor(1)

    c.UntilNextMenuY()
    c.UntilNextMenuY()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to status')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Unable to navigate to equip')
    end

    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then
        return c.Bail('Unable to navigate to door')
    end
    c.PushA() -- Pick Door
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.RandomFor(12)
    c.PushFor('Up', 6)

    c.RndUntilY('Up', 20)
    c.RandomFor(11)
    c.WaitFor(1)
    c.PushFor('Left', 5)

    c.RandomFor(8)
    c.PushFor('Up', 5)

    c.UntilNextMenuY()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushA() -- Talk
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.WaitFor(2) -- Input Frame
    c.UntilNextInputFrame()
    c.PushA() -- Yes
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.WaitFor(2)
    c.RndAtLeastOne()

    c.WaitFor(5)
    c.UntilNextInputFrame()

    c.PushA() -- Bring up menu
    c.UntilNextMenuY()
    c.UntilNextMenuY()
    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.UseFirstMenuItem()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to naivagate to Bonmalmo')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Unable to naivagate to Endor')
    end

    c.PushA()
    c.RandomFor(1)
    c.WaitFor(200)
    c.UntilNextInputFrame()

    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
    local result = c.Best(_enterCastle, 4)        
	if result > 0 then
        result = c.Best(_deliverPlates, 4)
        if result > 0 then
            c.Done()
        end        
	end
end

c.Finish()



