% Displays main menu, collects input and manages it: starts game or quits
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

% Displays ai difficulty menu, collects input and manages it: starts game or quits
% P1 - type of player 1 (human, bot)
% P1 - type of player 2 (human, bot)
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
  manage_ai_input(Input,P1,P2).

% Manages input from ai menu
% Input - option selected in menu
% P1 - type of player 1 (human, bot)
% P1 - type of player 2 (human, bot)
manage_ai_input(Input,P1,P2):-
  Input =:= 1 -> start(P1,P2,1);
  Input =:= 2 -> start(P1,P2,2);
  Input =:= 3 -> true.

% Manages input from main menu
% Input - option selected in menu
managemain_menuInput(Input):-
  Input =:= 1 -> start(0,0,0);
  Input =:= 2 -> ai_menu(0,1);
  Input =:= 3 -> ai_menu(1,1);
  Input =:= 4 -> true.

% Collects input 
% Input - input to be read
% Low - lower option limit
% High - higher option limit
get_input(Input,Low,High):-
  catch(read(Input),_Err,fail),
  test_input(Input,Low,High); (write('\nInvalid Input. Try again: \n'), get_input(Input,Low,High)).

% Verifies if input is valid
% Input - input to be read
% Low - lower option limit
% High - higher option limit
test_input(Input,Low,High):-
  integer(Input),
  between(Low,High,Input).  

% Gets move input from user
% FromX - Row of piece to move
% FromY - Collumn of piece to move
% ToX - Row of desired position
% ToY - Collumn of desired position
ask_for_move(point(FromX,FromY), point(ToX,ToY)):-
  write('From Row: '),
  get_input(Input1,0,9),
  FromX is Input1,
  write('From Col: '),
  get_input(Input2,0,9),
  FromY is Input2,
  write('To Row: '),
  get_input(Input3,0,9),
  ToX is Input3,
  write('To Col: '),
  get_input(Input4,0,9),
  ToY is Input4.