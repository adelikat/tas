--Starts anytime during the 'Fight is starting' mode before Glass Joe
--Manipulates the Glass Joe Fight
dofile('MTPO-Core.lua')

c.InitSession()

if c.Mode() ~= c.Modes.FightIsStarting then
    error('This script must start while the fight is starting')
end

if c.CurrentOpponent() ~= c.OpponentNames.GlassJoe then
    error('Script only works on Glass Joe!')
end

if c.CurrentRound() ~= 1 then
    error('Script only works on round 1')
end

c.FastMode()

local function _hitAfterTaunt()
    if not c.QuickRightDodge() then return false end
    if not c.QuickRightDodge() then return false end
    if not c.Duck() then return false end
    if not c.QuickRightDodge() then return false end
    c.WaitFor(3)
    if not c.RightFacePunch() then return false end
    return true
end

local function _do()
    c.RandomUntilMacCanFight()
    for i = 1, 18 do
        if not c.Cap(c.LeftFacePunch, 30) then
            c.Log(string.format('Failed on punch %s', i))
            return false
        end
    end

    if not c.Cap(c.RightFacePunch, 30) then
        c.Log(string.format('Failed on punch 19', i))
        return false
    end

    if not c.Cap(_hitAfterTaunt, 100) then return false end
    if not c.Cap(c.UntilKoFinishes, 100) then return false end
    if not c.UntilPostFightBlackScreen() then return false end
    return true
end

while not c.IsDone() do
    local result = c.Cap(_do, 100)
    if result then
        c.Done()
    end
end

c.Finish()
