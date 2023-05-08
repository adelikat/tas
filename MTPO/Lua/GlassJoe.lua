--Starts anytime during the 'Fight is starting' mode before Glass Joe
--Manipulates the Glass Joe Fight
dofile('MTPO-Core.lua')

c.InitSession()
c.Load(1)

if c.Mode() ~= c.Modes.FightIsStarting then
    error('This script must start while the fight is starting')
end

if c.CurrentOpponent() ~= c.OpponentNames.GlassJoe then
    error('Script only works on Glass Joe!')
end

if c.CurrentRound() ~= 1 then
    error('Scirpt only works on round 1')
end

c.FastMode()
while not c.IsDone() do
    c.RandomUntilMacCanFight()
    
    c.Done()
end

c.Finish()
