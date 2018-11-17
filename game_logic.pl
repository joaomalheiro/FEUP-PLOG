valid_moves(B, Player, ListMoves):-
    findall([FromX,FromY,ToX,ToY],valid_play(B,Player,point(FromX,FromY),point(ToX,ToY)),ListMoves).

valid_play(B, Player, PFrom, PTo):-
    between_board(PFrom),
    between_board(PTo),
    check_player_piece(B, Player,PFrom),
    valid_kill(B, Player,PFrom,PTo);
    valid_engage(B, Player, PFrom,PTo).

valid_kill(B, Player, PFrom, PTo):-
    check_destiny_target(B,Player, PTo),
    is_diagonal(PFrom,PTo),
    empty_spaces(B,PFrom,PTo).

valid_engage(B, Player, PFrom, PTo):-
    check_player_piece(B,Player,PFrom),
    check_destiny_empty(B,PTo),
    is_diagonal(PFrom,PTo),
    empty_spaces(B,PFrom,PTo),
    valid_kill(B,Player,PTo,point(_X,_Y)).

empty_spaces(B, point(FromX,FromY), point(ToX,ToY)):-
    DirX is sign(ToX - FromX),
    DirY is sign(ToY - FromY),
    X2 is FromX+DirX,
    Y2 is FromY+DirY,
    empty_spaces_aux(B, point(X2, Y2), point(ToX,ToY), DirX, DirY).

empty_spaces_aux(_B, point(X,Y), point(X, Y), _DirX, _DirY).
empty_spaces_aux(B,point(FromX,FromY), point(ToX,ToY), DirX, DirY):-
    X2 is FromX+DirX,
    Y2 is FromY+DirY,
    get_piece(B,point(FromX,FromY),Piece),
    is_empty_piece(Piece),
    empty_spaces_aux(B,point(X2,Y2),point(ToX,ToY),DirX,DirY).

is_empty_piece(Piece):-
    Piece =:= 1.

is_diagonal(point(FromX,FromY), point(ToX,ToY)):-
    abs(ToX - FromX) =:= abs(ToY - FromY).

check_player_piece(B,Player,point(FromX,FromY)):-
    Player is 1,
    get_piece(B, point(FromX,FromY), PlayerPiece) , PlayerPiece == 3.

check_player_piece(B,Player,point(FromX,FromY)):-
    Player is 2,
    get_piece(B, point(FromX,FromY), PlayerPiece) , PlayerPiece == 2.

check_destiny_empty(B, point(ToX,ToY)):-
    get_piece(B,point(ToX,ToY),Piece),
    is_empty_piece(Piece).

check_destiny_target(B,Player, point(ToX,ToY)):-
        Player is 1,
        (get_piece(B,point(ToX,ToY), DestinyPiece) , DestinyPiece =:= 2).

check_destiny_target(B,Player, point(ToX,ToY)):-
        Player is 2,
        (get_piece(B,point(ToX,ToY), DestinyPiece) , DestinyPiece =:= 3). 

get_piece(B, point(Row, Column), Value):-
    nth0(Row, B, HelpRow),
    nth0(Column, HelpRow, Value).

between_board(point(X, Y)):-
        between(0, 9, X) , between(0,9,Y).

list_to_move(A, move(point(FromX,FromY),point(ToX,ToY))):-
    nth0(0,A,FromX),
    nth0(1,A,FromY),
    nth0(2,A,ToX), 
    nth0(3,A,ToY). 
    
generate_random_num(D,U,RandomNum):-
    random(D, U, RandomNum).

change_player(Player, NewPlayer):-
    Player is 1, NewPlayer is 2.
    
change_player(Player, NewPlayer):-
    Player is 2, NewPlayer is 1.

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
