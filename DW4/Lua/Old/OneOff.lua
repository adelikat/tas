local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 2

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _doCrit()
	--c.PushA()
	--c.WaitFor(60)
	c.PushA()
	c.WaitFor(10)

	if c.ReadDmg() < 220 then
		return false
	end
	
	return true
end

local function _doBuildPower()
	c.PushA()
	c.RandomFor(30)
	c.WaitFor(25)
	if c.ReadTurn() == 4 then
		return c.Bail('Taloon did not go first')
	end

	if c.Read(c.Addr.P2Action) ~= c.Actions.BuildingPower then
		return c.Bail('asdf')
	end

	return true
end

local function _doReinforcements()
	c.PushA()
	c.RandomFor(30)
	c.WaitFor(25)
	if c.ReadTurn() == 4 then
		return c.Bail('Taloon did not go first')
	end

	if c.Read(c.Addr.P2Action) ~= c.Actions.Reinforcements then
		return c.Bail('asdf')
	end

	return true
end


c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
	local result = c.FrameSearch(_doCrit, 1000, 200)	
	if c.Success(result) then
		c.Done()
	else
		c.Log('Nothing found')
	end
end

c.Finish()



