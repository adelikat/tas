-- Starts at the last lag frame upon coming back up stairs
-- Manipualtes going into the door and up the stairs
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

-- Override encounter, we don't have any and it doesn't work because
-- E1Group stays 0xBB until the end of the chapter
c.IsEncounter = function()
	return false
end

local function _enterDoor()
    local result = c.WalkMap({
        { ['Right'] = 2 },
        { ['Up'] = 3 },
    })
    if not result then return false end

    c.PushA()
    c.UntilNextMenuY()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.Door()

    c.RandomFor(12)
    c.WaitFor(1)
    c.PushFor('Up', 2)
    c.WalkUp()
    c.WaitFor(10)
    c.UntilNextInputFrame()

    return true
end

local function _upStairs()
    c.WalkUp(6)
    c.WaitFor(10)
    c.UntilNextInputFrame()

    return true
end

local function _sail()
    c.WalkDown(2)
    c.WalkLeft()
    c.UntilNextMenuY()
    c.UntilNextMenuY()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushA() -- Talk
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(3)
    c.PushA() -- Yes
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(500)
    c.UntilNextInputFrame()
    c.RandomFor(200)
    c.WaitFor(600)
    c.UntilNextInputFrame()
    c.RandomFor(200)
    c.UntilNextInputFrame()
    c.RandomFor(1450)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.RandomFor(30)
    c.UntilNextInputFrame()
    c.RandomFor(1)
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.RandomFor(1)
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.WaitFor(1)
    c.RndAtLeastOne()

    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.RandomFor(1)
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.PushA() -- Yes
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.RandomFor(1)
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
    

    c.Log('Saving 5')
    c.Save(5)
    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
    local result = c.Best(_sail, 2000)
    if result > 0 then
        c.Done()
    end
    -- local result = c.Best(_enterDoor, 10)
    -- if result > 0 then
    --     if result > 0 then
    --         result = c.Best(_upStairs, 10)
    --         if result > 0 then
    --             c.Done()
    --         end
    --     end
    -- end    
end

c.Finish()
