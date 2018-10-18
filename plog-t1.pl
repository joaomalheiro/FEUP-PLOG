
mediumBoard([
[0,1,0,2,0,1,0,2,0,3],
[3,0,1,0,2,0,1,0,1,0],
[0,2,0,3,0,1,0,3,0,1],
[1,0,1,0,1,0,1,0,2,0],
[0,2,0,2,0,3,0,1,0,3],
[2,0,1,0,1,0,1,0,1,0],
[0,3,0,2,0,3,0,3,0,1],
[1,0,1,0,3,0,1,0,2,0],
[0,1,0,3,0,2,0,3,0,3],
[2,0,1,0,1,0,3,0,1,0]
]).

finalBoard([
[0,1,0,2,0,1,0,2,0,3],
[3,0,1,0,2,0,1,0,1,0],
[0,2,0,3,0,1,0,3,0,1],
[1,0,1,0,1,0,1,0,2,0],
[0,2,0,2,0,3,0,1,0,3],
[2,0,1,0,1,0,1,0,1,0],
[0,3,0,2,0,3,0,3,0,1],
[1,0,1,0,3,0,1,0,2,0],
[0,1,0,3,0,2,0,3,0,3],
[2,0,1,0,1,0,3,0,1,0]
]).

displayGame([]) :-
  initialBoard(X),
  tablePrint(X,0).

tablePrint([]).
tablePrint([L|T],X) :-
  printList(L),
  C is X+1,
  nl,
  tablePrint(T,C).

printList([]).
printList([C|L]) :-
  printCell(C),
  printList(L).

printCell(X) :-
  printSymbol(X,S),
  write(S),
  write(' | ').

  printSymbol(0,S) :- S='.'.
  printSymbol(1,S) :- S=','.
  printSymbol(2,S) :- S='X'.
  printSymbol(3,S) :- S='Y'.

initialBoard(X) :-
  X = ([
  [0,3,0,2,0,3,0,2,0,3],
  [2,0,2,0,3,0,2,0,3,0],
  [0,3,0,3,0,2,0,3,0,2],
  [3,0,2,0,2,0,3,0,2,0],
  [0,2,0,3,0,3,0,2,0,3],
  [2,0,3,0,2,0,2,0,3,0],
  [0,3,0,2,0,3,0,3,0,2],
  [3,0,2,0,3,0,2,0,2,0],
  [0,2,0,3,0,2,0,3,0,3],
  [2,0,3,0,2,0,3,0,2,0]
  ]).
