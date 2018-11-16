
mainMenu:-
  nl,
  write('           M A D  B I S H O P S          '),
  printLine,
  write('1 - Human vs Human'),
  nl,
  write('2 - Human vs Bot'),
  nl,
  write('3 - Bot vs Bot'),
  nl,
  write('4 - Quit'),
  printLine,
  nl,
  write('Input: '),
  getInput(Input,1,4),
  nl, nl,
  manageMainMenuInput(Input).

aiMenu(P1,P2):-
  nl,nl,nl,nl,nl,nl,
  write('           M A D  B I S H O P S          '),
  printLine,
  write('1 - Easy'),
  nl,
  write('2 - Intermediate'),
  nl,
  write('3 - Quit'),
  printLine,
  write('Input: '),
  getInput(Input,1,3),
  nl, nl,
  manageInput(Input,P1,P2).

manageInput(Input,P1,P2):-
  Input =:= 1 -> start(P1,P2,1);
  Input =:= 2 -> start(P1,P2,2);
  Input =:= 3 -> true.

manageMainMenuInput(Input):-
  Input =:= 1 -> start(0,0,0);
  Input =:= 2 -> aiMenu(0,1);
  Input =:= 3 -> aiMenu(1,1);
  Input =:= 4 -> true.

getInput(Input,Low,High):-
  read(Input).
  %testInput(Input,Low,High); (write('\nInvalid Input. Try again: \n'), getInput(Input,Low,High)).

testInput(Input,Low,High):-
  between(Low,High,Input),
  integer(Input).  

  askForMove(point(FromX,FromY), point(ToX,ToY)):-
    write('From Row: '),
    read(Input1),
    %getInput(Input1,0,9),
    FromX is Input1,
    write('From Col: '),
    read(Input2),
   %getInput(Input2,0,9),
    FromY is Input2,
    write('To Row: '),
    read(Input3),
    %getInput(Input3,0,9),
    ToX is Input3,
    write('To Col: '),
    read(Input4),
    %getInput(Input4,0,9),
    ToY is Input4.



