local M = {
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

M.UntilNextInputFrame = function ()
	M.Save("CoreTemp")
	local startFrameCount = emu.framecount()

	while emu.islagged() == true do
		M.WaitFor(1)
	end

	local endFrameCount = emu.framecount()
	local targetFrames = endFrameCount - startFrameCount - 1

	M.Load("CoreTemp")
	if targetFrames > 0 then		
		M.WaitFor(targetFrames)
	end
end

--[[
runs a parameterless boolean function until it
returns true or the cap is reached in which it will
return false
]]
M.Cap = function(func, limit)
	local tempFile = 'Cap-'.. emu.framecount()
	M.Save(tempFile)
	local i
	for i = 0, limit do
		M.Increment()
		M.Debug('Cap Attempt: ' .. i)
		result = func()
		if result then
			return true
		else
			M.Load(tempFile)
		end
	end
	
	M.LogProgress('Cap limit reached')
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
M.Best = function(func, tries)
	local noResult = 9999999
	local best = noResult
	local tempFile = 'Best-Start-'.. emu.framecount()
	M.Save(tempFile)
	local i
	for i = 0, tries do
		M.Load(tempFile)
		M.Increment()
		M.Debug('Best Search Attempt: ' .. i)
		result = func()

		if result then
			current = emu.framecount()
			if current < best then
				best = current			
				M.Log('New best found: ' .. best)
				M.Save('Best-End-' .. best)
			end			
		end
	end

	if best == noResult then
		M.LogProgress('Failed to complete a single attempt')
		return 0		
	else
		M.LogProgress('Loading best version: ' .. best)
		M.Load('Best-End-' .. best)
		return best
	end	
end

--[[
runs a parameterless boolean function and delays by
1 frame until it returns true or the limit is reach
in which it will return false
]]
M.FrameSearch = function (func, limit)
	tempFile = 'Search-' .. emu.framecount()
	M.Save(tempFile)
	local fsi
	for fsi = 0, limit do
		M.WaitFor(fsi)
		result = func()
		if result then
			return true
		else
			M.Increment()
			M.Load(tempFile)
		end
	end

	M.LogProgress('Search limit reached')
	return false
end

--[[
Performs a boolean function until it returns true or the cap is reached.
Once the cap is reached, delay frames are progressively added and it is tried
again until cap.  Frames are added until maxFrames is reached
]]
M.ProgressiveSearch = function (func, cap, maxFrames, isLevelUp)
    local tempFile = 'Pg-' .. emu.framecount()
    M.Save(tempFile)
	local psi
    for psi = 0, maxFrames do
        M.Log('Progressive Search with delay ' .. psi)
		if isLevelUp then
			M.DelayUpToForLevels(psi)
		else
			M.WaitFor(psi)
		end
		
        result = M.Cap(func, cap)
        if result then
            return true
        else
			M.Increment()
            M.Load(tempFile)
        end
    end

    M.LogProgress('Progress Search limit reached')
    return false
end

M.PushButtonsFor = function(buttons, frames)
	for i = 0, frames, 1 do
		_doFrame(buttons)
	end
end

M.GenerateRndDirection = function()	
	x = math.random(0, 3)
	if x == 0 then return 'P1 Left' end
	if x == 1 then return 'P1 Right' end
	if x == 2 then return 'P1 Up' end
	return 'P1 Down'
end

M.PokeRng = function()
	memory.writebyte(0x0012, math.random(0, 255))
	memory.writebyte(0x0013, math.random(0, 255))
end

M.PokeRngVal = function(val)
	mainmemory.write_u16_be(0x0012, val)
end

M.Abort = function()
	M.done = true
	M.fail = true
end

M.Log = function(msg)
	console.log(msg)
end

M.DebugAddr = function(addr)
	if (_isDebug()) then
		local val = memory.readbyte(addr)
		console.log('Read ' .. _toHex(addr) .. ' got ' .. val)
	end
end

M.Read = function(addr)
	return memory.readbyte(addr)
end

M.Save = function(slot)
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
		savestate.save(slot .. '.State')
	end
end

M.Load = function(slot)
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
		savestate.load(slot .. '.State')
	end
end

M.Debug = function(msg)
	if _isDebug() then
		console.log(msg)
	end
end

M.RndDirectionButton = function()
	_doFrame(_rndDirection())
end

M.Increment = function()
	M.attempts = M.attempts + 1
	M.LogProgress(logInfo)
end

M.InitSession = function()
	M.attempts = 0
	M.done = false
	M.maxDelay = 0
	math.randomseed(os.time())
	client.displaymessages(false)
	memory.usememorydomain('System Bus')
	--client.unpause()
end

M.Finish = function()
	console.log('---------------')
	client.displaymessages(true)
	client.pause()

	if (M.fail == false) then
		
		console.log('Success!')
		M.Save(99)
		M.Save(9)
	else
		console.log('Aborted.')
	end
end

M.LogProgress = function(extraInfo, force)
	if (M.attempts % M.reportFrequency == 0 or M.done or force == true) then
		ei = ''
		if (extraInfo ~= nil) then
			ei = extraInfo
		end
		console.log('attempt: ' .. M.attempts .. ' maxDelay: ' .. M.maxDelay .. ' ' .. ei)
	end
end

M.Push = function()
	if (not bizstring.startswith(name, 'P1')) then
		name = 'P1 ' .. name
	end
	_doFrame(_push(name))	
end

M.WaitFor = function(frames)
	if (frames > 0) then
		for i = 0, frames - 1, 1 do
			emu.frameadvance()
		end
	end
end

M.DelayUpTo = function(frames)
	if (frames <= 0) then return 0 end
	delay = math.random(0, frames)
	if (delay > 0) then
		for i = 0, delay - 1, 1 do
			emu.frameadvance()
		end
	end
	return delay
end
M.DelayUpToForLevels = function(frames)
	if (frames <= 0) then return 0 end
	delay = math.random(0, frames)
	if (delay > 0) then
		for i = 0, delay - 1, 1 do
			_doFrame(_rndButtonsNoAorB())
			emu.frameadvance()
		end
	end
	return delay
end
M.GenerateRndBool = _rndBool
M.RandomFor = function(frames)	
	if (frames > 0) then
		for i = 0, frames - 1, 1 do
			joypad.set(_rndButtons())
			emu.frameadvance()
		end
	end
end
M.RndButtons = function()
	_doFrame(_rndButtons())
end
M.RndAtLeastOne = function()
	_doFrame(_rndAtLeastOne())
end
M.RndLeftOrRight = function()
	_doFrame(_rndLeftOrRight())
end

M.RndWalking = function(directionButton)
	if (not bizstring.startswith(directionButton, 'P1')) then
		directionButton = 'P1 ' .. directionButton
	end
	_doFrame(_rndWalking(directionButton))
end

M.RndWalkingFor = function(directionButton, frames)
	if (not bizstring.startswith(directionButton, 'P1')) then
		directionButton = 'P1 ' .. directionButton
	end
	for i = 0, frames, 1 do
		_doFrame(_rndWalking(directionButton))
	end
end

M.RandomDirectionAtLeastOne = function()
	_doFrame(_rndDirectionAtLeastOne())
end

M.PushFor = function(directionButton, frames)
	if (not bizstring.startswith(directionButton, 'P1')) then
		directionButton = 'P1 ' .. directionButton
	end
	for i = 0, frames, 1 do
		_doFrame(_push(directionButton))
	end
end

M.PushA = function()
	_doFrame(_push('P1 A'))
end
M.PushB = function()
	_doFrame(_push('P1 B'))
end
M.PushAorB = function()
	_doFrame(_pushAorB())
end
M.RndAorB = function()
	_doFrame(_rndAorB())
end
M.PushLorR = function()
	_doFrame(_pushLorR())
end
M.PushUp = function()
	_doFrame(_push('P1 Up'))
end
M.PushDown = function()
	_doFrame(_push('P1 Down'))
end
M.PushLeft = function()
	_doFrame(_push('P1 Left'))
end
M.PushRight = function()
	_doFrame(_push('P1 Right'))
end

M.UntilNextMenuY = function()
	local origMenu = M.Read(M.Addr.MenuPosY)
	advance = true
	while advance do
		M.WaitFor(1)
		advance = M.Read(M.Addr.MenuPosY) == origMenu
	end
end

M.Bail = function(msg)
	M.Debug(msg)
	return false
end

M.Etypes = {
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

M.Items = {
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

M.Addr = {
	["Rng1"] = 0x0012,
	["Rng2"] = 0x0013,
	["XSquare"] = 0x0044,
	["YSquare"] = 0x0045,
	["BattleFlag"] = 0x008B,
	["Turn"] = 0x0096,
	["Drop"] = 0x00C4,
	["NextStat"] = 0x00FD,
	["MenuPosX"] = 0x03CE,
	["MenuPosY"] = 0x03CF,	
	["CristoHP"] = 0x6020,
	["BreyHP"] = 0x607A,
	["TaloonStr"] = 0x609D,
	["TaloonAg"] = 0x609E,
	["TaloonVit"] = 0x609F,
	["TaloonInt"] = 0x60A0,
	["TaloonLuck"] = 0x60A1,
	["TaloonMaxHP"] = 0x60A3,
	["TaloonLv"] = 0x609C,
	["RagnarLv"] = 0x60BA,
	["AlenaHP"] = 0x60D4,
	["AlenaLv"] = 0x60D8,
	["AlenaStr"] = 0x60D9,
	["AlenaAg"] = 0x60DA,
	["AlenaVit"] = 0x60DB,
	["AlenaInt"] = 0x60DC,
	["AlenaLuck"] = 0x60DD,
	["AlenaMaxHP"] = 0x60DE,
	["AlenaSlot1"] = 0x60E6,
	["AlenaSlot2"] = 0x60E7,
	["AlenaSlot3"] = 0x60E8,
	["AlenaSlot4"] = 0x60E9,
	["AlenaSlot5"] = 0x60EA,
	["AlenaSlot6"] = 0x60EB,
	["AlenaSlot7"] = 0x60EC,
	["AlenaSlot8"] = 0x60ED,
	["StepCounter"] = 0x62ED,
	["EGroup1Type"] = 0x6E45,
	["EGroup2Type"] = 0x6E46,
	["E1Count"] = 0x6E49,
	["E1Hp"] = 0x727E,
	["E2Hp"] = 0x728C,
	["Dmg"] = 0x7361,
	["TaloonHp"] = 0x6098
}

M.ReadE1Hp = function()
	return M.Read(M.Addr.E1Hp)
end

M.ReadE2Hp = function()
	return M.Read(M.Addr.E2Hp)
end

M.ReadRng1 = function()
	return M.Read(M.Addr.Rng1)
end

M.ReadRng2 = function()
	return M.Read(M.Addr.Rng2)
end

M.ReadBattle = function()
	return M.Read(M.Addr.BattleFlag)
end

M.ReadStepCounter = function()
	return M.Read(M.Addr.StepCounter)
end

M.ReadEGroup1Type = function()
	return M.Read(M.Addr.EGroup1Type)
end

M.ReadEGroup2Type = function()
	return M.Read(M.Addr.EGroup2Type)
end

M.ReadE1Count = function()
	return M.Read(M.Addr.E1Count)
end

M.ReadMenuPosY = function()
	return M.Read(M.Addr.MenuPosY)
end

M.ReadTurn = function()
	return M.Read(M.Addr.Turn)
end

M.ReadDmg = function()
	return M.Read(M.Addr.Dmg)
end

M.ReadDrop = function()
	return M.Read(M.Addr.Drop)
end

M.Done = function()
	M.done = true
	M.fail = false
end

function _generateRngCacheKey(r)
	return string.format('%s-%s-%s', r.Rng1, r.Rng2, r.FrameCount)
end

function _generateRngeState()
	return {
        Rng1 = M.ReadRng1(),
        Rng2 = M.ReadRng2(),
        FrameCount= emu.framecount()
    }
end

M.RngCache = {}
-- Adds Current Framecount and Rng to cache if it does not already exists
-- If already exist, this returns false, else true
M.AddToRngCache = function()
	local r = _generateRngeState()
	local key = _generateRngCacheKey(r)
	if M.RngCache[key] == nil then
		M.RngCache[key] = r
		return true
	end

	return false
end

M.RngCacheLength = function()
	local count = 0
	for _ in pairs(M.RngCache) do count = count + 1 end
	return count
end

M.RngCacheClear = function()
	M.RngCache = {}
end

-- Not safe for recording!
-- Takes a function that returns a boolean value and
-- Pokes the RNG incrementally by 1 until the function returns true
-- returns true if an RNG seed is found, else false
M.RngSearch = function(func)
	local tempFile = 'RngSearch-' .. emu.framecount()
    M.Save(tempFile)
	local result = false
	for i = 0, 65535, 1 do
		M.Load(tempFile)
		M.Debug('Attempting rng seed: ' .. i)
		memory.write_u16_be(0x0012, i)
		result = func()
		if result then
			return true
		end
	end

	M.Log('Unable to find an RNG seed')
	return false
end


M.PushUntilX = function(direction, x, max)
    if not max then
        max = 1000 -- avoid a potentially infinite loop
    end

    for i = 0, max, 1 do
        M.PushFor(direction, 1)
        if M.Read(M.Addr.XSquare) == x then
            return true
        end
    end

    return false
end

M.PushUntilY = function(direction, y, max)
    if not max then
        max = 1000 -- avoid a potentially infinite loop
    end

    for i = 0, max, 1 do
        M.PushFor(direction, 1)
        if M.Read(M.Addr.YSquare) == y then
            return true
        end
    end

    return false
end

M.RndUntilY = function(direction, y, max)
    if not max then
        max = 1000 -- avoid a potentially infinite loop
    end

    for i = 0, max, 1 do
        M.PushFor(direction, 1)
        if M.Read(M.Addr.YSquare) == y then
            return true
        end
    end

    return false
end

M.RndUntilX = function(direction, x, max)
    if not max then
        max = 1000 -- avoid a potentially infinite loop
    end

    for i = 0, max, 1 do
        M.RndWalkingFor(direction, 1)
        if M.Read(M.Addr.XSquare) == x then
            return true
        end
    end

    return false
end

M.UseFirstMenuItem = function()
    M.PushDown()
    
    if M.ReadMenuPosY() ~= 17 then
        return M.Bail('Unable to navigate to status')
    end
    M.PushRight()
    if M.ReadMenuPosY() ~= 33 then
        return M.Bail('Unable to navigate to item')
    end
    M.PushA()
    M.WaitFor(3)
    M.UntilNextInputFrame()
    M.PushA() -- Pick first character
    M.WaitFor(2)
    M.UntilNextInputFrame()
    M.PushA() -- Pick first item
    M.WaitFor(3)
    M.UntilNextInputFrame()
    M.PushA() -- Use
    M.WaitFor(2)
    M.UntilNextInputFrame()

    return true
end

return M
