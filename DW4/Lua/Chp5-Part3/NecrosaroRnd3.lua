-- Starts at the first frame to dismiss "terrific blow" from the previous round, 3rd critical (1st hit against the 2nd form)
-- Manipulates Taloon going first, attacking and getting a regular hit that defeats the 2nd form, necrosar will not have a turn
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 0
local delay = 0
local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function __next()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
end


local function _turn()
    c.RndAtLeastOne()
    __next()
    c.RndAtLeastOne()
    __next()
    c.RndAtLeastOne()
    c.RandomFor(25)
    c.WaitFor(3)
    if not c.PushAWithCheck() then return false end
    c.RandomFor(25)
    c.WaitFor(7)
    if c.ReadTurn() == 4 then
        return c.Bail('Taloon did not go first')
    end

    if c.Read(c.Addr.P2Action) == 247 then
        c.Log('Taloon did not make up his mind yet')
    end

    if c.Read(c.Addr.P2Action) ~= c.Actions.Trips then
        return c.Bail('did not trip')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)

   return true
end

c.Load(6)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do    
	c.Load(100)
    local result = c.Cap(_turn, 100)
    if c.Success(result) then
        c.Log('Turn manipulated')
    --     result = c.Cap(_crit1, 500)
    --     if c.Success(result) then
    --         c.Log('delay: ' .. delay)
            c.Done()
    --     end
    end
end

c.Finish()

