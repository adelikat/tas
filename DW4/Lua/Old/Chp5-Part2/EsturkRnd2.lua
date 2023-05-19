-- Starts at the first frame to dimiss "Taloon is building up power" from round 1
-- Manipulates round 1
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _turn()
    c.RndAtLeastOne()
    c.RandomFor(35)
    c.WaitFor(5)
    if not c.PushAWithCheck() then return false end
    c.RandomFor(30)
    c.WaitFor(8)
    --------------------
    if c.ReadTurn() ~= 1 then
        return c.Bail('Taloon did not go first')
    end

    local taloonAction = c.Read(c.Addr.P2Action)
    if taloonAction ~= 67 then
        c.Log('Taloon action: ' .. taloonAction)
    end
    if c.Read(c.Addr.P2Action) ~= c.Actions.Reinforcements then
        return c.Bail('Taloon did not call for reinforcements')
    end

    --------------------

    c.UntilNextInputFrame()
    c.WaitFor(2)
    return true
end

-- Did not write the Taloon building power method because I got it on the first try

c.Load(4)
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



