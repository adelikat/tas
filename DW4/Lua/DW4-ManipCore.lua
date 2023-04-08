local c = {
	buttonmap = { [1]='P1 Up',[2]='P1 Down',[4]='P1 Left',[8]='P1 Right',[16]='P1 A',[32]='P1 B',[64]='P1 Start',[128]='P1 Select' },
	attempts = 0,
	done = false,
	maxDelay = 0,
	reportFrequency = 1,
	debug = true
}

-------------------------------------
-- Private
-------------------------------------
local function _isDebug()
	config = client.getconfig()
	return config.SpeedPercent < 800
end

local function _doFrame(keys)
	if (keys ~= nil) then
		joypad.set(keys)
	end

	emu.frameadvance()
end

local function _rndBool()
	x = math.random(0, 1)
	if (x == 1) then
		return true
	end

	return false
end

local function _rndButtons()
	key1 = {}
	key1['P1 Up'] = _rndBool()
	key1['P1 Down'] = _rndBool()
	key1['P1 Left'] = _rndBool()
	key1['P1 Right'] = _rndBool()
	key1['P1 B'] = _rndBool()
	key1['P1 A'] = _rndBool()
	key1['P1 Select'] = false
	key1['P1 Start'] = _rndBool()

 	return key1
end

local function _rndAtLeastOne()
	result = _rndButtons()
	if (key1['P1 Up'] == false
		and key1['P1 Down'] == false
		and key1['P1 Left'] == false
		and key1['P1 Right'] == false
		and key1['P1 B'] == false
		and key1['P1 A'] == false
		and key1['P1 Select'] == false
		and key1['P1 Start'] == false
	) then
		key1['P1 A'] = true
	end

	return result		
end

local function _rndButtonsLAndR()
	key1 = {}
	key1['P1 Up'] = false
	key1['P1 Down'] = false
	key1['P1 Left'] = _rndBool()
	key1['P1 Right'] = _rndBool()
	key1['P1 B'] = false
	key1['P1 A'] = false
	key1['P1 Select'] = false
	key1['P1 Start'] = false

 	return key1
end

local function _rndButtonsNoAorB()
	key1 = {}
	key1['P1 Up'] = _rndBool()
	key1['P1 Down'] = _rndBool()
	key1['P1 Left'] = _rndBool()
	key1['P1 Right'] = _rndBool()
	key1['P1 B'] = false
	key1['P1 A'] = false
	key1['P1 Select'] = _rndBool()
	key1['P1 Start'] = _rndBool()

 	return key1
end

local function _rndDirection()
	key1 = {}
	key1['P1 Up'] = _rndBool()
	key1['P1 Down'] = _rndBool()
	key1['P1 Left'] = _rndBool()
	key1['P1 Right'] = _rndBool()
	key1['P1 B'] = false
	key1['P1 A'] = false
	key1['P1 Select'] = false
	key1['P1 Start'] = false

 	return key1
end

local function _rndLeftOrRight()
	key1 = {}
	key1['P1 Up'] = false
	key1['P1 Down'] = false
	key1['P1 Left'] = RndBool()
	key1['P1 Right'] = RndBool()
	key1['P1 B'] = false
	key1['P1 A'] = false
	key1['P1 Select'] = false
	key1['P1 Start'] = false

 	return key1
end

local function _rndWalking(directionButton)
	key1 = _rndDirection()
	key1[directionButton] = true
	return key1
end

local function _rndDirectionAtLeastOne()
	result = _rndDirection()
	if (key1['P1 Up'] == false
		and key1['P1 Down'] == false
		and key1['P1 Left'] == false
		and key1['P1 Right'] == false
	) then
		key1['P1 A'] = true
	end

	return result		
end

local function _push(name)
	key1 = {}	
	key1['P1 Up'] = false
	key1['P1 Down'] = false
	key1['P1 Left'] = false
	key1['P1 Right'] = false
	key1['P1 B'] = false
	key1['P1 A'] = false
	key1['P1 Select'] = false
	key1['P1 Start'] = false
	key1[name] = true
  	return key1
end

local function _pushAorB()
	key1 = {}	
	key1['P1 Up'] = false
	key1['P1 Down'] = false
	key1['P1 Left'] = false
	key1['P1 Right'] = false
	key1['P1 B'] = false
	key1['P1 A'] = false
	key1['P1 Select'] = false
	key1['P1 Start'] = false
	
	if (math.random(0, 1) == 0) then
		key1['P1 A'] = true
	else
		key1['P1 B'] = true
	end

	return key1
end

local function _rndAorB()
	key1 = {}	
	if (math.random(0, 2) == 0) then
		key1['P1 A'] = true
	elseif (x == 1) then
		key1['P1 B'] = true
	else
		key1['P1 A'] = true
		key1['P1 B'] = true
	end

	key1['P1 Up'] = _rndBool()
	key1['P1 Down'] = _rndBool()
	key1['P1 Left'] = _rndBool()
	key1['P1 Right'] = _rndBool()
	key1['P1 Select'] = _rndBool()
	key1['P1 Start'] = _rndBool()

	return key1
end

local function _pushLorR()
	key1 = {}	
	key1['P1 Up'] = false
	key1['P1 Down'] = false
	key1['P1 Left'] = false
	key1['P1 Right'] = false
	key1['P1 B'] = false
	key1['P1 A'] = false
	key1['P1 Select'] = false
	key1['P1 Start'] = false
	
	x = math.random(0, 1)
	if (x == 1) then
		key1['P1 Left'] = true
	end

	y = math.random(0, 1)
	if (y == 1 ) then
		key1['P1 Right'] = true
	end

	return key1
end

local function _toHex(val)
	return "0x" .. string.format("%X", val)
end

-- Ensures you will be on the lag frame before the input frame
c.UntilNextInputFrame = function ()
	c.Save("CoreTemp")
	local startFrameCount = emu.framecount()

	while emu.islagged() == true do
		c.WaitFor(1)
	end

	local endFrameCount = emu.framecount()
	local targetFrames = endFrameCount - startFrameCount - 1

	c.Load("CoreTemp")
	if targetFrames > 0 then		
		c.WaitFor(targetFrames)
	end
end

-- Ensures you will be on the lag frame after input
c.UntilNextLagFrame = function ()
	c.Save("CoreTemp")
	local startFrameCount = emu.framecount()

	while emu.islagged() == false do
		c.WaitFor(1)
	end

	local endFrameCount = emu.framecount()
	local targetFrames = endFrameCount - startFrameCount

	c.Load("CoreTemp")
	if targetFrames > 0 then		
		c.WaitFor(targetFrames)
	end
end

--[[
runs a parameterless boolean function until it
returns true or the cap is reached in which it will
return false
]]
c.Cap = function(func, limit)
	local tempFile = 'Cap-'.. emu.framecount()
	c.Save(tempFile)
	local i
	for i = 1, limit do
		c.Increment()
		c.Debug('Cap Attempt: ' .. i)
		result = func()
		if result then
			return true
		else
			c.Load(tempFile)
		end
	end
	
	c.LogProgress('Cap limit reached')
	return false
end

--[[
runs a parameterless bool function and runs it
for the number of tries specified. At the end it will load a
savestate of the best result and return the frame count, only 
successful attempts (where the function returns true) will be 
considered, if 0 is returned it indicated that no successful 
attempt occurred
]]
c.Best = function(func, tries)
	local noResult = 9999999
	local best = noResult
	local tempFile = 'Best-Start-'.. emu.framecount()
	c.Save(tempFile)
	local i
	for i = 1, tries do
		c.Load(tempFile)
		c.Increment()
		c.Debug('Best Search Attempt: ' .. i)
		result = func()

		if result then
			current = emu.framecount()
			if current < best then
				best = current			
				c.Log('New best found: ' .. best)
				c.Save('Best-End-' .. best)
			end			
		end
	end

	if best == noResult then
		c.LogProgress('Failed to complete a single attempt')
		return 0		
	else
		c.LogProgress('Loading best version: ' .. best)
		c.Load('Best-End-' .. best)
		return best
	end	
end

--[[
runs a parameterless boolean function and delays by
1 frame until it returns true or the limit is reach
in which it will return false
]]
c.FrameSearch = function (func, limit)
	tempFile = 'Search-' .. emu.framecount()
	c.Save(tempFile)
	local fsi
	for fsi = 0, limit do
		c.Debug(string.format('Attempting delay %s', fsi))
		c.WaitFor(fsi)
		result = func()
		if result then
			return true
		else
			c.Increment()
			c.Load(tempFile)
		end
	end

	c.LogProgress('Search limit reached')
	return false
end

--[[
Performs a boolean function until it returns true or the cap is reached.
Once the cap is reached, delay frames are progressively added and it is tried
again until cap.  Frames are added until maxFrames is reached
]]
c.ProgressiveSearch = function (func, cap, maxFrames)
    local tempFile = 'Pg-' .. emu.framecount()
    c.Save(tempFile)
	local psi
    for psi = 0, maxFrames do
        c.Log('Progressive Search with delay ' .. psi)
		c.WaitFor(psi)
        result = c.Cap(func, cap)
        if result then
            return true
        else
			c.Increment()
            c.Load(tempFile)
        end
    end

    c.LogProgress('Progress Search limit reached')
    return false
end

local __frames = 0
local __func = nil
local function _progressiveWrapper(func)	
	c.RandomForLevels(__frames)
	return __func()
end

--[[
Performs a boolean function until it returns true or the cap is reached.
Once the cap is reached, delay frames are progressively added and it is tried
again until cap. Delays will happen on each attempt and will push random non-AorB
buttons to increase RNG possibilities
Frames are added until maxFrames is reached
Cap is not a parameter because it will be calculated based on how many delay frames
since possible rng values are so limited
]]
c.ProgressiveSearchForLevels = function (func, maxFrames, multiplier)
	if multipler == nil then
		multipler = 4
	end
	__func = func
    local tempFile = 'Pg-' .. emu.framecount()
    c.Save(tempFile)
	local psi
    for psi = 0, maxFrames do
		local cap = (psi * multipler) + 8
        c.Log('Progressive Search with delay ' .. psi)
		__frames = psi				
        result = c.Cap(_progressiveWrapper, cap)
        if result then
            return true
        else
			c.Increment()
            c.Load(tempFile)
        end
    end

    c.LogProgress('Progress Search limit reached')
    return false
end


c.PushButtonsFor = function(buttons, frames)
	for i = 1, frames, 1 do
		_doFrame(buttons)
	end
end

c.GenerateRndDirection = function()	
	x = math.random(0, 3)
	if x == 0 then return 'P1 Left' end
	if x == 1 then return 'P1 Right' end
	if x == 2 then return 'P1 Up' end
	return 'P1 Down'
end

c.PokeRng = function()
	memory.writebyte(0x0012, math.random(0, 255))
	memory.writebyte(0x0013, math.random(0, 255))
end

c.PokeRngVal = function(val)
	mainmemory.write_u16_be(0x0012, val)
end

c.Abort = function()
	c.done = true
	c.fail = true
end

c.Log = function(msg)
	console.log(msg)
end

c.DebugAddr = function(addr)
	if (_isDebug()) then
		local val = memory.readbyte(addr)
		console.log('Read ' .. _toHex(addr) .. ' got ' .. val)
	end
end

c.Read = function(addr)
	return memory.readbyte(addr)
end

c.Save = function(slot)
	if slot == nil then
		error("slot can not be nil")
	end

	slotNum = tonumber(slot)
	if slotNum == 0 then
		slotNum = 10
	end

	if slotNum ~= nill and slotNum > 0 and slotNum <= 10 then
		savestate.saveslot(slot)
	else
		savestate.save(string.format('state-archive/%s.State', slot))
	end
end

c.Load = function(slot)
	if slot == nil then
		error("slot must be a number")
	end

	slotNum = tonumber(slot)

	if slotNum == 0 then
		slotNum = 10
	end

	if slotNum ~= nil and slotNum > 0 and slotNum <= 10 then
		savestate.loadslot(slotNum)
	else
		savestate.load(string.format('state-archive/%s.State', slot))
	end
end

c.Debug = function(msg)
	if _isDebug() then
		console.log(msg)
	end
end

c.RndDirectionButton = function()
	_doFrame(_rndDirection())
end

c.Increment = function(logInfo)
	c.attempts = c.attempts + 1
	c.LogProgress(logInfo)
end

c.InitSession = function()
	c.attempts = 0
	c.done = false
	c.maxDelay = 0
	math.randomseed(os.time())
	client.displaymessages(false)
	memory.usememorydomain('System Bus')
	--client.unpause()
end

c.Finish = function()
	console.log('---------------')
	client.displaymessages(true)
	client.pause()
	client.speedmode(100)

	if (c.fail == false) then
		
		console.log('Success!')
		c.Save(99)
		c.Save(9)
	else
		console.log('Aborted.')
	end
end

c.LogProgress = function(extraInfo, force)
	if (c.attempts % c.reportFrequency == 0 or c.done or force == true) then
		ei = ''
		if (extraInfo ~= nil) then
			ei = extraInfo
		end
		console.log('attempt: ' .. c.attempts .. ' maxDelay: ' .. c.maxDelay .. ' ' .. ei)
	end
end

c.Push = function()
	if (not bizstring.startswith(name, 'P1')) then
		name = 'P1 ' .. name
	end
	_doFrame(_push(name))	
end

c.WaitFor = function(frames)
	if (frames > 0) then
		for i = 1, frames, 1 do
			emu.frameadvance()
		end
	end
end

c.DelayUpTo = function(frames)
	if (frames <= 0) then return 0 end
	delay = math.random(0, frames)
	if (delay > 0) then
		for i = 1, delay, 1 do
			emu.frameadvance()
		end
	end
	return delay
end
c.DelayUpToForLevels = function(frames)
	if (frames <= 0) then return 0 end
	delay = math.random(0, frames)
	if (delay > 0) then
		for i = 1, delay, 1 do
			_doFrame(_rndButtonsNoAorB())
			emu.frameadvance()
		end
	end
	return delay
end
c.DelayUpToWithLAndR = function(frames)
	if (frames <= 0) then return 0 end
	delay = math.random(0, frames)
	if (delay > 0) then
		for i = 1, delay, 1 do
			_doFrame(_rndButtonsLAndR())
			emu.frameadvance()
		end
	end
	return delay
end
c.GenerateRndBool = _rndBool
c.RandomFor = function(frames)	
	if (frames > 0) then
		for i = 1, frames, 1 do
			joypad.set(_rndButtons())
			emu.frameadvance()
		end
	end
end
c.RandomForLevels = function(frames)	
	if (frames > 0) then
		for i = 1, frames, 1 do
			joypad.set(_rndButtonsNoAorB())
			emu.frameadvance()
		end
	end
end
c.RndButtons = function()
	_doFrame(_rndButtons())
end
c.RndAtLeastOne = function()
	_doFrame(_rndAtLeastOne())
end
c.RndLeftOrRight = function()
	_doFrame(_rndLeftOrRight())
end

c.RndWalking = function(directionButton)
	if (not bizstring.startswith(directionButton, 'P1')) then
		directionButton = 'P1 ' .. directionButton
	end
	_doFrame(_rndWalking(directionButton))
end

c.RndWalkingFor = function(directionButton, frames)
	if (not bizstring.startswith(directionButton, 'P1')) then
		directionButton = 'P1 ' .. directionButton
	end
	for i = 1, frames, 1 do
		_doFrame(_rndWalking(directionButton))
	end
end

c.RandomDirectionAtLeastOne = function()
	_doFrame(_rndDirectionAtLeastOne())
end

c.PushFor = function(directionButton, frames)
	if (not bizstring.startswith(directionButton, 'P1')) then
		directionButton = 'P1 ' .. directionButton
	end
	for i = 1, frames, 1 do
		_doFrame(_push(directionButton))
	end
end

c.PushA = function()
	_doFrame(_push('P1 A'))
end
c.PushB = function()
	_doFrame(_push('P1 B'))
end
c.PushAorB = function()
	_doFrame(_pushAorB())
end
c.RndAorB = function()
	_doFrame(_rndAorB())
end
c.PushLorR = function()
	_doFrame(_pushLorR())
end
c.PushUp = function()
	_doFrame(_push('P1 Up'))
end
c.PushDown = function()
	_doFrame(_push('P1 Down'))
end
c.PushLeft = function()
	_doFrame(_push('P1 Left'))
end
c.PushRight = function()
	_doFrame(_push('P1 Right'))
end

c.UntilNextMenuY = function()
	local origMenu = c.Read(c.Addr.MenuPosY)
	advance = true
	while advance do
		c.WaitFor(1)
		advance = c.Read(c.Addr.MenuPosY) == origMenu
	end
end

c.Bail = function(msg)
	c.Debug(msg)
	return false
end

c.Etypes = {
	[0x00] = 'Slime',
	[0x01] = 'Kaskos Hopper',
	[0x02] = 'Prank Gopher',
	[0x03] = 'Stag Beetle',
	[0x04] = 'Slime for King Slime',
	[0x05] = 'Red Slime',
	[0x06] = 'Monjar',
	[0x07] = 'Giant Worm',
	[0x08] = 'Elerat',
	[0x09] = 'Diverat',
	[0x0A] = 'Babble',
	[0x0B] = 'Troglodyte',
	[0x0C] = 'Demon Stump',
	[0x0D] = 'Blazeghost',
	[0x0E] = 'Minon',
	[0x0F] = 'Angel Head',
	[0x10] = 'Sizarmage',
	[0x11] = 'Demon Toadstool',
	[0x12] = 'Chameleon Humanoid',
	[0x13] = 'Lethal Gopher',
	[0x14] = 'Healer',
	[0x15] = 'Poison Arrop',
	[0x16] = 'Lava Doll',
	[0x17] = 'Elefrover',
	[0x18] = 'Rabidhound',
	[0x19] = 'Ducksbill',
	[0x1A] = 'Carnivore Plant',
	[0x1B] = 'Xemime',
	[0x1C] = 'Brahmird',
	[0x1D] = 'Ozwarg',
	[0x1E] = 'Lilypa',
	[0x1F] = 'Vampire Bat',
	[0x20] = 'Crested Viper',
	[0x21] = 'Giant Bantam',
	[0x22] = 'Pixie',
	[0x23] = 'Infurnus Beetle',
	[0x24] = 'Thevro',
	[0x25] = 'Orc',
	[0x26] = 'Somnabeetle',
	[0x27] = 'Magemonja',
	[0x28] = 'Sand Master',
	[0x29] = 'Giant Eyeball',
	[0x2A] = 'Poison Lizard',
	[0x2B] = 'Arrop',
	[0x2C] = 'Kordra',
	[0x2D] = 'Liclick',
	[0x2E] = 'Spectet',
	[0x2F] = 'Zappersaber',
	[0x30] = 'King Slime',
	[0x31] = 'Dark Doriard',
	[0x32] = 'Viceter',
	[0x33] = 'Flythrope',
	[0x34] = 'Plesionsaur',
	[0x35] = 'Bangler',
	[0x36] = 'Grislysaber',
	[0x37] = 'Metal Scorpion',
	[0x38] = 'Razor Wind',
	[0x39] = 'Man O War',
	[0x3A] = 'Guzzle Ray',
	[0x3B] = 'Runamok Albacore',
	[0x3C] = 'Mandrake',
	[0x3D] = 'Mad Clown',
	[0x3E] = 'Pteranodon',
	[0x3F] = 'Sealthrope',
	[0x40] = 'Butterfly Dragon',
	[0x41] = 'Piranian',
	[0x42] = 'Vampdon',
	[0x43] = 'Rogue Wisper',
	[0x44] = 'Infsnip',
	[0x45] = 'Weretiger',
	[0x46] = 'Rogue Knight',
	[0x47] = 'Mage Toadstool',
	[0x48] = 'Skeleton',
	[0x49] = 'Infurnus Knight',
	[0x4A] = 'Vileplant',
	[0x4B] = 'Rabid Roover',
	[0x4C] = 'Baby Salamand',
	[0x4D] = 'Armor Scorpion',
	[0x4E] = 'Garcoil Rooster',
	[0x4F] = 'Conjurer',
	[0x50] = 'Iceloth',
	[0x51] = 'Demonite',
	[0x52] = 'Bisonhawk',
	[0x53] = 'Batoidei',
	[0x54] = 'Giant Octopod',
	[0x55] = 'Bisonbear',
	[0x56] = 'Ouphnest',
	[0x57] = 'Sea Worm',
	[0x58] = 'Mystic Doll',
	[0x59] = 'Man-Eater chest',
	[0x5A] = 'Dragonpup',
	[0x5B] = 'Phantom Knight',
	[0x5C] = 'Metal Slime',
	[0x5D] = 'Lethal Armor',
	[0x5E] = 'Curer',
	[0x5F] = 'Flamer',
	[0x60] = 'Chillanodon',
	[0x61] = 'Savnuck',
	[0x62] = 'Mimic',
	[0x63] = 'Tyranosaur',
	[0x64] = 'Phantom Messenger',
	[0x65] = 'Mantam',
	[0x66] = 'Barrenth',
	[0x67] = 'Rhinothrope',
	[0x68] = 'Bengal',
	[0x69] = 'Sea Lion',
	[0x6A] = 'Beleth',
	[0x6B] = 'Archbison',
	[0x6C] = 'Maelstrom',
	[0x6D] = 'Skullknight',
	[0x6E] = 'Great ohrus',
	[0x6F] = 'Dragonit',
	[0x70] = 'Hambalba',
	[0x71] = 'Hemasword',
	[0x72] = 'Zapangler',
	[0x73] = 'Jumbat',
	[0x74] = 'Minidemon',
	[0x75] = 'Metal Babble',
	[0x76] = 'Plesiodon',
	[0x77] = 'Tyranobat',
	[0x78] = 'Bomb Crag',
	[0x79] = 'Raygarth',
	[0x7A] = 'Bebanbar',
	[0x7B] = 'Leaonar',
	[0x7C] = 'Balakooda',
	[0x7D] = 'Doolsnake', 
	[0x7E] = 'Rhinoband',
	[0x7F] = 'Necrodon',
	[0x80] = 'Fury Face',
	[0x81] = 'Karon',
	[0x82] = 'Maskan',
	[0x83] = 'Snow Jive',
	[0x84] = 'Necrodain',
	[0x85] = 'Blizag',
	[0x86] = 'Tentagor',
	[0x87] = 'Chaos Hopper',
	[0x88] = 'Podokesaur',
	[0x89] = 'Eigerhorn',
	[0x8A] = 'Ogre',
	[0x8B] = 'Red Cyclone',
	[0x8C] = 'Dragon Rider',
	[0x8D] = 'Ryvern',
	[0x8E] = 'Wilymage',
	[0x8F] = 'Master Necrodain',
	[0x90] = 'Ferocial',
	[0x91] = 'Clay Doll',
	[0x92] = 'Infernus Sentinel',
	[0x93] = 'Green Dragon',
	[0x94] = 'Bellzabble',
	[0x95] = 'Noctabat',
	[0x96] = 'Beastan',
	[0x97] = 'King Healer',
	[0x98] = 'Leaping Maskan',
	[0x99] = 'Impostor',
	[0x9A] = 'Pit Viper',
	[0x9B] = 'Rhinoking',
	[0x9C] = 'Bharack',
	[0x9D] = 'Flamadog',
	[0x9E] = 'Fairy Dragon',
	[0x9F] = 'Demighoul',
	[0xA0] = 'Bull Basher',
	[0xA1] = 'Red Dragon',
	[0xA2] = 'Big Sloth',
	[0xA3] = 'Guardian',
	[0xA4] = 'Swinger',
	[0xA5] = 'Master Malice',
	[0xA6] = 'Duke Malisto',
	[0xA7] = 'Great Ridon',
	[0xA8] = 'King Metal',
	[0xA9] = 'Ryvernlord',
	[0xAA] = 'Spite Spirit',
	[0xAB] = 'Mighty Healer',
	[0xAC] = 'Ogrebasher',
	[0xAD] = 'Item Shop',
	[0xAE] = 'Necrosaro',
	[0xAF] = 'Hun',
	[0xB0] = 'Roric',
	[0xB1] = 'Vivian',
	[0xB2] = 'Sampson',
	[0xB3] = 'Saro Shadow',
	[0xB4] = 'Balzack',
	[0xB5] = 'Balzack 2',
	[0xB6] = 'Radimvice',
	[0xB7] = 'Infurnus Shadow',
	[0xB8] = 'Anderoug',
	[0xB9] = 'Gigademon',
	[0xBA] = 'Linguar',
	[0xBB] = 'Keeleon',
	[0xBC] = 'Esturk',
	[0xBD] = 'Troubadour',
	[0xBE] = 'Keeleon',
	[0xBF] = 'Lighthouse Bengal',
	[0xC0] = 'Tricksy Urchin',
	[0xC1] = 'Saroknight',
	[0xC2] = 'Bakor',
	[0xC3] = 'Hero',
	[0xEF] = 'Broken',
	[0xF0] = 'Broken',
	[0xFD] = 'Sampson Broken',
	[0xFD] = 'Linquar-Esturk Broken',
	[0xFE] = 'Non Equipped',
	[0xFF] = 'None'
}

c.Items = {
	[0x00] = 'Cypress Stick',
	[0x01] = 'Club',
	[0x02] = 'Copper Sword',
	[0x03] = 'Iron Claw',
	[0x04] = 'Chain Sickle',
	[0x05] = 'Iron Spear',
	[0x06] = 'Broad Sword',
	[0x07] = 'Battle Axe',
	[0x08] = 'Silver Tarot Cards',
	[0x09] = 'Thorn Whip',
	[0x0A] = 'Morning Star',
	[0x0B] = 'Boomerang',
	[0x0C] = 'Abacus of Virtue',
	[0x0D] = 'Iron Fan',
	[0x0E] = 'Metal Babble Sword',
	[0x0F] = 'Poison Needle',
	[0x10] = 'Staff of Force',
	[0x11] = 'Staff of Thunder',
	[0x12] = 'Demon Hammer',
	[0x13] = 'Multi-edge Sword',
	[0x14] = 'Zenithian Sword',
	[0x15] = 'Dragon Killer',
	[0x16] = 'Stilleto Earrings',
	[0x17] = 'Staff of Punishment',
	[0x18] = 'Sword of Lethargy',
	[0x19] = 'Venomous Dagger',
	[0x1A] = 'Fire Claw',
	[0x1B] = 'Ice Blade',
	[0x1C] = 'Sword of Miracles',
	[0x1D] = 'Staff of Antimagic',
	[0x1E] = 'Magma Staff',
	[0x1F] = 'Sword of Decimation',
	[0x20] = 'Staff of Healing',
	[0x21] = 'Zenithian Sword',
	[0x22] = 'Staff of Jubilation',
	[0x23] = 'Sword of Malice',
	[0x24] = 'Basic Clothes',
	[0x25] = 'Wayfarers Clothes',
	[0x26] = 'Leather Armor',
	[0x27] = 'Chain Mail',
	[0x28] = 'Half Plate Armor',
	[0x29] = 'Iron Apron',
	[0x2A] = 'Full Plate Armor',
	[0x2B] = 'Silk Robe',
	[0x2C] = 'Dancers Costume',
	[0x2D] = 'Bronze Armor',
	[0x2E] = 'Metal Babble Armor',
	[0x2F] = 'Fur Coat',
	[0x30] = 'Leather Dress',
	[0x31] = 'Pink Leotard',
	[0x32] = 'Dragon Mail',
	[0x33] = 'Cloak of Evasion',
	[0x34] = 'Sacred Robe',
	[0x35] = 'Water Flying Clothes',
	[0x36] = 'Mysterious Bolero',
	[0x37] = 'Zenithian Armor',
	[0x38] = 'Swordedge Armor',
	[0x39] = 'Robe of Serenity',
	[0x3A] = 'Zombie Mail',
	[0x3B] = 'Dress of Radiance',
	[0x3C] = 'Demon Armor',
	[0x3D] = 'Leather Shield',
	[0x3E] = 'Scale Shield',
	[0x3F] = 'Iron Shield',
	[0x40] = 'Shield of Strenth',
	[0x41] = 'Mirror Shield',
	[0x42] = 'Aeolus Shield',
	[0x43] = 'Dragon Shield',
	[0x44] = 'Zenithian Shield',
	[0x45] = 'Metal Babble Shield',
	[0x46] = 'Leather Hat',
	[0x47] = 'Wooden Hat',
	[0x48] = 'Iron Helmet',
	[0x49] = 'Iron Mask',
	[0x4A] = 'Feather Hat',
	[0x4B] = 'Zenithian Helm',
	[0x4C] = 'Mask of Corruption',
	[0x4D] = 'Golden Barrette',
	[0x4E] = 'Hat of Happiness',
	[0x4F] = 'Metal Babble Helm',
	[0x50] = 'Meteorite Armband',
	[0x51] = 'Barons Horn',
	[0x53] = 'Medical Herb',
	[0x54] = 'Antidote Herb',
	[0x55] = 'Fairy Water',
	[0x56] = 'Wing of Wryvern',
	[0x57] = 'Leaf of World Tree',
	[0x58] = 'Full Moon Herb',
	[0x59] = 'Wizards Ring',
	[0x5A] = 'Magic Potion',
	[0x5B] = 'Dew of World Tree',
	[0x5C] = 'Flute of Uncovering',
	[0x5E] = 'Shere of Silence',
	[0x5E] = 'Scent Pouch',
	[0x5F] = 'Sandglass of Regression',
	[0x60] = 'Sages Stone',
	[0x61] = 'Strength Seed',
	[0x62] = 'Agility Seed',
	[0x63] = 'Luck Seed',
	[0x64] = 'Lifeforce Nuts',
	[0x65] = 'Mystic Acorns',
	[0x66] = 'Mirror of Ra',
	[0x67] = 'Lamp of Darkness',
	[0x68] = 'Staff of Transform',
	[0x69] = 'Small Medal',
	[0x6A] = 'Stone of Drought',
	[0x6B] = 'Iron Safe',
	[0x6C] = 'Flying Shoes',
	[0x6D] = 'Silver Statuette',
	[0x6E] = 'Treasure Map',
	[0x6F] = 'Symbol of Faith',
	[0x70] = 'Gunpowder Jar',
	[0x71] = 'Thiefs Key',
	[0x72] = 'Magic Key',
	[0x73] = 'Final Key',
	[0x74] = 'Lunch',
	[0x75] = 'Birdsong Nectar',
	[0x76] = 'Golden Bracelet',
	[0x77] = 'Princes Letter',
	[0x78] = 'Royal Scroll',
	[0x79] = 'Gum Pod',
	[0x7A] = 'Boarding Pass',
	[0x7B] = 'Padequia Root',
	[0x7C] = 'Fire of Serenity',
	[0x7D] = 'Gas Canister',
	[0x7E] = 'Padequia Seed',
	[0x7F] = 'Empty',
	[0xFF] = 'Empty'
}

c.Addr = {
	['Rng1'] = 0x0012,
	['Rng2'] = 0x0013,
	['MoveTimer'] = 0x003E,
	['XSquare'] = 0x0044,
	['YSquare'] = 0x0045,
	['OYSquare'] = 0x007B,
	['OXSquare'] = 0x007C,
	['BattleFlag'] = 0x008B,
	['Turn'] = 0x0096,
	['Drop'] = 0x00C4,
	['NextStat'] = 0x00FD,
	['MenuPosX'] = 0x03CE,
	['MenuPosY'] = 0x03CF,
	['HeroHP']	= 0x6002,
	['HeroStr'] = 0x6007,
	['HeroAg'] = 0x6008,
	['HeroVit'] = 0x6009,
	['HeroInt'] = 0x600A,
	['HeroLuck'] = 0x600B,
	['HeroMaxHp'] = 0x600D,
	['HeroMaxMp'] = 0x600F,
	['CristoHP'] = 0x6020,
	['BreyHP'] = 0x607A,
	['TaloonLv'] = 0x609C,
	['TaloonStr'] = 0x609D,
	['TaloonAg'] = 0x609E,
	['TaloonVit'] = 0x609F,
	['TaloonInt'] = 0x60A0,
	['TaloonLuck'] = 0x60A1,
	['TaloonMaxHP'] = 0x60A3,
	['RagnarHp'] = 0x60B6,
	['RagnarLv'] = 0x60BA,
	['AlenaHP'] = 0x60D4,
	['AlenaLv'] = 0x60D8,
	['AlenaStr'] = 0x60D9,
	['AlenaAg'] = 0x60DA,
	['AlenaVit'] = 0x60DB,
	['AlenaInt'] = 0x60DC,
	['AlenaLuck'] = 0x60DD,
	['AlenaMaxHP'] = 0x60DE,
	['AlenaSlot1'] = 0x60E6,
	['AlenaSlot2'] = 0x60E7,
	['AlenaSlot3'] = 0x60E8,
	['AlenaSlot4'] = 0x60E9,
	['AlenaSlot5'] = 0x60EA,
	['AlenaSlot6'] = 0x60EB,
	['AlenaSlot7'] = 0x60EC,
	['AlenaSlot8'] = 0x60ED,
	['StepCounter'] = 0x62ED,
	['EGroup1Type'] = 0x6E45,
	['EGroup2Type'] = 0x6E46,
	['E1Count'] = 0x6E49,
	
	['TaloonHp'] = 0x6098,
	['NaraHp'] = 0x603E,
	['MaraHp'] = 0x605C,
	['MaraStr'] = 0x6061,
	['MaraAg'] = 0x6062,
	['MaraVit'] = 0x6063,
	['MaraInt'] = 0x6064,
	['MaraLuck'] = 0x6065,
	['MaraMaxHp'] = 0x6067,
	['MaraMaxMp'] = 0x6069,
	['E1Hp'] = 0x727E,
	['E2Hp'] = 0x728C,
	['E3Hp'] = 0x729A,
	['E4Hp'] = 0x72A8,
	['E1Target'] = 0x7304,
	['E2Target'] = 0x7305,
	['E3Target'] = 0x7306,
	['P1Action'] = 0x7324,
	['P2Action'] = 0x7325,
	['P3Action'] = 0x7326,
	['P4Action'] = 0x7327,
	['E1Action'] = 0x7328,
	['E2Action'] = 0x7329,
	['E3Action'] = 0x732A,
	['E4Action'] = 0x732B,
	['BattleOrder1'] = 0x7348,
	['BattleOrder2'] = 0x7349,
	['BattleOrder3'] = 0x734A,
	['BattleOrder4'] = 0x734B,
	['BattleOrder5'] = 0x734C,
	['BattleOrder6'] = 0x734D,
	['BattleOrder7'] = 0x734E,
	['BattleOrder8'] = 0x734F,
	['Dmg'] = 0x7361,
}

c.Actions = {
	['Dazed'] = 61,
	['BuildingPower'] = 62,
	['Attack'] = 67,
	['Shouts'] = 120,
	['Sings'] = 122,
	['AwfulPun'] = 124,
	['Trips'] = 125,
	['StealsTreasure'] = 126,
	['GrabsSand'] = 168,
	['Reinforcements'] = 169,
	['WagsFinger'] = 170,
}

c.ReadE1Hp = function()
	return c.Read(c.Addr.E1Hp)
end

c.ReadE2Hp = function()
	return c.Read(c.Addr.E2Hp)
end

c.ReadRng1 = function()
	return c.Read(c.Addr.Rng1)
end

c.ReadRng2 = function()
	return c.Read(c.Addr.Rng2)
end

c.ReadBattle = function()
	return c.Read(c.Addr.BattleFlag)
end

c.ReadStepCounter = function()
	return c.Read(c.Addr.StepCounter)
end

c.ReadEGroup1Type = function()
	return c.Read(c.Addr.EGroup1Type)
end

c.ReadEGroup2Type = function()
	return c.Read(c.Addr.EGroup2Type)
end

c.ReadE1Count = function()
	return c.Read(c.Addr.E1Count)
end

c.ReadMenuPosY = function()
	return c.Read(c.Addr.MenuPosY)
end

c.ReadTurn = function()
	return c.Read(c.Addr.Turn)
end

c.ReadDmg = function()
	return c.Read(c.Addr.Dmg)
end

c.ReadDrop = function()
	return c.Read(c.Addr.Drop)
end

c.Done = function()
	c.done = true
	c.fail = false
end

function _generateRngCacheKey(r)
	return string.format('%s-%s-%s', r.Rng1, r.Rng2, r.FrameCount)
end

function _generateRngeState()
	return {
        Rng1 = c.ReadRng1(),
        Rng2 = c.ReadRng2(),
        FrameCount= emu.framecount()
    }
end

c.RngCache = {}
-- Adds Current Framecount and Rng to cache if it does not already exists
-- If already exist, this returns false, else true
c.AddToRngCache = function()
	local r = _generateRngeState()
	local key = _generateRngCacheKey(r)
	if c.RngCache[key] == nil then
		c.RngCache[key] = r
		return true
	end

	return false
end

c.RngCacheLength = function()
	local count = 0
	for _ in pairs(c.RngCache) do count = count + 1 end
	return count
end

c.RngCacheClear = function()
	c.RngCache = {}
end

-- Not safe for recording!
-- Takes a function that returns a boolean value and
-- Pokes the RNG incrementally by 1 until the function returns true
-- returns true if an RNG seed is found, else false
c.RngSearch = function(func)
	local tempFile = 'RngSearch-' .. emu.framecount()
    c.Save(tempFile)
	local result = false
	for i = 0, 65535, 1 do
		c.Load(tempFile)
		c.Debug('Attempting rng seed: ' .. i)
		memory.write_u16_be(0x0012, i)
		result = func()
		if result then
			return true
		end
	end

	c.Log('Unable to find an RNG seed')
	return false
end


c.PushUntilX = function(direction, x, max)
	if direction == nil then
		c.Log('direction not specified')
		return false
	end

    if not max then
        max = 1000 -- avoid a potentially infinite loop
    end

    for i = 1, max, 1 do
        c.PushFor(direction, 1)
        if c.Read(c.Addr.XSquare) == x then
            return true
        end
    end

    return false
end

c.PushUntilY = function(direction, y, max)
	if direction == nil then
		c.Log('direction not specified')
		return false
	end

    if not max then
        max = 1000 -- avoid a potentially infinite loop
    end

    for i = 1, max, 1 do
        c.PushFor(direction, 1)
        if c.Read(c.Addr.YSquare) == y then
            return true
        end
    end

    return false
end

c.RndUntilY = function(direction, y, max)
	if direction == nil then
		c.Log('direction not specified')
		return false
	end

    if not max then
        max = 1000 -- avoid a potentially infinite loop
    end

    for i = 1, max, 1 do
        c.RndWalkingFor(direction, 1)
        if c.Read(c.Addr.YSquare) == y then
            return true
        end
    end

    return false
end

-- Note max needs to be half of the expected value
-- Each loop is 2 frames??
c.RndUntilX = function(direction, x, max)
	if direction == nil then
		c.Log('direction not specified')
		return false
	end

    if not max then
        max = 1000 -- avoid a potentially infinite loop
    end

    for i = 1, max, 1 do
        c.RndWalkingFor(direction, 1)
        if c.Read(c.Addr.XSquare) == x then
            return true
        end
    end

    return false
end

c.UseFirstMenuItem = function()
    c.PushDown()
    
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to status')
    end
    c.PushRight()
    if c.ReadMenuPosY() ~= 33 then
        return c.Bail('Unable to navigate to item')
    end
    c.PushA()
    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.PushA() -- Pick first character
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushA() -- Pick first item
    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.PushA() -- Use
    c.WaitFor(2)
    c.UntilNextInputFrame()

    return true
end

c.IsEncounter = function()
	if c.ReadEGroup2Type() ~= 0xFF then
		return true
	end

	-- Special hack because Keeleon value is not cleared after boss fight of Chp 4
	-- Stays until the next encounter in Chp 5, and Keeleon is never a random encounter
	return c.ReadEGroup1Type() ~= 0xFF and c.ReadEGroup1Type() ~= 0xBB
end

c.WalkOneSquare = function(direction, cap)
    if c.Read(c.Addr.MoveTimer) ~= 0 then
        error(string.format('Move timer must be zero to call this method! %s', c.Read(c.Addr.MoveTimer)))
        return false
    end

    if cap == nil or cap <= 0 then
        cap = 100
    end
    
    c.Save('WalkStart')

    local attempts = 0
    while attempts < cap do
		if attempts > 0 then
			c.Load('WalkStart')
		end
        
        c.PushFor(direction, 1)
        if c.Read(c.Addr.MoveTimer) ~= 15 then
            return c.Bail('Move timer did not start on 15')
        end

        c.RandomFor(14)
        c.WaitFor(1)
        if c.IsEncounter() then
            attempts = attempts + 1
        else
			local moveTimer = c.Read(c.Addr.MoveTimer)
			if moveTimer == 1 then
				c.WaitFor(1) -- Accounts for lag during day/night transition
				c.Debug('Lagged, increasing walk by 1 frame')
			end
            return true
        end
    end
    
    c.Debug('Could not avoid encounter')
    return false
end

c.Walk = function(direction, squares)
	if squares == nil then
		squares = 1
	end
    local result
    for i = 1, squares do
        result = c.WalkOneSquare(direction)
        if not result then
            return false
        end
    end

    return true
end

c.WalkUp = function(squares)
    return c.Walk('Up', squares)
end

c.WalkDown = function(squares)
    return c.Walk('Down', squares)
end

c.WalkLeft = function(squares)
    return c.Walk('Left', squares)
end

c.WalkRight = function(squares)
    return c.Walk('Right', squares)
end

c.WalkToCaveTransition = function(direction)
    c.WalkOneSquare(direction)
    c.WaitFor(1)
    if not emu.islagged() then
        return c.Bail('Did not arrive at a transition!')
    end

    c.WaitFor(2)
    c.UntilNextInputFrame() -- Super inefficient on encounters, but encounter happens on exactly the last lag frame
    if c.IsEncounter() then
        return false
    end

    return true
end

c.WalkUpToCaveTransition = function()
    return c.WalkToCaveTransition('Up')
end

c.WalkDownToCaveTransition = function()
    return c.WalkToCaveTransition('Down')
end

c.WalkRightToCaveTransition = function()
    return c.WalkToCaveTransition('Right')
end

c.WalkLeftToCaveTransition = function()
    return c.WalkToCaveTransition('Left')
end

local function _mapDirectionToWalk(directionStr)
    if directionStr == 'Up' then
        return c.WalkUp
    elseif directionStr == 'Down' then
        return c.WalkDown
    elseif directionStr == 'Left' then
        return c.WalkLeft
    elseif directionStr == 'Right' then
        return c.WalkRight
    end

    error('Unknown direction: ' .. tostring(directionStr))
end

c.WalkMap = function(dirTable)
    if dirTable == nil then
        error('Must have a table!')
    end

    local result
    for i = 1, #dirTable do
        for k, v in pairs(dirTable[i]) do
            c.Debug(string.format('walking %s for %s squares', k, v))
            local func = _mapDirectionToWalk(k)
            result = func(v)
            if not result then
                return false
            end
        end
      end

    return true
end

c.Search = function()
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to status')
    end
    c.PushRight()
    if c.ReadMenuPosY() ~= 33 then
        return c.Bail('Unable to navigate to item')
    end
    c.PushDown()
    if c.ReadMenuPosY() ~= 34 then
        return c.Bail('Unable to navigate to tactics')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 35 then
        return c.Bail('Unable to navigate to search')
    end
    c.PushA() -- Pick Search
    c.RandomFor(2) -- Input frame that can be used for RNG
    c.UntilNextInputFrame()
    return true
end

c.Door = function()
	c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to status')
    end
	c.WaitFor(1)
	c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Unable to navigate to equip')
    end
	c.WaitFor(1)
	c.PushDown()
	if c.ReadMenuPosY() ~= 19 then
        return c.Bail('Unable to navigate to door')
    end

	c.PushA() -- Pick Door
	c.RandomFor(2) -- Input frame that can be used for RNG
    c.UntilNextInputFrame()
	return true
end

c.Item = function()
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to status')
    end
    c.PushRight()
    if c.ReadMenuPosY() ~= 33 then
        return c.Bail('Unable to navigate to item')
    end

    return true
end

c.Tactics = function()
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to status')
    end
    c.PushRight()
    if c.ReadMenuPosY() ~= 33 then
        return c.Bail('Unable to navigate to item')
    end
	c.PushDown()
	if c.ReadMenuPosY() ~= 34 then
        return c.Bail('Unable to navigate to tactics')
    end

    return true
end

c.BringUpMenu = function()   
	c.PushA()
    if c.Read(c.Addr.MenuPosY) == 16 then
        error('Menu is already 16, this function will not work')
        return false
    end
    
	advance = true
	while advance do
		c.WaitFor(1)
		advance = c.Read(c.Addr.MenuPosY) ~= 16
	end

    c.UntilNextLagFrame()
    c.UntilNextInputFrame()
    return true
end

c.AorBAdvance = function()
    c.RndAorB()
    c.WaitFor(1)
    c.UntilNextInputFrame()
end

c.DismissDialog = function()
	c.RndAtLeastOne()
	c.WaitFor(1)
    c.UntilNextInputFrame()
end

c.Success = function(val)
	if val == nil then
		return false
	end

	if type(val) == "number" then
		return val > 0
	end

	if type(val) == "boolean" then
		return val
	end

	error('Unsupported type in Success call: ' .. tostring(val))
end

c.ReadBattleOrder1 = function()
    return c.Read(c.Addr.BattleOrder1) & 0xF
end

c.ReadBattleOrder2 = function()
    return c.Read(c.Addr.BattleOrder2) & 0xF
end

c.ReadBattleOrder3 = function()
    return c.Read(c.Addr.BattleOrder3) & 0xF
end

c.ReadBattleOrder4 = function()
    return c.Read(c.Addr.BattleOrder4) & 0xF
end

c.ReadBattleOrder5 = function()
    return c.Read(c.Addr.BattleOrder5) & 0xF
end

c.ReadBattleOrder6 = function()
    return c.Read(c.Addr.BattleOrder6) & 0xF
end

c.ReadBattleOrder7 = function()
    return c.Read(c.Addr.BattleOrder7) & 0xF
end

c.ReadBattleOrder8 = function()
    return c.Read(c.Addr.BattleOrder8) & 0xF
end

c.HeroCastReturn = function()
    c.PushRight()
    if c.ReadMenuPosY() ~= 32 then
        return c.Bail('Could not navigate to spell')
    end
    c.PushA()
    if c.Read(0x0644) ~= 0xFF then
        return c.Bail('Could not pick spell')
    end
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.PushA()
    if c.Read(0x0644) ~= 0xFF then
        return c.Bail('Could not pick A')
    end
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.PushA()
    if c.Read(0x0644) ~= 0xFF then
        return c.Bail('Could not pick A')
    end
    c.WaitFor(5)
    c.UntilNextInputFrame()
	return true
end

c.HeroCastOutside = function()
    c.PushRight()
    if c.ReadMenuPosY() ~= 32 then
        return c.Bail('Could not navigate to spell')
    end
    c.PushA()
    if c.Read(0x0644) ~= 0xFF then
        return c.Bail('Could not pick spell')
    end
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.PushA()
    if c.Read(0x0644) ~= 0xFF then
        return c.Bail('Could not pick A')
    end
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Could not navigate to Healmore')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Could not navigate to Repel')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then
        return c.Bail('Could not navigate to Outside')
    end
    c.PushA()
    if c.Read(0x0644) ~= 0xFF then
        return c.Bail('Could not pick Return')
    end
    c.RandomFor(5)
    c.UntilNextInputFrame()
	return true
end

c.PushAWithCheck = function()
	c.PushA()
    if c.Read(0x0644) ~= 0xFF then
        return c.Bail('Pressing A did not pick something')
    end
	return true
end

-- Manipulates the 15 frame delay before you can start walking
c.ChargeUpWalking = function()
	c.PushA()
	c.RandomFor(13)
	c.WaitFor(1)
end

return c
