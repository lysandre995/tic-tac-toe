local win = function (board, symbol)
    local numberOfZeroes = 0
    for rowId, row in ipairs(board) do
        for columnId, column in ipairs(row) do
            if column == symbol then
                if row[columnId + 1] then
                    if row[columnId + 2] then
                        if row[columnId + 1] == symbol and row[columnId + 2] == symbol then
                            return 0
                        end
                    end
                end
                if board[rowId + 1] and board[rowId + 1][columnId] then
                    if board[rowId + 2] and board[rowId + 2][columnId] then
                        if board[rowId + 1][columnId] == symbol and board[rowId + 2][columnId] == symbol then
                            return 0
                        end
                    end
                end
                if board[rowId + 1] and board[rowId + 1][columnId + 1] then
                    if board[rowId + 2] and board[rowId +2][columnId + 2] then
                        if board[rowId + 1][columnId + 1] == symbol and board[rowId +2][columnId + 2] == symbol then
                            return 0
                        end
                    end
                end
                if board[rowId - 1] and board[rowId - 1][columnId + 1] then
                    if board[rowId - 2] and board[rowId - 2][columnId + 2] then
                        if board[rowId - 1][columnId + 1] == symbol and board[rowId - 2][columnId + 2] == symbol then
                            return 0
                        end
                    end
                end
            else
                if column == 0 then
                    numberOfZeroes = numberOfZeroes + 1
                end
            end
        end
    end
    if numberOfZeroes == 0 then
        return 1
    end
    return 2
end

return win
