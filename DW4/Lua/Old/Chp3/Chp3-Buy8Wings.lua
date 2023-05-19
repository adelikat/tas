--Starts at the magic frame before the "encounter" with the merchange
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 10000

--Starts at the first frame you can press A to select Buy (Buy, Sell, Exit menu is 1 frame away from fully being visible)
local function _buy1Wing()
    c.PushA() -- Buy
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.RandomFor(1)
    c.WaitFor(1)
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Failed to navigate to antidote herb')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Failed to navigate to fairy water')
    end
    c.WaitFor(1)
    c.PushDown() -- Wing
    if c.ReadMenuPosY() ~= 19 then
        return c.Bail('Failed to navigate to wing')
    end
    c.PushA()
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.RndAorB() -- The wing of wyvern, right? Thank you
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.RandomFor(1) -- Magic frame
    c.WaitFor(1)
    c.UntilNextInputFrame()

    c.RndAorB() -- Here you go, Taloon
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.RandomFor(1) -- Magic frame
    c.WaitFor(1)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    return true
end

local function _buy()
    c.RandomFor(1)
    c.WaitFor(1)
    c.UntilNextInputFrame()
    c.RandomFor(1) -- 2 input frames in a row, one can be for randomness
    c.WaitFor(2)
    c.UntilNextInputFrame()

    -- Sell Broad Sword
    c.PushDown()
    c.PushA()
    c.WaitFor(20)
    c.UntilNextInputFrame()
    c.WaitFor(2) -- Input frame
    c.UntilNextInputFrame()

    c.PushA() -- Pick Broad Sword
    c.WaitFor(20)
    c.UntilNextInputFrame()

    c.RndAorB() -- The Broad Sword? Hmm...
    c.WaitFor(20)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.PushA() -- Yes
    c.WaitFor(20)
    c.UntilNextInputFrame()
    c.RandomFor(1) -- Magic frame    
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.RndAorB() -- Thank you for selling it to me
    c.WaitFor(20)
    c.UntilNextInputFrame()
    c.RandomFor(1) -- Magic frame
    c.WaitFor(1)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.Cap(_buy1Wing, 10)
    c.Cap(_buy1Wing, 10)
    c.Cap(_buy1Wing, 10)
    c.Cap(_buy1Wing, 10)
    c.Cap(_buy1Wing, 10)
    c.Cap(_buy1Wing, 10)
    c.Cap(_buy1Wing, 10)
    c.Cap(_buy1Wing, 10)

    c.PushB() -- Exit
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(1)
    c.UntilNextInputFrame()

   return true
end

c.Load(0)
c.Save(100)
while not c.done do
	c.Load(100)
	local result = c.Best(_buy, 50)
    
	if result > 0 then
        c.Done()
    end	
end

c.Finish()



