--Starts anytime during the 'Fight is starting' mode before Von Kaiser
--Manipulates the Von Kaiser Fight
dofile('MTPO-Core.lua')

c.InitSession()
c.Load(1)
if c.Mode() ~= c.Modes.FightIsStarting then
    error('This script must start while the fight is starting')
end

if c.CurrentOpponent() ~= c.OpponentNames.VonKaiser then
    error('Script only works on Glass Joe!')
end

if c.CurrentRound() ~= 1 then
    error('Script only works on round 1')
end

c.FastMode()

local function _phase1()
    c.RandomUntilMacCanFight()
    
    return true
end

while not c.IsDone() do
    local result = c.Cap(_phase1, 100)
    if result then
        c.Done()
    end
end

c.Finish()
