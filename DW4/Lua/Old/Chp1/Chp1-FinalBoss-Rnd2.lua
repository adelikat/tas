--Manipulates all of round 2 including a max damage critical hit
--Starts at the frame you see "Terrific blow" from round 1
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 500

function _readDmg()
    return c.Read(0x7361)
end

function _menuY()
	return c.Read(c.Addr.MenuPosY)
end

function _battleFlag()
	return c.Read(c.Addr.BattleFlag)
end

function _turn()
	return c.Read(c.Addr.Turn)
end

function _bail(msg)
	c.Debug(msg)
	c.Increment()
	return false
end

function _ragnarCurrentHp()
	return c.Read(0x60B6)
end

function _manipSaroAttackWithMiss()
    c.WaitFor(1)
    c.RndAtLeastOne()
    c.RandomFor(1)
    if c.ReadE2Hp() ~= 0 then
        c.Save(4)
        return _bail('Lag at attack')
    end

    c.WaitFor(40)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- x Dmg points to Giant Eyeball
    c.RandomFor(1)
    c.WaitFor(2)

    if _battleFlag() ~= 8 then
        return _bail('Lag after damage to eyeball')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- Giant Eyeball want defeated

    -- Transition to next round
    c.RandomFor(17) -- Lots of Rng frames

    if _battleFlag() ~= 0 then
        return _bail('Lag at next round transition')
    end

    c.WaitFor(3)

    if _menuY() ~= 16 then
        c.Save(4)
        return _bail('Lag at ARPI menu')
    end

    c.UntilNextInputFrame()
    
    c.PushA() -- Attack

    -- Not sure what 0x001E is, but it is consistently 128 and then 129 on the frame
    -- immediately after successfully picking attack, if not 129,
    -- the first input frame was too soon to press attack
    if c.Read(0x001E) ~= 129 then
        return _bail('Lag at ARPI menu')
    end

    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushA() -- Target Saro's Shadow
   
    c.RandomFor(14)
    c.WaitFor(12)

    if _turn() == 0 then
        c.Save('PossibleJackpot-RagnarWentFirst')
        return _bail('lag')
    end

    if _battleFlag() ~= 76 then
        return _bail('Saro did not attack')
    end

    c.UntilNextInputFrame()

    c.WaitFor(2)
    c.RndAtLeastOne() -- Saro's Shadow attacks!
    c.RandomFor(1)
    c.WaitFor(10)

    if _ragnarCurrentHp() ~= 27 then
        return false
    end

    return true
end

function _manipCritical()
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.RandomFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() --Ragnar attacks
    c.RandomFor(1)
    c.WaitFor(10)
    local dmg = c.ReadDmg()
    c.Debug('Ragnar attack dmg: ' .. dmg)
    c.DelayUpTo(3)
    return c.ReadDmg() == 60
end

function _saveMiss()
    c.Save(4)
    frames = emu.framecount()
    rng1 = c.ReadRng1()
    rng2 = c.ReadRng2()
    filename = 'Rnd2Miss-' .. frames .. '-rng-' .. rng1 .. '-' .. rng2
    c.Log(filename)
    c.Save(filename)
end

c.Load(10)
c.Save(100)
while not c.done do
	c.Load(100)
    result = c.Cap(_manipSaroAttackWithMiss, 10000)
    if result then
        _saveMiss()
        result = c.Cap(_manipCritical, 64)
        if result then
            c.Done()
        end
        
    end

	c.Increment()
end

c.Finish()



