-- Starts at the water quare before the last (step count = 15) upon landing on the continent directly south of the cave
-- Manipulates getting an encounter with 3 enemies of 1 group, that can 1-shot each character
-- Dragonpup, Bisonbear, 
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _do()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    c.PushUp()    
    c.RandomFor(14)
    c.WaitFor(1)
    c.RndWalkingFor('Up', 60)

    c.WaitFor(150)
    c.AddToRngCache()

    if not c.IsEncounter() then
        return c.Bail('Did not get an encoutner')
    end

    if c.ReadEGroup2Type() ~= 0xFF then
        return c.Bail('Did not get 1 enemy group')
    end

    if c.ReadE1Count() ~= 3 then
        return c.Bail('Did not get 3 enemies')
    end

    if c.ReadEGroup1Type() == 0x52 then
        return c.Bail('Bisonhawks cannot do enough damage')
    end

    _tempSave(5)
    return true
end



c.Load(4)
c.Save(100)
c.RngCacheClear()
--client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)
    local result = c.Cap(_do, 100)
    if c.Success(result) then
        c.Done()
    end
    c.Log('RNG: ' .. c.RngCacheLength())
end

c.Finish()
