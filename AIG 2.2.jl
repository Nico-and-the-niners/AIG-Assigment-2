#-------------------------------------------------------------------------------------------------------------------------------

cache = Dict()

function wipe_cache()
    cache = Dict()
end
    

function possible_moves(board)
    N, _ = size(board)
    out = []
    for i=1:N
        for j=1:N
            if board[i,j] == 0
                out = vcat(out,[(i,j)])
            end
        end
    end
    out
end

function findmax_index(a)
    findmax(a)[2]
end

function findmin_index(a)
    findmin(a)[2]
end


function minmax(board, player)
func = (player == 1) ? findmax_index : findmin_index
# this needs to return the utility 
# and also the best move
if haskey(cache, string(board))
cache[string(board)]
else
child_player = -1 * player
if state(board) == :continue_game
children = []
for next_move=possible_moves(board)
child_board = move(board, player, next_move)
util, _ = minmax(child_board, child_player)
children = vcat(children, [(util, next_move)])
end
util, chosen_move = children[func([c[1] for c=children])]
cache[string(board)] = util, chosen_move
util, chosen_move
else
cache[string(board)] = state(board), nothing
end
end
end

#-------------------------------------------------------------------------------------------------------------------------------

function drawboard(N)
    #  board of size N x N
    rows = [Char(x+48) for x=1:N]
    columns = [x for x='A':'Z'][1:N]
    return zeros(Int, N, N), rows, columns
end
function move(board, player, position)
    b = copy(board)
    i, j = position
    if b[i,j] != 0
        :invalid_move
    else
        b[i,j] = player
        b
    end
end
function state(board)
    N, _ = size(board)
    # for rows and columns
    for i=1:N
        if sum(board[i,:]) == N || sum(board[:,i]) == N
            return 1
        elseif sum(board[i,:]) == -N || sum(board[:,i]) == -N
            return -1
        end
    end
    # cheching diagonals
    if sum(diag(board,0)) == N || sum(diag(rotl90(board),0)) == N
        return 1
    elseif sum(diag(board,0)) == -N || sum(diag(rotl90(board),0)) == -N
        return -1
    elseif ~any(x -> x==0, board)
        return 0
    end
    # game o
    return :continue_game
end

function board_to_string(board, rows, columns)
    function row_to_string(row, fun)
        local out = ""
        for i=row
            out = string(out, "\t", fun(i))
        end
        out
    end

    width, height = size(board)
    out = string("\t", row_to_string([x for x=columns], string), "\n")
    for j=1:height # use this rather than 'rows' as we need an integer 
        row_seq = [x for x=board[j,:]]
        row_string = row_to_string(row_seq, player_to_mark)
        out = string(out, string(j), "\t", row_string, "\n")
    end
    out
end
function player_to_mark(x)
    if x == -1
        out = "O"
    elseif x == 1
        out = "X"
    else
        out = " "
    end
    out
end

function parse_input(input, rows, columns)
    if length(input) == 2
		col = findfirst(x -> x == input[1], columns)
        row = findfirst(x -> x == input[2], rows)
        if (col > 0) && (row > 0)
            return (row, col)
        else
            :invald_input
        end
    elseif input == "END"
        return :end
    else
        :invalid_input
    end
end

function get_player_status(player)
    player_string = (player == 1) ? "X" : "O"
    println("Player $player_string: Human or AI?")
		input = readline(stdin)
    if input == "Human"
        :human
    elseif input == "AI"
        :computer
    else
        println("Type 'Human' for Human or 'AI' for AI")
        get_player_status(player)
    end
end


function maingame()
    # setup game and first player
    board, rows, columns = drawboard(3)
    player = 1
    # get player status Human or Computer
    players = [1, -1]
    player_type = Dict()
    for p=players
        player_type[p] = get_player_status(p)
    end
    # main game loop
    while state(board) == :continue_game
        println(board_to_string(board, rows, columns))
        if player_type[player] == :human
            println("Enter your move:")
            input = readline(stdin)
            command = parse_input(input, rows, columns)
            if command == :end
                break
            elseif command == :invalid_input
                println("Invalid input")
            else
                new_board = move(board, player, command)
                if new_board == :invalid_move
                    println("Invalid move")
                else
                    board = new_board
                    player *= -1
                end
            end
        else
            ai_util, ai_move = minmax(board, player)
            board = move(board, player, ai_move)
            player *= -1
        end
    end
    if state(board) == 1
        println(board_to_string(board, rows, columns))
        println(string("PLAYER A (Xs) Winner!"))
    elseif state(board) == -1
        println(board_to_string(board, rows, columns))
        println(string("PLAYER B (Os) Winner!"))
    elseif state(board) == 0
        println(board_to_string(board, rows, columns))
        println("Draw")
    else
        println("Game stopped")
    end
end

    println("***************Welcome to the Tic Toc Game*************?")
println("")
maingame()




