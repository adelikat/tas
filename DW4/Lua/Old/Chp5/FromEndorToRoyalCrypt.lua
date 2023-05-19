
-- Starts at the last lag frame after arriving at Endor from Soretta
-- Manipulates entering the royal crypt, and getting an optimal metal babble encounter
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 2000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _travelToCrypt()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    c.PushDown()
    c.RandomFor(17)
    c.UntilNextInputFrame()
    local result = c.WalkMap({
        { ['Right'] = 1 },
        { ['Down'] = 8 },
        { ['Left'] = 2 },
        { ['Down'] = 3 },
        { ['Left'] = 8 },
        { ['Down'] = 5 },
    })    
    if not result then return false end
    c.PushDown()
    result = c.WalkDown(2)
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _enter()
    local result = c.WalkUp(6)
    if not result then return false end
    c.BringUpMenu()
    c.Door()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    c.WalkUp()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _encounter()
    if c.GenerateRndBool() then
        c.PushUp()        
    else
        c.PushRight()
    end
    c.RandomFor(15)

    c.WaitFor(5)
    if not c.IsEncounter() then
        return false
    end

    if c.ReadEGroup1Type() ~= 0x75 then
        return c.Bail('Did not get metal babbles')
    end

    if c.ReadEGroup2Type() ~= 0xFF then
        return c.Bail('Got 2nd enemy group')
    end

    c.Log('Got metal babbles')
    c.Save(string.format('CryptEncounter-%s-Count-%s-Rng2-%s-Rng1-%s', emu.framecount(), c.ReadE1Count(), c.ReadRng2(), c.ReadRng1()))

    if c.ReadE1Count() > 1 then
        return c.Bail('Too many metal babbles')
    end

    c.UntilNextInputFrame()

    return true
end


c.Load(3)
c.Save(100)
c.RngCacheClear()
client.unpause()
client.speedmode(3200)
while not c.done do
	c.Load(100)
	local result = c.Best(_travelToCrypt, 5)
    if c.Success(result) then
        result = c.Cap(_enter, 100)
        if result then
            local cacheResult= c.AddToRngCache()
            if cacheResult then
                result = c.Cap(_encounter, 2000)
                if result then
                    c.Done()
                end
            else
                c.Log('RNG already found')
            end            
        end
    end
end

c.Finish()



