-- Starts at the first frame possible to dismiss the "Terrific blow" dialog
-- From the previous round
-- Turn order and 2 misses
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 6
local delay = 0
local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _turn()
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- x dmg points
    c.RandomFor(18)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.UntilNextInputFrame()

    c.PushA() -- Pick A
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushA() -- Pick Liclick-A
    c.RandomFor(22)
    c.UntilNextInputFrame()

    if c.ReadTurn() ~= 0 then
        if c.ReadTurn() < 4 then
            c.Log('Turn: '.. c.ReadTurn())
        end
        
        return c.Bail('Hero did not go first')
    end

    c.WaitFor(2)
    return true
end

local function _attack()
    c.RndAtLeastOne()
    c.WaitFor(5)
    if c.ReadDmg() ~= 3 then
        return c.Bail('Did not do enough damage')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)
    return true
end


c.Load(3)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)
    
    local result = c.Cap(_turn, 100)
    if c.Success(result) then
        result = c.Cap(_attack, 5)
        if result then
            c.Done()
        else
            c.Log('Could not get attack')
         end        
    else
        c.Log('Could not manip turn')
    end
end

c.Finish()
