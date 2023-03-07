-- Starts on the magic frame before the encounter
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000


local function _turn()
    c.RandomFor(1)
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne() -- One X appears
    c.RandomFor(19)
    c.UntilNextInputFrame()
    c.WaitFor(2) -- Input frame
    c.UntilNextInputFrame()

    c.PushA() -- Attack
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushUp()
    if c.ReadMenuPosY() ~= 31 then
        return c.Bail('Failed to navigate to arrow')
    end
    c.PushA()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushA() -- Taloon
    c.RandomFor(23)
    c.UntilNextInputFrame()

    if c.ReadTurn() ~= 0 then
        return c.Bail('Taloon did not go first')
    end

    c.WaitFor(2)

    return true
end

local function _getCritical()
    c.RndAtLeastOne()
    c.WaitFor(5)
    return c.ReadDmg() > 20
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
	local result = c.Cap(_turn, 1000)
    if result then
        local rngResult = c.AddToRngCache()
        if rngResult then
            result = c.ProgressiveSearch(_getCritical, 1, 20)
            if result then
                c.Done()
            else
                c.Log('Could not critical')
            end
        else
            c.Log('RNG already found')
        end        
    else
        c.Log('Could not go first')
    end
	
end

c.Finish()
