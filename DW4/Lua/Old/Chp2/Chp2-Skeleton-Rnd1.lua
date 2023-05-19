-- Starts from the magic frame at the beginning of the Skeleton encounter
-- Gives medicine to king and wings to bazaar
local c = require("DW4-ManipCore")

c.InitSession()
c.reportFrequency = 2000

local function _battleOrder()
    c.RandomFor(1)
    c.WaitFor(9)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.RandomFor(22)
    c.UntilNextInputFrame()
    c.WaitFor(2) -- Input frame necessary for early menu
    c.UntilNextInputFrame()

    c.PushA() -- Attack
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushA() -- Skeleton
    c.RandomFor(20)

    if c.ReadTurn() ~= 4 then
        return c.Bail('Skeleton did not go first')
    end

    c.WaitFor(40)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    if c.ReadBattle() ~= 94 then
        return c.Bail('Skeleton did not cast defense')
    end

    return true
end

local function _getCritical()
    c.RndAtLeastOne() -- Skeleton casts defense
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne() -- Defense lowered by x points
    c.RandomFor(30)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- Alena attacks
    c.WaitFor(6)
    local dmg = c.ReadDmg()
    c.Debug('dmg: ' .. dmg)
    return dmg >= 21
end

c.Load(0)
c.Save(100)
while not c.done do
	c.Load(100)
    local result = c.Cap(_battleOrder, 1000)
    if result then   
        c.Log('Turn manipulated')
        c.Save(4)
        result = c.Cap(_getCritical, 256)
        if result then
            c.Done()
        else
          c.Log('Unable to get critical')
        end        
    end
end

c.Finish()

