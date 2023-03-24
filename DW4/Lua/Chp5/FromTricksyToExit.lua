-- Starts at the first frame to dismiss the x MP points, with Return manipulated
-- Manipulates up the cave exit
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 0

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _upStairs()
    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    c.WalkUp(4)
    c.WalkRight(7)
    c.WaitFor(10)
    c.UntilNextInputFrame()
  
    return true
end

local function _upStairs2()
    c.WalkUp(3)
    c.WalkRight(7)
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

-- Room with Mara and Nara
local function _upStairs3()
    c.WalkDown(11)
    c.BringUpMenu()
    c.PushA()
    c.RandomFor(10)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushB() -- No
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    c.WalkUp(5)
    c.WalkRight(2)
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _downStairs()
    c.WalkLeft()
    c.WalkDown(9)
    c.WalkLeft(3)
    c.WalkDown(6)
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _downStairs2()
    c.WalkLeft(9)
    c.WalkDown(7)
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

-- Down to room with symbol of waith
local function _downStairs3()
    c.WalkLeft()
    c.WalkDown(5)
    c.WalkLeft(4)
    c.WalkDown(4)
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _symbolOfFaithRoom()
    c.WalkDown(8)
    c.WalkLeft(7)
    c.WalkUp(8)
    c.BringUpMenu()
    c.Search()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(2)
    c.DismissDialog()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    c.WalkDown(8)
    c.WalkRight(7)
    c.WalkUp(8)
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

-- After getting Symbol of faith
local function _upStairs4()
    c.WalkUp(5)
    c.WalkRight(5)
    c.WalkUp(4)
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _leaveCave()    
    c.WalkUp(8)
    c.WalkRight(4)
    c.WalkUp(3)
    c.WalkLeft(4)
    c.WalkUp(12)
    c.WalkLeft(9)
    c.WalkDown(4)
    c.WalkLeft(6)
    c.WalkDown(20)
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

c.Load(3)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)
    c.Best(_upStairs, 10)
    c.Best(_upStairs2, 10)
    c.Best(_upStairs3, 10)
    c.Best(_downStairs, 10)
    c.Best(_downStairs2, 10)
    c.Best(_downStairs3, 10)
    c.Best(_symbolOfFaithRoom, 10)
    c.Best(_upStairs4, 10)
    c.Best(_leaveCave, 10)
    c.Done()
end

c.Finish()
