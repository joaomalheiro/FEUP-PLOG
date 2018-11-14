displayGame([],Pieces1,Pieces2, P).
displayGame(T,Pieces1,Pieces2,P) :-
  write('PLAYER TURN: '),
  ((
    P =:= 1 -> write('BLUE')
  );
  (
    P =:= 2 -> write('RED')
  )),
  nl,nl,
  write('RED BISHOPS: '), write(Pieces2),nl,nl,
  write('BLUE BISHOPS: '), write(Pieces1),nl,nl,
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
printSymbol(2,S) :- S='V'.
printSymbol(3,S) :- S='B'.
