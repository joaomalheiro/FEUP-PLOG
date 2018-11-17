display_game([],_PiecesP1,_Pieces2, _P).
display_game(T,Pieces1,Pieces2,P) :-
print_line, nl,
  write('PLAYER TURN: '),
  ((
    P =:= 1 -> write('BLUE')
  );
  (
    P =:= 2 -> write('RED')
  )),
  nl,nl,
  write('RED BISHOPS: '), write(Pieces2),
  write('  |  BLUE BISHOPS: '), write(Pieces1),nl,nl,
  write('    0   1   2   3   4   5   6   7   8   9'),
  print_seperation,
  nl,
  table_print(T,-1).


print_seperation :- 
  nl,
  write('  |---|---|---|---|---|---|---|---|---|---|').

table_print([], _X).
table_print([L|T],X) :-
  C is X+1,
  write(C),
  print_list(L),
  write(' |'),
  print_seperation,
  nl,
  table_print(T,C).

print_list([]).
print_list([C|L]) :-
  write(' | '),
  print_cell(C),
  print_list(L).

print_cell(X) :-
  print_symbol(X,S),
  write(S).

print_line :-
nl,
write('-------------------------------------------'),
nl.  

print_symbol(0,S) :- S='.'.
print_symbol(1,S) :- S=' '.
print_symbol(2,S) :- S='V'.
print_symbol(3,S) :- S='B'.
