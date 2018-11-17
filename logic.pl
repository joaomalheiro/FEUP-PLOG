starting_board([
[0,2,0,2,0,2,0,2,0,2],
[3,0,3,0,3,0,3,0,3,0],
[0,2,0,2,0,2,0,2,0,2],
[3,0,3,0,3,0,3,0,3,0],
[0,2,0,2,0,2,0,2,0,2],
[3,0,3,0,3,0,3,0,3,0],
[0,2,0,2,0,2,0,2,0,2],
[3,0,3,0,3,0,3,0,3,0],
[0,2,0,2,0,2,0,2,0,2],
[3,0,3,0,3,0,3,0,3,0]
]) :- !.

% example of a board in a terminal state of the game
final_board([
[0,1,0,1,0,1,0,1,0,1],
[1,0,1,0,1,0,1,0,1,0],
[0,1,0,1,0,1,0,1,0,1],
[1,0,1,0,1,0,1,0,1,0],
[0,1,0,1,0,1,0,1,0,1],
[1,0,1,0,2,0,1,0,1,0],
[0,1,0,1,0,1,0,1,0,1],
[1,0,1,0,1,0,1,0,1,0],
[0,1,0,1,0,3,0,1,0,1],
[1,0,1,0,1,0,1,0,1,0]
]) :- !.

initial_board(board(B, PiecesP1, PiecesP2)) :- starting_board(B), PiecesP1 is 25, PiecesP2 is 25.
initial_player(2) :- !.

initial_state(state(board(B,PiecesP1,PiecesP2), Player)) :-
    initial_board(board(B,PiecesP1,PiecesP2)),
    initial_player(Player).

start(TypeP1, TypeP2,Level) :-
    initial_state(state(board(B,PiecesP1,PiecesP2),Player)),
    display_game(B,PiecesP1,PiecesP2,Player),
    game_loop(state(board(B,PiecesP1,PiecesP2),Player), TypeP1, TypeP2, Level).  


game_loop(state(board(B,PiecesP1,PiecesP2),Player), TypeP1, TypeP2,Level):-
    game_over(board(B,PiecesP1,PiecesP2),Winner),
    Winner is 1,
    printLine,
    write(' BLUE PLAYER WON!'),
    printLine.

game_loop(state(board(B,PiecesP1,PiecesP2),Player), TypeP1, TypeP2,Level):-
    game_over(board(B,PiecesP1,PiecesP2),Winner),
    Winner is 2,
    printLine,
    write(' RED PLAYER WON!'),
    printLine.    

game_loop(state(board(B,PiecesP1,PiecesP2),Player), TypeP1, TypeP2, Level):-
    game_over(board(B,PiecesP1,PiecesP2),Winner),
    (
        Player =:= 1 -> Type is TypeP1;
        Player =:= 2 -> Type is TypeP2
    ),
    update(state(board(B, PiecesP1, PiecesP2),Player), state(board(NewB, NewPiecesP1, NewPiecesP2), NewPlayer), Type, Level) ,
    game_loop(state(board(NewB, NewPiecesP1, NewPiecesP2), NewPlayer),TypeP1, TypeP2, Level).

game_over(board(B,PiecesP1,PiecesP2), Winner):-
    PiecesP1 is 0, Winner is 2.

game_over(board(B,PiecesP1,PiecesP2), Winner):-
   PiecesP2 is 0, Winner is 1.
    
game_over(board(B,PiecesP1,PiecesP2), 0).

ai_medium(state(board(B,PiecesP1,PiecesP2),Player),Move):-
    findall(Value-FromX-FromY-ToX-ToY,(valid_play(B, Player, point(FromX,FromY),point(ToX,ToY)),
    move(move(point(FromX, FromY),point(ToX,ToY)),board(B,PiecesP1,PiecesP2),board(NewBoard,NewPiecesP1,NewPiecesP2),Player),
    change_player(Player,NewPlayer),
    value(state(board(NewBoard,NewPiecesP1,NewPiecesP2),NewPlayer),Value)),ListValues),
    choose_best_move(ListValues, Move,-100,move(0,0,0,0)).

choose_best_move([],BestMove, _CurrBestValue, BestMove).
choose_best_move([ActualValue-FromX-FromY-ToX-ToY|T],BestMove, CurrBestValue, CurrBestMove):-
    ActualValue > CurrBestValue,
    choose_best_move(T,BestMove,ActualValue,move(FromX,FromY,ToX,ToY)).
    
choose_best_move([ActualValue-FromX-FromY-ToX-ToY|T], BestMove, CurrBestValue,CurrBestMove):-
    (ActualValue =:= CurrBestValue,
    generate_random_num(0,1,Num),
    Num =:= 0 -> choose_best_move(T, BestMove, ActualValue,move(FromX,FromY,ToX,ToY))); choose_best_move(T, BestMove, CurrBestValue, CurrBestMove).

value(state(board(Board,PiecesP1,PiecesP2),Player),Value):-
    value_kills(PiecesP1, PiecesP2, Player, Value_kills),
    value_killable(Board, Player, Value_killable),
    Value is Value_kills - Value_killable.

value_kills(PiecesP1, PiecesP2, Player, Value):-
    Player is 1, 
    Value is PiecesP2*(PiecesP2-PiecesP1).

value_kills(PiecesP1, PiecesP2, Player, Value):-  
    Player is 2,
    Value is PiecesP1*(PiecesP1-PiecesP2).

value_killable(Board, Player, Value):-
    findall([FromX,FromY,ToX,ToY],(check_player_piece(Board, Player,point(FromX,FromY)),valid_kill(Board,Player,point(FromX,FromY),point(ToX,ToY))),ListKills),
    length(ListKills, ListSize),
    Value is ListSize.

valid_moves(Board, Player, ListMoves):-
    findall([FromX,FromY,ToX,ToY],valid_play(Board,Player,point(FromX,FromY),point(ToX,ToY)),ListMoves).

valid_play(Board, Player, PFrom, PTo):-
    between_board(PFrom),
    between_board(PTo),
    check_player_piece(Board, Player,PFrom),
    valid_kill(Board, Player,PFrom,PTo);
    valid_engage(Board, Player, PFrom,PTo).

valid_kill(Board, Player, PFrom, PTo):-
    check_destiny_target(Board,Player, PTo),
    is_diagonal(PFrom,PTo),
    empty_spaces(Board,PFrom,PTo).

valid_engage(Board, Player, PFrom, PTo):-
    check_player_piece(Board,Player,PFrom),
    check_destiny_empty(Board,PTo),
    is_diagonal(PFrom,PTo),
    empty_spaces(Board,PFrom,PTo),
    valid_kill(Board,Player,PTo,point(X,Y)).

empty_spaces(Board, point(FromX,FromY), point(ToX,ToY)):-
    DirX is sign(ToX - FromX),
    DirY is sign(ToY - FromY),
    X2 is FromX+DirX,
    Y2 is FromY+DirY,
    empty_spaces_aux(Board, point(X2, Y2), point(ToX,ToY), DirX, DirY).

empty_spaces_aux(_Board, point(X,Y), point(X, Y), _DirX, _DirY).
empty_spaces_aux(Board,point(FromX,FromY), point(ToX,ToY), DirX, DirY):-
    X2 is FromX+DirX,
    Y2 is FromY+DirY,
    get_piece(Board,point(FromX,FromY),Piece),
    is_empty_piece(Piece),
    empty_spaces_aux(Board,point(X2,Y2),point(ToX,ToY),DirX,DirY).

is_empty_piece(Piece):-
    Piece =:= 1.

is_diagonal(point(FromX,FromY), point(ToX,ToY)):-
    abs(ToX - FromX) =:= abs(ToY - FromY).

check_player_piece(Board,Player,point(FromX,FromY)):-
    Player is 1,
    get_piece(Board, point(FromX,FromY), PlayerPiece) , PlayerPiece == 3.

check_player_piece(Board,Player,point(FromX,FromY)):-
    Player is 2,
    get_piece(Board, point(FromX,FromY), PlayerPiece) , PlayerPiece == 2.

check_destiny_empty(Board, point(ToX,ToY)):-
    get_piece(Board,point(ToX,ToY),Piece),
    is_empty_piece(Piece).

check_destiny_target(Board,Player, point(ToX,ToY)):-
        Player is 1,
        (get_piece(Board,point(ToX,ToY), DestinyPiece) , DestinyPiece =:= 2).

check_destiny_target(Board,Player, point(ToX,ToY)):-
        Player is 2,
        (get_piece(Board,point(ToX,ToY), DestinyPiece) , DestinyPiece =:= 3). 

get_piece(Board, point(Row, Column), Value):-
    nth0(Row, Board, HelpRow),
    nth0(Column, HelpRow, Value).

between_board(point(X, Y)):-
        between(0, 9, X) , between(0,9,Y).

choose_move(state(board(B, PiecesP1, PiecesP2),Player), Level, move(point(FromX,FromY),point(ToX,ToY))):-
    Level is 1, ai_easy(B, Player,move(point(FromX,FromY),point(ToX,ToY))).

choose_move(state(board(B, PiecesP1, PiecesP2),Player), Level, move(point(FromX,FromY),point(ToX,ToY))):-
    Level is 2, ai_medium(state(board(B,PiecesP1,PiecesP2),Player),move(FromX,FromY,ToX,ToY)).
    
ai_easy(B, Player, move(point(FromX,FromY),point(ToX,ToY))):-
    valid_moves(B, Player, ListMoves),
    length(ListMoves, _ListSize),
    generate_random_num(0,_ListSize,RandomNum),
    nth0(RandomNum, ListMoves, Movement),
    list_to_move(Movement,move(point(FromX,FromY),point(ToX,ToY))).

list_to_move(A, move(point(FromX,FromY),point(ToX,ToY))):-
    nth0(0,A,FromX),
    nth0(1,A,FromY),
    nth0(2,A,ToX), 
    nth0(3,A,ToY). 
    
generate_random_num(D,U,RandomNum):-
    random(D, U, RandomNum).

update(state(board(B, PiecesP1, PiecesP2),Player), state(board(NewB, NewPiecesP1, NewPiecesP2), NewPlayer), TypePlayer, Level):-
    get_move(state(board(B, PiecesP1, PiecesP2),Player),point(FromX,FromY), point(ToX,ToY),TypePlayer, Level),
    move(move(point(FromX,FromY), point(ToX,ToY)), board(B,PiecesP1,PiecesP2), board(NewB,NewPiecesP1,NewPiecesP2), Player),
    change_player(Player,NewPlayer),
    nl,
    display_game(NewB,NewPiecesP1,NewPiecesP2,NewPlayer). 

get_move(state(board(B, PiecesP1, PiecesP2),Player),point(FromX,FromY), point(ToX,ToY),TypePlayer,Level):-
    TypePlayer is 1,
    choose_move(state(board(B, PiecesP1, PiecesP2),Player), Level, move(point(FromX,FromY),point(ToX,ToY))),
    write('\n Bot made move: '),
    write(point(FromX,FromY)),
    write(' -> '),
    write(point(ToX,ToY)), nl. 

get_move(state(board(B, PiecesP1, PiecesP2),Player),point(FromX,FromY), point(ToX,ToY),TypePlayer,Level):-
    TypePlayer is 0,
    get_user_move(state(board(B, PiecesP1, PiecesP2),Player),point(FromX,FromY), point(ToX,ToY)).       

get_user_move(state(board(B, PiecesP1, PiecesP2),Player),point(FromX,FromY), point(ToX,ToY)):-
    ask_for_move(point(FromX,FromY), point(ToX,ToY)),
    valid_play(B, Player, point(FromX,FromY), point(ToX,ToY));
    (write('\nInvalid move. Try again\n\n'), 
    get_user_move(state(board(B, PiecesP1, PiecesP2),Player),point(FromX,FromY), point(ToX,ToY))).


change_player(Player, NewPlayer):-
    Player is 1, NewPlayer is 2.
    
change_player(Player, NewPlayer):-
    Player is 2, NewPlayer is 1.

move(move(point(FromX, FromY),point(ToX,ToY)),board(B,PiecesP1,PiecesP2),board(NewBoard,NewPiecesP1,NewPiecesP2),Player):-
    get_piece(B,point(FromX, FromY), Piece),
    replace_in_table(B,FromX,FromY,1,TempBoard),
    replace_in_table(TempBoard,ToX,ToY,Piece, NewBoard),
    (
        check_destiny_target(B,Player,point(ToX,ToY)), Player =:= 2 -> (NewPiecesP1 is (PiecesP1-1), NewPiecesP2 is PiecesP2); 
        check_destiny_target(B,Player,point(ToX,ToY)), Player =:= 1 -> (NewPiecesP2 is (PiecesP2-1), NewPiecesP1 is PiecesP1);
        NewPiecesP1 is PiecesP1, NewPiecesP2 is PiecesP2
    ).


same(L1,L2):-
    append(L1,[],L2).        
        
replace_in_line([_|T], 0, V, [V|T]).
replace_in_line([H|T], Y, V, [H|R]) :-
    Y > 0,
    Y1 is Y - 1,
    replace_in_line(T, Y1, V, R).

replace_in_table([H|T], X, Y, V, [U|R]):-
    X is 0,
    replace_in_line(H,Y,V,U),
    same(T,R).
    
replace_in_table([H|T], X, Y, V, [U|R]):-
    same(H,U),
    X1 is X-1,
    replace_in_table(T,X1,Y,V,R).
