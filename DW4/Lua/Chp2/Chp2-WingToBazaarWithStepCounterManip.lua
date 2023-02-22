-- Starts inside Frenor, on the last lag frame
-- Manips the first two steps to not advance the step counter
local c = require("DW4-ManipCore")

c.InitSession()
c.reportFrequency = 5000
c.maxDelay = 0
local direction = 'Left'

local function _wing()
    c.PushA() -- Bring up menu
    c.WaitFor(19)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.UntilNextInputFrame()

    if c.ReadMenuPosY() ~= 16 then
        return c.Bail('Failed to bring up menu')        
    end

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Failed to navigate to status')
    end

    c.PushRight()
    if c.ReadMenuPosY() ~= 33 then
        return c.Bail('Failed to navigate to item')
    end

    c.PushA() -- Pick Item
    c.WaitFor(13)
    c.UntilNextInputFrame()

    c.PushA() -- Pick Alena
    c.WaitFor(8)
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Failed to navigate to Wing')
    end
    c.PushA()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushA() -- Use
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Failed to navigate to Tempe')
    end

    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Failed to navigate to Frenor')
    end

    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then
        return c.Bail('Failed to navigate to Bazaar')
    end

    c.PushA()
    c.RandomFor(1)
    c.WaitFor(220)
    c.UntilNextInputFrame()

    return true
end

local function _takeFirstStep()
    c.PushFor('Down', 16)
    c.RndWalkingFor('Down', 16)
    return c.ReadStepCounter() == 30
end

-- Starts at the first frame the step counter advances on the last square before town
-- If more RNG manip is needed
local function _intoFrenor()
    c.RndWalkingFor(direction, 16)
    c.WaitFor(40)
    c.UntilNextInputFrame()
    return true
end

local function _untilDayBreak()
    c.PushFor('Down', 2)
    c.RndWalkingFor('Down', 152)
    c.PushFor('Left', 7)
    c.RndWalkingFor('Left', 120)
    c.PushFor('Up', 8)
    c.RndWalkingFor('Up', 17)
    c.PushFor('Left', 11)
    c.RndWalkingFor('Left', 24)
    c.PushFor('Up', 6)
    c.RndWalkingFor('Up', 22)
    c.PushFor('Left', 8)
    c.RndWalkingFor('Left', 132)
    c.PushFor('Down', 16)
    c.RndWalkingFor('Down', 70)
    c.RandomFor(49)
    
    --Start dialogs
    c.WaitFor(57)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushA() -- Yes

    c.WaitFor(39)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.RndAtLeastOne() -- Close dialog
    c.WaitFor(4)
    c.UntilNextInputFrame()
    c.RandomFor(73) -- As fake princess walks to you
    c.WaitFor(70)
    c.UntilNextInputFrame()
    c.RndAorB() -- Thanks for rescuing me. I've learned a lesson
    c.WaitFor(74)
    c.UntilNextInputFrame()
    c.RndAorB() -- I'm just an actress
    c.WaitFor(120)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.RndAtLeastOne() -- Close dialog
    c.WaitFor(4)
    c.UntilNextInputFrame()
    c.RandomFor(62) -- While fake party members walk to you
    c.WaitFor(70)
    c.UntilNextInputFrame()

    c.RndAorB() -- I'll join my companions now
    c.WaitFor(32)
    c.UntilNextInputFrame()

    c.RndAorB() --- It's not much, but I'll give you this Thief's Key
    c.WaitFor(220)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.RndAtLeastOne() -- Close dialog
    c.RandomFor(215)
    c.WaitFor(64)
    c.UntilNextInputFrame()

    c.RndAorB() -- Thereafter, the fake princess, disappeared    
    c.WaitFor(20)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    
    c.RndAtLeastOne() -- Close dialog
    c.WaitFor(76)
    c.WaitFor(4)

    return c.ReadStepCounter() == 30
end

local function _doThings()
    local result = _untilDayBreak()
    if result then
        result = _wing()
        if result then
            return true
        end
    end

    return false
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
    c.Best(_doThings, 25)
    c.Done()
    -- local result = c.Cap(_untilDayBreak, 2)
    -- if result then
    --     local bestResult = c.Best(_wing, 9)
    --     if bestResult > 0 then
    --         c.Done()
    --         if c.AddToRngCache() then
    --             c.Log('New Rng Set')
    --             result = c.Cap(_takeFirstStep, 320)
    --             if result then
    --                 c.Done()
    --             else
    --                 c.Log('Failed to manip step counter')
    --             end
    --         else
    --             c.Log('Rng already attempted, skipping')
    --         end        
    --     else
    --         c.Log('Unable to wing to bazaar')
    --     end
    -- else
    --     c.Log('Unable to navigate town')
    -- end
    
	
end

c.Finish()

