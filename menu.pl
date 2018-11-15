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
  getInput(Input),
  nl, nl,
  manageInput(Input).
  

manageInput(Input):-
  Input =:= 1 -> start(1);
  Input =:= 2 -> start(2);
  Input =:= 3 -> true.

getInput(Input):-
  read(Input),
  testInput(Input); (write('\nInvalid Input. Try again: \n'), getInput(Input)).

testInput(Input):-
  between(1,3,Input),
  integer(Input).  


getMove(point(FromX,FromY), point(ToX,ToY)):-
  write('From Row: '),
  getInput(Input1), 
  FromX is Input1,
  write('From Col: '),
  getInput(Input2),
  FromY is Input2,
  write('To Row: '),
  getInput(Input3),
  ToX is Input3,
  write('To Col: '),
  getInput(Input4),
  ToY is Input4.



