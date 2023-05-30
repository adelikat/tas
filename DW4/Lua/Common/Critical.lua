-- Starts from a menu advance.  Assumes that the first menu advance can not include delays because it was used to manipulate a critical or a miss
-- Finds the minimum damage at the minimum dleay frames
-- Manipulates round 2
dofile('../DW4Core.lua')
c.InitSession()
c.FastMode()
c.BlackscreenMode()
c.Load(0)

local _maxDelay = 64
local _minDmg = 57

-- Should account for the max possible input frames during segment
-- Will push random buttons for this many frames
local _expectedInputFrames = {
    [1] = 1,
    [2] = 10,
    [3] = 10
}

local function _step(inputFrames)
    c.RandomAtLeastOne()
    c.RandomFor(inputFrames)
    c.UntilNextInputFrameThenOne()
    c.WaitFor(1)
    
end

local function _evaluate()
    local dmg = addr.Dmg:Read()
    c.Debug(string.format('dmg: %s', dmg))
    return dmg >= _minDmg
end

local delay
local function _do()
    if _expectedInputFrames[1] == nil then error('at step 1 is needed!') end    
    local eif = _expectedInputFrames[2]
    if eif == nil then
        error('step 2 is needed! Otherwise, other algorithms are better')
    end

    -- Expected manipulated action such as critical or miss
    _step(1) 

    delay = c.DelayUpTo(_maxDelay)
    c.Debug(string.format('Pre-step 2 Delaying %s frames', delay))
    _step(eif)

    eif = _expectedInputFrames[3]
    if eif ~= nil then
        delay = c.DelayUpTo(_maxDelay - delay)
        c.Debug(string.format('Pre-step 3 Delaying %s frames', delay))
        _step(eif)
    end

    c.RngCache:Add()
    return _evaluate()
end

c.Save(100)
while not c.IsDone() do
    c.Load(100)
    delay = 0
    local result = c.Cap(_do, 100)
    if c.Success(result) then
        if delay == 0 then
            c.Done()
        else
            c.Log(string.format('Critical found! Delay %s', delay))
            c.Save(string.format('Critical%s-%s', delay, emu.framecount()))
            c.Save(9)
            _maxDelay = delay - 1
        end
    end
    c.Log(string.format('RNG: %s maxDelay: %s', c.RngCache:Length(), _maxDelay))
end