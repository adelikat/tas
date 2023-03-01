-- Starts at the first visible frame of walking right, just outside of the
-- chambers with stairs down to the jail X: 11, Y: 2
-- Manipulates walking downstairs, giving a wing to the prisoner, winging out, and walking into Lakanaba
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _transition(direction)
	local arrived = false

	-- we do not want to mistake a random lag frame for a transition, so we define it as 2 in a row
	local lastFrameWasLagged = false

	while not arrived do
		c.RndWalking(direction)
	
		if emu.islagged() then
			if lastFrameWasLagged then
				start = emu.framecount()
				c.Debug('Arrived at transition on frame ' .. start)
                c.WaitFor(20)
                c.UntilNextInputFrame()
				return true
			end

			lastFrameWasLagged = true
		else
			lastFrameWasLagged = false
		end
	end
end

local function _downStairs()
    _transition('Right')
    c.PushRight()
    _transition('Right')
    return true
end

local function _giveWingAndLeave()
    c.WaitFor(72)
    c.PushFor('Left', 18)
    c.RndWalkingFor('Left', 20)
    c.PushFor('Up', 10)
    c.RndWalkingFor('Up', 96)
    c.PushFor('Right', 4)
    c.RndWalkingFor('Right', 93)

    if c.Read(0x0044) ~= 11 then
        return c.Bail('Failed to walk')
    end

    c.WaitFor(55)
    c.PushFor('Down', 20)
    c.RndWalkingFor('Down', 88)
    c.PushA()
    c.PushFor('Right', 12)
    c.UntilNextInputFrame()

    c.PushA()
    c.WaitFor(40)
    c.UntilNextInputFrame()

    c.RndAorB() -- Hey Taloon! It's me!
    c.WaitFor(40)
    c.UntilNextInputFrame()

    c.RndAorB() -- How stupid I was to get caught
    c.WaitFor(40)
    c.UntilNextInputFrame()

    c.RndAorB() -- You're a merchant, right?
    c.WaitFor(40)
    c.UntilNextInputFrame()
    c.WaitFor(2) -- Input Frame
    c.UntilNextInputFrame()

    c.PushA() -- Yes
    c.WaitFor(40)
    c.UntilNextInputFrame()

    c.RndAorB() -- Thanks a lot
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.RndAorB() -- I'll see you then
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.WaitFor(2)
    c.RndAtLeastOne() -- Close dialog

    c.WaitFor(4)
    c.UntilNextInputFrame()

    c.PushA() -- Open Menu
    c.WaitFor(20)
    c.UntilNextInputFrame()
    
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Status')
    end
    c.PushRight()
    if c.ReadMenuPosY() ~= 33 then
        return c.Bail('Unable to navigate to Item')
    end
    c.PushA() -- Pick Item
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.PushA() -- Pick Taloon
    c.WaitFor(5)
    c.UntilNextInputFrame()

    c.PushA() -- Pick Wing
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushA() -- Use
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushA() -- Lakanaba
    c.WaitFor(100)
    c.UntilNextInputFrame()

    return true
end

local function _walkIntoLakanaba()
    c.Save(4)
    c.PushFor('Up', 19)
    _transition('Up')
    c.PushRight()
    c.RndWalkingFor('Right', 87)

    return c.Read(0x0044) >= 6
end

local function _do()
    local result = c.Cap(_downStairs, 10)
    if result then
        result = c.Cap(_giveWingAndLeave, 20)
        if result then
            result = c.Cap(_walkIntoLakanaba, 30)
            if result then
                return true
            end
        end
    end

    return false
end



c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
    local result = c.Best(_do, 50)
    if result > 0 then
        c.Done()
    else
        c.Log('No best result')
    end
end

c.Finish()
