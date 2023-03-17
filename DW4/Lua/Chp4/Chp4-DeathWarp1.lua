-- Starts at the magic frame of an encounter with 1 Magemonja
-- Manipulates a death warp
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _turn()
    c.RandomFor(1)
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne() -- Magemonja appears
    c.RandomFor(22)    
    c.UntilNextInputFrame()
    c.WaitFor(2) -- Input frame
    c.UntilNextInputFrame()

    c.PushA() -- Mara attack
    c.WaitFor(2) 
    c.UntilNextInputFrame()
    c.PushA() -- Magemonja
    c.RandomFor(8)
    c.UntilNextInputFrame()
    c.WaitFor(2) -- Input frame
    c.UntilNextInputFrame()

    c.PushA() -- Nara attack
    c.WaitFor(4) 

    c.PushUp()
    if c.ReadMenuPosY() ~= 31 then
        return c.Bail('Unable to navigate to arrow')
    end

    c.PushA() -- Arrow
    c.WaitFor(3)
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Failed to navigate to Nara')
    end
    c.DelayUpToForLevels(1)
    c.PushA()
    c.RandomFor(23)
    c.UntilNextInputFrame()

    if c.ReadTurn() ~= 4 then
        return c.Bail('Magemonja did not go first')
    end

    if c.ReadBattle() ~= 191 and c.ReadBattle() ~= 94 then
        return c.Bail('Magemonja did not cast spell')
    end

    if c.Read(0x7304) ~= 0 then
        return c.Bail('Magemonja did not target Mara')       
    end

    if c.Read(0x7349) < 3 then
        c.Save(string.format('aaaJackpot-SlowOrin-bo-%s-rng2-%s-fr-', c.Read(0x7349), c.ReadRng2(), emu.framecount()))
        return true
    end
   
    c.WaitFor(2)

   
    return true
end

local function _iceBolt()
    c.RndAtLeastOne()
    c.WaitFor(5)
    return c.ReadDmg() >= 16
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
    local result = c.Cap(_turn, 1000)
    if result then
        local rngResult = c.AddToRngCache()
        if rngResult then
            result = c.Cap(_iceBolt, 5)
            if result then
                c.Done()
            else
                c.Log('Could not get 16 dmg')
            end        
        else
            c.Log('RNG already found')
        end        
    else
        c.Log('Could not manip turn')
    end
end

c.Finish()
