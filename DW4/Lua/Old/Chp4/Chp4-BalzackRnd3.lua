--Starts at the first magic frame after Balzack regenerates HP
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 3
local delay = 0
local maxHpRegen = 16
local function _turn()
	c.RandomFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    
    c.PushA() -- Mara attack
    c.WaitFor(2)
    c.UntilNextInputFrame()

    delay = c.DelayUpToWithLAndR(c.maxDelay - 1)
    c.PushA() -- Balzack
    c.RandomFor(20)
    c.WaitFor(12)

    if c.ReadTurn() ~= 2 then
        return c.Bail('Orin did not go first')
    end

    if c.ReadBattle() ~= 76 then
        
        return c.Bail('Orin did not attack')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)
    
	return true
end

local function _critical()
    local minDmg = c.ReadE1Hp()
    delay = delay + c.DelayUpTo(c.maxDelay)
    c.RndAtLeastOne()
    c.WaitFor(10)
    local dmg = c.ReadDmg()

    c.Debug('dmg: ' .. dmg)
    return dmg >= minDmg
end

--Starts at last frame to dismiss the Orin "terrific blow" message
--Manipulates Mara's miss, and a low HP refill
local function _finish()    
    c.RndAtLeastOne()
    c.WaitFor(40)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne() -- xx damage points to Balzack
    c.RandomFor(25)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    local origBalzackHp = c.ReadE1Hp()
    c.RndAtLeastOne() -- Mara attacks
    c.WaitFor(8)
    local currBalzackHp = c.ReadE1Hp()
    if currBalzackHp ~= origBalzackHp then
        return c.Bail('Mara did damage: ' .. origBalzackHp - currBalzackHp)
    end

    local dmg = c.ReadDmg()
    if dmg > 1 and dmg < 80 then
        return c.Bail('Mara got a critical')
    end

    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.RandomFor(20)

    local currBalzackHp = c.ReadE1Hp()
    local hpRegen = currBalzackHp - origBalzackHp
    c.Log(string.format('HP Regen: %s', hpRegen))

    if hpRegen > maxHpRegen then
        return c.Bail('Too much HP Regen')
    end

    c.UntilNextInputFrame()

    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
    c.Load(100)
    delay = 0
	local result = c.Cap(_turn, 1000)	
	if result then
        result = c.Cap(_critical, 250)
        if result then
            c.Log('Delay: ' .. delay)
            c.Done()
        else
            c.Log('Could not get crit')
        end		
	else
		c.Log('Nothing found')
	end
end

c.Finish()



