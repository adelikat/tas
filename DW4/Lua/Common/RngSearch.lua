--Starts at the last lag frame after the King's chambers appears after starting the game
dofile('../DW4Core.lua')
c.InitSession()
c.FastMode()
c.BlackscreenMode()
c.Load(0)

local function _do()
    c.PushA()
    c.WaitFor(30)
    local bo1 = c.BattleOrder1()
    local bo5 = c.BattleOrder5()
    return bo1 < bo5
end

while not c.IsDone() do
    local result = c.RngSearch(_do)
    if not c.Success(result) then
        c.Log('RNG result was found')
    end
    c.Done()
end
