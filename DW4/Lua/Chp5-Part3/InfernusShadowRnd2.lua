-- Starts at the first frame to dismiss "Building power" in round one
-- Manipulates Taloon going first, calling for reinforcements and getting critical hits
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _turn()
    c.RndAtLeastOne()
    c.RandomFor(39)
    c.WaitFor(4)
    if not c.PushAWithCheck() then return false end
    c.RandomFor(30)
    c.WaitFor(5)

    c.AddToRngCache()
    if c.ReadTurn() == 4 then
        return c.Bail('Taloon did not go first')
    end

    local taloonAction = c.Read(c.Addr.P2Action)
    if taloonAction == 247 then        
        c.Log('taloon did not make up his mind yet')
        return false
    end

    if taloonAction ~= c.Actions.Attack then
        c.Log('Taloon action: ' .. c.TaloonActions[taloonAction])    
    end
    
    if taloonAction ~= c.Actions.Reinforcements then
        return c.Bail('Infernus did not attack')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)
    return true
end

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

    c.Log('RNG: ' .. c.RngCacheLength())
end

c.Finish()
