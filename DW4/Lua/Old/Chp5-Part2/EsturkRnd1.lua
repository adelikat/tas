-- Starts at the magic frame before the Esturk Fight
-- Manipulates round 1
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _turn()
    c.RandomFor(1)
    c.WaitFor(14)
    
    c.RndAtLeastOne()
    c.WaitFor(52)

    c.RndAtLeastOne()
    c.RandomFor(14)
    c.WaitFor(4)
    if not c.PushAWithCheck() then return false end
    c.RandomFor(30)

    --------------------
    if c.ReadTurn() ~= 4 then
        return c.Bail('Esturk did not go first')
    end

    if c.ReadBattle() ~= 18 then
        return c.Bail('Esturk did not wake up')
    end

    --------------------

    c.UntilNextInputFrame()
    c.WaitFor(2)
    return true
end

-- Did not write the Taloon building power method because I got it on the first try

c.Load(3)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
	c.Load(100)

    local result = c.Cap(_turn, 100)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()



