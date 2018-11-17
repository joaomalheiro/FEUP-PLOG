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


game_loop(state(board(B,PiecesP1,PiecesP2), _Player), _TypeP1, _TypeP2,_Level):-
    game_over(board(B,PiecesP1,PiecesP2),Winner),
    Winner is 1,
    printLine,
    write(' BLUE PLAYER WON!'),
    printLine.

game_loop(state(board(B,PiecesP1,PiecesP2), _Player), _TypeP1, _TypeP2, _Level):-
    game_over(board(B,PiecesP1,PiecesP2),Winner),
    Winner is 2,
    printLine,
    write(' RED PLAYER WON!'),
    printLine.    

game_loop(state(board(B,PiecesP1,PiecesP2),Player), TypeP1, TypeP2, Level):-
    game_over(board(B,PiecesP1,PiecesP2),_Winner),
    (
        Player =:= 1 -> Type is TypeP1;
        Player =:= 2 -> Type is TypeP2
    ),
    update(state(board(B, PiecesP1, PiecesP2),Player), state(board(NewB, NewPiecesP1, NewPiecesP2), NewPlayer), Type, Level) ,
    game_loop(state(board(NewB, NewPiecesP1, NewPiecesP2), NewPlayer),TypeP1, TypeP2, Level).


choose_move(state(board(B, _PiecesP1,_PiecesP2),Player), Level, move(point(FromX,FromY),point(ToX,ToY))):-
    Level is 1, ai_easy(B, Player,move(point(FromX,FromY),point(ToX,ToY))).

choose_move(state(board(B, PiecesP1, PiecesP2),Player), Level, move(point(FromX,FromY),point(ToX,ToY))):-
    Level is 2, ai_medium(state(board(B,PiecesP1,PiecesP2),Player),move(FromX,FromY,ToX,ToY)).

game_over(board(_B,PiecesP1,_PiecesP2), Winner):-
    PiecesP1 is 0, Winner is 2.

game_over(board(_B,_PiecesP1,PiecesP2), Winner):-
    PiecesP2 is 0, Winner is 1.
    
game_over(board(_B,_PiecesP1, _PiecesP2), 0).

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

get_move(state(board(B, PiecesP1, PiecesP2),Player),point(FromX,FromY), point(ToX,ToY),TypePlayer,_Level):-
    TypePlayer is 0,
    get_user_move(state(board(B, PiecesP1, PiecesP2),Player),point(FromX,FromY), point(ToX,ToY)).       

get_user_move(state(board(B, PiecesP1, PiecesP2),Player),point(FromX,FromY), point(ToX,ToY)):-
    ask_for_move(point(FromX,FromY), point(ToX,ToY)),
    valid_play(B, Player, point(FromX,FromY), point(ToX,ToY));
    (write('\nInvalid move. Try again\n\n'), 
    get_user_move(state(board(B, PiecesP1, PiecesP2),Player),point(FromX,FromY), point(ToX,ToY))).

move(move(point(FromX, FromY),point(ToX,ToY)),board(B,PiecesP1,PiecesP2),board(NewBoard,NewPiecesP1,NewPiecesP2),Player):-
    get_piece(B,point(FromX, FromY), Piece),
    replace_in_table(B,FromX,FromY,1,TempBoard),
    replace_in_table(TempBoard,ToX,ToY,Piece, NewBoard),
    (
        check_destiny_target(B,Player,point(ToX,ToY)), Player =:= 2 -> (NewPiecesP1 is (PiecesP1-1), NewPiecesP2 is PiecesP2); 
        check_destiny_target(B,Player,point(ToX,ToY)), Player =:= 1 -> (NewPiecesP2 is (PiecesP2-1), NewPiecesP1 is PiecesP1);
        NewPiecesP1 is PiecesP1, NewPiecesP2 is PiecesP2
    ).