
mainMenu:-
  nl,
  write('           M A D  B I S H O P S          '),
  nl,
  write('-----------------------------------------'),
  nl,
  write('1 - Play'),
  nl,
  write('-----------------------------------------'),
  nl, nl,
  write('Input: '),
  read(Input),
  nl, nl.
  % manage input %


  getMove(point(FromX,FromY), point(ToX,ToY)):-
    write('From X: '),
    read(Input1), 
    FromX is Input1,
    write('From Y: '),
    read(Input2),
    FromY is Input2,
    write('To X: '),
    read(Input3),
    ToX is Input3,
    write('To X: '),
    read(Input4),
    ToY is Input4.



