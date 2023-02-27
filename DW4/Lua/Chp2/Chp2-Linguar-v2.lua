-- Starts at the magic frame before the fight
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 0

_miss = 98
_hpAddr = c.Addr.AlenaHP
_bestDelay = 999

function _turnOrder()
    c.RandomFor(1)
    c.WaitFor(11)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne() -- Linguar appears
    c.RandomFor(20)
    c.WaitFor(150)
    c.UntilNextInputFrame()
    c.RandomFor(1) -- Another Magic frame
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(2) -- Input frame needed for early attack
    c.UntilNextInputFrame()

    c.PushA() -- Attack
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushA() -- Target Linguar-A
    c.RandomFor(23)
    c.UntilNextInputFrame()

    local turn = c.ReadTurn()
    if turn == 0 then
        c.Save(9)
        c.Log('Jackpot!! Alena went first')
        c.Done()
        return true
    end

    if turn ~= 4 then
        return c.Bail('Linguar A was not the real linguar')
    end

    if c.ReadBattle() ~= 76 then
        return c.Bail('Linguar did not attack')
    end

    c.WaitFor(2)
    return true
end

function _miss()
	local origHp = c.Read(c.Addr.AlenaHP)
	c.RndAtLeastOne()
	c.WaitFor(5)

	local currHp = c.Read(c.Addr.AlenaHP)
	local dmg = origHp - currHp
	c.Debug('dmg: ' .. dmg)
	return dmg == 0
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
	local result = c.Cap(_turnOrder, 1000)
    if result then
        local cacheResult = c.AddToRngCache()
        if cacheResult then
            result = c.FrameSearch(_miss, 7)
            if result then
                c.Done()
            else
                c.Log('Unable to get miss')
            end
        else
            c.Log('RNG already found')
        end
    else
        c.Log('Unable to manip turn')
    end
end

c.Finish()
