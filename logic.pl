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
finalBoard([
[0,1,0,1,0,1,0,1,0,1],
[1,0,1,0,1,0,1,0,1,0],
[0,1,0,1,0,1,0,1,0,1],
[1,0,1,0,1,0,1,0,1,0],
[0,1,0,2,0,1,0,1,0,1],
[1,0,1,0,1,0,1,0,1,0],
[0,1,0,1,0,1,0,1,0,1],
[1,0,1,0,1,0,1,0,1,0],
[0,1,0,1,0,3,0,3,0,1],
[1,0,1,0,1,0,1,0,1,0]
]) :- !.

initial_board(board(B, PiecesP1, PiecesP2)) :- starting_board(B), PiecesP1 is 25, PiecesP2 is 25.
initial_player(1) :- !.

initial_state(state(board(B,PiecesP1,PiecesP2), Player)) :-
    initial_board(board(B,PiecesP1,PiecesP2)),
    initial_player(Player).

start :-
    initial_state(state(board(B,PiecesP1,PiecesP2),Player)),
    displayGame(B, Player),
    valid_moves(B, Player, PossibleMoves),
    %write(PossibleMoves).
    % [H|T] = X,
    update(state(board(B, PiecesP1, PiecesP2),Player), newState(newBoard(NewB, NewPiecesP1, NewPiecesP2), NewPlayer)).
    %write(B2).

        
    % H is the table, T is the player %,

valid_moves(Board, Player, ListMoves):-
    findall([FromX,FromY,ToX,ToY],validPlay(Board,Player,point(FromX,FromY),point(ToX,ToY)),ListMoves).

validPlay(Board, Player, PFrom, PTo):-
    betweenBoard(PFrom),
    betweenBoard(PTo),
    checkPlayerPiece(Board, Player,PFrom),
    validKill(Board, Player,PFrom,PTo);
    validEngage(Board, Player, PFrom,PTo).

validKill(Board, Player, PFrom, PTo):-
    checkDestinyTarget(Board,Player, PTo),
    isDiagonal(PFrom,PTo),
    emptySpaces(Board,PFrom,PTo).

validEngage(Board, Player, PFrom, PTo):-
    checkPlayerPiece(Board,Player,PFrom),
    checkDestinyEmpty(Board,PTo),
    isDiagonal(PFrom,PTo),
    emptySpaces(Board,PFrom,PTo),
    validKill(Board,Player,PTo,_X,_Y).

emptySpaces(Board, point(FromX,FromY), point(ToX,ToY)):-
    DirX is sign(ToX - FromX),
    DirY is sign(ToY - FromY),
    X2 is FromX+DirX,
    Y2 is FromY+DirY,
    emptySpacesAux(Board, point(X2, Y2), point(ToX,ToY), DirX, DirY).

emptySpacesAux(_Board, point(X,Y), point(X, Y), _DirX, _DirY).
emptySpacesAux(Board,point(FromX,FromY), point(ToX,ToY), DirX, DirY):-
    X2 is FromX+DirX,
    Y2 is FromY+DirY,
    getPiece(Board,point(FromX,FromY),Piece),
    isEmptyPiece(Piece),
    emptySpacesAux(Board,point(X2,Y2),point(ToX,ToY),DirX,DirY).

isEmptyPiece(Piece):-
    Piece =:= 1.

isDiagonal(point(FromX,FromY), point(ToX,ToY)):-
    abs(ToX - FromX) =:= abs(ToY - FromY).

checkPlayerPiece(Board,Player,point(FromX,FromY)):-
    ((
        Player =:= 1 -> getPiece(Board, point(FromX,FromY), PlayerPiece) , PlayerPiece == 3
    );
    (
        Player =:= 2 -> getPiece(Board, point(FromX,FromY), PlayerPiece) , PlayerPiece == 2
    )).

checkDestinyEmpty(Board, point(ToX,ToY)):-
    getPiece(Board,point(ToX,ToY),Piece),
    isEmptyPiece(Piece).

checkDestinyTarget(Board,Player, point(ToX,ToY)):-
    ((
        Player =:= 1 -> (getPiece(Board,point(ToX,ToY), DestinyPiece) , DestinyPiece =:= 2)
    );
    (
        Player =:= 2 -> (getPiece(Board,point(ToX,ToY), DestinyPiece) , DestinyPiece =:= 3)
    )).

getPiece(Board, point(Row, Column), Value):-
    nth0(Row, Board, HelpRow),
    nth0(Column, HelpRow, Value).

betweenBoard(point(X, Y)):-
        between(0, 9, X) , between(0,9,Y).

update(state(board(B, PiecesP1, PiecesP2),Player), newState(newBoard(NewB, NewPiecesP1, NewPiecesP2), NewPlayer)):-
    getMove(point(FromX,FromY), point(ToX,ToY)).
    % getMove(point(point(FromX,FromY)),point(point(ToX,ToY)))
    % validPlay()




same(L1,L2):-
    append(L1,[],L2).        
        
replaceInLine([_|T], 0, V, [V|T]).
replaceInLine([H|T], X, V, [H|R]) :-
    X > 0,
    X1 is X - 1,
    replaceInLine(T, X1, V, R).

replaceInTable([H|T], X, Y, V, [U|R]):-
    Y is 0,
    replaceInLine(H,X,V,U),
    same(T,R).
    
replaceInTable([H|T], X, Y, V, [U|R]):-
    same(H,U),
    Y1 is Y-1,
    replaceInTable(T,X,Y1,V,R).
