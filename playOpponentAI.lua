local function couldWin(board, symbol)
    for rowId, row in ipairs(board) do
        for columnId, column in ipairs(row) do
            if column == symbol then
                if row[columnId + 1] then
                    if row[columnId + 2] then
                        if row[columnId + 1] == 0 and row[columnId + 2] == symbol then
                            return rowId, columnId + 1
                        elseif row[columnId + 1] == symbol and row[columnId + 2] == 0 then
                            return rowId, columnId + 2
                        end
                    end
                end
                if board[rowId + 1] and board[rowId + 1][columnId] then
                    if board[rowId + 2] and board[rowId + 2][columnId] then
                        if board[rowId + 1][columnId] == 0 and board[rowId + 2][columnId] == symbol then
                            return rowId + 1, columnId
                        elseif board[rowId + 1][columnId] == symbol and board[rowId + 2][columnId] == 0 then
                            return rowId + 2, columnId
                        end
                    end
                end
                if board[rowId + 1] and board[rowId + 1][columnId + 1] then
                    if board[rowId + 2] and board[rowId +2][columnId + 2] then
                        if board[rowId + 1][columnId + 1] == 0 and board[rowId + 2][columnId + 2] == symbol then
                            return rowId + 1, columnId + 1
                        elseif board[rowId + 1][columnId + 1] == symbol and board[rowId +2][columnId + 2] == 0 then
                            return rowId + 2, columnId + 2
                        end
                    end
                end
                if board[rowId - 1] and board[rowId - 1][columnId + 1] then
                    if board[rowId - 2] and board[rowId - 2][columnId + 2] then
                        if board[rowId - 1][columnId + 1] == 0 and board[rowId - 2][columnId + 2] == symbol then
                            return rowId - 1, columnId + 1
                        elseif board[rowId - 1][columnId + 1] == symbol and board[rowId - 2][columnId + 2] == 0 then
                            return rowId - 2, columnId + 2
                        end
                    end
                end
            end
        end
    end
end

local function playOpponentAI(board, opponentSymbol, playerSymbol)
    local attempts = {opponentSymbol, playerSymbol}
    for _, attempt in ipairs(attempts) do
        local nextMoveX, nextMoveY = couldWin(board, attempt)
        if nextMoveX and nextMoveY then
            return nextMoveX, nextMoveY
        end
    end
    local randomNextMoveX, randomNextMoveY
    repeat
        randomNextMoveX, randomNextMoveY = math.random(3), math.random(3)
    until board[randomNextMoveX][randomNextMoveY] == 0
    return randomNextMoveX, randomNextMoveY
end

return playOpponentAI
