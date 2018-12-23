:-consult('logic.pl').
:- use_module(library(between)).

mainMenu:-
    nl,
    write('           S U D O K U          '),
    nl,
    print_line(8),
    write('Enter board size (Must be a square root between 4 and 9 ex.: 4):'),
    get_input(Input),
    difficultyMenu(Level),
    newPuzzle(Input,Level,2).


difficultyMenu(Level):-
    write('           S U D O K U          '),
    nl,
    print_line(8),
    write('Difficulty: '),
    nl,
    write('1 - Easy'),
    nl,
    write('2 - Medium'),
    nl,
    write('3 - Genius'),
    get_input(Level,1,3).


get_input(Input,Low,High):-
  catch(read(Input),_Err,fail),
  test_input(Input,Low,High).

get_input(Input,Low,High):-
  write('\nInvalid Input. Try again: \n'), 
  get_input(Input,Low,High).

get_input(Input):-
  catch(read(Input),_Err,fail),
  test_input(Input).

get_input(Input):-
  write('\nInvalid Input. Try again: \n'), 
  get_input(Input).


% Verifies if input is valid
% Input - input to be read
% Low - lower option limit
% High - higher option limit
test_input(Input,Low,High):-
  integer(Input),
  between(Low,High,Input).  

test_input(4).
test_input(9).
