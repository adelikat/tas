-- Starts at the first frame to say Yes to the 3rd offer
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 10000

local origBattleFlag = c.ReadBattle()
local function _isEncounter()
	local battle = c.ReadBattle()
	return battle ~= origBattleFlag
end

local function _finishConvo()
    c.DelayUpToWithLAndR(1)
    c.PushA()
    c.WaitFor(30)
    c.UntilNextInputFrame()

    c.RndAorB()
    c.WaitFor(40)
    c.UntilNextInputFrame()
    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.PushB() -- No
    c.WaitFor(30)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    return true
end

local function _wing()
	c.RndAtLeastOne()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushA() -- Bring up menu
    c.RandomFor(5)
	c.UntilNextMenuY()
    c.WaitFor(7)
    c.UntilNextInputFrame()
    local result = c.UseFirstMenuItem()

    if not result then
        return false
    end

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Bonmalmo')
    end

    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Unable to navigate to Endor')
    end
    c.DelayUpToWithLAndR(1)
    c.PushA()
    c.RandomFor(1)
    c.WaitFor(200)
    c.UntilNextInputFrame()

	return true
end

local function _encounter()
    c.RandomFor(10)
    c.PushFor('Right', 7)
    c.RndWalkingFor('Right', 28)
    c.AddToRngCache()
    if not _isEncounter() then
        return c.Bail('Did not get encounter')
    end

    if c.ReadEGroup2Type() ~= 0xFF then
        c.Log('Got 2nd enemy group')
        return c.Bail('Got a 2nd enemy group')
    end

    if c.ReadE1Count() ~= 1 then
        c.Log('Did not get 1 enemy')
        return c.Bail('Did not get 1 enemy')
    end

    if c.ReadEGroup1Type() == 0xAD then
        c.Log('Got Merchant')
        return c.Bail('Got Merchant')
    end

    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
    local result = c.Cap(_finishConvo, 100)    
	result = c.Cap(_wing, 100)	
    --result = true
	if result then
        result = c.Cap(_encounter, 100)        
        if result then
            c.Done()
        else
            c.Log('RNGs: ' .. c.RngCacheLength())
            --c.Log('No encounter')
        end		
	end
end

c.Finish()



