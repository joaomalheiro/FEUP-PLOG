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
  % H is the table, T is the player %,
  verifyPlaysTable(H).

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
