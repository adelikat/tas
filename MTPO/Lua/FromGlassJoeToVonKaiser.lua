--Starts anytime during the 'Black Screen Between Fights', advances until the Von Kaiser fight is starting
--Manipulates the Glass Joe Fight
dofile('MTPO-Core.lua')

c.InitSession()
if c.Mode() ~= c.Modes.BlackScreenBetweenFights then
    error('This script must start during the black screen between fights')
end

c.FastMode()

local function _do()
    c.UntilMode(c.Modes.PostFightScreen)
    c.WaitFor(2)
    if c.Read(c.Addr.Timer1) == 0 then
        c.Log('Timer has not started yet')
        return false
    end
    while c.Read(c.Addr.Timer1) > 1 do
        c.WaitFor(1)        
    end
    c.PushStart(2)
    c.UntilMode(c.Modes.PreRound)
    c.UntilNextInputFrame()
    c.PushStart(2)
    c.UntilMode(c.Modes.FightIsStarting)
    c.WaitFor(1) -- TO ensure we are in proper mode for next script
    return true
end

while not c.IsDone() do
    local result = c.Cap(_do, 100)
    if result then
        c.Done()
    end
end

c.Finish()
