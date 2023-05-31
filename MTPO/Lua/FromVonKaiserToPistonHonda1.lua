--Starts anytime during 'Opponent is knocked down' or before the black scree
--Manipulates the Piston Honda 1 fight
dofile('MTPO-Core.lua')
c.InitSession()
if c.Mode() ~= c.Modes.BlackScreenBetweenFights and
    c.Mode() ~= c.Modes.OpponentKnockedDown
    and c.Mode ~= c.Modes.TKO then
    error('This script must start during the black screen between fights')
end

c.FastMode()

local function _do()
    c.UntilMode(c.Modes.PostFightScreen)
    c.WaitFor(2)
    if addr.Timer1:Read() == 0 then
        c.Log('Timer has not started yet')
        return false
    end
    while addr.Timer1:Read() > 1 do
        c.WaitFor(1)        
    end
    c.PushStart(2)
    c.UntilMode(c.Modes.PreRound)
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushStart(2)
    c.UntilMode(c.Modes.FightIsStarting)
    c.WaitFor(1) -- To ensure we are in proper mode for next script
    return true
end

while not c.IsDone() do
    local result = c.Cap(_do, 100)
    if result then
        c.Done()
    end
end

c.Finish()
