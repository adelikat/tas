-- Starts at the first input frame after 'Taloon eludes nimbly'
-- Manipulates a 2 dmg attack and then a Broad Sword treasure drop
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 18
local delay = 0

-- Starts at the first input frame after '2 dmg points'
local function _getDrop()
    c.RndAtLeastOne() -- 2 Dmg points
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    delay = c.DelayUpTo(c.maxDelay)
    c.RndAtLeastOne() -- Slime was defeated

    c.RandomFor(140)

    local drop = c.ReadDrop()
    if drop == 0xFF then
        return c.Bail('Did not get a drop')
    end

    if drop > 0x05 then --reduce noise a bit on these logs
        c.Debug(string.format('Got drop: %s delay: %s', c.Items[drop], delay))
    end
    
    if drop ~= 0x06 then
        return c.Bail('Did not get a broad sword')
    end

    c.Save(string.format('BroadSword-%s', emu.framecount()))
    return true
end

-- Starts at the first input frame after 'Taloon eludes nimbly'
local function _rnd2()
    c.RndAtLeastOne()
    c.RandomFor(18)
    c.UntilNextInputFrame()
    c.WaitFor(2) -- Input frame
    c.UntilNextInputFrame()

    c.PushA() -- Attack
    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.PushA() -- Slime
    c.RandomFor(20)
    c.UntilNextInputFrame()

    if c.ReadTurn() ~= 0 then
        return c.Bail('Slime went first')
    end

    c.WaitFor(2)
    c.RndAtLeastOne() -- Taloon attacks
    c.WaitFor(20)
    c.UntilNextInputFrame()

    if c.ReadDmg() ~= 2 then
        return c.Bail('Taloon did not do 2 damage') -- Note that 3 or 4 is actually a critical which we do not want either
    end

    c.WaitFor(2)

    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
    local result = c.Cap(_rnd2, 100)
    if result then
        c.Log('2 Dmg Manipulated')
        c.Save(3)
        result = c.Cap(_getDrop, 1000)
        if result then
            if delay < c.maxDelay then
                c.maxDelay = delay - 1
                c.Log('New Best delay: ' .. delay)
                c.Save(7)
                if c.maxDelay <= 0 then
                    c.Done()
                end
            end
        end
    end
end

c.Finish()
