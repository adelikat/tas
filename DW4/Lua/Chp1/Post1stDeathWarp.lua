--Starts at the first frame to dimiss the "terrific blow" message from Ragnar's max damage critical, manipulates until Burland appears
dofile('../DW4Core.lua')
c.InitSession()
c.FastMode()
--c.BlackscreenMode()
c.Load(3)

local function _do()
    c.RandomAtLeastOne()

    return true
end

while not c.IsDone() do
    local result = c.Cap(_do, 100)
    if c.Success(result) then
        c.Done()
    end

    c.RngCache:Log()
end
