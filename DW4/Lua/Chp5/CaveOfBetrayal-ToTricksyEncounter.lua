-- Starts at the first frame to advance after the Max HP line
-- during level up after the Liclick fight, assume MP will be the correct value
-- Manipulates to the next encounter
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _downStairs()
    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
   
    _tempSave(4)
    return true
end

local function _encounter()
    c.PushA()
    c.RandomFor(3)
    c.WaitFor(1)
    c.WalkUp(2)
    c.WalkLeft(2)
    local result = c.BringUpMenu()
    if not result then return false end

    c.PushA()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()

    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()

    _tempSave(5)
    return true
end




c.Load(4)
c.Save(100)
c.RngCacheClear()
client.unpause()
client.speedmode(3200)
while not c.done do
    c.Load(100)
    --local result = c.Best(_downStairs, 10)
    local result = true
    if c.Success(result) then
        result = c.Best(_encounter, 10)
        if result then
            c.Done()
        end
    end
end

c.Finish()
