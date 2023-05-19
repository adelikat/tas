-- Starts at the magic frame before the infurnus shadow fight
-- Manipulates Infernus Shadow going first, attacking and missing,
-- Then Taloon builds power
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _turn()
    c.RandomFor(2)
    c.WaitFor(12)
    c.RndAtLeastOne()
    c.RandomFor(23)
    c.WaitFor(5)
    if not c.PushAWithCheck() then return false end
    c.RandomFor(32)

    if c.ReadTurn() ~= 4 then
        return c.Bail('Infernus did not go first')
    end

    c.WaitFor(2)

    if c.Read(c.Addr.E1Action) ~= 67 then
        return c.Bail('Infernus did not attack')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)

    return true
end

local function _miss()
    local origHp = c.Read(c.Addr.TaloonHp)
    c.RndAtLeastOne()
    c.WaitFor(5)
    local currHp = c.Read(c.Addr.TaloonHp)
    c.Debug('curr: ' .. currHp .. ' orig: ' .. origHp)
    if currHp < origHp then
        return c.Bail('Did not miss')
    end

    return true
end

-- did not finish because I got the building power right away
local function _buildingPower()
    c.RndAtLeastOne()
    c.RandomFor(27)

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
        local result = c.ProgressiveSearch(_miss, 5, 1)
        if c.Success(result) then
            c.Done()
        end
    end

    -- local result = c.Cap(_buildingPower, 100)
    -- if c.Success(result) then
    --     c.Done()
    -- end
end

c.Finish()
