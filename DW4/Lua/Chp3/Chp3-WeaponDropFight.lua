-- Starts at the magic frame before the encounter
-- Assumes the enemy can be killed in 1 non-critical hit
-- Manipulates Taloon going first, killing the enemy,
-- and getting the specified drop
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 10000

local neededDrop = 0x06 -- Broad Sword
--local neededDrop = 0x28 -- Half Plate

local function _turn()
    c.RandomFor(1)
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne() -- One X appears
    c.RandomFor(18)
    c.UntilNextMenuY()
    c.WaitFor(3) -- Input Frame
    c.UntilNextInputFrame()

    c.PushA() -- Attack
    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.PushA() -- Pick enemy
    c.RandomFor(20)
    c.UntilNextInputFrame()

    if c.ReadTurn() ~= 0 then
        return c.Bail('Taloon did not go first')
    end

    c.WaitFor(2)

    return true
end

local function _defeatEnemy()
    c.RndAtLeastOne()
    c.WaitFor(5)

    if c.ReadE1Hp() > 0 then
        return c.Bail('Did not do enough dmg: ' .. c.ReadDmg())
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)
    return true
end

local function _getDrop()
    c.RndAtLeastOne() -- x Damage points to y
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- x was defeated
    c.RandomFor(20) -- Several input frames
    c.WaitFor(130)

    local drop = c.ReadDrop()
    if drop == 0xFF then
        return c.Bail('Did not get a drop')
    end

    if drop > 0x05 and drop ~= 0x026 then --reduce noise a bit on these logs
        c.Log(string.format('Got drop: %s', c.Items[drop]))
    end

    if drop ~= neededDrop then
        return c.Bail(string.format('Did not get %s', c.Items[neededDrop]))
    end

    return true
end
c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
    local result = c.Cap(_turn, 1000)        
	if result then
        c.Log('saving 5')
        c.Save(5)
        result = c.Cap(_defeatEnemy, 2)
        if result then
            result = c.Cap(_getDrop, 500)
            if result then
                c.Done()
            else
                c.Log('Could not get drop')
            end
        else
            c.Log('Unable to do enough damage')
        end
	end
end

c.Finish()



