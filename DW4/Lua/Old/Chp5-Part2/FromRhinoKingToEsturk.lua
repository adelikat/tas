-- Starts at the first frame to dismiss the "Terrific Blow" dialog in round 2
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _endFight()
    c.RndAtLeastOne()
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.RandomFor(80)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.DismissDialog()

    return true
end

local function _toEsturk()
    c.ChargeUpWalking()
    if not c.WalkUp(3) then return false end
    c.RandomFor(5)
    c.UntilNextInputFrame()
    return true
end

local function _do()
    local result = c.Best(_endFight, 10)
    if c.Success(result) then
        result = c.Best(_toEsturk, 10)
        if c.Success(result) then
            return true
        end
    end

    return false
end

c.Load(3)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
	c.Load(100)

    local result = c.Best(_do, 10)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()



