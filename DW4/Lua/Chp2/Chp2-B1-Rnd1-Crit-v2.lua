--Starts at the first frame that the dialog can be closed 'Don't litter the litter, Right sorry'
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 5000
c.maxDelay = 3

local delay = 0

local function _bail(msg)
	c.Debug(msg)
	c.Increment()
	return false
end

function _readChamTarget()
	return c.Read(0x7305)
end

function _readRabBTarget()
	return c.Read(0x7306)
end

function _getToARPI()
    c.RndAtLeastOne()
    c.RandomFor(672)
    c.WaitFor(630)
    c.UntilNextInputFrame()
    
    c.RandomFor(1) -- Magic frame
	c.WaitFor(8)
    c.UntilNextInputFrame()
	c.WaitFor(2)

    c.RndAtLeastOne() -- Rabidhound appears
    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- Chameleon Humanoid appears
    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- Rabidhound appears
    c.RandomFor(25)
    c.UntilNextInputFrame()

    if c.ReadTurn() ~= 0 then
        return _bail('Failed to get to ARPI menu')
    end

    c.WaitFor(2)
    c.UntilNextInputFrame()

    return true
end

local function _cristoHp()
    return c.Read(0x6020)
end

-- Alena attack Rabidhound A
-- Cristo attack Rabidhound A
-- Brety cast Icebolt on Chameleon Humanoise
function _manipBattleOrder()
    c.PushA() -- Pick Alena attack
    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.PushA() -- Pick Rabidhound A
    c.WaitFor(2)
    c.RandomFor(10) -- Magic frame in here
    c.UntilNextInputFrame()
    c.WaitFor(2) -- A non-input frame but we need it for the fastest menu
    c.UntilNextInputFrame()

    c.PushA() -- Pick Cristo attack
    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.PushA() -- Pick Rabidhound A
    c.WaitFor(2)
    c.RandomFor(10) -- Magic frame in here
    c.UntilNextInputFrame()
    c.WaitFor(2) -- A non-input frame but we need it for the fastest menu
    c.UntilNextInputFrame()

    c.PushDown() -- Brey down to spell
    if c.ReadMenuPosY() ~= 17 then
        return _bail('Lag navigating to spell')
    end
    c.PushA()
    c.WaitFor(4)
    c.UntilNextInputFrame()

    c.PushA() -- Icebolt
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return _bail('Lag navigating to Chameleon Humanoid')
    end
    c.PushA() -- Chameleon Humanoid
    c.RandomFor(20)
    c.WaitFor(3)
    c.UntilNextInputFrame()

    if c.ReadTurn() ~= 5 then
        return _bail('Chameleon Humanoid did not go first')
    end

    if c.ReadBattle() ~= 76 then
        return _bail('Chameleon Humanoid did not attack')
    end

    if _readChamTarget() ~= 1 then
        return _bail('Chameleon Humanoid did not target Cristo')
    end

    -- Battle order flags must be specific
    if c.Read(0x7348) ~= 114 then
        return _bail('Bad Battle Order 1 value')
    end
	if c.Read(0x7349) ~= 3 then
        return _bail('Bad Battle Order 2 value')
    end

	if c.Read(0x734A) ~= 118 then
        return _bail('Bad Battle Order 3 value')
    end

    c.WaitFor(2)
    c.RndAtLeastOne()
    c.WaitFor(3)

    if _cristoHp() > 7 then
        return _bail('Did not do enough damage to Cristo')
    end

    c.WaitFor(54)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    return true
end

--Starts from the first frame after cristo is hit with damage
function _alenaCritical()
    delay = c.DelayUpTo(c.maxDelay)
    c.RndAtLeastOne()
    c.WaitFor(1)
    if c.ReadBattle() == 102 then
        return _bail('Cristo fell asleep')
    end

    c.RandomFor(22)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    delay = delay + c.DelayUpTo(c.maxDelay - delay)
    c.RndAtLeastOne()
    c.WaitFor(5)

    local dmg = c.ReadDmg()
    if dmg < 10 then
        return _bail('Failed to get Alena critical')
    end

    if dmg < 13 then
        c.Save('AlenaCrit' .. dmg)
        return _bail('Got Alena critical, but not enough dmg')
    end

    return true
end

c.Load(0)
c.Save(101)
while not c.done do
	c.Load(101)       
    local result = c.Cap(_getToARPI, 5)
    if result then
        result = c.Cap(_manipBattleOrder, 200)    
        if result then
            result = c.Cap(_alenaCritical, 1000)
            if result then
                c.Done()
            else
                c.Log('Unable to manip alena critical, bailing')
            end            
        else
            c.Log('Unable to manip battle order, bailing')
        end
    end
    
end

c.Finish()

