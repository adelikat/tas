-- Starts at the magic frame before the fight
-- Manipulates
-- Hero getting initiative over all 3 Demighouls and casting expel
-- Radimvice only getting 1 attack
-- Taloon building power
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 7

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _turn()
    c.RandomFor(2)
    c.WaitFor(12)
    c.RndAtLeastOne()
    c.WaitFor(7)
    c.RndAtLeastOne()
    c.RandomFor(30)
    c.WaitFor(5)
    if not c.PushAWithCheck() then return false end -- Fight
    c.RandomFor(10)
    c.WaitFor(5)
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Spell')
    end
    if not c.PushAWithCheck() then return false end -- Spell
    c.WaitFor(6)
    if not c.PushAWithCheck() then return false end -- Expel
    c.WaitFor(6)
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Demighoul')
    end
    c.DelayUpToWithLAndR(c.maxDelay)
    if not c.PushAWithCheck() then return false end
    c.RandomFor(35)

    c.AddToRngCache()
    ---------------------------------------
    if c.ReadTurn() ~= 0 then
		return c.Bail('Hero did not go first')
	end

	-- if c.Read(c.Addr.E1Action) ~= 15 then
	-- 	return c.Bail('Radimvice must cast Intermost in order for Taloon to cover mouth')
	-- end

    ---------------------------------------
    return true
end

c.Load(2)
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
