
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
    read(Input), 
    FromX is Input,
    write('From Y: '),
    read(Input),
    FromY is Input,
    write('To X: '),
    read(Input),
    ToX is Input,
    write('To X: '),
    read(Input),
    ToY is Input.



