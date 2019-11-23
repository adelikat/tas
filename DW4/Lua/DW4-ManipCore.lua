local M = {}

M.buttonmap = { [1]='P1 Up',[2]='P1 Down',[4]='P1 Left',[8]='P1 Right',[16]='P1 A',[32]='P1 B',[64]='P1 Start',[128]='P1 Select' } 
M.attempts = 0;
M.done = 0;
M.fail = false; -- if true, and done is true it will not savestate
M.maxDelay = 0;
M.reportFrequency = 1;
M.debug = true;
-------------------------------------
-- Private
-------------------------------------
function _isDebug()
	config = client.getconfig()
	return config.SpeedPercent < 800
end

function _doFrame(keys)
	if (keys ~= nil) then
		joypad.set(keys);
	end

	emu.frameadvance();
end

function _rndButtons()
	key1 = {};
	key1['P1 Up'] = _rndBool();
	key1['P1 Down'] = _rndBool();
	key1['P1 Left'] = _rndBool();
	key1['P1 Right'] = _rndBool();
	key1['P1 B'] = _rndBool();
	key1['P1 A'] = _rndBool();
	key1['P1 Select'] = false;
	key1['P1 Start'] = _rndBool();

 	return key1;
end

function _rndAtLeastOne()
	result = _rndButtons();
	if (key1['P1 Up'] == false
		and key1['P1 Down'] == false
		and key1['P1 Left'] == false
		and key1['P1 Right'] == false
		and key1['P1 B'] == false
		and key1['P1 A'] == false
		and key1['P1 Select'] == false
		and key1['P1 Start'] == false
	) then
		key1['P1 A'] = true;
	end

	return result;		
end

function _rndDirection()
	key1 = {};
	key1['P1 Up'] = _rndBool();
	key1['P1 Down'] = _rndBool();
	key1['P1 Left'] = _rndBool();
	key1['P1 Right'] = _rndBool();
	key1['P1 B'] = false;
	key1['P1 A'] = false;
	key1['P1 Select'] = false;
	key1['P1 Start'] = false;

 	return key1;
end

function _rndLeftOrRight()
	key1 = {};
	key1['P1 Up'] = false;
	key1['P1 Down'] = false;
	key1['P1 Left'] = RndBool();
	key1['P1 Right'] = RndBool();
	key1['P1 B'] = false;
	key1['P1 A'] = false;
	key1['P1 Select'] = false;
	key1['P1 Start'] = false;

 	return key1;
end

function _rndWalking(directionButton)
	key1 = _rndDirection();
	key1[directionButton] = true;
	return key1;
end

function _rndDirectionAtLeastOne()
	result = _rndDirection();
	if (key1['P1 Up'] == false
		and key1['P1 Down'] == false
		and key1['P1 Left'] == false
		and key1['P1 Right'] == false
	) then
		key1['P1 A'] = true;
	end

	return result;		
end

function _rndBool()
	x = math.random(0, 1);
	if (x == 1) then
		return true;
	end

	return false;
end

function _push(name)
	key1 = {};	
	key1['P1 Up'] = false;
	key1['P1 Down'] = false;
	key1['P1 Left'] = false;
	key1['P1 Right'] = false;
	key1['P1 B'] = false;
	key1['P1 A'] = false;
	key1['P1 Select'] = false;
	key1['P1 Start'] = false;
	key1[name] = true;
  	return key1;
end

function _pushAorB()
	key1 = {};	
	key1['P1 Up'] = false;
	key1['P1 Down'] = false;
	key1['P1 Left'] = false;
	key1['P1 Right'] = false;
	key1['P1 B'] = false;
	key1['P1 A'] = false;
	key1['P1 Select'] = false;
	key1['P1 Start'] = false;
	
	if (math.random(0, 1) == 0) then
		key1['P1 A'] = true;
	else
		key1['P1 B'] = true;
	end

	return key1;
end

function _rndAorB()
	key1 = {};	
	if (math.random(0, 2) == 0) then
		key1['P1 A'] = true;
	elseif (x == 1) then
		key1['P1 B'] = true;
	else
		key1['P1 A'] = true;
		key1['P1 B'] = true;
	end

	key1['P1 Up'] = _rndBool();
	key1['P1 Down'] = _rndBool();
	key1['P1 Left'] = _rndBool();
	key1['P1 Right'] = _rndBool();
	key1['P1 Select'] = _rndBool();
	key1['P1 Start'] = _rndBool();

	return key1;
end

function _pushLorR()
	key1 = {};	
	key1['P1 Up'] = false;
	key1['P1 Down'] = false;
	key1['P1 Left'] = false;
	key1['P1 Right'] = false;
	key1['P1 B'] = false;
	key1['P1 A'] = false;
	key1['P1 Select'] = false;
	key1['P1 Start'] = false;
	
	x = math.random(0, 1);
	if (x == 1) then
		key1['P1 Left'] = true;
	end

	y = math.random(0, 1);
	if (y == 1 ) then
		key1['P1 Right'] = true;
	end

	return key1;
end

function _toHex(val)
	return "0x" .. string.format("%X", val)
end

function _save(slot)
	if slot == nil then
		error("slot can not be nil")
	end

	slotNum = tonumber(slot)
	if slotNum ~= nill and slotNum >= 0 and slotNum <= 9 then
		savestate.saveslot(slot)
	else
		savestate.save(slot .. '.State')
	end
end

function _load(slot)
	if slot == nil then
		error("slot must be a number")
	end

	slotNum = tonumber(slot)

	if slotNum ~= nil and slotNum >= 0 and slotNum <= 9 then
		savestate.loadslot(tonumber(slot))
	else
		savestate.load(slot .. '.State')
	end
end

-------------------------------------
function InitSession()
	M.attempts = 0
	M.done = false
	M.maxDelay = 0
	math.randomseed(os.time())
	--client.displaymessages(false);
	memory.usememorydomain('System Bus')
	--client.unpause();
end

function Finish()
	console.log('---------------')
	client.displaymessages(true);
	client.pause();

	if (M.fail == false) then
		
		console.log('Success!');
		_save(99)
		_save(9)
	else
		console.log('Aborted.');
	end
end

function Log(msg)
	console.log(msg)
end

function Debug(msg)
	if _isDebug() then
		console.log(msg)
	end
end

function LogProgress(extraInfo, force)
	if (M.attempts % M.reportFrequency == 0 or M.done or force == true) then
		ei = '';
		if (extraInfo ~= nil) then
			ei = extraInfo;
		end
		console.log('attempt: ' .. M.attempts .. ' maxDelay: ' .. M.maxDelay .. ' ' .. ei)
	end
end

function Push(name)
	if (not bizstring.startswith(name, 'P1')) then
		name = 'P1 ' .. name;
	end
	_doFrame(_push(name));
end

function WaitFor(frames)
	if (frames > 0) then
		for i = 0, frames - 1, 1 do
			emu.frameadvance();
		end
	end
end

function DelayUpTo(frames)
	if (frames <= 0) then return 0 end;
	delay = math.random(0, frames);
	if (delay > 0) then
		for i = 0, delay - 1, 1 do
			emu.frameadvance();
		end
	end
	return delay;
end

function RandomFor(frames) -- exclusive
	if (frames > 0) then
		for i = 0, frames - 1, 1 do
			joypad.set(_rndButtons());
			emu.frameadvance();
		end
	end
end

function GenerateRndBool()
	return _rndBool();
end

function GenerateRndDirection()
	x = math.random(0, 3);
	if x == 0 then return 'P1 Left' end
	if x == 1 then return 'P1 Right' end
	if x == 2 then return 'P1 Up' end
	return 'P1 Down'
end

function RndButtons()
	_doFrame(_rndButtons());
end

function RndAtLeastOne()
	_doFrame(_rndAtLeastOne());
end

function RndDirection()
	_doFrame(_rndDirection());
end

function RndLeftOrRight()
	_doFrame(_rndLeftOrRight());
end

function RndWalking(directionButton)
	if (not bizstring.startswith(directionButton, 'P1')) then
		directionButton = 'P1 ' .. directionButton;
	end
	_doFrame(_rndWalking(directionButton));
end

function RndWalkingFor(directionButton, frames)
	if (not bizstring.startswith(directionButton, 'P1')) then
		directionButton = 'P1 ' .. directionButton;
	end
	for i = 0, frames, 1 do
		_doFrame(_rndWalking(directionButton));
	end
end

function RandomDirectionAtLeastOne()
	_doFrame(_rndDirectionAtLeastOne());
	
	return result;		
end

function PushFor(directionButton, frames)
	if (not bizstring.startswith(directionButton, 'P1')) then
		directionButton = 'P1 ' .. directionButton;
	end
	for i = 0, frames, 1 do
		_doFrame(_push(directionButton));
	end
end

function PushButtonsFor(buttons, frames)
	for i = 0, frames, 1 do
		_doFrame(buttons);
	end
end

function PushA()	
	_doFrame(_push('P1 A'));
end

function PushB()
	_doFrame(_push('P1 B'));
end

function PushAorB()
	_doFrame(_pushAorB());
end

function RndAorB()
	_doFrame(_rndAorB());
end

function PushLorR()
	_doFrame(_pushLorR());
end

function PushUp()
	_doFrame(_push('P1 Up'));
end

function PushDown()
	_doFrame(_push('P1 Down'));
end

function PushRight()
	_doFrame(_push('P1 Right'));
end

function PushLeft()
	_doFrame(_push('P1 Left'));
end

function Increment(logInfo)
	M.attempts = M.attempts + 1;
	LogProgress(logInfo);
end

function UntilNextMenu()
	length = 0;
	advance = memory.readbyte(0x0059) ~= 248
	while advance do
		M.WaitFor(1);
		length = length + 1;
		advance = memory.readbyte(0x0059) ~= 248
	end
	return length;
end

function RndDirectionButton()
	local x = math.random(0, 3);
	if (x == 1) then
		return 'P1 Left';
	end

	if (x == 2) then
		return 'P1 Right';
	end
	
	if (x == 3) then
		return 'P1 Down';
	end

	return 'P1 Up';
end

function Read(addr)
	return memory.readbyte(addr)
end

function DebugAddr(addr)
	if (_isDebug()) then
		local val = memory.readbyte(addr)
		console.log('Read ' .. _toHex(addr) .. ' got ' .. val)
	end
end

function Save(slot)
	_save(slot)
end

function Load(slot)
	_load(slot)
end

function Done()
	M.done = true
	M.fail = false
end

function Abort()
	M.done = true
	M.fail = true
end

function PokeRng()
	memory.writebyte(0x0012, math.random(0, 255))
	memory.writebyte(0x0013, math.random(0, 255))
end


function UntilNextInputFrame()
	c.Save("CoreTemp")

	while emu.islagged() == true do
		c.Save("CoreTemp")
		c.WaitFor(1)
	end

	c.Load("CoreTemp")
end

M.UntilNextInputFrame = function ()
	Save("CoreTemp")

	while emu.islagged() == true do
		Save("CoreTemp")
		WaitFor(1)
	end

	Load("CoreTemp")
end

M.PushButtonsFor = PushButtonsFor
M.GenerateRndButtons = _rndButtons
M.GenerateRndDirection = GenerateRndDirection
M.PokeRng = PokeRng;
M.Abort = Abort;
M.Log = Log;
M.DebugAddr = DebugAddr;
M.Done = Done;
M.Read = Read;
M.Save = Save;
M.Load = Load;
M.Debug = Debug
M.RndDirectionButton = RndDirectionButton;
M.Increment = Increment;
M.InitSession = InitSession;
M.Finish = Finish;
M.LogProgress = LogProgress;
M.Push = Push;
M.WaitFor = WaitFor;
M.DelayUpTo = DelayUpTo;
M.GenerateRndBool = GenerateRndBool;
M.RandomFor = RandomFor;
M.RndButtons = RndButtons;
M.RndAtLeastOne = RndAtLeastOne;
M.RndDirection = RndDirection;
M.RndLeftOrRight = RndLeftOrRight;
M.RndWalking = RndWalking;
M.RndWalkingFor = RndWalkingFor;
M.RandomDirectionAtLeastOne = RandomDirectionAtLeastOne;
M.PushFor = PushFor;
M.PushA = PushA;
M.PushB = PushB;
M.PushAorB = PushAorB;
M.RndAorB = RndAorB;
M.PushLorR = PushLorR;
M.PushUp = PushUp;
M.PushDown = PushDown;
M.PushLeft = PushLeft;
M.PushRight = PushRight;
M.UntilNextMenu = UntilNextMenu;

M.Etypes = {};
M.Etypes[0x00] = 'Slime';
M.Etypes[0x01] = 'Kaskos Hopper';
M.Etypes[0x02] = 'Prank Gopher';
M.Etypes[0x03] = 'Stag Beetle';
M.Etypes[0x04] = 'Slime for King Slime';
M.Etypes[0x05] = 'Red Slime';
M.Etypes[0x06] = 'Monjar';
M.Etypes[0x07] = 'Giant Worm';
M.Etypes[0x08] = 'Elerat';
M.Etypes[0x09] = 'Diverat';
M.Etypes[0x0A] = 'Babble';
M.Etypes[0x0B] = 'Troglodyte';
M.Etypes[0x0C] = 'Demon Stump';
M.Etypes[0x0D] = 'Blazeghost';
M.Etypes[0x0E] = 'Minon';
M.Etypes[0x0F] = 'Angel Head';
M.Etypes[0x10] = 'Sizarmage';
M.Etypes[0x11] = 'Demon Toadstool';
M.Etypes[0x12] = 'Chameleon Humanoid';
M.Etypes[0x13] = 'Lethal Gopher';
M.Etypes[0x14] = 'Healer';
M.Etypes[0x15] = 'Poison Arrop';
M.Etypes[0x16] = 'Lava Doll';
M.Etypes[0x17] = 'Elefrover';
M.Etypes[0x18] = 'Rabidhound';
M.Etypes[0x19] = 'Ducksbill';
M.Etypes[0x1A] = 'Carnivore Plant';
M.Etypes[0x1B] = 'Xemime';
M.Etypes[0x1C] = 'Brahmird';
M.Etypes[0x1D] = 'Ozwarg';
M.Etypes[0x1E] = 'Lilypa';
M.Etypes[0x1F] = 'Vampire Bat';
M.Etypes[0x20] = 'Crested Viper';
M.Etypes[0x21] = 'Giant Bantam';
M.Etypes[0x22] = 'Pixie';
M.Etypes[0x23] = 'Infurnus Beetle';
M.Etypes[0x24] = 'Thevro';
M.Etypes[0x25] = 'Orc';
M.Etypes[0x26] = 'Somnabeetle';
M.Etypes[0x27] = 'Magemonja';
M.Etypes[0x28] = 'Sand Master';
M.Etypes[0x29] = 'Giant Eyeball';
M.Etypes[0x2A] = 'Poison Lizard';
M.Etypes[0x2B] = 'Arrop';
M.Etypes[0x2C] = 'Kordra';
M.Etypes[0x2D] = 'Liclick';
M.Etypes[0x2E] = 'Spectet';
M.Etypes[0x2F] = 'Zappersaber';
M.Etypes[0x30] = 'King Slime';
M.Etypes[0x31] = 'Dark Doriard';
M.Etypes[0x32] = 'Viceter';
M.Etypes[0x33] = 'Flythrope';
M.Etypes[0x34] = 'Plesionsaur';
M.Etypes[0x35] = 'Bangler';
M.Etypes[0x36] = 'Grislysaber';
M.Etypes[0x37] = 'Metal Scorpion';
M.Etypes[0x38] = 'Razor Wind';
M.Etypes[0x39] = 'Man O War';
M.Etypes[0x3A] = 'Guzzle Ray';
M.Etypes[0x3B] = 'Runamok Albacore';
M.Etypes[0x3C] = 'Mandrake';
M.Etypes[0x3D] = 'Mad Clown';
M.Etypes[0x3E] = 'Pteranodon';
M.Etypes[0x3F] = 'Sealthrope';
M.Etypes[0x40] = 'Butterfly Dragon';
M.Etypes[0x41] = 'Piranian';
M.Etypes[0x42] = 'Vampdon';
M.Etypes[0x43] = 'Rogue Wisper';
M.Etypes[0x44] = 'Infsnip';
M.Etypes[0x45] = 'Weretiger';
M.Etypes[0x46] = 'Rogue Knight';
M.Etypes[0x47] = 'Mage Toadstool';
M.Etypes[0x48] = 'Skeleton';
M.Etypes[0x49] = 'Infurnus Knight';
M.Etypes[0x4A] = 'Vileplant';
M.Etypes[0x4B] = 'Rabid Roover';
M.Etypes[0x4C] = 'Baby Salamand';
M.Etypes[0x4D] = 'Armor Scorpion';
M.Etypes[0x4E] = 'Garcoil Rooster';
M.Etypes[0x4F] = 'Conjurer';
M.Etypes[0x50] = 'Iceloth';
M.Etypes[0x51] = 'Demonite';
M.Etypes[0x52] = 'Bisonhawk';
M.Etypes[0x53] = 'Batoidei';
M.Etypes[0x54] = 'Giant Octopod';
M.Etypes[0x55] = 'Bisonbear';
M.Etypes[0x56] = 'Ouphnest';
M.Etypes[0x57] = 'Sea Worm';
M.Etypes[0x58] = 'Mystic Doll';
M.Etypes[0x59] = 'Man-Eater chest';
M.Etypes[0x5A] = 'Dragonpup';
M.Etypes[0x5B] = 'Phantom Knight';
M.Etypes[0x5C] = 'Metal Slime';
M.Etypes[0x5D] = 'Lethal Armor';
M.Etypes[0x5E] = 'Curer';
M.Etypes[0x5F] = 'Flamer';
M.Etypes[0x60] = 'Chillanodon';
M.Etypes[0x61] = 'Savnuck';
M.Etypes[0x62] = 'Mimic';
M.Etypes[0x63] = 'Tyranosaur';
M.Etypes[0x64] = 'Phantom Messenger';
M.Etypes[0x65] = 'Mantam';
M.Etypes[0x66] = 'Barrenth';
M.Etypes[0x67] = 'Rhinothrope';
M.Etypes[0x68] = 'Bengal';
M.Etypes[0x69] = 'Sea Lion';
M.Etypes[0x6A] = 'Beleth';
M.Etypes[0x6B] = 'Archbison';
M.Etypes[0x6C] = 'Maelstrom';
M.Etypes[0x6D] = 'Skullknight';
M.Etypes[0x6E] = 'Great ohrus';
M.Etypes[0x6F] = 'Dragonit';
M.Etypes[0x70] = 'Hambalba';
M.Etypes[0x71] = 'Hemasword';
M.Etypes[0x72] = 'Zapangler';
M.Etypes[0x73] = 'Jumbat';
M.Etypes[0x74] = 'Minidemon';
M.Etypes[0x75] = 'Metal Babble';
M.Etypes[0x76] = 'Plesiodon';
M.Etypes[0x77] = 'Tyranobat';
M.Etypes[0x78] = 'Bomb Crag';
M.Etypes[0x79] = 'Raygarth';
M.Etypes[0x7A] = 'Bebanbar';
M.Etypes[0x7B] = 'Leaonar';
M.Etypes[0x7C] = 'Balakooda';
M.Etypes[0x7D] = 'Doolsnake'; 
M.Etypes[0x7E] = 'Rhinoband';
M.Etypes[0x7F] = 'Necrodon';
M.Etypes[0x80] = 'Fury Face';
M.Etypes[0x81] = 'Karon';
M.Etypes[0x82] = 'Maskan';
M.Etypes[0x83] = 'Snow Jive';
M.Etypes[0x84] = 'Necrodain';
M.Etypes[0x85] = 'Blizag';
M.Etypes[0x86] = 'Tentagor';
M.Etypes[0x87] = 'Chaos Hopper';
M.Etypes[0x88] = 'Podokesaur';
M.Etypes[0x89] = 'Eigerhorn';
M.Etypes[0x8A] = 'Ogre';
M.Etypes[0x8B] = 'Red Cyclone';
M.Etypes[0x8C] = 'Dragon Rider';
M.Etypes[0x8D] = 'Ryvern';
M.Etypes[0x8E] = 'Wilymage';
M.Etypes[0x8F] = 'Master Necrodain';
M.Etypes[0x90] = 'Ferocial';
M.Etypes[0x91] = 'Clay Doll';
M.Etypes[0x92] = 'Infernus Sentinel';
M.Etypes[0x93] = 'Green Dragon';
M.Etypes[0x94] = 'Bellzabble';
M.Etypes[0x95] = 'Noctabat';
M.Etypes[0x96] = 'Beastan';
M.Etypes[0x97] = 'King Healer';
M.Etypes[0x98] = 'Leaping Maskan';
M.Etypes[0x99] = 'Impostor';
M.Etypes[0x9A] = 'Pit Viper';
M.Etypes[0x9B] = 'Rhinoking';
M.Etypes[0x9C] = 'Bharack';
M.Etypes[0x9D] = 'Flamadog';
M.Etypes[0x9E] = 'Fairy Dragon';
M.Etypes[0x9F] = 'Demighoul';
M.Etypes[0xA0] = 'Bull Basher';
M.Etypes[0xA1] = 'Red Dragon';
M.Etypes[0xA2] = 'Big Sloth';
M.Etypes[0xA3] = 'Guardian';
M.Etypes[0xA4] = 'Swinger';
M.Etypes[0xA5] = 'Master Malice';
M.Etypes[0xA6] = 'Duke Malisto';
M.Etypes[0xA7] = 'Great Ridon';
M.Etypes[0xA8] = 'King Metal';
M.Etypes[0xA9] = 'Ryvernlord';
M.Etypes[0xAA] = 'Spite Spirit';
M.Etypes[0xAB] = 'Mighty Healer';
M.Etypes[0xAC] = 'Ogrebasher';
M.Etypes[0xAD] = 'Item Shop';
M.Etypes[0xAE] = 'Necrosaro';
M.Etypes[0xAF] = 'Hun';
M.Etypes[0xB0] = 'Roric';
M.Etypes[0xB1] = 'Vivian';
M.Etypes[0xB2] = 'Sampson';
M.Etypes[0xB3] = 'Saro Shadow';
M.Etypes[0xB4] = 'Balzack';
M.Etypes[0xB5] = 'Balzack 2';
M.Etypes[0xB6] = 'Radimvice';
M.Etypes[0xB7] = 'Infurnus Shadow';
M.Etypes[0xB8] = 'Anderoug';
M.Etypes[0xB9] = 'Gigademon';
M.Etypes[0xBA] = 'Linguar';
M.Etypes[0xBB] = 'Keeleon';
M.Etypes[0xBC] = 'Esturk';
M.Etypes[0xBD] = 'Troubadour';
M.Etypes[0xBE] = 'Keeleon';
M.Etypes[0xBF] = 'Lighthouse Bengal';
M.Etypes[0xC0] = 'Tricksy Urchin';
M.Etypes[0xC1] = 'Saroknight';
M.Etypes[0xC2] = 'Bakor';
M.Etypes[0xC3] = 'Hero';
M.Etypes[0xEF] = 'Broken';
M.Etypes[0xF0] = 'Broken';
M.Etypes[0xFD] = 'Sampson Broken';
M.Etypes[0xFD] = 'Linquar-Esturk Broken';
M.Etypes[0xFE] = 'Non Equipped';
M.Etypes[0xFF] = 'None';


M.Items = {};
M.Items[0x00] = 'Cypress Stick';
M.Items[0x01] = 'Club';
M.Items[0x02] = 'Copper Sword';
M.Items[0x03] = 'Iron Claw';
M.Items[0x04] = 'Chain Sickle';
M.Items[0x05] = 'Iron Spear';
M.Items[0x06] = 'Broad Sword';
M.Items[0x07] = 'Battle Axe';
M.Items[0x08] = 'Silver Tarot Cards';
M.Items[0x09] = 'Thorn Whip';
M.Items[0x0A] = 'Morning Star';
M.Items[0x0B] = 'Boomerang';
M.Items[0x0C] = 'Abacus of Virtue';
M.Items[0x0D] = 'Iron Fan';
M.Items[0x0E] = 'Metal Babble Sword';
M.Items[0x0F] = 'Poison Needle';
M.Items[0x10] = 'Staff of Force';
M.Items[0x11] = 'Staff of Thunder';
M.Items[0x12] = 'Demon Hammer';
M.Items[0x13] = 'Multi-edge Sword';
M.Items[0x14] = 'Zenithian Sword';
M.Items[0x15] = 'Dragon Killer';
M.Items[0x16] = 'Stilleto Earrings';
M.Items[0x17] = 'Staff of Punishment';
M.Items[0x18] = 'Sword of Lethargy';
M.Items[0x19] = 'Venomous Dagger';
M.Items[0x1A] = 'Fire Claw';
M.Items[0x1B] = 'Ice Blade';
M.Items[0x1C] = 'Sword of Miracles';
M.Items[0x1D] = 'Staff of Antimagic';
M.Items[0x1E] = 'Magma Staff';
M.Items[0x1F] = 'Sword of Decimation';
M.Items[0x20] = 'Staff of Healing';
M.Items[0x21] = 'Zenithian Sword';
M.Items[0x22] = 'Staff of Jubilation';
M.Items[0x23] = 'Sword of Malice';
M.Items[0x24] = 'Basic Clothes';
M.Items[0x25] = 'Wayfarers Clothes';
M.Items[0x26] = 'Leather Armor';
M.Items[0x27] = 'Chain Mail';
M.Items[0x28] = 'Half Plate Armor';
M.Items[0x29] = 'Iron Apron';
M.Items[0x2A] = 'Full Plate Armor';
M.Items[0x2B] = 'Silk Robe';
M.Items[0x2C] = 'Dancers Costume';
M.Items[0x2D] = 'Bronze Armor';
M.Items[0x2E] = 'Metal Babble Armor';
M.Items[0x2F] = 'Fur Coat';
M.Items[0x30] = 'Leather Dress';
M.Items[0x31] = 'Pink Leotard';
M.Items[0x32] = 'Dragon Mail';
M.Items[0x33] = 'Cloak of Evasion';
M.Items[0x34] = 'Sacred Robe';
M.Items[0x35] = 'Water Flying Clothes';
M.Items[0x36] = 'Mysterious Bolero';
M.Items[0x37] = 'Zenithian Armor';
M.Items[0x38] = 'Swordedge Armor';
M.Items[0x39] = 'Robe of Serenity';
M.Items[0x3A] = 'Zombie Mail';
M.Items[0x3B] = 'Dress of Radiance';
M.Items[0x3C] = 'Demon Armor';
M.Items[0x3D] = 'Leather Shield';
M.Items[0x3E] = 'Scale Shield';
M.Items[0x3F] = 'Iron Shield';
M.Items[0x40] = 'Shield of Strenth';
M.Items[0x41] = 'Mirror Shield';
M.Items[0x42] = 'Aeolus Shield';
M.Items[0x43] = 'Dragon Shield';
M.Items[0x44] = 'Zenithian Shield';
M.Items[0x45] = 'Metal Babble Shield';
M.Items[0x46] = 'Leather Hat';
M.Items[0x47] = 'Wooden Hat';
M.Items[0x48] = 'Iron Helmet';
M.Items[0x49] = 'Iron Mask';
M.Items[0x4A] = 'Feather Hat';
M.Items[0x4B] = 'Zenithian Helm';
M.Items[0x4C] = 'Mask of Corruption';
M.Items[0x4D] = 'Golden Barrette';
M.Items[0x4E] = 'Hat of Happiness';
M.Items[0x4F] = 'Metal Babble Helm';
M.Items[0x50] = 'Meteorite Armband'
M.Items[0x51] = 'Barons Horn'
M.Items[0x53] = 'Medical Herb'
M.Items[0x54] = 'Antidote Herb'
M.Items[0x55] = 'Fairy Water'
M.Items[0x56] = 'Wing of Wryvern'
M.Items[0x57] = 'Leaf of World Tree'
M.Items[0x58] = 'Full Moon Herb'
M.Items[0x59] = 'Wizards Ring'
M.Items[0x5A] = 'Magic Potion'
M.Items[0x5B] = 'Dew of World Tree'
M.Items[0x5C] = 'Flute of Uncovering'
M.Items[0x5E] = 'Shere of Silence'
M.Items[0x5E] = 'Scent Pouch'
M.Items[0x5F] = 'Sandglass of Regression'
M.Items[0x60] = 'Sages Stone'
M.Items[0x61] = 'Strength Seed'
M.Items[0x62] = 'Agility Seed'
M.Items[0x63] = 'Luck Seed'
M.Items[0x64] = 'Lifeforce Nuts'
M.Items[0x65] = 'Mystic Acorns'
M.Items[0x66] = 'Mirror of Ra'
M.Items[0x67] = 'Lamp of Darkness'
M.Items[0x68] = 'Staff of Transform'
M.Items[0x69] = 'Small Medal'
M.Items[0x6A] = 'Stone of Drought'
M.Items[0x6B] = 'Iron Safe'
M.Items[0x6C] = 'Flying Shoes'
M.Items[0x6D] = 'Silver Statuette'
M.Items[0x6E] = 'Treasure Map'
M.Items[0x6F] = 'Symbol of Faith'
M.Items[0x70] = 'Gunpowder Jar'
M.Items[0x71] = 'Thiefs Key'
M.Items[0x72] = 'Magic Key'
M.Items[0x73] = 'Final Key'
M.Items[0x74] = 'Lunch'
M.Items[0x75] = 'Birdsong Nectar'
M.Items[0x76] = 'Golden Bracelet'
M.Items[0x77] = 'Princes Letter'
M.Items[0x78] = 'Royal Scroll'
M.Items[0x79] = 'Gum Pod'
M.Items[0x7A] = 'Boarding Pass'
M.Items[0x7B] = 'Padequia Root'
M.Items[0x7C] = 'Fire of Serenity'
M.Items[0x7D] = 'Gas Canister'
M.Items[0x7E] = 'Padequia Seed'
M.Items[0x7F] = 'Empty'
M.Items[0xFF] = 'Empty';


M.Addr = {};
M.Addr["Rng1"] = 0x0012
M.Addr["Rng2"] = 0x0013
M.Addr["CaveX"] = 0x0044
M.Addr["CaveY"] = 0x0045
M.Addr["BattleFlag"] = 0x008B
M.Addr["Turn"] = 0x0096
M.Addr["Drop"] = 0x00C4
M.Addr["NextStat"] = 0x00FD
M.Addr["MenuPosX"] = 0x03CE
M.Addr["MenuPosY"] = 0x03CF
M.Addr["CristoHP"] = 0x6020
M.Addr["BreyHP"] = 0x607A
M.Addr["RagnarLv"] = 0x60BA
M.Addr["AlenaHP"] = 0x60D4
M.Addr["AlenaLv"] = 0x60D8
M.Addr["AlenaStr"] = 0x60D9
M.Addr["AlenaAg"] = 0x60DA
M.Addr["AlenaVit"] = 0x60DB
M.Addr["AlenaInt"] = 0x60DC
M.Addr["AlenaLuck"] = 0x60DD
M.Addr["AlenaMaxHP"] = 0x60DE
M.Addr["AlenaSlot1"] = 0x60E6
M.Addr["AlenaSlot2"] = 0x60E7
M.Addr["AlenaSlot3"] = 0x60E8
M.Addr["AlenaSlot4"] = 0x60E9
M.Addr["AlenaSlot5"] = 0x60EA
M.Addr["AlenaSlot6"] = 0x60EB
M.Addr["AlenaSlot7"] = 0x60EC
M.Addr["AlenaSlot8"] = 0x60ED
M.Addr["StepCounter"] = 0x62ED
M.Addr["EGroup1Type"] = 0x6E45
M.Addr["EGroup2Type"] = 0x6E46
M.Addr["E1Count"] = 0x6E49
M.Addr["Dmg"] = 0x7361
M.Addr["TaloonHp"] = 0x6098

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

return M