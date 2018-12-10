-----------------
-- Settings
-----------------
maxEarlyDelay = 3;
maxDelay = 5; --Max amount of delay to use during delayable moments

-------------------------
attempts = 0;
math.randomseed(os.time());
local buttonmap = { [1]='P1 Up',[2]='P1 Down',[4]='P1 Left',[8]='P1 Right',[16]='P1 A',[32]='P1 B',[64]='P1 Start',[128]='P1 Select' } 

function RndButtons()
	key1 = {};
	key1['P1 Up'] = RndBool();
	key1['P1 Down'] = RndBool();
	key1['P1 Left'] = RndBool();
	key1['P1 Right'] = RndBool();
	key1['P1 B'] = RndBool();
	key1['P1 A'] = RndBool();
	key1['P1 Select'] = false;
	key1['P1 Start'] = RndBool();

 	return key1;
end

function RandAtLeast1()
	result = RndButtons();
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

function RndBool()
	x = math.floor(math.random() + 0.5);
	if (x == 1) then
		return true;
	end

	return false;
end

function Push(name)
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

function DoFrame(keys)
	if (keys ~= nil) then
		joypad.set(keys);
	end

	emu.frameadvance();
end

function DelayUpTo(frames) -- inclusive
	delay = math.floor(math.random(0, frames) + 0.5);
	for i = 0, delay, 1 do
		emu.frameadvance();
	end

	return delay;
end

function RandomFor(frames) -- exclusive
	for i = 0, frames, 1 do
		joypad.set(RndButtons());
		emu.frameadvance();
	end
end

function WaitFor(frames)
	for i = 0, frames, 1 do
		emu.frameadvance();
	end
end

function LogProgress(done, attempts, delay, extraInfo)
	if (attempts % 1 == 0 or done) then
		rng1 = memory.readbyte(0x0012);
		rng2 = memory.readbyte(0x0013);
		console.log('attempt: ' .. attempts .. ' delay: ' .. delay .. ' ' .. ' rng: ' .. rng1 .. ' ' .. rng2 .. extraInfo)
	end
end

client.displaymessages(false);
client.unpause();
memory.usememorydomain('System Bus');
done = false;
originalHP = memory.readbyte(0x60B6);

while not done do
	savestate.loadslot(0);

	--------------------------------------
	-- Loop
	--------------------------------------
	delay = 0

	delay = delay + DelayUpTo(maxEarlyDelay);
	DoFrame(Push('P1 A')); --Advance menu
	RandomFor(7);
	WaitFor(1);

	delay = delay + DelayUpTo(maxEarlyDelay);
	DoFrame(Push('P1 A')); --Advance menu
	RandomFor(6);
	WaitFor(1);
	

	delay = delay + DelayUpTo(maxEarlyDelay);
	DoFrame(Push('P1 A')); --Advance menu
	RandomFor(31);
	WaitFor(1);

	delay = delay + DelayUpTo(maxEarlyDelay);
	DoFrame(Push('P1 A')); --Advance menu - Alena attack
	RandomFor(5);
	WaitFor(1);

	delay = delay + DelayUpTo(maxEarlyDelay);
	DoFrame(Push('P1 A')); --Advance menu - Alena pick Rabidhound A
	RandomFor(15);
	WaitFor(1);

	delay = delay + DelayUpTo(maxEarlyDelay);
	DoFrame(Push('P1 A')); --Advance menu - Cristo attack
	RandomFor(5);
	WaitFor(1);

	delay = delay + DelayUpTo(maxEarlyDelay);
	DoFrame(Push('P1 A')); --Advance menu - Cristo pick Rabidhound A
	attempts = attempts + 1;
	RandomFor(15);
	WaitFor(1);

	delay = delay + DelayUpTo(maxEarlyDelay);
	DoFrame(Push('P1 Down'));
	DoFrame(Push('P1 A')); --Advance menu - Brey pick Spell
	RandomFor(5);
	WaitFor(1);

	DoFrame(Push('P1 A')); --Advance menu - Brey pick Icebolt
	RandomFor(6);
	WaitFor(1);
	DoFrame(Push('P1 Down'));

	delay = delay + DelayUpTo(maxDelay);
	DoFrame(Push('P1 A')); --Advance menu - Brey attack

	RandomFor(38);


	--------------------------------------
	-- Eval
	--------------------------------------
	rhatarget = memory.readbyte(0x7304);
	chmtarget = memory.readbyte(0x7305);
	rhbtarget = memory.readbyte(0x7306);

	battleor1 = memory.readbyte(0x7348);
	battleor2 = memory.readbyte(0x7349);
	battleor3 = memory.readbyte(0x734A);

	done = ((rhatarget == 1 or rhbtarget == 1)
	   --and chmtarget == 1
	   and battleor1 == 117
	   and battleor2 == 2
	   and battleor3 >= 114;
	
	targetsuccess = rhatarget == 1
	   and chmtarget == 1;

	or1success = battleor1 == 117;
	or2success = battleor2 == 2;
	or3success = battleor3 >= 114;

	if (targetsuccess and or1success and or2success and or3success) then
		console.log('done: ' .. tostring(done));
		--info = ' rha: ' .. rhatarget .. ' ' .. ' chm: ' .. chmtarget .. ' rha b: ' .. rhbtarget .. ' o1: ' .. battleor1 .. ' or2: ' .. battleor2 .. ' or3: ' .. battleor3;
		info = '';
		if (targetsuccess) then
			info = info .. ' targetsuccess';
		end

		if (or1success) then
			info = info .. ' or1success ';
		end		

		if (or2success) then
			info = info .. ' or2success ';
		end		

		if (or3success) then
			info = info .. ' or3success ';
		end		

		LogProgress(done, attempts, delay, info);
	end
	
	--------------------------------------
end
console.log('Success!');
client.pause();
client.displaymessages(true);

