initialBoard([[
[0,2,0,2,0,2,0,2,0,2],
[3,0,3,0,3,0,3,0,3,0],
[0,2,0,2,0,2,0,2,0,2],
[3,0,3,0,3,0,3,0,3,0],
[0,2,0,2,0,2,0,2,0,2],
[3,0,3,0,3,0,3,0,3,0],
[0,2,0,2,0,2,0,2,0,2],
[3,0,3,0,3,0,3,0,3,0],
[0,2,0,2,0,2,0,2,0,2],
[3,0,3,0,3,0,3,0,3,0]],1
]).


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
[0,1,0,1,0,1,0,1,0,1],
[1,0,1,0,2,0,1,0,1,0],
[0,1,0,1,0,1,0,1,0,1],
[1,0,1,0,1,0,1,0,1,0],
[0,1,0,2,0,1,0,1,0,1],
[1,0,1,0,1,0,1,0,1,0],
[0,1,0,1,0,1,0,1,0,1],
[1,0,1,0,1,0,1,0,1,0],
[0,1,0,1,0,1,0,2,0,1],
[1,0,1,0,1,0,1,0,1,0]
]).

start :-
  initialBoard(X),
  displayGame(X).

displayGame([]).
displayGame([T|B]) :-
  nl,
  write('           M A D  B I S H O P S          '),
  nl, nl,
  write('    PLAYER: '),
  ((
    B =:= 1 -> write('blue')
  );
  (
    B =:= 2 -> write('red')
  )),
  nl,nl,
  write('    0   1   2   3   4   5   6   7   8   9'),
  printSeparation,
  nl,
  tablePrint(T,-1).


printSeparation :-
  nl,
  write('  |---|---|---|---|---|---|---|---|---|---|').

tablePrint([], _X).
tablePrint([L|T],X) :-
  C is X+1,
  write(C),
  printList(L),
  write(' |'),
  printSeparation,
  nl,
  tablePrint(T,C).

printList([]).
printList([C|L]) :-
  write(' | '),
  printCell(C),
  printList(L).

printCell(X) :-
  printSymbol(X,S),
  write(S).

  printSymbol(0,S) :- S='.'.
  printSymbol(1,S) :- S=' '.
  printSymbol(2,S) :- S='R'.
  printSymbol(3,S) :- S='B'.
