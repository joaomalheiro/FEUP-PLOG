

printBoard(board(Board,hints(LeftHints,UpHints,RightHints,DownHints)),Size):-
    nl,
    print_horizontal_hints(UpHints,round(sqrt(Size)),round(sqrt(Size))), 
    nl,align-right(round(sqrt(Size))+1),
    print_inner_seperation(Size),nl,
    table_print(Board,Size,0,hints(LeftHints,RightHints)),
    print_horizontal_hints(DownHints,round(sqrt(Size)),round(sqrt(Size))).

% Prints the board
% [L|T] - list of lists ([list|tail])
% X - row counter a
table_print([],_,_,_).
table_print([L|T],Size,Ind,hints(LeftHints,RightHints)) :-
    I1 is Ind+1,
    print_vertical_hints_left(LeftHints,I1,round(sqrt(Size))),
  print_list(L),
      print_vertical_hints_right(LeftHints,I1,round(sqrt(Size))),

  nl,
  align-right(round(sqrt(Size))+1),
  print_inner_seperation(Size),
  nl,
  table_print(T,Size,I1,hints(LeftHints,RightHints)).

% Prints a row of the board
% [C|L] - list ([cell|tail])
print_list([]):-write(' |').
print_list([C|L]) :-
  write(' | '),
  print_cell(C),
  print_list(L).

% Prints a single board cell
% X - symbol
print_cell(X) :-
  write(X).

% Prints dashed line
print_line(0):- nl. 
print_line(Size) :- 
  write('----'),
  S1 is Size-1,
  print_line(S1).

% Prints a seperation line separation
print_inner_seperation(0):- write('|').
print_inner_seperation(Size) :- 
  write('|---'),
  S1 is Size-1,
  print_inner_seperation(S1).


print_horizontal_hints(_,Index,_):-
  Index is 0.


print_horizontal_hints(L,1,Length):-
   align-right(3),
  print_horizontal_hints_rec(L,Index),
  I1 is Index-1,
  print_horizontal_hints(L,I1,Length).

print_horizontal_hints(L,Index,Length):-
   align-right(3),
  print_horizontal_hints_rec(L,Index),
  nl,
  I1 is Index-1,
  print_horizontal_hints(L,I1,Length).  


print_horizontal_hints_rec([],_):-!.
print_horizontal_hints_rec([H|T],Index):-
  print_horizontal_hints_line(H,Index),
  print_horizontal_hints_rec(T,Index).

print_horizontal_hints_line([],_):- write('    ').
print_horizontal_hints_line([H|_], 1):-
  write('  '),
  write( H ),
  write(' ').

print_horizontal_hints_line([_|T], I):-
  I1 is I-1,
  print_horizontal_hints_line(T,I1).  

align-right(0):-!.
align-right(Ind):-
  write(' '),
  I1 is Ind-1,
  align-right(I1).


print_vertical_hints_left([],_,Size):-align-right(Size).
print_vertical_hints_left(L,I,Size):-
  print_vertical_hints_aux_left(L,I,Size).


print_vertical_hints_right([],_,_).
print_vertical_hints_right([H|_],1,Size):-
  length(H,L),
  L1 is Size-L,
  align-right(L1),
  print_vertical_hints_line(H).

print_vertical_hints_right([_|T], I,Size):-
  I1 is I-1,
  print_vertical_hints_right(T,I1,Size).    

print_vertical_hints_aux_left([],_,_).
print_vertical_hints_aux_left([H|_],1,Size):-
  length(H,L),
  L1 is Size-L,
  align-right(L1),
  print_vertical_hints_line(H).

print_vertical_hints_aux_left([_|T], I,Size):-
  I1 is I-1,
  print_vertical_hints_aux_left(T,I1,Size).  

print_vertical_hints_line([]).
print_vertical_hints_line([H|T]):-
  write( H ),
  print_vertical_hints_line(T).    