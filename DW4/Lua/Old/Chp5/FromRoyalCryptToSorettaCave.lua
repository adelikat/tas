
-- Starts at the first frame to dimiss 'Intelligence goes up' from the last Taloon level up
-- With the ideal HP manipulated
-- Manipulates leaving the crypt and walking to the cave south of Soretta
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 2

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _leave()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    c.BringUpMenu()
    c.HeroCastReturn()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Could not navigate to Endor')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Could not navigate to Konenber')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then
        return c.Bail('Could not navigate to Mintos')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 20 then
        return c.Bail('Could not navigate to Soretta')
    end
    c.PushA()
    if c.Read(0x0644) ~= 0xFF then
        return c.Bail('Could not pick Soretta')
    end
    c.RandomFor(2)
    c.UntilNextInputFrame()

    _tempSave(4)
	return true
end

local function _enterSorettaCave()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    local result = c.WalkMap({
        { ['Left'] = 7 },
        { ['Down'] = 5 },
        { ['Left'] = 3 },
        { ['Down'] = 17 },
        { ['Left'] = 5 },
        { ['Down'] = 3 },
        { ['Left'] = 1 },
        { ['Down'] = 1 },
        { ['Left'] = 1 },
        { ['Down'] = 2 },
        { ['Left'] = 1 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    _tempSave(5)
    return true
end

c.Load(3)
c.Save(100)
c.RngCacheClear()
client.unpause()
client.speedmode(3200)
while not c.done do
	c.Load(100)
	local result = c.Best(_leave, 30)	
	if c.Success(result) then
        result = c.Best(_enterSorettaCave, 30)
        if c.Success(result) then
            c.Done()
        end
	end
end

c.Finish()

