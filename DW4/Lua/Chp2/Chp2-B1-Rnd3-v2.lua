--Starts at the previous round, 'Brety gets x Damage points', that would kill off brey
--The first frame you can advance the menu
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 0
local _minCritDmg = 10

local function _bail(msg)
	c.Debug(msg)
	c.Increment()
	return false
end

function _readRabBTarget()
	return c.Read(0x7306)
end

local function _battleOrder()
    c.RndAtLeastOne()
    c.RandomFor(1)
    c.WaitFor(15)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- Brey passes away
    c.RandomFor(23)

    c.UntilNextInputFrame()
    c.WaitFor(2) -- This magic frame is neccessary to have no input in order to select attack at the earliest frame
    c.UntilNextInputFrame()
    
    c.PushA() -- Pick Alena Attack
    c.WaitFor(2)
    c.UntilNextInputFrame()
    
    c.PushA() -- Pick Rabidhound
    c.RandomFor(1)
    c.WaitFor(9)
    c.UntilNextInputFrame()
    c.WaitFor(2) -- Same for this magic frame
    c.UntilNextInputFrame()

    c.PushA() -- Pick Cristo Attack
    c.WaitFor(2)
    c.UntilNextInputFrame()

    c.PushA() -- Pick Rabidhound
    c.RandomFor(23)
    c.UntilNextInputFrame()

    if c.ReadTurn() ~= 6 then
        return _bail('Rabidhound-b did not go first')
    end

    if _readRabBTarget() ~= 1 then
        return _bail('Rabidhound-b did not target Cristo')
    end

    c.WaitFor(2)
    
    return true
end

local function _getAlenaCritical()
    c.RndAtLeastOne() -- Rabidhound-b attacks!
    c.RandomFor(1)
    c.WaitFor(3)

    if c.Read(0x6020) > 0 then
        return _bail('Cristo did not die')
    end

    c.WaitFor(47)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- Cristo gets x points of dmg
    c.RandomFor(1)
    c.WaitFor(19)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.DelayUpTo(c.maxDelay)
    c.RndAtLeastOne() -- Cristo passes away
    c.RandomFor(47)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- Alena attacks
    c.WaitFor(6)


    local dmg = c.ReadDmg()
    if dmg < _minCritDmg then
        return _bail('No crit, dmg: ' .. dmg)
    end

    return true
end

c.Load(0)
c.Save(100)
while not c.done do
	c.Load(100)
	local result = c.Cap(_battleOrder, 200)
    if result then
        c.Log('Battle order manipulated, attempting alena critical')
        c.Save(4)
        result = c.Cap(_getAlenaCritical, 1750)
        if result then
            c.Done()
        else
            c.Log('Failed to get alena critical')
        end
    else
        c.Log('Failed to get Battle order')
    end
end

c.Finish()
