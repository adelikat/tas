--Starts anytime during the 'Fight is starting' mode before Piston Honda 1
--Manipulates the Piston Honda 1 fight
dofile('MTPO-Core.lua')
c.InitSession()
if c.Mode() ~= c.Modes.FightIsStarting then
    error('This script must start while the fight is starting')
end

if c.CurrentOpponent() ~= opponents.PistonHonda1 then
    error('Script only works on Piston Honda 1!')
end

if addr.Round:Read() ~= 1 then
    error('Script only works on round 1')
end

c.FastMode()

local function _rndFacePunch()
    return c.LeftFacePunch()
end

local function _do()
    c.RandomUntilMacCanFight()
    if not c.Cap(_rndFacePunch, 48) then return false end
    if not c.Cap(_rndFacePunch, 48) then return false end
    if not c.Cap(_rndFacePunch, 48) then return false end
    if not c.Uppercut() then return false end
    if not c.Uppercut() then return false end
    if not c.Cap(_rndFacePunch, 48) then return false end
    return true
end

while not c.IsDone() do
    local result = c.Cap(_do, 100)
    if result then
        c.Done()
    end
end

c.Finish()
