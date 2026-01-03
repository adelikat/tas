dofile('loz-core.lua')

local function drawEnemy(enemy)
    if enemy.type == 0 then
        return
    end

    local mode = c.GameMode()
    if mode ~= c.GameModes.Normal and mode ~= c.GameModes.Cave then
        return
    end

    p = c.Player();
    x = p.x
    y = p.y
    if enemy.target == 0 then
        x = 240 - p.x
        y = 220   - p.y
    end

    gui.drawLine(enemy.x, enemy.y, x, y, 'red')
end

local function moneyMakingDisplay(val)
    if val == 10 then
        return '-10'
    elseif val == 20 then
        return '+20'
    elseif val == 40 then
        return '-40'
    elseif val == 50 then
        return '+50'
    end
end

local function moneyMakingColor(val)
    if val == 10 or val == 40 then
        return 'red'
    end

    return 'green'
end

local function drawShadowLink()
    if c.GameMode() ~= c.GameModes.Normal then
        return
    end
    p = c.Player();
    x = 240 - p.x
    y = 220   - p.y

    gui.drawRectangle(x, y-6, 16, 16, 'black')
    gui.drawImage('shadow.png', x+2, y-6, 13, 16)
end

while true do
    drawShadowLink()

    drawEnemy(c.Enemy(1))
    drawEnemy(c.Enemy(2))
    drawEnemy(c.Enemy(3))
    drawEnemy(c.Enemy(4))
    drawEnemy(c.Enemy(5))
    drawEnemy(c.Enemy(6))
    drawEnemy(c.Enemy(7))
    drawEnemy(c.Enemy(8))
    drawEnemy(c.Enemy(9))

	emu.frameadvance();
end
