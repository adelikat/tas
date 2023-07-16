--Starts at the first frame to press start to advance the 'Time' screen (Great fighting, you won, Time x:xx.xx)
--Manipulates the Piston Honda 1 fight
dofile('MTPO-Core.lua')
c.InitSession()
c.Load(5)

if c.CurrentOpponent() ~= opponents.PistonHonda1 then
    error('Script only works on Piston Honda 1!')
end

if addr.Round:Read() ~= 1 then
    error('Script only works on round 1')
end

c.FastMode()
--c.BlackscreenMode()

local function _rndFacePunch()
    return c.Cap(c.LeftFacePunch, 48)
end

local function _rndMaxDamageUpperCut()
    local origHP = addr.OppHp:Read()
    if not c.Uppercut(true) then return false end
    local currHP = addr.OppHp:Read()
    local dmg = origHP - currHP
    c.Debug('dmg: ' .. dmg)
    return dmg >= 19
end

local function _setup()
    c.PushStart(2)
    c.UntilMode(c.Modes.PreRound)
    c.UntilNextInputFrame()
    c.PushStart(2)
    c.UntilMode(c.Modes.FightIsStarting)
    return true
end

local function _phase1()
    c.RandomUntilMacCanFight()
    if not _rndFacePunch() then return false end
    if not _rndFacePunch() then return false end
    if not _rndFacePunch() then return false end
    if not c.Uppercut() then return false end
    if not c.Uppercut() then return false end
    if not _rndFacePunch() then return false end

    c.WaitFor(5)
    if not c.Cap(_rndMaxDamageUpperCut, 96) then return false end
    if not _rndFacePunch() then return false end
    c.WaitFor(6)
    if not c.Cap(_rndMaxDamageUpperCut, 96) then return false end
    return true
end

local function _phase2()
    c.UntilMode(c.Modes.Fighting)
    c.UntilMacCanFight()
    if not c.Uppercut() then return false end

    local nextHealth = addr.OppNextHealth:Read()
    if nextHealth > 48 then
        c.Debug('Opponent did not get 48 health')
        return false
    end

    if c.OpponentWillGetUpOnCount() ~= 2 then
        c.Debug('Opponent will not get up on 2')
        return false
    end

    return true
end

local function _phase3()
    c.UntilMode(c.Modes.Fighting)
    c.UntilMacCanFight()
    --if not _rndFacePunch() then return false end
    return true
end

c.Save(100)
while not c.IsDone() do
    --local result = c.Cap(_setup, 100)
    local result = true
    if c.Success(result) then
        --result = c.Cap(_phase1, 100)
        result = true
        if c.Success(result) then
            --result = c.Cap(_phase2, 100)
            result = true
            if c.Success(result) then
                result = c.Cap(_phase3, 100)
                if c.Success(result) then
                    c.Done()
                end
            end
        end
    end
    
    if result then
        c.Done()
    end
end

c.Finish()
