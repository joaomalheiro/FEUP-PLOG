gameState([[
[0,2,0,2,0,2,0,2,0,2],
[3,0,3,0,3,0,3,0,3,0],
[0,2,0,2,0,2,0,2,0,2],
[3,0,3,0,3,0,3,0,3,0],
[0,2,0,2,0,2,0,2,0,2],
[3,0,3,0,3,0,3,0,3,0],
[0,2,0,2,0,2,0,2,0,2],
[3,0,3,0,3,0,3,0,3,0],
[0,2,0,2,0,2,0,2,0,2],
[3,0,3,0,3,0,3,0,3,0]],
1
]).

% example of a board in a terminal state of the game
finalBoard([[
[0,1,0,1,0,1,0,1,0,1],
[1,0,1,0,1,0,1,0,1,0],
[0,1,0,1,0,1,0,1,0,1],
[1,0,1,0,1,0,1,0,1,0],
[0,1,0,2,0,1,0,1,0,1],
[1,0,1,0,1,0,1,0,1,0],
[0,1,0,1,0,1,0,1,0,1],
[1,0,1,0,1,0,1,0,1,0],
[0,1,0,1,0,3,0,3,0,1],
[1,0,1,0,1,0,1,0,1,0]],
2
]).


start :-
    finalBoard(X),
    displayGame(X),
    [H|T] = X,
    findall([FromX,FromY,ToX,ToY],validPlay(X,FromX,FromY,ToX,ToY),Ali),
    write(Ali).
    % H is the table, T is the player %,

validPlay(State,FromX, FromY, ToX, ToY):-
    betweenBoard(FromX,FromY),
    betweenBoard(ToX,ToY),
    validKill(State,FromX,FromY, ToX, ToY);
    validEngage(State,FromX,FromY,ToX, ToY).

validKill(State,FromX,FromY, ToX, ToY):-
    checkPlayerPiece(State,FromX,FromY),
    checkDestinyTarget(State,ToX,ToY),
    isDiagonal(FromX,FromY,ToX,ToY),
    emptySpaces(State,FromX,FromY,ToX,ToY).

validEngage(State,FromX,FromY,ToX,ToY):-
    checkPlayerPiece(State,FromX,FromY),
    checkDestinyEmpty(State,ToX,ToY),
    isDiagonal(FromX,FromY,ToX,ToY),
    emptySpaces(State,FromX,FromY,ToX,ToY),
    validKill(State,ToX,ToY,_X,_Y).

emptySpaces(State, FromX, FromY, ToX, ToY):-
    [B|P] = State,
    DirX is sign(ToX - FromX),
    DirY is sign(ToY - FromY),
    X2 is FromX+DirX,
    Y2 is FromY+DirY,
    emptySpacesAux(B,X2, Y2, ToX, ToY, DirX, DirY).

emptySpacesAux(_Board, X, Y, X, Y, _DirX, _DirY).
emptySpacesAux(Board,FromX, FromY, ToX, ToY, DirX, DirY):-
    X2 is FromX+DirX,
    Y2 is FromY+DirY,
    getPiece(Board,FromX,FromY,Piece),
    isEmptyPiece(Piece),
    emptySpacesAux(Board,X2,Y2,ToX,ToY,DirX,DirY).

isEmptyPiece(Piece):-
    Piece =:= 1.

isDiagonal(FromX, FromY, ToX, ToY):-
    abs(ToX - FromX) =:= abs(ToY - FromY).

checkPlayerPiece(State,FromX,FromY):-
    [B|P] = State,
    ((
        P =:= 1 -> getPiece(B, FromX, FromY, PlayerPiece) , PlayerPiece == 3
    );
    (
        P =:= 2 -> getPiece(B, FromX, FromY, PlayerPiece) , PlayerPiece == 2
    )).

checkDestinyEmpty(State, ToX, ToY):-
    [B|P] = State,
    getPiece(B,ToX,ToY,Piece),
    isEmptyPiece(Piece).

checkDestinyTarget(State, ToX, ToY):-
    [B|P] = State,
    ((
        P =:= 1 -> (getPiece(B,ToX, ToY, DestinyPiece) , DestinyPiece =:= 2)
    );
    (
        P =:= 2 -> (getPiece(B,ToX, ToY, DestinyPiece) , DestinyPiece =:= 3)
    )).

getPiece(Board, Row, Column, Value):-
    nth0(Row, Board, HelpRow),
    nth0(Column, HelpRow, Value).

betweenBoard(X, Y):-
        between(0, 9, X) , between(0,9,Y).
        
replaceInLine([_|T], 0, V, [V|T]).
replaceInLine([H|T], X, V, [H|R]) :-
    X > 0,
    X1 is X - 1,
    replaceInLine(T, X1, V, R).

replaceInTable([_|T], X, 0, V, T).
replaceInTable([H|T], X, Y, V, [U|R]):-
    nl,
    Y > 0,
    Y1 is Y-1,
    ((
        Y1=:=0 -> replaceInLine(H,X,V,U),  replaceInTable(T,X,Y1,V,R)
    );
    (
        Y1\=0 -> U=H,  replaceInTable(T,X,Y1,V,R)
    )).


