if os.getenv('LOCAL_LUA_DEBUGGER_VSCODE') == '1' then
    require('lldebugger').start()
end

local playOpponentAI = require 'playOpponentAI'
local win = require 'win'

math.randomseed(os.time())

local font = love.graphics.newFont(32)
local distanceFromGrid = 50
local winMessage = nil

local board = {
    {0, 0, 0},
    {0, 0, 0},
    {0, 0, 0}
}

local cursor = {x = 1, y = 1}

local playerSymbol = math.random(1, 2)
local oppositeSymbol = playerSymbol == 1 and 2 or 1
if oppositeSymbol == 1 then
    local opponentMoveX, opponentMoveY = playOpponentAI(board, oppositeSymbol, playerSymbol)
    board[opponentMoveX][opponentMoveY] = oppositeSymbol
end

function love.load()
    love.graphics.setLineWidth(4)
    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    if key == 'escape' then love.event.quit() end
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key) return love.keyboard.keysPressed[key] end

function love.update()
    if not winMessage then
        if love.keyboard.wasPressed('up') then
            if cursor.y > 1 then
                cursor.y = cursor.y - 1
            end
        elseif love.keyboard.wasPressed('down') then
            if cursor.y < 3 then
                cursor.y = cursor.y + 1
            end
        elseif love.keyboard.wasPressed('left') then
            if cursor.x > 1 then
                cursor.x = cursor.x - 1
            end
        elseif love.keyboard.wasPressed('right') then
            if cursor.x < 3 then
                cursor.x = cursor.x + 1
            end
        elseif love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.keyboard.wasPressed('space') then
            if board[cursor.x][cursor.y] == 0 then
                board[cursor.x][cursor.y] = playerSymbol
                local playerWin = win(board, playerSymbol)
                if playerWin == 0 then
                    winMessage = 'Player wins!'
                elseif playerWin == 1 then
                    winMessage = 'Draft'
                end
                if not winMessage then
                    local opponentMoveX, opponentMoveY = playOpponentAI(board, oppositeSymbol, playerSymbol)
                    board[opponentMoveX][opponentMoveY] = oppositeSymbol
                    local opponentWin = win(board, oppositeSymbol)
                    if opponentWin == 0 then
                        winMessage = 'Computer wins!'
                    elseif opponentWin == 1 then
                        winMessage = 'Draft'
                    end
                end
            end
        end
    else
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.keyboard.wasPressed('space') then
            board = {
                {0, 0, 0},
                {0, 0, 0},
                {0, 0, 0}
            }
            winMessage = nil
            cursor = {x = 1, y = 1}

            playerSymbol = math.random(1, 2)
            oppositeSymbol = playerSymbol == 1 and 2 or 1
            if oppositeSymbol == 1 then
                local opponentMoveX, opponentMoveY = playOpponentAI(board, oppositeSymbol, playerSymbol)
                board[opponentMoveX][opponentMoveY] = oppositeSymbol
            end
        end
    end
    love.keyboard.keysPressed = {}
end

function love.draw()
    if not winMessage then
        -- board
        love.graphics.clear(0.41, 0.58, 0.82)
        -- symbols
        for rowId, row in ipairs(board) do
            for columnId, value in ipairs(row) do
                local x = (rowId - 1) * 200
                local y = (columnId - 1) * 200
                if value == 1 then
                    love.graphics.setColor(0.82, 0.28, 0.28)
                    love.graphics.line(x + distanceFromGrid, y + distanceFromGrid, x + (200 - distanceFromGrid), y + (200 - distanceFromGrid))
                    love.graphics.line(x + distanceFromGrid, y + (200 - distanceFromGrid), x + (200 - distanceFromGrid), y + distanceFromGrid)
                elseif value == 2 then
                    love.graphics.setColor(0.35, 0.71, 0.77)
                    love.graphics.circle('line', (rowId - 1) * 200 + 100, (columnId - 1) * 200 + 100, (200 - distanceFromGrid) / 2.2)
                end
            end
        end

        -- cursor
        love.graphics.setColor(0.95, 0.73, 0.37, 0.7)
        love.graphics.rectangle('line', (cursor.x - 1) * 200 + 10, (cursor.y - 1) * 200 + 10, 180, 180, 5)
        love.graphics.print(cursor.x .. ' ' .. cursor.y, 0, 0)

        -- grid
        love.graphics.setColor(1, 1, 1)
        --  horizontal
        love.graphics.line(0, 200, 600, 200)
        love.graphics.line(0, 400, 600, 400)
        -- vertical
        love.graphics.line(200, 0, 200, 600)
        love.graphics.line(400, 0, 400, 600)
    else
        love.graphics.clear(0.99, 0.91, 0.4)
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(winMessage, font, 0, 280, 600, 'center')
        love.graphics.setColor(1, 1, 1)
    end
end
