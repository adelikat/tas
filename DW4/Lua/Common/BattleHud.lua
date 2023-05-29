--Starts at the last lag frame after the King's chambers appears after starting the game
dofile('../DW4Core.lua')
c.InitSession()
function __clear()
	gui.clearGraphics()
end
event.onexit(__clear)

local turnNames = {
    [0] = 'P1',
    [1] = 'P2',
    [2] = 'P3',
    [3] = 'P4',
    [4] = 'E1',
    [5] = 'E2',
    [6] = 'E3',
    [7] = 'E4'    
}

local hud = {
    DrawBattleOrder = function()
        bo1 = c.BattleOrder1()
        bo2 = c.BattleOrder2()
        bo3 = c.BattleOrder3()
        bo4 = c.BattleOrder4()

        bo5 = c.BattleOrder5()
        bo6 = c.BattleOrder6()
        bo7 = c.BattleOrder7()
        bo8 = c.BattleOrder8()

        local str = string.format(
            '%s %s %s %s | %s %s %s %s',
            bo1, bo2, bo3, bo4, bo5, bo6, bo7, bo8)

        gui.drawText(256, 0, str, nil, nil, nil, nil, nil, 'right')
    end,
    DrawTurn = function()
        local str = 'Turn: ' .. turnNames[addr.Turn:Read()]
        gui.drawText(256, 12, str, nil, nil, nil, nil, nil, 'right')
    end,
    EnemyActions = function()
        local str = 'E1: ' .. c.E1Action()
        gui.drawText(256, 24, str, nil, nil, nil, nil, nil, 'right')
        local str = 'E2: ' .. c.E2Action()
        gui.drawText(256, 36, str, nil, nil, nil, nil, nil, 'right')
    end
}

while true do
    hud.DrawBattleOrder()
    hud.DrawTurn()
    hud.EnemyActions()
    emu.frameadvance()
end
