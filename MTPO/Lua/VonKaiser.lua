--Starts anytime during the 'Fight is starting' mode before Von Kaiser
--Manipulates the Von Kaiser Fight
dofile('MTPO-Core.lua')

c.InitSession()

if c.Mode() ~= c.Modes.FightIsStarting then
    error('This script must start while the fight is starting')
end

if c.CurrentOpponent() ~= opponents.VonKaiser then
    error('Script only works on Von Kaiser!')
end

if addr.Round:Read() ~= 1 then
    error('Script only works on round 1')
end

c.FastMode()

local function _punch2or4()
    local orig = addr.OppHp:Read()
    c.WaitFor(1)
    c.PushB(2)
    c.WaitFor(5)
    c.PushUp()
    c.WaitFor(3)
    local curr = addr.OppHp:Read()
    local gain = orig - curr
    if gain ~= 4 then
        c.Debug('Did not successfully hit gutter')
        return false
    end
    c.WaitFor(24)
    return true
end

-- punch 7 as a 3/16 chance of landing
-- we want to buffer the RNG using the previous non-random punch
local function _punch6and7()
    if not c.LeftGutPunch() then return false end
    c.WaitFor(1)
    if not c.LeftFacePunch() then return false end
    return true
end

local function _phase1()
    c.RandomUntilMacCanFight()
    c.LeftFacePunch()
    if not _punch2or4() then return false end
    if not c.LeftGutPunch() then return false end
    if not _punch2or4() then return false end
    if not c.LeftGutPunch() then return false end
    if not c.Cap(_punch6and7, 30) then return false end
    if not c.RightFacePunch() then return false end

    -- Got star, time to set up uppercut
    c.WaitFor(5)
    if not c.Duck() then return false end
    if not c.LeftFacePunch() then return false end
    if not c.Uppercut() then return false end

    -- We know Von will get up on 1 so no count or health to manipulate
    return true
end

local function __phase2punches()
    if not c.MisdirectedLeftGutPunch() then return false end
    if not c.LeftGutPunch() then return false end
    if not c.Uppercut() then return false end
    if addr.Stars:Read() ~= 1 then
        c.Debug('Did not get random star')
        return false
    end
    if c.OpponentWillGetUpOnCount() ~= 2 then
        c.Debug('Von will not get up on 2')
        return false
    end
    return true
end

local function _phase2()
    c.UntilMode(c.Modes.Fighting)
    c.UntilMacCanFight()
    c.WaitFor(7)
    if not c.Cap(__phase2punches, 30) then return false end
    return true
end

local function _phase3()
    c.UntilMode(c.Modes.Fighting)
    c.UntilMacCanFight()
    c.WaitFor(30)
    if not c.Duck() then return false end
    if not c.Uppercut() then return false end
    return true
end

while not c.IsDone() do
    local result = c.Cap(_phase1, 100)
    if result then
        local result = c.Cap(_phase2, 100)
        if result then
            local result = c.Cap(_phase3, 100)
            if result then
                c.Done()
            end
        end
    end
end
c.Save(10)
c.Finish()
