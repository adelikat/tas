-- Starts at the first input frame after 'Terriffic blow' in the metal slime fight
-- Maniulates a Half Plate Armor drop
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 20
local delay = 0

-- Starts at the first input frame after '2 dmg points'
local function _getDrop()
    delay = 0
    delay = delay + c.DelayUpTo(c.maxDelay - delay)
    c.RndAtLeastOne() -- 2 Dmg points
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    delay = delay + c.DelayUpTo(c.maxDelay - delay)
    c.RndAtLeastOne()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    delay = delay + c.DelayUpTo(c.maxDelay - delay)
    c.RndAtLeastOne() -- Slime was defeated
 
    c.RandomFor(140)

    local drop = c.ReadDrop()
    if drop == 0xFF then
        return c.Bail(string.format('Did not get a drop, delay: %s', delay))
    end

    if drop > 0x05 then --reduce noise a bit on these logs
        c.Debug(string.format('Got drop: %s delay: %s', c.Items[drop], delay))
    end
    
    -- if drop ~= 0x28 then
    --     return c.Bail('Did not get a half plate')
    -- end

    if drop ~= 0x06 then
        return c.Bail('Did not get a broad sword')
    end

    c.Save(string.format('HalfPlate-%s', emu.framecount()))
    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
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

c.Finish()
