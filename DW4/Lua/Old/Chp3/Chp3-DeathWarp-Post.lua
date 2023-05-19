-- Starts at the first frame to dimiss the "terrific blow" command
-- Manipulates the death warp, winging to bonmalmo and
-- Entering the castle
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000


local function _appearInTown()
    c.RndAtLeastOne()
    c.WaitFor(40)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- Taloon gets x damage points
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- Taloon passes away
    c.RandomFor(25) -- Lots of input frames here
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne()
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.RandomFor(2) -- Magic Frame
    c.WaitFor(20)
    c.UntilNextInputFrame()

    c.RndAorB() -- A voice is heard out of nowhere
    c.WaitFor(30)
    c.UntilNextInputFrame()

    c.RndAorB() -- Chosen ones
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.RndAorB() -- I shall revive you
    c.WaitFor(20)
    c.UntilNextInputFrame()

    return true
end

local function _wingToBonmalmo()
    c.RandomFor(1) -- Input Frame
    c.WaitFor(30)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushA() -- Bring up menu
    c.UntilNextMenuY()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    if not c.UseFirstMenuItem() then
        return false
    end
    
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Could not navigate to Bonmalmo')
    end
    c.PushA()
    c.RandomFor(2) -- Input frame

    c.WaitFor(200)
    c.UntilNextInputFrame()

    return true
end

local function _enterBonmalmo()
    c.PushFor('Up', 16)
    c.RndWalkingFor('Up', 18)
    c.UntilNextInputFrame()
    return true
end

local function _do()
    local result = c.Best(_appearInTown, 2)
    if result > 0 then
        return true
        -- result = c.Best(_wingToBonmalmo, 2)
        -- if result > 0 then
        --     --result = c.Best(_enterBonmalmo, 10)
        --     --if result > 0 then
        --         return true
        --     --end
        -- end       
    end	
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
	local result = c.Best(_do, 0)
    if result > 0 then
        c.Done()
    end    
end

c.Finish()
