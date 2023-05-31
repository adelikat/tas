moves = {
	-- Generic
	[0xFF] = {
		[01] = 'Waiting',
		[02] = 'Hit Uppercut',
		[03] = 'Dodge Upper',
		[04] = 'Ducking',
		[05] = 'Block R. Face',
		[06] = 'Block L. Face',
		[07] = 'Block R. Gut',
		[08] = 'Block L. Gut',
		[13] = 'Hit R. Face',
		[14] = 'Hit L. Face',
		[15] = 'Hit R. Gut',
		[16] = 'Hit L. Gut',
		[17] = 'Stun R. Face',
		[18] = 'Stun L. Face',
		[19] = 'Stun R. Gut',
		[20] = 'Stun L. Gut',
		[21] = 'R. Hook',
		[22] = 'L. Jab',
		[23] = 'R. Uppercut',		
		[24] = 'L. Uppercut',
		[25] = 'Special 1',
		[26] = 'Special 2',
		[27] = 'Special 3',
		[64] = 'Walk To Mac',
	},
	[00] = {
		[25] = 'Taunt'
	},
	[02] = {
		[24] = 'R. Bonzai',
		[25] = 'Bonzai Attack',
		[26] = 'L. Bonzai',
	},
	[03] = {
		[24] = 'Taunt',
	},
	[04] = {
		[23] = 'R. Open Mouth',
		[24] = 'L. Open Mouth',
		[26] = 'Dancing'
	},
	[05] = {
		[25] = 'Tiger Punch',
	},
	[06] = {
		[22] = 'Rolling Jab',
		[25] = 'Bull Charge',
	},
	[07] = {
		[24] = 'R. Bonzai',
		[25] = 'Bonzai Attack',
		[26] = 'L. Bonzai',
		[28] = 'Eye Roll',
		[29] = 'Jiving Upper',
	},
	[08] = { -- Soda Popinski
		[22] = 'R. Jab',
		[26] = 'Dancing',
		[65] = 'Walking To Mac',
	},
	[09] = {
		[22] = 'Rolling Jab',
		[25] = 'Eye Rub',
		[26] = 'Bull Charge'
	},
	[10] = {
		[24] = 'Taunt',
	},
	[11] = { -- Mr. Sandman
		[03] = 'Dodge L.',
		[04] = 'Dodge R.',
		[24] = 'R. Jab',
		[26] = 'Dreamland E',
		[27] = 'Dreamland E',
		[28] = 'L. Hook-Jab',
		[29] = 'Dreamland E',
		[31] = 'Dreamland E',
	},
	[12] = {
		[25] = 'Reg. Spin',
		[26] = 'Super Spin',
		[27] = 'Jiving Upper',
	},
	[13] = { -- Tyson
		[24] = 'R. Hook',
		[25] = 'Eye Blink',
		[26] = 'L. Hook',
		[28] = 'L. Hook',
		[29] = 'L. Uppercut',
		[65] = 'Walking To Mac',
	},
	[19] = {
		[22] = 'Rolling Jab',
		[25] = 'Bull Charge',
	},	
	[20] = {
		[23] = 'R. Open Mouth',
		[24] = 'L. Open Mouth',
		[26] = 'Dancing',
	},
	[21] = {
		[25] = 'Tiger Punch',
	},
	[22] = {
		[24] = 'R. Bonzai',
		[25] = 'Bonzai Attack',
		[26] = 'L. Bonzai',
		[28] = 'Eye Roll',
		[29] = 'Jiving Upper',
	},
	[23] = { -- Soda Popinski
		[22] = 'R. Jab',
		[26] = 'Dancing',
		[65] = 'Walking To Mac',
	},
	[24] = {
		[22] = 'Rolling Jab',
		[25] = 'Eye Rub',
		[26] = 'Bull Charge'
	},
	[25] = {
		[24] = 'Taunt'
	},
	[26] = { -- Mr. Sandman
		[03] = 'Dodge L.',
		[04] = 'Dodge R.',
		[24] = 'R. Jab',
		[26] = 'Dreamland E',
		[27] = 'Dreamland E',
		[28] = 'L. Hook-Jab',
		[29] = 'Dreamland E',
		[31] = 'Dreamland E',
	},
	[28] = { -- Tyson
		[24] = 'R. Hook',
		[25] = 'Eye Blink',
		[26] = 'L. Hook',
		[28] = 'L. Hook',
		[29] = 'L. Uppercut',
		[65] = 'Walking To Mac',
	},	
}
