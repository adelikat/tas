-- Starts from the last lag frame after exiting the cave south of soretta
-- Casts return and enters Soretta, staying at the inn
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _return()
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
        return c.Bail('Could not pick Return')
    end
    c.RandomFor(5)
    c.UntilNextInputFrame()
    _tempSave(4)
    return true
end

local function _enterSoretta()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    local result = c.WalkUp()
    if not result then return false end
    c.WaitFor(10)
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
    local result = c.Best(_return, 25)
    if c.Success(result) then
        result = c.Best(_enterSoretta, 50)
        if c.Success(result) then
            c.Done()
        end
    end
end

c.Finish()
