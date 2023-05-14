--For misc testing
dofile('MTPO-Core.lua')
c.Load(0)
c.InitSession()
c.FastMode()

local function _do()
    c.Uppercut()
    return true
end

while not c.IsDone() do
    local result = c.Cap(_do, 100)
    if result then
        c.Done()
    end
end

c.Finish()
