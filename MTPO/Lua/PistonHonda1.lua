--Starts at the first frame to press start to advance the 'Time' screen (Great fighting, you won, Time x:xx.xx)
--Manipulates the Piston Honda 1 fight
dofile('MTPO-Core.lua')
c.InitSession()
c.Load(3)

if c.CurrentOpponent() ~= opponents.PistonHonda1 then
    error('Script only works on Piston Honda 1!')
end

if addr.Round:Read() ~= 1 then
    error('Script only works on round 1')
end

c.FastMode()
--c.BlackscreenMode()

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

c.Save(100)
while not c.IsDone() do
    c.Load(100)
    c.PushStart(2)
    c.UntilMode(c.Modes.PreRound)
    c.UntilNextInputFrame()
    c.PushStart(2)
    c.UntilMode(c.Modes.FightIsStarting)    
    local result = c.Cap(_do, 100)
    if result then
        c.Done()
    end
end

c.Finish()
