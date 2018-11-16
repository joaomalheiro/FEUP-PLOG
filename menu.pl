
mainMenu:-
  nl,
  write('           M A D  B I S H O P S          '),
  printLine,
  write('1 - Human vs Human'),
  nl,
  write('2 - Human vs Bot'),
  nl,
  write('3 - Quit'),
  printLine,
  nl,
  write('Input: '),
  getInput(Input,1,3),
  nl, nl,
  start(1).

manageInput(Input):-
  Input =:= 1 -> start(1);
  Input =:= 2 -> start(2);
  Input =:= 3 -> true.

getInput(Input,Low,High):-
  read(Input),
  testInput(Input,Low,High); (write('\nInvalid Input. Try again: \n'), getInput(Input,Low,High)).

testInput(Input,Low,High):-
  between(Low,High,Input),
  integer(Input).  

  getMove(point(FromX,FromY), point(ToX,ToY)):-
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



