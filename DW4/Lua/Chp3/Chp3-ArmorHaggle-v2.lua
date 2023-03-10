-- Starts at the first frame to dimiss the "terrific blow" command
-- Manipulates the death warp, winging to endor
-- And getting the first encoutner
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 100
local bestOffer2 = 0
local bestOffer3 = 0
local function _readOffer()
    local offer = memory.read_u16_le(0x006F)
    c.Debug('offer: ' .. offer)
    return offer
end

local function _walkToShop()
    c.RndUntilY('Up', 17)
    c.RndWalking('Up', 12)
    c.WaitFor(1)
    c.PushFor('Left', 13)
    local result = c.RndUntilX('Left', 4, 100)
    if not result then
        return c.Bail('NPC got in the way')
    end
    c.RndWalking('Left', 12)
    c.WaitFor(1)
    c.PushFor('Down', 13)
    c.RndWalkingFor('Down', 21)
    c.WaitFor(1)

    c.PushA() -- Bring up menu
    c.UntilNextMenuY()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    return true
end

local function _offer1()
    c.PushA()
    c.RandomFor(6) -- Input frame in here
    c.UntilNextInputFrame()

    local delay = c.DelayUpToForLevels(c.maxDelay)
    c.RndAorB() -- We're short of armor
    c.WaitFor(30)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.UntilNextInputFrame()

    c.PushA() -- Yes
    c.WaitFor(30)
    c.UntilNextInputFrame()

    c.RandomFor(1)
    c.WaitFor(2)
    c.UntilNextInputFrame()

    c.PushA()
    c.WaitFor(20)

    local offer = _readOffer()

    if offer < 4600 then
        return c.Bail('Offer not enough')
    end

    c.UntilNextInputFrame()

    c.Save(string.format('Offer1-4600-%s-%s', delay, emu.framecount()))
    return false
end

local function _offer2()
    c.Debug('RNG cache: ' .. c.RngCacheLength())

    --Made a savestate for these inputs to reduce loop
    -- c.WaitFor(2)
    -- c.UntilNextInputFrame()
    -- c.PushA() -- Yes
    -- c.WaitFor(10)
    -- c.UntilNextInputFrame()
    -- c.Log('Saving 4')
    -- c.Save(4)

    local delay = c.DelayUpToForLevels(c.maxDelay)
    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.PushA() -- Yes (more to sell)

    c.WaitFor(20)
    c.UntilNextInputFrame()
    c.WaitFor(3) -- Input frame
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Half Plate')
    end

    --delay = delay + c.DelayUpToWithLAndR(c.maxDelay - delay)
    delay = delay + c.DelayUpToWithLAndR(c.maxDelay)
    c.PushA()

    c.WaitFor(25)

    local offer = _readOffer()
    if offer > bestOffer2 then
        bestOffer2 = offer
        c.Log('New Best Offer: ' .. offer)
    end

    local rngResult = c.AddToRngCache()
    if rngResult and c.RngCacheLength() > 100 then -- less than 100 to reduce noise
        c.Log(string.format('New RNG (%s)', c.RngCacheLength()))
    end
    

    if offer < 2381 then
        c.Save(string.format('BadOffer2-%s', offer))
        return c.Bail('Offer 2 not enough')
    end

    c.UntilNextInputFrame()

    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushA() -- Yes
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.Log('Offer 2 found')
    c.Save(string.format('Offer2-%s-delay-%s-%s-Rng2-%s-Rng1-%s', offer, delay, emu.framecount(), c.ReadRng2(), c.ReadRng1()))
    return false
end

local offer3Rng2Cache = {}
local function offer3Rng2CacheLength()
	local count = 0
	for _ in pairs(offer3Rng2Cache) do
        count = count + 1
    end
	return count
end

local function _offer3()
    c.Debug('RNG cache: ' .. c.RngCacheLength())       
    local delay = c.DelayUpToForLevels(10)
    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.PushA() -- Yes (more to sell)

    c.WaitFor(20)
    c.UntilNextInputFrame()
    c.WaitFor(3) -- Input frame
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Broad Sword')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Unable to navigate to Broad Sword')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then
        return c.Bail('Unable to navigate to Half Plate')
    end

    delay = c.DelayUpTo(c.maxDelay)
    c.PushA()
    c.WaitFor(20)

    if c.ReadMenuPosY() ~= 16 then
        return c.Bail('Did not successfully close menu')
    end

    local offer = _readOffer()
    if offer > bestOffer3 then
        bestOffer3 = offer
        c.Log('New Best Offer: ' .. offer)
    end

    local rngResult = c.AddToRngCache()
    if rngResult and c.RngCacheLength() > 100 then -- less than 100 to reduce noise
        c.Log(string.format('New RNG (%s)', c.RngCacheLength()))
    end
    local rng2 = c.ReadRng2()
    offer3Rng2Cache[tostring(rng2)] = rng2
    c.Debug('RNG2 cache: ' .. offer3Rng2CacheLength())

    if offer < 2386 then
        c.Save(string.format('BadOffer3-%s', offer))
        return c.Bail('Offer 3 not enough')
    end

    c.Save(7)
    c.Save(string.format('Offer3-%s-delay-%s-%s', offer, delay, emu.framecount()))
    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)	

    local result = c.Cap(_offer2, 10000)
    --local result = c.Cap(_offer3, 10000)

    --local result = c.Cap(_walkToShop, 10)
    -- if result then
    --     local rngResult = c.AddToRngCache()
    --     if rngResult then
    --         c.Save(3)
    --         local result = c.Cap(_offer1, 1000)
    --         if result then
    --             c.Done()
    --         end
    --     else
    --          c.Log(string.format('RNG already found (%s)', c.RngCacheLength()))
    --      end        
    -- end    
end

c.Finish()
