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

start :-
    gameState(X),
    displayGame(X),
    [H|T] = X,
    validPlay(X,1,0,0,1).
        
    % H is the table, T is the player %,
    % verifyPlaysTable(H).

verifyPlaysTable([]).
verifyPlaysTable([L|T]) :-
    nl,
    verifyPlaysList(L),
    verifyPlaysTable(T).

verifyPlaysList([]).
verifyPlaysList([C|L]):-
    verifyPlaysCell(C),
    verifyPlaysList(L).

verifyPlaysCell(X):-
    % verify possible plays for this cell %
    write('. ').

validKill(State,FromX,FromY, ToX, ToY):-
    %checkIfFinished(FromX,FromY,ToX,ToY),
    DirX is sign(ToX - FromX),
    DirY is sign(ToY - FromY),
    X2 is FromX+DirX,
    Y2 is FromY+DirY.
    %validKill(State, X2, Y2, ToX, ToY).


checkPieces(State,FromX,FromY,ToX, ToY):-
    [B|P] = State,
    ((
        P =:= 1 -> (getPiece(B,ToX, ToY, DestinyPiece) , DestinyPiece == 2, getPiece(B, FromX, FromY, PlayerPiece) , PlayerPiece == 3)
    );
    (
        P =:= 2 -> (getPiece(B,ToX, ToY, DestinyPiece) , DestinyPiece == 3, getPiece(B, FromX, FromY, PlayerPiece) , PlayerPiece == 2)
    )).

checkIfFinished(FromX,FromY,ToX,ToY):-
    not(FromX==ToX);
    not(FromY==ToY).

validPlay(State,FromX, FromY, ToX, ToY):-
    betweenBoard(FromX,FromY),
    betweenBoard(ToX,ToY),
    checkPieces(State,FromX,FromY, ToX, ToY),
    validKill(State,FromX,FromY, ToX, ToY),
    nl.

getPiece(Board, Row, Column, Value):-
    nth0(Row, Board, HelpRow),
    nth0(Column, HelpRow, Value).

betweenBoard(X, Y):-
        between(0, 9, X) , between(0,9,Y).
        

