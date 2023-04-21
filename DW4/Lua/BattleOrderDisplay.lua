local c = require("DW4-ManipCore")
while true do
	bo1 = c.ReadBattleOrder1()
	bo2 = c.ReadBattleOrder2()
	bo3 = c.ReadBattleOrder3()
	bo4 = c.ReadBattleOrder4()
	bo5 = c.ReadBattleOrder5()
	bo6 = c.ReadBattleOrder6()
	bo7 = c.ReadBattleOrder7()
	bo8 = c.ReadBattleOrder8()
	gui.text(0, 0,  'BO1 ' .. bo1, nil, 'topright')
	gui.text(0, 16, 'BO2 ' .. bo2, nil, 'topright')
	gui.text(0, 32, 'BO3 ' .. bo3, nil, 'topright')
	gui.text(0, 48, 'BO4 ' .. bo4, nil, 'topright')
	gui.text(0, 64, 'BO5 ' .. bo5, nil, 'topright')
	gui.text(0, 80, 'BO6 ' .. bo6, nil, 'topright')
	gui.text(0, 96, 'BO7 ' .. bo7, nil, 'topright')
	gui.text(0, 112, 'BO8 ' .. bo8, nil, 'topright')
	local taloonFast = bo2 < bo5
	gui.text(0, 128, 'Taloon will go first: ' .. tostring(taloonFast), nil, 'topright')
	emu.frameadvance();
end
