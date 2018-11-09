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
    getPiece(H,0,1,Y),
    write(Y),
    betweenBoard(2,1),
    nl,
    write('it went through').
    
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
    % verify possible playes for this cell %
    write('. ').


getPiece(Board, Row, Column, Value):-
    nth0(Row, Board, HelpRow),
    nth0(Column, HelpRow, Value).

betweenBoard(X, Y):-
        between(0, 9, X) , between(0,9,Y).
        

