
main_menu:-
  nl,
  write('           M A D  B I S H O P S          '),
  print_line,
  write('1 - Human vs Human'),
  nl,
  write('2 - Human vs Bot'),
  nl,
  write('3 - Bot vs Bot'),
  nl,
  write('4 - Quit'),
  print_line,
  nl,
  write('Input: '),
  get_input(Input,1,4),
  nl, nl,
  managemain_menuInput(Input).

ai_menu(P1,P2):-
  nl,nl,nl,nl,nl,nl,
  write('           M A D  B I S H O P S          '),
  print_line,
  write('1 - Easy'),
  nl,
  write('2 - Intermediate'),
  nl,
  write('3 - Quit'),
  print_line,
  write('Input: '),
  get_input(Input,1,3),
  nl, nl,
  manage_input(Input,P1,P2).

manage_input(Input,P1,P2):-
  Input =:= 1 -> start(P1,P2,1);
  Input =:= 2 -> start(P1,P2,2);
  Input =:= 3 -> true.

managemain_menuInput(Input):-
  Input =:= 1 -> start(0,0,0);
  Input =:= 2 -> ai_menu(0,1);
  Input =:= 3 -> ai_menu(1,1);
  Input =:= 4 -> true.

get_input(Input,Low,High):-
  read(Input).
  %test_input(Input,Low,High); (write('\nInvalid Input. Try again: \n'), get_input(Input,Low,High)).

test_input(Input,Low,High):-
  between(Low,High,Input),
  integer(Input).  

  ask_for_move(point(FromX,FromY), point(ToX,ToY)):-
    write('From Row: '),
    read(Input1),
    %get_input(Input1,0,9),
    FromX is Input1,
    write('From Col: '),
    read(Input2),
   %get_input(Input2,0,9),
    FromY is Input2,
    write('To Row: '),
    read(Input3),
    %get_input(Input3,0,9),
    ToX is Input3,
    write('To Col: '),
    read(Input4),
    %get_input(Input4,0,9),
    ToY is Input4.



