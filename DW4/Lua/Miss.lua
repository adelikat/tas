local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 48

local _wait3 = 0
local _wait2 = 0
local _wait1 = 44

local _hpAddr = c.Addr.HeroHP
local _attack = 76
local _miss = 98

-------------------------
local delay = 0

local function _readBattle()
	return c.Read(c.Addr.BattleFlag)
end

local function _readHp()
	return c.Read(_hpAddr)
end

local function _step(wait)
	if (wait > 0) then
		delay = delay + c.DelayUpTo(c.maxDelay - delay)
		c.RndAtLeastOne()
		c.RandomFor(wait - 2)
		c.WaitFor(2)
	end
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
	delay = 0
	oHp = _readHp()

	_step(_wait3)
	_step(_wait2)
	_step(_wait1)

	
	battle = _readBattle()
	c.RndAtLeastOne()
	c.RandomFor(2)
	c.WaitFor(50) -- Ensure damage is calculated and in memory
	postBattle = _readBattle()
	--------------------------------------
	newHP = _readHp()
	c.Debug('Dmg: ' .. oHp - newHP)
	c.AddToRngCache()
	c.Debug('RNG: ' .. c.RngCacheLength())
	if newHP == oHp
		and battle == _attack
		and postBattle == _miss
	 then
	 	found = true
	 	c.LogProgress('Miss! ' .. ' delay: ' .. delay, true)
	 	c.maxDelay = delay - 1
	 	c.Save(9)
	else
		found = false
	end

	dmg = oHp - newHP
	c.Increment('delay: ' .. delay .. ' dmg: ' .. dmg .. ' newHP: ' .. newHP .. ' action: ' .. battle)

	if (found == true and delay == 0) then
		c.done = true
	end
end

c.Finish()



