-----------------
-- Settings
-----------------
maxDelay = 2; --Max amount of delay to use during delayable moments
targetStat = 4;
statAddr = 0x00FD;
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

function PushAorB()
	key1 = {};	
	key1['P1 Up'] = false;
	key1['P1 Down'] = false;
	key1['P1 Left'] = false;
	key1['P1 Right'] = false;
	key1['P1 B'] = false;
	key1['P1 A'] = false;
	key1['P1 Select'] = false;
	key1['P1 Start'] = false;
	
	x = math.floor(math.random() + 0.5);
	if (x == 1) then
		key1['P1 A'] = true;
	end
	else
		key1['P1 B'] = true;
	end

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
	if (attempts % 20 == 0 or done) then
		console.log('attempt: ' .. attempts .. ' delay: ' .. delay .. ' ' .. extraInfo)
	end
end


client.unpause();
memory.usememorydomain('System Bus');
done = false;
originalHP = memory.readbyte(0x60B6);

while not done do
	savestate.loadslot(0);

	--------------------------------------
	-- Loop
	--------------------------------------
	delay1 = DelayUpTo(maxDelay);
	DoFrame(RandAtLeast1()); -- Advance "defeated" menu
	RandomFor(331);

	attempts = attempts + 1;

	--------------------------------------
	-- Eval
	--------------------------------------

	amt = memory.readbyte(statAddr);

	if amt == targetStat then
		done = true;
	end

	if (amt == 100) then
		console.log('attempt: ' .. attempts .. 'Uh oh, amt is 100');
	end

	LogProgress(done, attempts, delay1, 'amt: ' .. amt);

	--------------------------------------
end

console.log('Success!');
client.pause();


